// server 联调(W2 切片 E):uni.uploadFile 传图到 /analyze,返回报告 envelope { id, createdAt, report }。
// API_BASE 为本地 wrangler dev 地址(pnpm dev --port 8890);部署后换线上域名
// —— 小程序 / App 真机还需 https + 各端后台配请求合法域名,H5 跨域由 server 端 CORS 放行。
// 「分析 → 结果卡」的 envelope 用模块级暂存单次取用传递(redirectTo 不便携带大对象;
// 不自动写历史,保存仍由用户在结果卡点「保存报告」)。

import type { SkinReport } from '@/types/skin-report'

const API_BASE = 'http://127.0.0.1:8890'

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
