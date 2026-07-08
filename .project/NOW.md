# NOW · skin-checker 当前状态

**最后更新:** 2026-07-08

## 阶段

🟡 **W2 前端起步(app-uni,H5 优先):** uniapp(Vue3 vite-ts)骨架 + 设计 token/类型两条生成脚本(`pnpm gen:tokens` / `gen:types`,产物禁手改)。**已建成四页 + 底部 tab 并 H5 验证通过**:首页(品牌 + 人脸拓扑网格取景意象[MediaPipe canonical 468 点投影程序生成 + 扫描光带]+ 双 CTA)、拍照页(深色相机 + 取景/拍摄要求 + `uni.chooseImage` + 分析中蒙层)、结果卡(四维双极光谱含敏感「参考」态 + 逐维度科普展开 + 分区评估 + 护理建议 + 免责声明 + 「保存报告」写本地历史)、我的(游客态 + 我的检测本地历史列表 + 免责/隐私/关于底部弹层完整声明入口)。自绘暖调底部 tab(检测 / 我的,CSS 图标走 token,`components/tab-bar`)统领导航:首页 ↔ 我的为 tab 根级(`reLaunch` 切换),拍照 / 结果为全屏二级页(navigateTo/redirectTo,不挂 tab);Fraunces 数字体 + 暖调美妆 token 全生效;`vue-tsc` 类型检查过。微信小程序端已过编译层(补 `loadFontFace`、变量本就落 `page`、`build:mp-weixin` 通过 + 产物双证),真机视觉待微信开发者工具确认(本环境无)。

🟢 **W1 后端主链路本地全通(mock):** `/analyze`(R2 临时图 → 分析 → 四维派生 code/名 → 契约校验 → D1 落库 → 用后删图)+ `/history` 端到端验证过(unstable_dev,纯本地不碰远程);16 型手册映射已接入、CORS 已挂。**只差真实千问 VL 调用**(切片 D,需 API key)。

## 下一步

**前端(W2 续):**
- ✅ app-uni 四页静态端 + 底部 tab 完成(首页/拍照/结果卡/我的),H5 导航闭环通、免责声明双入口可达、结果卡→本地历史(uni Storage)→「我的」回看闭环通。
- 🟡 微信小程序端代码 + 编译层已过一遍(审计无逻辑属性 / CSS 变量本就落 `page` / 补 `uni.loadFontFace` 静默降级 / `build:mp-weixin` 编译通过 + 产物双证);**待真机**:`mp-weixin.appid` 空(测试号可预览,发布填自有)+ woff2 字体配 `downloadFile` 合法域名,渲染 / Fraunces 效果需微信开发者工具确认(本环境无)。
- 与 server `/analyze` 联调(multipart 传图 → `{ id, createdAt, report }`)。
- 🆕 uniapp App(APK)目标(2026-07-08 决,ADR 0009):手机 / 平板装机,与 flutter APK 并存双栈;平板用 CSS max-width 容器限宽居中(不走 rpx:`maxWidth` 仅 H5、rpx 封顶字段 Vue3 App 存疑)。限宽容器已落地(定值 600px,`App.vue` 全局 `.skn-shell` + 四页 / tab / 弹层套用,拍照页深色底全屏、内容居中)、App 端 Fraunces 字体已接(`loadFontFace` 条件编译放宽到 `APP-PLUS || MP-WEIXIN`,`uni build -p app` 编译通过 + 产物含字体调用);待实现:`manifest.json` App appid + `#ifdef APP-PLUS` 其余能力按需补齐 + HBuilderX 出包(`uni build -p app` 只产资源、本环境无 HBuilderX,留用户)。

**后端(W1 收尾,自然暂停点):**
- 切片 D:真实千问 VL 调用(`src/qwen.ts` 现空 key 走 mock)。需 `QWEN_API_KEY`(本地 `.dev.vars` / 远程 `wrangler secret`),真调计费 = **待用户提供 key**。详见 `tasks/W1-backend-pipeline.md`。

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
