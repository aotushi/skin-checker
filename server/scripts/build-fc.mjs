// FC 代码包构建:esbuild 把 src/index.fc.ts 打成单文件(hono / @hono/node-server /
// @cfworker/json-schema / shared schema 全部内联,产物零 node_modules),
// 外加最小 package.json —— FC 控制台启动命令 `npm run start` 对应 `node index.mjs`。
// 产物目录 dist/fc/(已被 .gitignore 的 dist/ 覆盖);上传 = 把 dist/fc 打成 ZIP。
import { build } from 'esbuild'
import { writeFile, mkdir } from 'node:fs/promises'
import { fileURLToPath } from 'node:url'
import { join } from 'node:path'

const root = fileURLToPath(new URL('..', import.meta.url))
const outDir = join(root, 'dist', 'fc')
await mkdir(outDir, { recursive: true })

await build({
  entryPoints: [join(root, 'src', 'index.fc.ts')],
  bundle: true,
  platform: 'node',
  target: 'node22',
  format: 'esm',
  outfile: join(outDir, 'index.mjs'),
  // node: 内置模块自动 external;JSON import(shared schema)esbuild 原生支持
})

await writeFile(
  join(outDir, 'package.json'),
  JSON.stringify(
    {
      name: 'skin-checker-server-fc',
      private: true,
      type: 'module',
      scripts: { start: 'node index.mjs' },
    },
    null,
    2,
  ) + '\n',
)

console.log('dist/fc/ 就绪(index.mjs + package.json);上传:压缩 dist/fc 内两个文件为 ZIP → FC 控制台')
