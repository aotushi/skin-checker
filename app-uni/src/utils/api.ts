// server 联调(W2 切片 E):uni.uploadFile 传图到 /analyze,返回报告 envelope { id, createdAt, report }。
// API_BASE:dev = 本地 wrangler dev(pnpm dev --port 8890),build 按端分流(W5,ADR 0010):
// - H5 / App → 阿里云 FC 默认域名(大陆链路 ~9 倍快;H5 跨域依赖 server 侧 cors(),
//   App 原生请求不受 CORS 与合法域名限制);
// - 小程序 → 仍走 Workers skin.9shi.cc(FC 默认域名 fcapp.run 无 ICP 备案,进不了
//   小程序合法域名)。
// server 挂 basePath('/api'),各处都带 /api 后缀。
// 「分析 → 结果卡」的 envelope 用模块级暂存单次取用传递(redirectTo 不便携带大对象;
// 不自动写历史,保存仍由用户在结果卡点「保存报告」)。

import type { SkinReport } from '@/types/skin-report'

let prodBase = 'https://skin.9shi.cc/api'
// #ifdef H5 || APP-PLUS
prodBase = 'https://skin-checker-egkggmemue.cn-hangzhou.fcapp.run/api'
// #endif
const API_BASE = import.meta.env.DEV ? 'http://127.0.0.1:8890/api' : prodBase

export interface AnalysisEnvelope {
  id: string
  createdAt: number // 毫秒时间戳(server 侧生成)
  report: SkinReport
}

/** 上传正脸照到 /analyze;成功返回 envelope,失败抛 Error(message 可直接 toast)。 */
export function requestAnalyze(filePath: string): Promise<AnalysisEnvelope> {
  return new Promise((resolve, reject) => {
    uni.uploadFile({
      url: `${API_BASE}/analyze`,
      filePath,
      name: 'image', // 与 server parseBody 的 image 字段对齐
      success: (res) => {
        let data: { error?: string } & Partial<AnalysisEnvelope> = {}
        try {
          data = JSON.parse(res.data)
        } catch {
          // 非 JSON 响应按通用错误走下方 reject
        }
        if (res.statusCode === 200 && data.id && data.report) {
          resolve(data as AnalysisEnvelope)
        } else {
          reject(new Error(data.error || `分析失败(${res.statusCode})`))
        }
      },
      fail: () => reject(new Error('网络异常,请检查连接后重试')),
    })
  })
}

// —— 分析结果暂存(拍照页 → 结果页)——
let pending: AnalysisEnvelope | null = null

export function setPendingAnalysis(envelope: AnalysisEnvelope) {
  pending = envelope
}

/** 取出并清空暂存(仅结果页 onLoad 调,单次取用避免旧结果串页)。 */
export function takePendingAnalysis(): AnalysisEnvelope | null {
  const p = pending
  pending = null
  return p
}
