// 从 16 型肌肤手册生成 server/src/skin-type-map.ts(code → 中文名 + 按型护理建议)。
// 源:docs/raw-data/history_skin-info/history_skin_info_structured.json。
// 只取 skincare_strategy(成分/品类/思路层),排除 product_pairing 的具体产品
// (品牌/品名不进 MVP 契约,见 docs/adr/0006-skin-type-16-axes.md)。
// 内置产品名护栏:strategy 若命中产品名指示词即抛错拒绝生成,防未来源数据把品牌打包进 Worker。
// 用法:node scripts/gen-skin-type-map.mjs(或 pnpm gen:skinmap)。改护理内容→改源数据后重跑,勿手改产物。

import { readFileSync, writeFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, resolve } from 'node:path'

const here = dirname(fileURLToPath(import.meta.url))
const RAW = resolve(here, '../../docs/raw-data/history_skin-info/history_skin_info_structured.json')
const OUT = resolve(here, '../src/skin-type-map.ts')

// 产品名指示词:命中即判定该条含具体产品,拒绝生成(合规护栏,ADR 0006)。
const PRODUCT_TOKENS = ['绿茶多酚水', '姜黄凝露', '维A醇霜', '精华', '凝露', '面膜', '乳液', '洁面', '爽肤', '水:', '霜:']

const data = JSON.parse(readFileSync(RAW, 'utf8'))
const cls = data.subjects.find((s) => s.subject_id === 'skin_type_classification')
if (!cls) throw new Error('未找到 skin_type_classification 子集')

const routineById = Object.fromEntries(
  data.subjects.filter((s) => s.content_type === 'skin_type_routine').map((s) => [s.subject_id, s]),
)

const types = cls.skin_types ?? []
if (types.length !== 16) throw new Error(`预期 16 型,实际 ${types.length} 型`)

const map = {}
for (const t of types) {
  const routine = routineById[t.routine_subject_id]
  if (!routine) throw new Error(`型 ${t.code} 缺护理方案 routine(${t.routine_subject_id})`)
  const suggestions = (routine.skincare_strategy ?? []).map((st) => {
    const line = `${st.strategy}:${(st.details ?? []).join(';')}`
    for (const tok of PRODUCT_TOKENS) {
      if (line.includes(tok)) throw new Error(`型 ${t.code} 建议含疑似产品名"${tok}"(ADR 0006 禁具体产品):${line}`)
    }
    return line
  })
  if (!suggestions.length) throw new Error(`型 ${t.code} 无 skincare_strategy`)
  map[t.code] = { name: t.normalized_name, suggestions }
}

const banner = `// ⚠️ 本文件由 scripts/gen-skin-type-map.mjs 生成,请勿手改。
// 源:docs/raw-data/history_skin-info/ 的 16 型肌肤手册(skin_type_classification + routine_*)。
// 内容 = 每型中文名(normalized_name)+ 按型护理建议(仅取 skincare_strategy 策略层)。
// 已排除 product_pairing 的具体产品(品牌/品名不进 MVP 契约,见 docs/adr/0006-skin-type-16-axes.md);
// 生成脚本内置产品名护栏,源数据若引入品牌名会拒绝生成。
// 改护理内容 → 改源数据后重跑 \`pnpm gen:skinmap\`,勿手改本产物。

/** 单一皮肤型的展示信息:中文名 + 按型护理建议(成分/品类/思路层)。 */
export interface SkinTypeInfo {
  name: string
  suggestions: string[]
}

/** 16 型肌肤 code(O-S-A-P 序)→ 展示信息;后端派生 skinTypeName / suggestions 的权威来源。 */
export const SKIN_TYPE_MAP: Record<string, SkinTypeInfo> = ${JSON.stringify(map, null, 2)}
`

writeFileSync(OUT, banner, 'utf8')
console.log(`已生成 ${OUT}(${Object.keys(map).length} 型)`)
