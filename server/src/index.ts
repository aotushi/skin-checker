import { Hono } from 'hono'

const app = new Hono<{ Bindings: Env }>()

// 健康检查(W1 起步占位,后续接 上传 / 分析 / 历史)
app.get('/health', (c) => c.json({ ok: true, service: 'skin-checker-server' }))

export default app
