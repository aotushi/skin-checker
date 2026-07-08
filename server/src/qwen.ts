import type { SkinReport } from './types/skin-report'

// 千问 VL 多模态分析:传图 + schema 约束 → 结构化候选(unknown,交 validateReport 把关)。
// 只判定「四维 + 分区」(看图能得出的);skinTypeCode / skinTypeName / suggestions / disclaimer
// 由后端派生注入(suggestions 按判定型号取 16 型手册,不交给 LLM,防幻觉与法务文案漂移,见 ADR 0006 / 0008)。

export interface QwenConfig {
  apiKey: string
  baseUrl?: string
  model?: string
}

/** 千问只判定这两块,其余(code / name / suggestions / disclaimer)后端派生。 */
export type QwenAnalysis = Pick<SkinReport, 'skinAxes' | 'zones'>

/**
 * 分析一张人脸照 → 结构化候选(unknown,交 validateReport 校验)。
 * 未配置 apiKey 时返回 mock(本地全链路验证用,不需真调、不花钱);
 * 真实千问 VL 调用(OpenAI 兼容,JSON mode + schema 约束,base64 传图)在切片 D 接入。
 */
export async function analyzeImage(
  cfg: QwenConfig,
  imageBytes: ArrayBuffer,
  contentType: string,
): Promise<unknown> {
  if (!cfg.apiKey) return mockAnalysis()
  // TODO(切片 D):OpenAI 兼容多模态调用,data:${contentType};base64 传 imageBytes。
  throw new Error('qwen 真实调用待切片 D 实现;当前未配置 QWEN_API_KEY 时走 mock 验证链路')
}

/** 一份结构合法的占位分析(仅供本地链路验证,数值非真实判定)。 */
function mockAnalysis(): QwenAnalysis {
  return {
    skinAxes: {
      oilDry: { value: 'O', confidence: 0.82 },
      sensitivity: { value: 'S', confidence: 0.41 },
      acne: { value: 'F', confidence: 0.7 },
      pigment: { value: 'P', confidence: 0.63 },
    },
    zones: [
      { area: 'T区', issues: ['出油明显', '毛孔粗大'], score: 5 },
      { area: '脸颊', issues: ['轻微泛红'], score: 7 },
    ],
  }
}
