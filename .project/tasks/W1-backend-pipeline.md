<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W1 · CF 后端核心链路

**最后更新:** 2026-07-06
**状态:** 🟡 进行中(切片推进)

## 目标

跑通后端 demo:图片上传 → 多模态分析 → 结构化结果 → 历史落库。

## 范围

- [x] `server/` scaffold:Cloudflare Workers + Hono(`wrangler.jsonc`、`.dev.vars`)
- [x] 图片上传接口 → R2 临时对象(用后即删,见 ADR 0003)—— `src/storage.ts` put/get/deleteTempImage;删除落在 `/analyze` 的 finally 确保执行;端到端 put/get 实证通
- [ ] 调通义千问 VL 多模态分析,传入 `shared/skin-report.schema.json` 约束结构化输出 —— 接口 + mock 已通链路(`src/qwen.ts`,空 key 自动走 mock);**真实调用待切片 D**(需 QWEN_API_KEY,真调计费=自然暂停点)
- [x] 用 schema 校验 LLM 返回值 —— `@cfworker/json-schema`(非 ajv:Workers 禁 eval),`src/validate.ts`;自检确认 enum / pattern / min-max 后校验均生效
- [x] D1 建表 + 写入历史(只存结构化结果,不存原图)—— `migrations/0001_init.sql`(reports 表 + created_at 索引);`src/db.ts` insertReport/listHistory;`wrangler.jsonc` 补 DB/IMG_BUCKET binding;`--local` apply + execute 读写(含中文)验证过
- [x] 本地全链路验证(unstable_dev/miniflare,纯本地,不碰远程)—— `POST /analyze`(存R2→读回→mock分析→派生 O-S-F-P/油敏色皮→校验→落D1→finally 删图)+ `GET /history` 读回,均通;真实 `wrangler dev` + 真 qwen 待切片 D
- [x] 16 型手册映射(name + 按型 suggestions)—— `scripts/gen-skin-type-map.mjs` 从 `docs/raw-data` 16 型手册生成 `src/skin-type-map.ts`(code→中文名+护理建议);`derive.ts` 按判定型号取权威 name/suggestions;只取 `skincare_strategy`(成分/品类层),排除 `product_pairing` 品牌(ADR 0006),脚本内置产品名护栏;`pnpm gen:skinmap` 固化;本地 E2E(O-S-F-P→油敏色皮+手册 5 条建议)验证过
- [x] CORS(H5 端跨域联调必需)—— `src/index.ts` 挂 `hono/cors`(`app.use('/*', cors())`);MVP 放开所有源(接口无凭证),部署时收紧到实际前端域名;微信小程序/APP 走原生请求不受 CORS。本地验证:预检 `OPTIONS /analyze`→204 带 `allow-origin`/`allow-methods`(含 POST),`/health` 响应带头

## ⚠️ 注意

- **16 型 name / suggestions 已接入手册映射**:`src/derive.ts` 按判定 code 从 `src/skin-type-map.ts`(由 `scripts/gen-skin-type-map.mjs` 从 `docs/raw-data` 16 型手册生成)取权威中文名 + 按型护理建议;规则拼接与 mock suggestions 已下线。`suggestions` 只到成分/品类层(仅取 `skincare_strategy`,排除 `product_pairing` 品牌,ADR 0006)。改护理内容 → 改源数据后重跑 `pnpm gen:skinmap`,勿手改产物。
- **schema 喂 LLM 的关键字兼容**:`confidence` / `score` 的 `minimum` / `maximum` 在 OpenAI 严格 `json_schema` 模式**不被支持**(`enum` 支持)。千问VL 兼容接口若走 strict 会被拒。先实测;不吃则降级为 JSON mode + ajv 后校验(schema 保留 min/max 给 ajv 用,不动)。
- **正式回归测试后置**:经确认(2026-07-06)MVP 阶段暂不补测试,优先前端两端成品;后端靠已验证的手动 E2E(unstable_dev)兜底。CLAUDE.md 规划的 `vitest` + `@cloudflare/vitest-pool-workers` 留前端联调稳定后 / V2 接,**勿误判为遗漏**。

## 验收

- 一张正脸照 → 返回符合 `skin-report.schema.json` 的结果 JSON。
- 历史接口能读回该条记录。

## 📝 变更历史

| 日期 | 变更内容 | 修改人 |
|------|---------|--------|
| 2026-06-16 | 创建任务,W1 范围与验收 | Claude |
| 2026-06-17 | 补 schema 喂 LLM 的 min/max strict 兼容注意 | Claude |
| 2026-06-17 | server scaffold(Hono + /health);tsc / wrangler types / dry-run 三层验证过 | Claude |
| 2026-07-06 | 切片 A 契约校验地基:@cfworker/json-schema 编译 2020-12 schema → validateReport;自检确认 enum/pattern/min-max 生效;tsc 过 | Claude |
| 2026-07-06 | 切片 B D1 历史:0001_init.sql 建表+索引,src/db.ts 读写模块,server 端从 schema 生成 SkinReport 类型,wrangler.jsonc 补 DB/IMG_BUCKET binding;typegen+tsc 过,--local apply + execute 读写(含中文)验证 | Claude |
| 2026-07-06 | 切片 C 主链路编排:storage.ts(R2 临时图 put/get/del)、qwen.ts(analyzeImage 接口+mock)、derive.ts(四维派生 code/name + 注入 disclaimer)、index.ts(/analyze·/health·/history + onError);.dev.vars 空 key 占位→typegen 纳入 Env;unstable_dev 端到端 /analyze→/history 全通(mock),tsc 过 | Claude |
| 2026-07-06 | 手册映射切片:scripts/gen-skin-type-map.mjs 从 16 型手册生成 src/skin-type-map.ts(code→名+按型建议,仅取 skincare_strategy 排除品牌,内置产品名护栏);derive.ts 的 name/suggestions 改从映射取,qwen 收窄到四维+分区不再产 suggestions;pnpm gen:skinmap 固化;tsc + 本地 E2E(O-S-F-P→油敏色皮+手册 5 条)过 | Claude |
| 2026-07-06 | 补 CORS:index.ts 挂 hono/cors 中间件(H5 跨域联调必需),MVP 放开所有源、部署时收紧;tsc + 本地预检(OPTIONS /analyze→204 带 allow-origin/methods)验证 | Claude |
