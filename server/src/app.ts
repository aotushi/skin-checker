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

export function createApp<E extends HonoEnv = HonoEnv>(
  resolveDeps: (c: Context<E>) => PlatformDeps,
): Hono<E> {
  const app = new Hono<E>().basePath('/api')

  // CORS:H5 端(浏览器)跨域 fetch 必需;微信小程序 / APP 走原生请求不受 CORS(但需各端后台配合法域名)。
  // MVP 先放开所有源(接口无 cookie / 无凭证);部署时收紧到实际前端域名。
  app.use('/*', cors())

  app.get('/health', (c) => c.json({ ok: true, service: 'skin-checker-server' }))

  // 分析:上传正脸照 → 平台暂存(Workers=R2 / FC=内存)→ 千问VL 分析(同调用内含输入质检,不合格 422)
  // → 后端派生 code/name + 注入 disclaimer → 契约校验 → 落库(只存结构化结果;FC 为 no-op)
  // → 清理暂存图(ADR 0003,finally 确保执行,质检拒绝路径同样覆盖)。
  app.post('/analyze', async (c) => {
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
