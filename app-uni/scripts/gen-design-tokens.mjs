// 从 shared/design-tokens.json(DTCG 单一真相源)生成 H5 / 小程序用的 CSS 自定义属性。
// 产物 src/styles/tokens.scss 禁止手改(ADR 0007);改视觉改 design-tokens.json 后重跑 pnpm gen:tokens。
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, resolve } from 'node:path'

const here = dirname(fileURLToPath(import.meta.url))
const SRC = resolve(here, '../../shared/design-tokens.json')
const OUT = resolve(here, '../src/styles/tokens.scss')

const tokens = JSON.parse(readFileSync(SRC, 'utf8'))
const lines = []

// 递归展平:跳过 $ 开头的元数据键,遇到含 $value 的叶子就产出一条 CSS 变量。
function walk(node, path) {
  if (node && typeof node === 'object' && '$value' in node) {
    const v = node.$value
    lines.push(`  --skn-${path.join('-')}: ${Array.isArray(v) ? v.join(', ') : String(v)};`)
    return
  }
  if (node && typeof node === 'object') {
    for (const key of Object.keys(node)) {
      if (key.startsWith('$')) continue
      walk(node[key], [...path, key])
    }
  }
}

walk(tokens, [])

const banner = `/**
 * ⚙️ 生成产物,请勿手改。
 * 源:shared/design-tokens.json(DTCG 单一真相源,ADR 0007)
 * 重新生成:pnpm gen:tokens
 * H5 挂 :root、小程序根节点挂 page,两处同挂以跨端可用。
 */`

mkdirSync(dirname(OUT), { recursive: true })
writeFileSync(OUT, `${banner}\n:root,\npage {\n${lines.join('\n')}\n}\n`, 'utf8')
console.log(`✓ 生成 ${lines.length} 个 token → src/styles/tokens.scss`)
