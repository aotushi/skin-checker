# ADR 0010:server 双部署目标(Cloudflare Workers + 阿里云 FC)

- **状态:** 已采纳
- **日期:** 2026-07-14

## 背景

生产后端在 Cloudflare Workers,大陆用户到 CF 通常路由至美西 PoP(RTT 150-250ms、高峰丢包),叠加原图直传后 `/analyze` 整体耗时过长。为优化大陆链路,引入阿里云函数计算 FC(Web 函数,cn-hangzhou,与百炼端点同区)作为第二部署目标;Workers 侧保留服务海外/现有域名。曾评估并否决「香港服务器中转」(加跳不减跳、引运维成本)。

## 决策

- **一套业务,两个部署目标**:业务路由唯一定义在 `server/src/app.ts` 的 `createApp(resolveDeps)` 工厂;平台差异收敛到 `platform.ts` 的 `PlatformDeps` 接口(图片暂存 / 历史落库 / 密钥来源),由两个入口各自实现:
  - `index.ts`(Workers):R2 暂存中转 + D1 历史 + `wrangler secret`。
  - `index.fc.ts`(FC):`@hono/node-server` 自监听(`FC_SERVER_PORT`,默认 9000);图片**内存直读不落存储**(同样满足 ADR 0003「分析后不留存」);历史 **no-op / 恒空**(前端历史本就在设备本地,后端历史属 V2 用户体系预留);key 走 FC 环境变量。
- **FC 产物**:`pnpm build:fc` 用 esbuild 打成单文件 `dist/fc/index.mjs` + 最小 `package.json`(`npm run start` = `node index.mjs`),ZIP 后控制台上传,零 node_modules。
- Hono 跨 runtime,`qwen.ts` / `derive.ts` / `validate.ts` 等纯逻辑零改动共享。

## 后果

- ➕ 大陆链路迁移不分叉代码库;新增平台只需实现一个接口;`@cfworker/json-schema` 免 eval 的选型在两个 runtime 通用。
- ➖ FC 侧无后端历史(V2 接阿里云存储时再实现 `PlatformDeps`);双目标各自部署、需各自验证;FC 自定义域名受 ICP 备案约束,前期用默认域名 + CORS 跨域调用。
