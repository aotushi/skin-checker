# NOW · skin-checker 当前状态

**最后更新:** 2026-07-10(`skin.9shi.cc` 绑定生效;H5 线上实测报的 3 项 UI 问题**同日修复完毕并本地验证**,待重新构建部署上线,见 `tasks/W2` 已知问题区块)

## 部署(2026-07-09,用户同意远程操作后执行)

- **架构**:H5 与 API 同域 `skin.9shi.cc` —— Pages 服务页面,worker 只接 `/api/*` 路由(`index.ts` 挂 `basePath('/api')`,本地 dev 同为 `/api/*`);生产 H5 同域免 CORS。
- **worker**:`wrangler deploy` 已上(版本 6a897396),路由 `skin.9shi.cc/api/*`;`QWEN_API_KEY` 已 `wrangler secret put`;远程 D1 已建(id 见 wrangler.jsonc)+ 迁移 0001 已应用;R2 `skin-checker-img` 已建 + 1 天生命周期兜底删图。
- **Pages**:项目 `skin-checker`(production branch master),H5 产物直传部署,`skin-checker.pages.dev` 已 200。
- **域名已生效(2026-07-10)**:用户已在 dashboard 绑 `skin.9shi.cc` → `https://skin.9shi.cc` = H5、`/api/*` = worker,线上可用。如需 git 自动部署,可在 dashboard 把仓库连到既有 worker/Pages 项目(`[Skip CI]` 前缀会跳过自动构建,注意)。
- **🐛 H5 线上 3 项 UI 问题(2026-07-10 实测,同日已修,本地已验证)**:① 预览不显示(`height:100%` 在不定高 flex 链塌 0 高 → 改绝对定位铺满);②③ 拍照页 / 我的页矮视口滚动条(`100vh→100dvh` 双声明 + 取景区/空态可收缩)。仅动 3 文件 CSS;**线上生效需重新 `build:h5` + Pages 部署(待用户同意)**;我的页小屏(<696 可见高)空态残余滚动已记录。详见 `tasks/W2` 「🐛 已知问题」各 ✅ 小节。
- **APK(HBuilderX,留用户)**:manifest appid 已填(`__UNI__8A0107B`);云打包勾相机/相册模块,首次装机自测拍照全流程。小程序真机延后(届时后台配 uploadFile 合法域名 `skin.9shi.cc`)。

## 阶段

🟡 **W2 前端起步(app-uni,H5 优先):** uniapp(Vue3 vite-ts)骨架 + 设计 token/类型两条生成脚本(`pnpm gen:tokens` / `gen:types`,产物禁手改)。**已建成四页 + 底部 tab 并 H5 验证通过**:首页(品牌 + 人脸拓扑网格取景意象[MediaPipe canonical 468 点投影程序生成 + 扫描光带]+ 双 CTA)、拍照页(深色相机 + 取景/拍摄要求 + `uni.chooseImage` + 分析中蒙层)、结果卡(四维双极光谱含敏感「参考」态 + 逐维度科普展开 + 分区评估 + 护理建议 + 免责声明 + 「保存报告」写本地历史)、我的(游客态 + 我的检测本地历史列表 + 免责/隐私/关于底部弹层完整声明入口)。自绘暖调底部 tab(检测 / 我的,CSS 图标走 token,`components/tab-bar`)统领导航:首页 ↔ 我的为 tab 根级(`reLaunch` 切换),拍照 / 结果为全屏二级页(navigateTo/redirectTo,不挂 tab);Fraunces 数字体 + 暖调美妆 token 全生效;`vue-tsc` 类型检查过。微信小程序端已过编译层(补 `loadFontFace`、变量本就落 `page`、`build:mp-weixin` 通过 + 产物双证),真机视觉待微信开发者工具确认(本环境无)。**已与本地 server 联调通(切片 E)**:拍照页真传图 → `/analyze` → 结果卡渲染 server envelope、「保存报告」沿用 server id(Playwright 真传图 E2E + 断服失败路径均验证)。

🟢 **W1 后端主链路全通(含真实 VL 调用,2026-07-09 切片 D 完成):** `/analyze`(R2 临时图 → 千问 VL 真调 → 四维派生 code/名 → 契约校验 → D1 落库 → 用后删图)+ `/history` 端到端验证过(纯本地不碰远程);16 型手册映射已接入、CORS 已挂。真调配置:用户 MaaS 专属端点 `/compatible-mode/v1` + `qwen3-vl-plus`(key 有模型级限制,需控制台放行;`qwen3.7-max` 纯文本不吃图),真图实测 200(~3.7s,D-R-F-N 干皮、敏感维置信 0.3 如约偏低);空 key 仍走 mock。W1 两条验收达成,仅剩切片 E 输入质检(未排期)。

## 下一步

