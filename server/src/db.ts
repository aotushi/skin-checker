import type { SkinReport } from './types/skin-report'
import type { HistoryRow } from './platform'

// D1 历史:只存结构化结果,不存原图(ADR 0003)。仅 Workers 入口使用(FC 侧历史为 V2 预留)。
// report_json 存完整 SkinReport(契约 SSOT),另拆 code/name/time 供列表查询。
// HistoryRow 形状定义在 platform.ts(两平台共用)。

interface ReportRecord {
  id: string
  created_at: number
  skin_type_code: string
  skin_type_name: string
  report_json: string
}

/** 写入一条检测历史。 */
export async function insertReport(
  db: D1Database,
  id: string,
  createdAt: number,
  report: SkinReport,
): Promise<void> {
  await db
    .prepare(
      'INSERT INTO reports (id, created_at, skin_type_code, skin_type_name, report_json) VALUES (?, ?, ?, ?, ?)',
    )
    .bind(id, createdAt, report.skinTypeCode, report.skinTypeName, JSON.stringify(report))
    .run()
}

/** 按时间倒序读取历史列表(默认 20 条)。 */
export async function listHistory(db: D1Database, limit = 20): Promise<HistoryRow[]> {
  const { results } = await db
    .prepare(
      'SELECT id, created_at, skin_type_code, skin_type_name, report_json FROM reports ORDER BY created_at DESC LIMIT ?',
    )
    .bind(limit)
    .all<ReportRecord>()
  return results.map((r) => ({
    id: r.id,
    createdAt: r.created_at,
    skinTypeCode: r.skin_type_code,
    skinTypeName: r.skin_type_name,
    report: JSON.parse(r.report_json) as SkinReport,
  }))
}
