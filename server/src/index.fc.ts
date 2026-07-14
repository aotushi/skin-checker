import { serve } from '@hono/node-server'
import { createApp } from './app'
import type { PlatformDeps } from './platform'

// 阿里云 FC(Web 函数)入口:自定义运行时 Node.js 22,自监听端口,FC 把原始 HTTP 直接转给本进程。
// 业务路由见 app.ts;平台差异接口见 platform.ts(ADR 0010)。
//
// 与 Workers 入口的差异:
// - 图片内存直读,不经任何暂存(同样满足 ADR 0003「分析后不留存」);
// - 历史 no-op / 恒空(前端历史在本地;后端历史属 V2 用户体系预留);
// - QWEN_API_KEY 走 FC 控制台环境变量(本地验证用 node --env-file=.dev.vars,空 key 走 mock)。

const fcDeps: PlatformDeps = {
  async stashImage(file) {
    return { bytes: await file.arrayBuffer(), cleanup: async () => {} }
  },
  async saveReport() {},
  async listHistory() {
    return []
  },
  qwenApiKey: process.env.QWEN_API_KEY ?? '',
}

const app = createApp(() => fcDeps)

// FC 自定义运行时注入 FC_SERVER_PORT(与控制台「监听端口」一致,默认 9000);本地直跑同默认。
const port = Number(process.env.FC_SERVER_PORT ?? 9000)
serve({ fetch: app.fetch, port, hostname: '0.0.0.0' }, (info) => {
  console.log(JSON.stringify({ level: 'info', msg: 'fc server listening', port: info.port, mock: !fcDeps.qwenApiKey }))
})
