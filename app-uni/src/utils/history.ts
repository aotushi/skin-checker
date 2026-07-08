// 本地历史记录(uni Storage)。MVP 无登录/游客态,历史仅存设备本地
// —— 契合「我的」页 hint「本地保存」+ 隐私说明「报告默认仅保存在你的设备本地」的承诺。
// 后端 D1 /history 保留给「可选用户体系」(V2 登录后),此处不涉及。
// 存的是完整 report envelope:{ id, createdAt, report(SkinReport 契约) },列表展示从 report 取型号码/名。

import type { SkinReport } from '@/types/skin-report'

const KEY = 'skn_history'
const MAX = 20 // 与后端 listHistory 默认条数对齐,超出淘汰最旧

export interface HistoryItem {
  id: string
  createdAt: number // 毫秒时间戳
  report: SkinReport
}

/** 读本地历史(已按新→旧存序,直接返回)。 */
export function listHistory(): HistoryItem[] {
  try {
    const raw = uni.getStorageSync(KEY)
    return Array.isArray(raw) ? (raw as HistoryItem[]) : []
  } catch {
    return []
  }
}

/** 按 id 取一条(供结果卡回看)。 */
export function getHistoryItem(id: string): HistoryItem | undefined {
  return listHistory().find((it) => it.id === id)
}

/** 存一条到最前,返回新项;超 MAX 淘汰最旧。meta:新分析沿用 server 的 id/createdAt,缺省本地生成(示例报告)。 */
export function saveHistory(report: SkinReport, meta?: { id: string; createdAt: number }): HistoryItem {
  const item: HistoryItem = { id: meta?.id ?? genId(), createdAt: meta?.createdAt ?? Date.now(), report }
  const list = [item, ...listHistory()].slice(0, MAX)
  uni.setStorageSync(KEY, list)
  return item
}

// 本地历史 id,非安全场景(不做鉴权/去重键):时间戳 + 随机后缀即可
function genId(): string {
  return Date.now().toString(36) + '-' + Math.random().toString(36).slice(2, 8)
}
