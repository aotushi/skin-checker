import { createApp } from './app'
import { putTempImage, getTempImageBytes, deleteTempImage } from './storage'
import { insertReport, listHistory } from './db'
import type { PlatformDeps } from './platform'

// Cloudflare Workers 入口:R2 暂存中转 + D1 历史 + wrangler secret 注入。
// 业务路由见 app.ts;平台差异接口见 platform.ts(ADR 0010)。

function workersDeps(env: Env): PlatformDeps {
  return {
    async stashImage(file) {
      const key = await putTempImage(env.IMG_BUCKET, file)
      const bytes = await getTempImageBytes(env.IMG_BUCKET, key)
      if (!bytes) {
        // 刚写入即读空,视作存储异常:删除兜底后抛错(app.onError → 500)。
        await deleteTempImage(env.IMG_BUCKET, key).catch(() => {})
        throw new Error('临时图片读取失败')
      }
      return {
        bytes,
        cleanup: async () => {
          // 删失败仅记日志(cleanup 约定不抛),R2 生命周期兜底。
          try {
            await deleteTempImage(env.IMG_BUCKET, key)
          } catch (err) {
            console.error(JSON.stringify({ level: 'error', msg: 'temp image delete failed', key, err: String(err) }))
          }
        },
      }
    },
    saveReport: (id, createdAt, report) => insertReport(env.DB, id, createdAt, report),
    listHistory: () => listHistory(env.DB),
    qwenApiKey: env.QWEN_API_KEY,
  }
}

export default createApp<{ Bindings: Env }>((c) => workersDeps(c.env))
