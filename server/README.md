# server · Hono 三端共享后端(双部署目标:CF Workers + 阿里云 FC)

🟢 **W1 完成并上线(Workers)**;🟡 **W5 进行中:映射阿里云 FC 第二部署目标**(大陆链路优化,见 `../docs/adr/0010-dual-deploy-worker-and-fc.md`)。链路细节见 `../.project/tasks/W1-backend-pipeline.md` / `W5-server-fc-migration.md`。

## 栈与结构

- Hono(跨 runtime)+ 通义千问 VL(OpenAI 兼容);输出以 `../shared/skin-report.schema.json` 约束 + 校验(`@cfworker/json-schema`,免 eval,两 runtime 通用)。
- **一套业务,两个入口**(ADR 0010):

| 文件 | 职责 |
| --- | --- |
| `src/app.ts` | 业务路由唯一定义处(`createApp` 工厂,依赖注入) |
| `src/platform.ts` | `PlatformDeps` 平台差异接口(图片暂存 / 历史 / 密钥) |
| `src/index.ts` | **Workers 入口**:R2 暂存中转(ADR 0003)+ D1 历史 + secret |
| `src/index.fc.ts` | **FC 入口**(Web 函数):`@hono/node-server` 监听 9000;图片内存直读不落存储;历史 no-op(V2 预留);key 走 FC 环境变量 |

## 本地开发

```bash
pnpm install
pnpm typegen      # = wrangler types,生成 worker-configuration.d.ts(Env 类型,勿手写)
pnpm dev          # = wrangler dev,本地起 workerd(Workers 路径;父目录 launch.json 惯用 --port 8890)
pnpm build:fc     # esbuild 单文件 → dist/fc/(index.mjs + package.json)
pnpm start:fc     # 本地跑 FC 入口(node --env-file=.dev.vars,:9000;不带 env 直跑 = 空 key 走 mock)
```

## 部署

- **Workers**:`pnpm deploy`(路由 `skin.9shi.cc/api/*`;R2/D1/secret 见 wrangler.jsonc)。
- **FC**(cn-hangzhou,函数 `skin-checker`):`pnpm build:fc` 后把 `dist/fc/` 内两个文件压成 ZIP,控制台上传;启动命令 `npm run start`、监听端口 9000;`QWEN_API_KEY` 配在 FC 环境变量(高级配置 → 更多配置)。自定义域名卡 ICP 备案,前期用默认域名 + CORS。

## 密钥

- 千问VL key:`wrangler secret put QWEN_API_KEY`(Workers 远程)/ FC 控制台环境变量(FC 远程)/ `.dev.vars`(本地,不入库,模板见 `.dev.vars.example`)。
- 空 key 自动走 mock(不真调、不计费),本地全链路验证用。
