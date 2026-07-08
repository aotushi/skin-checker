import type { SkinReport } from './types/skin-report'
import { SKIN_TYPE_MAP } from './skin-type-map'

// 后端确定性派生 + 法务文案注入(不交给 LLM,防幻觉/防漂移,见 ADR 0006 / 0008)。

type SkinAxes = SkinReport['skinAxes']

/** 免责声明标准文案(与 shared/skin-report.schema.json 的 disclaimer 描述一致;收敛到结果页一处,见 ADR 0008)。 */
export const DISCLAIMER =
  '本结果由 AI 生成,仅供护肤参考,不构成医疗建议,严重皮肤问题请就医。'

/**
 * 从四维派生 skinTypeCode(如 O-S-F-P)+ 手册权威 name / 按型 suggestions。
 * name 与 suggestions 取自 SKIN_TYPE_MAP(16 型手册,收后端一处,见 ADR 0006),不交 LLM;
 * 维度缺失/非法 → code 带 '?' 不命中映射,name='未知型'、suggestions=[],交 validateReport 兜底拒绝。
 */
export function deriveSkinType(axes: SkinAxes | undefined): {
  code: string
  name: string
  suggestions: string[]
} {
  const o = axes?.oilDry?.value
  const s = axes?.sensitivity?.value
  const a = axes?.acne?.value
  const p = axes?.pigment?.value
  const code = `${o ?? '?'}-${s ?? '?'}-${a ?? '?'}-${p ?? '?'}`
  const info = SKIN_TYPE_MAP[code]
  return { code, name: info?.name ?? '未知型', suggestions: info?.suggestions ?? [] }
}

/**
 * 把千问判定的「四维 + 分区」组装成完整 SkinReport:
 * 派生 code、按型取手册 name / suggestions、注入 disclaimer。返回值仍须过 validateReport 才可信。
 */
export function assembleReport(analysis: unknown): SkinReport {
  // analysis 为 LLM 原始输出(不可信边界),读取后统一交 validateReport 校验。
  const a = (analysis ?? {}) as Partial<QwenLike>
  const axes = a.skinAxes as SkinAxes
  const { code, name, suggestions } = deriveSkinType(axes)
  return {
    skinAxes: axes,
    skinTypeCode: code,
    skinTypeName: name,
    zones: a.zones ?? [],
    suggestions,
    disclaimer: DISCLAIMER,
  }
}

type QwenLike = Pick<SkinReport, 'skinAxes' | 'zones'>
