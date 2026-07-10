import type { SkinReport } from "./types/skin-report";

// 千问 VL 多模态分析:传图 + schema 约束 → 结构化候选(unknown,交 validateReport 把关)。
// 只判定「四维 + 分区」(看图能得出的);skinTypeCode / skinTypeName / suggestions / disclaimer
// 由后端派生注入(suggestions 按判定型号取 16 型手册,不交给 LLM,防幻觉与法务文案漂移,见 ADR 0006 / 0008)。
// 输入质检(W1 切片 E):同一次调用内前置 gate 判定(非人脸/翻拍/距离/质量),不合格由
// index.ts 返 422 + 重拍指引;定性为可信度增强非安全边界(相册路径天然可绕过)。

export interface QwenConfig {
  apiKey: string;
  baseUrl?: string;
  model?: string;
}

/** 千问只判定这两块,其余(code / name / suggestions / disclaimer)后端派生。 */
export type QwenAnalysis = Pick<SkinReport, "skinAxes" | "zones">;

// OpenAI 兼容端点;模型可由 cfg 覆盖(计费与质量权衡:vl-max 判肤质更稳,vl-plus 更省)。
// 该 MaaS 专属域名的兼容路径实测为 /compatible-mode/v1(/api/v1、/v1 均 404);公共端点备选:
// https://dashscope.aliyuncs.com/compatible-mode/v1
const DEFAULT_BASE_URL = "https://llm-iuwoeai21ul6aqmr.cn-beijing.maas.aliyuncs.com/compatible-mode/v1";

// 必须用 VL(视觉)模型:qwen3.7-max 为纯文本,不吃 image_url(实测 400)。
// 注意 API key 有模型级限制,需在控制台放行所选 VL 模型(否则 403 access_denied)。
const DEFAULT_MODEL = "qwen3-vl-plus";

// 提示词只要「gate + 四维 + 分区」的裸 JSON;不喂完整 JSON Schema(strict json_schema 对
// minimum/maximum 兼容存疑,见 tasks/W1 注意项),形状写进文字约束,后校验由 validateReport 兜底。
// 合规:描述性用语,禁诊断/疾病措辞(ADR 0008 同向约束在生成侧;gate 的 message 同受此约束)。
const SYSTEM_PROMPT = `你是护肤参考助手。先判定照片是否适合做肤质评估(gate),合格才对肤质状态做描述性评估。只输出 JSON,不输出任何其它文字、解释或 markdown 代码块。
输出形状(严格遵守):
{"gate":{"pass":布尔,"reason":"不通过的原因代码,通过时给空串","message":"不通过时给用户的一句中文拍摄指引,通过时给空串"},"skinAxes":{"oilDry":{"value":"O或D","confidence":0到1的小数},"sensitivity":{"value":"S或R","confidence":0到1的小数},"acne":{"value":"A或F","confidence":0到1的小数},"pigment":{"value":"P或N","confidence":0到1的小数}},"zones":[{"area":"分区名","issues":["问题点"],"score":0到10的整数}]}
gate 只依据画面内容判断,不要推测照片来源、拍摄场合或是否用户本人;出现任一情形则 pass=false,并省略 skinAxes 与 zones:
- 画面中没有真人面部(风景/物品/动物/卡通/插画/图标/文字截图等)→ reason "not_face",message 如「未检测到人脸,请正对镜头拍摄面部照片」
- 画面有明显翻拍痕迹(摩尔纹、屏幕边框、像素点阵、印刷网点、纸面反光)→ reason "recapture",message 如「照片疑似翻拍,请直接拍摄面部」
- 人脸占画面过小或大部分偏出画面 → reason "too_far",message 如「距离太远,请让面部占满取景框」
- 过暗、过曝或严重模糊到无法评估 → reason "low_quality",message 如「光线不佳或照片模糊,请在自然光下重拍」
message 是给用户看的拍摄指引;禁止出现疾病名、诊断类措辞。
pass=true 时继续输出 skinAxes 与 zones:
四维含义:oilDry O偏油/D偏干;sensitivity S偏敏感/R偏耐受(单张照片判定不稳,置信度应偏低);acne A有痘/F无痘;pigment P有色沉/N无色沉。confidence 是你对该维判定的把握,不确定就给低值。
zones 按可见区域给 2~4 条(如 T区、脸颊、下巴),issues 用日常描述(如 出油明显、毛孔粗大、轻微泛红、散在痘印),score 越高状态越好。
禁止出现疾病名、诊断、治疗类措辞;只做外观描述。`;

