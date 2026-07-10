<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W1 · CF 后端核心链路

**最后更新:** 2026-07-10
**状态:** 🟢 主链路完成(含真实 VL 调用 + 切片 E 输入质检)

## 目标

跑通后端 demo:图片上传 → 多模态分析 → 结构化结果 → 历史落库。

## 范围

- [x] `server/` scaffold:Cloudflare Workers + Hono(`wrangler.jsonc`、`.dev.vars`)
- [x] 图片上传接口 → R2 临时对象(用后即删,见 ADR 0003)—— `src/storage.ts` put/get/deleteTempImage;删除落在 `/analyze` 的 finally 确保执行;端到端 put/get 实证通
- [x] 调通义千问 VL 多模态分析 —— **真实调用通**(2026-07-09,`src/qwen.ts`:用户 MaaS 专属端点 `/compatible-mode/v1` + `qwen3-vl-plus`,base64 data URL 传图,prompt 文字约束形状 + 宽松解析[剥围栏/截花括号]+ 既有 validateReport 后校验,不走 strict json_schema[min/max 兼容存疑,见下注]);空 key 仍走 mock(回归验证过)。真图实测:`/analyze` 200(~3.7s)返回真实判定(D-R-F-N 干皮,敏感维置信 0.3 如约偏低),落库 + 删临时图无错、`/history` 读回
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

## 📋 切片 E · 输入质检:翻拍/印刷脸/范围不合理拒绝(2026-07-08 立项,✅ 2026-07-10 完成)

**落地(2026-07-10):** `qwen.ts` SYSTEM_PROMPT 前置 gate 判定(not_face / recapture / too_far / low_quality 四类 + 示例指引文案)+ `extractGate()`(**fail-open**:缺 gate 字段 / pass 非 false 一律放行——质检是可信度增强非安全边界,prompt 漂移不应打断主链路);`index.ts` 在 analyzeImage 后分流:不合格 → **422** + `{error: 指引}`(finally 删临时图覆盖拒绝路径,拒绝不落库)。前端零改动(`api.ts` 非 200 已 reject `data.error` → capture 页 toast + 留在页可重拍),契约未动。
**实测坑:** ①措辞「真人面部实拍」会让模型推测照片来源,已改为「只依据画面内容判断,不要推测来源/是否本人」;②**名人/著名图片**(奥巴马官方肖像、lenna)仍被拒 not_face——直连极简 prompt 验证模型能看见并识别人脸,判定为模型对可识别公众人物做肤质分析的自我审查,**接受**(真实用户拍自己不受影响);③匿名自拍脸占比 ~20% → too_far 拒(指引正确),裁成特写 → 200 真实报告(O-R-F-N 油皮)。

审计定性:**输入质量问题,非安全问题**——「相册选图」天然绕过任何相机侧手段、无对抗动机(拍杂志脸只伤自己的报告),真实风险是垃圾输入照出正经报告伤**可信度**。故做"识别 → 拒绝 → 重拍指引",不做"禁止"。

