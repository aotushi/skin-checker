<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W5 · server 迁移阿里云 FC(双部署目标)

**最后更新**: 2026-07-14
**状态:** 🟢 后端联调完成(切片 A+B 全通:FC 线上真 key 422 验证 + 耗时对比 **~9 倍提升**);⏳ 前端 `API_BASE` 切换另议

> 目标:优化大陆用户 `/analyze` 耗时(CF 美西 PoP 往返 + 原图直传所致)。方案 = server 增加阿里云 FC(Web 函数)为第二部署目标,一套业务两处部署(见 `docs/adr/0010-dual-deploy-worker-and-fc.md`);Workers 保留。FC 函数已由用户在控制台创建(cn-hangzhou / `skin-checker` / 0.25 vCPU / 0.5GB / 最小实例 0 / 并发 20 / 自定义运行时 Node.js 22 Debian 11 / `npm run start` / 端口 9000 / 超时 60s / 公网开;日志监控未开——账号未开通 SLS)。

## 范围(切片)

### ✅ A. 代码映射:平台适配层(2026-07-14)
- `src/platform.ts`:`PlatformDeps` 接口(stashImage / saveReport / listHistory / qwenApiKey)+ `HistoryRow` 形状(自 db.ts 挪入)。
- `src/app.ts`:`createApp(resolveDeps)` 工厂 —— 原 index.ts 全部路由平移,业务零改动,平台依赖改注入;`stash.cleanup()` 约定不抛(平台实现自兜底记日志)。
- `src/index.ts` → Workers 入口:R2 put/get/delete 组装成 `stashImage`(get 空 → 删除兜底后抛 500,与原行为等价)、D1 落库、`env.QWEN_API_KEY`。
- `src/index.fc.ts` → FC 入口:`@hono/node-server` 监听 `FC_SERVER_PORT ?? 9000`(hostname 0.0.0.0);图片 `file.arrayBuffer()` 内存直读(不落存储,ADR 0003 语义不变);历史 no-op / 恒空(V2 预留);key 走 `process.env`。
- `scripts/build-fc.mjs`:esbuild 单文件 `dist/fc/index.mjs`(153KB,依赖全内联)+ 最小 package.json(`start` = `node index.mjs`);`dist/` 已在 .gitignore。
- package.json:`build:fc` / `start:fc`(`node --env-file=.dev.vars`);依赖 +`@hono/node-server@^1.19.9`,dev +`esbuild@^0.27.3`。
- `tsc --noEmit` 全绿。

### ✅ 本地验证(2026-07-14)
- **FC 入口 mock**(无 env,空 key):`/api/health` 200;`/api/analyze`(multipart 传图)200 全链(mock 分析 → 派生 `O-S-F-P 油敏色皮` → 契约校验 → envelope);`/api/history` `{items:[]}`;未知路由 404;错字段名 400。
- **FC 入口真 key**(`pnpm start:fc`):非人脸图真调百炼 VL → 422「未检测到人脸…」(gate 生效,2.0s)。
- **Workers 回归**(`wrangler dev` :8890):health 200;真 key 422(R2 暂存 put/get/delete 路径通);`/history` 读回既有本地 D1 数据。写路径 `insertReport` 函数体零改动仅调用点搬迁。

### ✅ B. FC 部署联调(2026-07-14)
- ✅ ZIP 上传(2026-07-14,用户操作):控制台 WebIDE 确认文件树 = `index.mjs` + `package.json`(代码大小 34KB),内容即 esbuild 产物。
- ✅ 触发器认证方式「签名认证」→「无需认证」(2026-07-14,用户确认提交):默认触发器签名认证会在网关层拦匿名请求(实测 400 `MissingRequiredHeader: Date`,不到函数),H5 直连必须无需认证 —— 与 Workers 版 `skin.9shi.cc/api/*` 公开可调对等(10MB 限制 + 422 gate 兜滥用面)。
- ✅ 公网域名冒烟(mock 链路,2026-07-14):**`https://skin-checker-egkggmemue.cn-hangzhou.fcapp.run`** —— `/api/health` 200(冷启动 1.36s / 热 0.22s);`/api/history` `{items:[]}`;404 探针过;缺 file 400;**真图 2MB POST `/api/analyze` → 200 mock envelope,0.57s(含上传,大陆→杭州)**。
- ✅ FC 环境变量 `QWEN_API_KEY` 已配(2026-07-14,用户填值并部署;变量名表单 Claude 预填)。
- ✅ 真 key 验证 + 耗时对比(2026-07-14,大陆本机实测,同一张 2MB 非人脸图真调百炼到 422):

  | 链路 | health RTT | `/api/analyze`(2MB 真调) |
  | --- | --- | --- |
  | **FC cn-hangzhou** | 0.20s | **4.06s / 3.74s** |
  | Workers(CF 美西 PoP) | 0.71s | 36.79s / 34.20s |

  **~9 倍提升**。Workers 慢因:大陆→美西 2MB 上传段 + R2 put/get 中转 + 美西→百炼(杭州)跨洋往返;FC 全程同区域。422 即证明真调(mock 不产生 422)。真人脸 200 路径线上未真调(repo 无真人脸照片;mock 200 已覆盖 assembleReport/validateReport/envelope 同一代码路径),留前端切换后用户真机验证。
- ⏳ 前端 `API_BASE` 切换策略(H5/小程序按域名分流 or 全量切 FC)另议;小程序合法域名需 ICP 备案,FC 自定义域名同卡备案 —— 前期 H5 用 FC 默认域名 + CORS。

### ⏳ 遗留(挂起项)
- 账号未开通 SLS,FC 日志监控未启用 —— 用户自行开通后在函数「日志」配置打开,否则线上问题盲调。
- 前端 canvas 压图(H5 `sizeType:['compressed']` 不生效,原图 3-10MB 直传)为耗时另一大头,独立切片待排。

## 验收

- ✅ 一套业务代码,`tsc` 全绿,两入口本地各自跑通(FC mock 200 全链 + 真 key 422;Workers 回归无破坏)。
- ✅ FC 线上默认域名 `/api/analyze` 真图全链通(mock 200 全链 + 真 key 422),大陆链路耗时对比已记录(FC ~4s vs Workers ~35s,~9 倍)。

## 📝 变更历史

| 日期 | 变更内容 | 修改人 |
|------|---------|--------|
| 2026-07-14 | 建 W5:平台适配层落地(platform.ts + app.ts 工厂 + 双入口 + esbuild 单文件构建);本地双链路验证(FC mock 200 / 真 key 422 / Workers 回归);ADR 0010 | Claude |
| 2026-07-14 | 切片 B 推进:ZIP 上线验证 ✓;触发器改无需认证(签名认证挡匿名请求)✓;公网域名 mock 冒烟全过(真图 2MB 0.57s);剩 QWEN_API_KEY + 真 key 验证 + 耗时对比 | Claude |
| 2026-07-14 | 切片 B 收官:QWEN_API_KEY 配置(用户)+ 真 key 422 验证 ✓;耗时对比 FC ~4s vs Workers ~35s(**~9 倍**),W5 后端联调完成;剩前端 API_BASE 切换(另议) | Claude |
