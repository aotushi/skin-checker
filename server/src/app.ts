import { Hono } from 'hono'
import type { Context, Env as HonoEnv } from 'hono'
import { cors } from 'hono/cors'
import { analyzeImage, extractGate } from './qwen'
import { assembleReport } from './derive'
import { validateReport } from './validate'
import type { PlatformDeps } from './platform'

// 业务路由唯一定义处:平台差异(图片暂存/历史落库/密钥)全部经 PlatformDeps 注入,
// Workers 入口 index.ts、FC 入口 index.fc.ts 各自实现(ADR 0010)。
//
// basePath('/api'):生产路由 skin.9shi.cc/api/* 会把完整路径(含 /api)转给 worker;
// FC 默认域名同样透传完整路径 —— 前端 API_BASE 统一带 /api 后缀,两平台一致。

const MAX_IMAGE_BYTES = 10 * 1024 * 1024 // 10MB 上限

// —— /analyze 滥用防护(W5 切片 E):公开匿名接口,每次调用都真调计费 VL ——
// 实例级内存限流:同 IP 每分钟最多 RATE_LIMIT 次,超限 429(走既有 {error} 形态,前端 toast 即可)。
// 计数器实例间不共享:FC 侧配合控制台「最大实例数」封顶后即近似全局限流;Workers 侧为 isolate 级尽力而为。
const RATE_LIMIT = 10
const RATE_WINDOW_MS = 60_000
const rateBuckets = new Map<string, { count: number; windowStart: number }>()

// 客户端 IP:Workers 用 CF-Connecting-IP(平台注入,不可伪造);FC 取 X-Forwarded-For
// 最后一跳(网关在既有值后追加真实 IP,首个条目可被客户端伪造,不可信)。
function clientIp(c: Context): string {
  const cf = c.req.header('cf-connecting-ip')
  if (cf) return cf
  const xff = c.req.header('x-forwarded-for')
  if (xff) {
    const hops = xff.split(',')
    return hops[hops.length - 1]!.trim()
  }
  return 'unknown'
}

function overRateLimit(ip: string): boolean {
  const now = Date.now()
  // 防 Map 无界增长:桶数超阈值时清一轮过期桶
  if (rateBuckets.size > 5_000) {
    for (const [k, v] of rateBuckets) {
      if (now - v.windowStart >= RATE_WINDOW_MS) rateBuckets.delete(k)
    }
  }
  const bucket = rateBuckets.get(ip)
  if (!bucket || now - bucket.windowStart >= RATE_WINDOW_MS) {
    rateBuckets.set(ip, { count: 1, windowStart: now })
    return false
  }
  bucket.count += 1
  return bucket.count > RATE_LIMIT
}

export function createApp<E extends HonoEnv = HonoEnv>(
  resolveDeps: (c: Context<E>) => PlatformDeps,
): Hono<E> {
  const app = new Hono<E>().basePath('/api')

  // CORS:收紧到 H5 生产域名 + 本地 dev(W5 切片 E;接口无 cookie / 无凭证)。
  // 只约束浏览器跨域 —— 小程序 / App / 脚本的原生请求无 Origin 不经此层,
  // 滥用面由上方限流 + FC 实例数封顶兜底(默认 fcapp.run 域名同样生效)。
  const ALLOWED_ORIGIN = /^https:\/\/skin\.9shi\.cc$|^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/
  app.use('/*', cors({ origin: (origin) => (ALLOWED_ORIGIN.test(origin) ? origin : null) }))

  app.get('/health', (c) => c.json({ ok: true, service: 'skin-checker-server' }))

  // 分析:上传正脸照 → 平台暂存(Workers=R2 / FC=内存)→ 千问VL 分析(同调用内含输入质检,不合格 422)
  // → 后端派生 code/name + 注入 disclaimer → 契约校验 → 落库(只存结构化结果;FC 为 no-op)
  // → 清理暂存图(ADR 0003,finally 确保执行,质检拒绝路径同样覆盖)。
  app.post('/analyze', async (c) => {
    // 限流放最前(解析 body 之前),超限请求零成本拒绝。
    if (overRateLimit(clientIp(c))) return c.json({ error: '请求过于频繁,请稍候再试' }, 429)

    const deps = resolveDeps(c)
    const body = await c.req.parseBody()
    const file = body['image']
    if (!(file instanceof File)) return c.json({ error: '缺少 image 文件字段' }, 400)
    if (!file.type.startsWith('image/')) return c.json({ error: '仅支持图片' }, 400)
    if (file.size > MAX_IMAGE_BYTES) return c.json({ error: '图片过大(上限 10MB)' }, 413)

    const stash = await deps.stashImage(file)
    try {
      const raw = await analyzeImage({ apiKey: deps.qwenApiKey }, stash.bytes, file.type)

      // 输入质检(W1 切片 E):非人脸/翻拍/距离/质量不合格 → 422 + 具体重拍指引。
      // 公共契约不动(拒绝走既有 {error} 形态),前端 catch 直接 toast 并留在拍照页可重拍。
      const gate = extractGate(raw)
      if (!gate.pass) {
        console.log(JSON.stringify({ level: 'info', msg: 'analyze rejected by input gate', reason: gate.reason }))
        return c.json({ error: gate.message }, 422)
      }

      const report = assembleReport(raw)

      const check = validateReport(report)
      if (!check.valid) return c.json({ error: '分析结果不符合契约', details: check.errors }, 502)

      const id = crypto.randomUUID()
      const createdAt = Date.now()
      await deps.saveReport(id, createdAt, report)
      return c.json({ id, createdAt, report })
    } finally {
      // 无论成败都清理暂存图(ADR 0003);cleanup 约定不抛,失败由平台实现记日志兜底。
      await stash.cleanup()
    }
  })

  // 历史:读回结构化结果(不含原图),按时间倒序。
  app.get('/history', async (c) => {
    const items = await resolveDeps(c).listHistory()
    return c.json({ items })
  })

  app.onError((err, c) => {
    console.error(JSON.stringify({ level: 'error', msg: 'unhandled error', path: c.req.path, err: String(err) }))
    return c.json({ error: '服务器内部错误' }, 500)
  })

  return app
}