- **方案(P1):** 千问 VL **同一次调用**的 prompt 加前置判定 ①真人面部实拍(排除屏幕翻拍/印刷品/卡通/非人脸——摩尔纹、屏幕边框、印刷网点、纸面反光等特征)②范围/质量(人脸占比、正脸、清晰度、光线)。不合格 → `/analyze` 返 4xx + `{error: 具体指引}`(如「检测到可能是翻拍照片,请直接拍摄面部」「距离太远,请让面部占满取景框」)。
- **改动面:** 全在 server 内部——`qwen.ts` 的 VL 输出结构加质检字段 + prompt、`index.ts` 分流 4xx;**公共契约 `skin-report.schema.json` 不动**(它只管 report,拒绝走现有 `{error}` 错误形态);前端近零改动(`api.ts` 已把 `data.error` 直显 toast、留拍照页可重拍)。约 2~3 小时;真实效果**只能等切片 D(真 key)实测**,mock 阶段仅能搭管道。
- **边界(接受):** 挡得住随手翻拍(摩尔纹/边框/网点明显的),挡不住高质量翻拍(好屏幕好打光)——但其皮肤纹理本就接近真实照片,肤质结果偏差有限,不值得为此上核身级活体。
- **P2(缓):** 小程序端 `<camera>` 实时预览 + 官方 VisionKit 人脸检测做**拍摄时**引导(太远/太近/请正对);仅小程序有官方免费能力(H5 需拖数 MB 检测模型、App 需原生插件),等小程序真机通、成为主入口再议。
- **明确不做:** 活体/核身 SDK(微信核身接口仅政务金融类目、商用 SDK 成本高、相册路径照样绕过;且多处理人脸数据与「分析后即删」最小化姿态相反,2025 人脸识别新规下保持"非人脸识别用途"是优势)、EXIF 校验(`chooseImage` 压缩后即无、可伪造)、端侧摩尔纹算法(研究级,误报率高)。

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
| 2026-07-09 | 切片 D 代码落地:`qwen.ts` 真实调用(DashScope OpenAI 兼容,默认 `qwen-vl-max-latest`,base64 传图,prompt 约束「四维+分区」裸 JSON + 合规描述性用语,不上 strict json_schema 改宽松解析 + validateReport 后校验);`tsc` 过、空 key mock 路径回归通(curl /analyze 全链路)。**真 key 实测待用户填 `.dev.vars`** | Claude |
| 2026-07-09 | 真 key 联调排障:用户 MaaS 专属端点兼容路径实测为 `/compatible-mode/v1`(`/api/v1`、`/v1` 均 404);`qwen3.7-max` 为**纯文本**不吃 `image_url`(400),默认模型改 `qwen3-vl-plus`;该 key 有**模型级限制**,所有 VL/omni 模型均 403 `access_denied`。代码侧已就绪(`/analyze` 日志确认打到正确端点+模型,卡 403)。**待用户在控制台给 key 放行 VL 模型** | Claude |
| 2026-07-09 | **切片 D 完成**:用户放行 `qwen3-vl-plus` 后真图实测通 —— `/analyze` 200(~3.7s)返回真实 VL 判定(lenna 测试图 → D-R-F-N 干皮,四维置信为真实值、敏感维 0.3 偏低符合 prompt 约定,3 分区描述性 issues),契约校验过、D1 落库、finally 删临时图无错、`/history` 读回。W1 两条验收达成;注意:放行后授权生效有约 1 分钟延迟(期间仍 403) | Claude |
| 2026-07-09 | **部署上线**(用户同意远程操作):远程 D1 建库(id 回填 wrangler.jsonc)+ 迁移 0001 应用;R2 `skin-checker-img` 建 + 1 天生命周期兜底(ADR 0003);`index.ts` 挂 `basePath('/api')`(生产路由 `skin.9shi.cc/api/*` 转完整路径,本地同为 /api/*,tsc + curl 验证);`wrangler deploy` 上线 + `QWEN_API_KEY` secret。待用户 dashboard 绑 Pages 自定义域名后 DNS 生效 | Claude |
| 2026-07-08 | 立项切片 E 输入质检(**未排期,仅文档**,依赖切片 D):VL 同一次调用前置判定"翻拍/印刷脸/非人脸/范围不合理"→ 4xx + `{error}` 指引重拍;定性输入质量非安全(相册路径绕过、无对抗动机),公共契约不动、前端近零改;活体·核身 SDK / EXIF / 端侧摩尔纹明确不做,小程序 VisionKit 拍摄时引导列 P2 缓 | Claude |
| 2026-07-10 | **切片 E 完成**(起因:线上非人脸照仍出报告):qwen.ts gate 前置判定 + extractGate fail-open,index.ts 不合格返 422 + `{error: 指引}`;前端零改、契约未动。本地验证:mock 回归 200、非人脸 422、匿名自拍 too_far 422(指引正确)、脸部特写 200 真实报告、422 不落库、H5 端到端(拍照页上传→toast 指引→留在页)。prompt 措辞坑与名人照被拒(模型自我审查,接受)记切片 E 落地小节;顺带发现本地 D1 曾缺表,已 `--local` 重新 apply 迁移 | Claude |
