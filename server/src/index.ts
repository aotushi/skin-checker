import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { putTempImage, getTempImageBytes, deleteTempImage } from './storage'
import { analyzeImage } from './qwen'
import { assembleReport } from './derive'
import { validateReport } from './validate'
import { insertReport, listHistory } from './db'

const app = new Hono<{ Bindings: Env }>()

// CORS:H5 端(浏览器)跨域 fetch 必需;微信小程序 / APP 走原生请求不受 CORS(但需各端后台配合法域名)。
// MVP 先放开所有源(接口无 cookie / 无凭证);部署时收紧到实际前端域名。
app.use('/*', cors())

const MAX_IMAGE_BYTES = 10 * 1024 * 1024 // 10MB 上限

app.get('/health', (c) => c.json({ ok: true, service: 'skin-checker-server' }))

// 分析:上传正脸照 → 存 R2 临时对象 → 千问VL 分析 → 后端派生 code/name + 注入 disclaimer
// → 契约校验 → 落库(只存结构化结果)→ 删临时图(ADR 0003,finally 确保执行)。
app.post('/analyze', async (c) => {
  const body = await c.req.parseBody()
  const file = body['image']
  if (!(file instanceof File)) return c.json({ error: '缺少 image 文件字段' }, 400)
  if (!file.type.startsWith('image/')) return c.json({ error: '仅支持图片' }, 400)
  if (file.size > MAX_IMAGE_BYTES) return c.json({ error: '图片过大(上限 10MB)' }, 413)

  const key = await putTempImage(c.env.IMG_BUCKET, file)
  try {
    const bytes = await getTempImageBytes(c.env.IMG_BUCKET, key)
    if (!bytes) return c.json({ error: '临时图片读取失败' }, 500)

    const raw = await analyzeImage({ apiKey: c.env.QWEN_API_KEY }, bytes, file.type)
    const report = assembleReport(raw)

    const check = validateReport(report)
    if (!check.valid) return c.json({ error: '分析结果不符合契约', details: check.errors }, 502)

    const id = crypto.randomUUID()
    const createdAt = Date.now()
    await insertReport(c.env.DB, id, createdAt, report)
    return c.json({ id, createdAt, report })
  } finally {
    // 无论成败都删临时图(ADR 0003);删失败仅记日志,R2 生命周期兜底。
    try {
      await deleteTempImage(c.env.IMG_BUCKET, key)
    } catch (err) {
      console.error(JSON.stringify({ level: 'error', msg: 'temp image delete failed', key, err: String(err) }))
    }
  }
})

// 历史:读回结构化结果(不含原图),按时间倒序。
app.get('/history', async (c) => {
  const items = await listHistory(c.env.DB)
  return c.json({ items })
})

app.onError((err, c) => {
  console.error(JSON.stringify({ level: 'error', msg: 'unhandled error', path: c.req.path, err: String(err) }))
  return c.json({ error: '服务器内部错误' }, 500)
})

export default app