/**
 * 分析一张人脸照 → 结构化候选(unknown,交 validateReport 校验)。
 * 未配置 apiKey 时返回 mock(本地全链路验证用,不需真调、不花钱);
 * 已配置则走千问 VL 真实调用(OpenAI 兼容,base64 data URL 传图)。
 */
export async function analyzeImage(cfg: QwenConfig, imageBytes: ArrayBuffer, contentType: string): Promise<unknown> {
  if (!cfg.apiKey) return mockAnalysis();

  const res = await fetch(`${cfg.baseUrl ?? DEFAULT_BASE_URL}/chat/completions`, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      authorization: `Bearer ${cfg.apiKey}`,
    },
    body: JSON.stringify({
      model: cfg.model ?? DEFAULT_MODEL,
      temperature: 0.2,
      messages: [
        { role: "system", content: SYSTEM_PROMPT },
        {
          role: "user",
          content: [
            { type: "image_url", image_url: { url: `data:${contentType};base64,${toBase64(imageBytes)}` } },
            { type: "text", text: "请对这张照片先做 gate 判定,合格再分析肤质状态,按约定形状输出 JSON。" },
          ],
        },
      ],
    }),
  });
  if (!res.ok) {
    const detail = (await res.text().catch(() => "")).slice(0, 300);
    throw new Error(`qwen API ${res.status}: ${detail}`);
  }

  const data = (await res.json()) as { choices?: Array<{ message?: { content?: unknown } }> };
  const content = data.choices?.[0]?.message?.content;
  if (typeof content !== "string" || !content) throw new Error("qwen 返回缺少文本内容");
  return parseLooseJson(content);
}

/** 输入质检判定(W1 切片 E):pass=false 时 message 为给用户的重拍指引,reason 为原因代码(仅日志用)。 */
export interface QwenGate {
  pass: boolean;
  reason: string;
  message: string;
}

/** 质检不通过但模型没给可用指引时的兜底文案。 */
const FALLBACK_REJECT_MESSAGE = "照片不适合分析,请在自然光下正对镜头拍摄面部";

/**
 * 从 VL 原始输出提取质检结论。容错取 fail-open:缺 gate 字段 / pass 非 false 一律视为通过——
 * 质检是可信度增强非安全边界(相册路径天然可绕过),prompt 漂移不应打断主链路,
 * 报告本体仍有 validateReport 兜底。
 */
export function extractGate(raw: unknown): QwenGate {
  const g = (raw as { gate?: { pass?: unknown; reason?: unknown; message?: unknown } } | null | undefined)?.gate;
  if (!g || g.pass !== false) return { pass: true, reason: "", message: "" };
  return {
    pass: false,
    reason: typeof g.reason === "string" && g.reason ? g.reason : "unqualified",
    message: typeof g.message === "string" && g.message ? g.message : FALLBACK_REJECT_MESSAGE,
  };
}

/** base64 编码(分块过 btoa,避免大图展开成参数列表爆栈;上游已限 10MB)。 */
function toBase64(buf: ArrayBuffer): string {
  const bytes = new Uint8Array(buf);
  const CHUNK = 0x8000;
  let binary = "";
  for (let i = 0; i < bytes.length; i += CHUNK) {
    binary += String.fromCharCode(...bytes.subarray(i, i + CHUNK));
  }
  return btoa(binary);
}

/** 宽松解析 LLM 文本:先整段 JSON.parse,失败则剥代码围栏 / 截取首尾花括号再试。 */
function parseLooseJson(text: string): unknown {
  const candidates = [text.trim()];
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  if (fenced) candidates.push(fenced[1].trim());
  const first = text.indexOf("{");
  const last = text.lastIndexOf("}");
  if (first >= 0 && last > first) candidates.push(text.slice(first, last + 1));
  for (const c of candidates) {
    try {
      return JSON.parse(c);
    } catch {
      /* 试下一个候选 */
    }
  }
  throw new Error(`qwen 返回不是合法 JSON: ${text.slice(0, 200)}`);
}

/** 一份结构合法的占位分析(仅供本地链路验证,数值非真实判定;mock 不看图,gate 恒通过)。 */
function mockAnalysis(): QwenAnalysis & { gate: QwenGate } {
  return {
    gate: { pass: true, reason: "", message: "" },
    skinAxes: {
      oilDry: { value: "O", confidence: 0.82 },
      sensitivity: { value: "S", confidence: 0.41 },
      acne: { value: "F", confidence: 0.7 },
      pigment: { value: "P", confidence: 0.63 },
    },
    zones: [
      { area: "T区", issues: ["出油明显", "毛孔粗大"], score: 5 },
      { area: "脸颊", issues: ["轻微泛红"], score: 7 },
    ],
  };
}