**前端(W2 续):**
- 🐛 **H5 线上 3 项 UI 问题已修(2026-07-10,本地已验证)**:预览 0 高改绝对定位、100vh 滚动条改 dvh 双声明(B1–B3 详见 `tasks/W2` 已知问题 ✅ 小节)。**下一动作:重新 `build:h5` + Pages 部署(需用户同意)+ 用户真机复验**;我的页小屏空态残余滚动如真机仍见再压余量。
- ✅ app-uni 四页静态端 + 底部 tab 完成(首页/拍照/结果卡/我的),H5 导航闭环通、免责声明双入口可达、结果卡→本地历史(uni Storage)→「我的」回看闭环通。
- 🟡 微信小程序端代码 + 编译层已过一遍(审计无逻辑属性 / CSS 变量本就落 `page` / 补 `uni.loadFontFace` 静默降级 / `build:mp-weixin` 编译通过 + 产物双证);**待真机**:`mp-weixin.appid` 空(测试号可预览,发布填自有)+ woff2 字体配 `downloadFile` 合法域名,渲染 / Fraunces 效果需微信开发者工具确认(本环境无)。
- ✅ 与 server `/analyze` 联调通(2026-07-08,切片 E):`utils/api.ts` 传图 → envelope 暂存直达结果卡,保存沿用 server id;本地 server 起 8890(`pnpm dev --port 8890`,8787/8788 被他项目占)。
- 📋 结果页分享(2026-07-08 审计,**未排期**,详见 `tasks/W2` 切片 G):16 型标签内容天然适合分享,但前提 = 联调完成 + 有公开可达端;切法 P1 小程序转发卡片 + H5 兜底(排联调后)→ P2 canvas 海报(缓)→ V2 链接分享(需公开 report 端点,不做现在);免责须延伸到分享物、海报不含人脸。
- 🆕 uniapp App(APK)目标(2026-07-08 决,ADR 0009):手机 / 平板装机,与 flutter APK 并存双栈;平板用 CSS max-width 容器限宽居中(不走 rpx:`maxWidth` 仅 H5、rpx 封顶字段 Vue3 App 存疑)。限宽容器已落地(定值 600px,`App.vue` 全局 `.skn-shell` + 四页 / tab / 弹层套用,拍照页深色底全屏、内容居中)、App 端 Fraunces 字体已接(`loadFontFace` 条件编译放宽到 `APP-PLUS || MP-WEIXIN`,`uni build -p app` 编译通过 + 产物含字体调用);待实现:`manifest.json` App appid + `#ifdef APP-PLUS` 其余能力按需补齐 + HBuilderX 出包(`uni build -p app` 只产资源、本环境无 HBuilderX,留用户)。

**后端(W1 收尾,自然暂停点):**
- ✅ 切片 D 完成(2026-07-09):真实千问 VL 调用通(`src/qwen.ts`,用户 MaaS 专属端点 `/compatible-mode/v1` + `qwen3-vl-plus`,base64 传图 + prompt 约束 + 宽松解析 + validateReport 后校验;空 key 仍 mock)。真图实测 `/analyze` 200 → 落库 → 删图 → `/history` 读回。远程部署时 key 用 `wrangler secret` 配。详见 `tasks/W1-backend-pipeline.md`。
- 📋 切片 E 输入质检(未排期)现已解除依赖(切片 D 通),可随时排期。
- 📋 输入质检(2026-07-08 立项,**未排期**,依赖切片 D,详见 `tasks/W1` 切片 E):VL 同一次调用前置判定"屏幕翻拍/印刷脸/非人脸/范围不合理"→ 4xx 指引重拍;定性输入质量非安全(相册路径绕过、无对抗动机),公共契约不动、前端近零改;活体/核身、EXIF、端侧摩尔纹明确不做。

## 关键决策(指针)

- 契约共享:JSON Schema 单一真相源 → `docs/adr/0001-…`
- 只锁三端 → `docs/adr/0002-…`
- 图片用后即删 → `docs/adr/0003-…`
- 工具链(**app-uni 用 uni CLI;Vite+ 收窄到 server;2026-07-06 修订**)→ `docs/adr/0004-…`
- 前端样式 / a11y → `docs/adr/0005-…`
- 16 型四维 → `docs/adr/0006-…`
- 设计 token SSOT(DTCG;app-uni 用自写 gen 脚本)→ `docs/adr/0007-…`
- 免责声明单处收敛 → `docs/adr/0008-…`
- uniapp 也出 App(APK)+ 平板限宽 → `docs/adr/0009-…`

## 备注

项目3 为**非冲刺项**(当前优先级为 P0 就业冲刺包)。可随时暂停;前端两端可见成品优先于后端补测(经确认 MVP 靠已验证手动 E2E 兜底)。

**代码托管:** 公开仓库 <https://github.com/aotushi/skin-checker>(2026-07-09 建仓并推送 master;提交信息沿用 `[Skip CI]` 前缀惯例,推前本地测试 + 征得同意)。本地 dev server 配置在父目录 `E:\code\github\.claude\launch.json`(`skin-server`,`pnpm dev --port 8890`)。
