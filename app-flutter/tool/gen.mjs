// W3 切片 B:两条生成线的固化入口(node tool/gen.mjs,在 app-flutter/ 或 repo 根均可跑)。
// ① shared/skin-report.schema.json → lib/models/skin_report.dart(quicktype)
// ② shared/design-tokens.json     → lib/theme/tokens.dart(DTCG 展平 → Dart 常量)
// 产物禁手改(ADR 0001/0007);改契约/token 只改 shared/*.json 后重跑本脚本。
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, resolve } from 'node:path'
import { spawnSync } from 'node:child_process'

const here = dirname(fileURLToPath(import.meta.url))
const APP = resolve(here, '..')
const SHARED = resolve(APP, '../shared')

// ---------- ① 契约 → Dart model ----------
function genModels() {
  const out = resolve(APP, 'lib/models/skin_report.dart')
  mkdirSync(dirname(out), { recursive: true })
  const r = spawnSync(
    'npx',
    ['-y', 'quicktype', '--src-lang', 'schema', resolve(SHARED, 'skin-report.schema.json'), '-l', 'dart', '-o', out],
    { shell: true, stdio: 'inherit' },
  )
  if (r.status !== 0) throw new Error('quicktype 生成失败')
  console.log('✓ 契约 → lib/models/skin_report.dart')
}

// ---------- ② token → Dart 常量 ----------
// 命名:kebab/点路径 → lowerCamel;纯数字段前缀 s(space 档位),数字开头段如 2xl → xl2。
function leafName(segs) {
  const norm = segs.map((s) => {
    if (/^\d+$/.test(s)) return `s${s}`
    const m = s.match(/^(\d+)(.+)$/)
    return m ? `${m[2]}${m[1]}` : s
  })
  const joined = norm.join('-')
  return joined.replace(/-([a-z0-9])/g, (_, c) => c.toUpperCase())
}

// '#A85A48' → 'Color(0xFFA85A48)';'rgba(160,90,72,0.10)' → 'Color.fromRGBO(160, 90, 72, 0.10)'
function dartColor(v) {
  if (v.startsWith('#')) return `Color(0xFF${v.slice(1).toUpperCase()})`
  const m = v.match(/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([\d.]+))?\s*\)/)
  if (!m) throw new Error(`无法解析颜色: ${v}`)
  return `Color.fromRGBO(${m[1]}, ${m[2]}, ${m[3]}, ${m[4] ?? 1})`
}

// CSS box-shadow 串(offsetX offsetY blur [spread] rgba(...))→ BoxShadow 构造串
function dartShadow(css) {
  const m = css.match(/^(.+?)\s*(rgba?\([^)]+\))\s*$/)
  if (!m) throw new Error(`无法解析阴影: ${css}`)
  const len = m[1].trim().split(/\s+/).map(parseFloat)
  const spread = len[3] ? `, spreadRadius: ${len[3]}` : ''
  return `BoxShadow(color: ${dartColor(m[2])}, offset: Offset(${len[0]}, ${len[1]}), blurRadius: ${len[2]}${spread})`
}

const num = (v) => String(parseFloat(v)) // '11px' → '11',1.55 → '1.55'

function genTokens() {
  const tokens = JSON.parse(readFileSync(resolve(SHARED, 'design-tokens.json'), 'utf8'))
  // 按顶层组分类收集:组名 → [{name, decl, doc}]
  const groups = new Map()
  const put = (group, name, decl, doc) => {
    if (!groups.has(group)) groups.set(group, [])
    groups.get(group).push({ name, decl, doc })
  }

  function walk(node, path) {
    if (node && typeof node === 'object' && '$value' in node) {
      const [group, ...rest] = path
      const name = leafName(rest.length ? rest : [group]) // 组下直挂叶子(如 color.on-dark)用叶名本身
      const v = node.$value
      const doc = node.$description
      if (group === 'color' || group === 'gradient') {
        put(group, name, `static const Color ${name} = ${dartColor(v)};`, doc)
      } else if (group === 'shadow') {
        put(group, name, `static const BoxShadow ${name} = ${dartShadow(v)};`, doc)
      } else if (group === 'typography' && path[1] === 'family') {
        put(group, name, `static const List<String> ${name} = [${v.map((s) => `'${s}'`).join(', ')}];`, doc)
      } else if (group === 'typography' && path[1] === 'weight') {
        put(group, name, `static const FontWeight ${name} = FontWeight.w${v};`, doc)
      } else {
        // typography.size / typography.leading / radius / space → double
        put(group, name, `static const double ${name} = ${num(v)};`, doc)
      }
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

  const CLASS = {
    color: ['SknColors', '色板'],
    gradient: ['SknGradients', '渐变起止色(角度见 shared JSON $description,使用侧拼 LinearGradient)'],
    typography: ['SknTypography', '字体 / 字号 / 字重 / 行高'],
    radius: ['SknRadius', '圆角'],
    space: ['SknSpace', '间距档位'],
    shadow: ['SknShadows', '阴影(已按分量转 BoxShadow)'],
  }
  const body = [...groups.entries()]
    .map(([group, items]) => {
      const [cls, note] = CLASS[group]
      const members = items
        .map(({ decl, doc }) => (doc ? `  /// ${doc}\n  ${decl}` : `  ${decl}`))
        .join('\n\n')
      return `/// ${note}\nabstract final class ${cls} {\n${members}\n}`
    })
    .join('\n\n')

  const banner = `// ⚙️ 生成产物,请勿手改。
// 源:shared/design-tokens.json(DTCG 单一真相源,ADR 0007)
// 重新生成:node tool/gen.mjs
import 'package:flutter/painting.dart';\n\n`
  const out = resolve(APP, 'lib/theme/tokens.dart')
  mkdirSync(dirname(out), { recursive: true })
  writeFileSync(out, banner + body + '\n', 'utf8')
  let count = 0
  for (const items of groups.values()) count += items.length
  console.log(`✓ ${count} 个 token → lib/theme/tokens.dart`)
}

// 产物过 dart format,保证「生成 → format 无 diff」幂等(工具链要求,ADR 0004)。
// 优先 PATH 里的 dart,本机未注入 PATH 时退到固定安装位(W3 文档切片 A)。
function formatOutputs() {
  const files = [resolve(APP, 'lib/models/skin_report.dart'), resolve(APP, 'lib/theme/tokens.dart')]
  for (const dart of ['dart', 'E:/dev/flutter/bin/dart.bat']) {
    const r = spawnSync(dart, ['format', ...files], { shell: true, stdio: 'pipe' })
    if (r.status === 0) {
      console.log('✓ 产物 dart format 完成')
      return
    }
  }
  throw new Error('dart format 失败:PATH 与 E:/dev/flutter 均不可用')
}

genModels()
genTokens()
formatOutputs()
