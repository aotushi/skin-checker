# NOW · skin-checker 当前状态

**最后更新:** 2026-07-13(**W3 收官 🟢** 用户真机复测通过;**uniapp APK 出包 ✅**:用户 HBuilderX 云打包成功(14.95MB),已补传 Release v0.1.0 + 落地页第三卡启用,装机自测留用户;**W4 落地页上线 🟢**:`landing/` Astro 双语站部署 Pages `skin-checker-doc` + GitHub Release v0.1.0 挂双 APK(flutter 47.7MB / uniapp 14.95MB),绑域 `doc.skin.9shi.cc` 留用户)

## 部署(2026-07-09,用户同意远程操作后执行)

- **架构**:H5 与 API 同域 `skin.9shi.cc` —— Pages 服务页面,worker 只接 `/api/*` 路由(`index.ts` 挂 `basePath('/api')`,本地 dev 同为 `/api/*`);生产 H5 同域免 CORS。
- **worker**:`wrangler deploy` 已上(版本 6a897396),路由 `skin.9shi.cc/api/*`;`QWEN_API_KEY` 已 `wrangler secret put`;远程 D1 已建(id 见 wrangler.jsonc)+ 迁移 0001 已应用;R2 `skin-checker-img` 已建 + 1 天生命周期兜底删图。
- **Pages**:项目 `skin-checker`(production branch master),H5 产物直传部署,`skin-checker.pages.dev` 已 200。
- **域名已生效(2026-07-10)**:用户已在 dashboard 绑 `skin.9shi.cc` → `https://skin.9shi.cc` = H5、`/api/*` = worker,线上可用。如需 git 自动部署,可在 dashboard 把仓库连到既有 worker/Pages 项目(`[Skip CI]` 前缀会跳过自动构建,注意)。
- **🐛 H5 线上 3 项 UI 问题(2026-07-10 实测,同日已修,本地已验证)**:① 预览不显示(`height:100%` 在不定高 flex 链塌 0 高 → 改绝对定位铺满);②③ 拍照页 / 我的页矮视口滚动条(`100vh→100dvh` 双声明 + 取景区/空态可收缩)。仅动 3 文件 CSS;**已部署并线上验证生效(2026-07-13,用户 push 触发 CF 构建)**:线上样式命中三项修复特征(`.viewer__img` absolute / `.cap` 与 `uni-page-body` 100dvh),实测拍照页 375×550 无滚动、我的页 812 高无滚动、相册选图预览 331×508 正常渲染;我的页小屏(<696 可见高)空态残余滚动为已知项维持。详见 `tasks/W2` 「🐛 已知问题」各 ✅ 小节。
- **uniapp APK 已出包(2026-07-13)**:用户 HBuilderX 云打包成功,产物 `app-uni/dist/release/apk/__UNI__8A0107B__20260713141805.apk`(14.95MB,测试证书);已上传 GitHub Release v0.1.0(asset `skinlens-uniapp-v0.1.0-android.apk`,SHA-1 `12248f10…55b1`,notes 双包对照表)。**剩用户侧:装机自测拍照全流程**。小程序真机延后(届时后台配 uploadFile 合法域名 `skin.9shi.cc`)。
- **落地页(W4,2026-07-13)**:`landing/`(Astro 双语)→ Pages 项目 `skin-checker-doc`(产物直传,`skin-checker-doc.pages.dev` 已 200,根 301→/zh/);**双 APK 走 GitHub Release v0.1.0**(`releases/latest` 固定链,flutter 47.7MB + uniapp 14.95MB,SHA-1 均 in notes);下载三卡全启用(uniapp 第三卡 2026-07-13 出包后同日启用并重部署,线上抽查生效);**剩用户 dashboard 绑 `doc.skin.9shi.cc`**(Pages → skin-checker-doc → Custom domains)。详见 `tasks/W4-landing-page.md`。

## 阶段

🟢 **W4 落地页完成(2026-07-13):** `landing/` Astro 5 双语静态站(/zh/ 默认 + /en/,根 CDN 级 301;文案单一来源 `src/i18n/zh.ts` + `Strings` 类型对齐 en)—— Nav/双机位 Hero(线上真截)/功能 2×2/三步/下载三卡(H5 + flutter APK→`releases/latest` + uniapp「即将提供」)/架构图 + 工程 6 点/合规双卡/Footer;SEO 全套(canonical/hreflang x-default→zh/OG 1200×630/JSON-LD/sitemap/robots),素材全可再生(og-src.html 定格截图)。验证:build 3 页 + Playwright 四组视口目检 + 链接断言(修 hero 网格出血 7px 溢出 → `overflow-x: clip`);线上 pages.dev 全路径 200。GitHub Release v0.1.0(tag@7632e60)挂 `skinlens-flutter-v0.1.0-android.apk`,`releases/latest` 302 实测。详见 `tasks/W4-landing-page.md`。

🟢 **W3 前端完成(app-flutter,切片 A–H 全 ✅ + 用户真机复测通过 2026-07-13):** 环境 = Flutter **3.44.6 stable / Dart 3.12.2**(`E:\dev\flutter`;PUB_CACHE 迁 `E:\dev\pub-cache` + flutter-io.cn 双镜像,详见 W3 文档切片 A);`app-flutter` 只锁 Android(`com.aotushi.skin_checker`)。**切片 B 生成线**:`tool/gen.mjs` 一键出契约模型 + 65 token 常量(产物 format 幂等);Fraunces variable ttf 进 assets。**切片 C 四页 UI + 导航(2026-07-10)**:首页/拍照/结果卡/我的全落地(文案逐字平移 app-uni),自绘双 tab 根级 + 拍照/结果全屏二级页;四维双极光谱 + 敏感「参考」虚线态 + 科普手风琴 + 三弹层齐;共用件 Press/SknShell(600 限宽)/SknCard/DashedOutline;**flutter web 冒烟全页通过**(web/ 目录不入库;canvas 语义树用 `flt-semantics-placeholder` 激活,坑已记 W3 文档),format/analyze 双绿。**切片 D `/analyze` 真联调(2026-07-10)**:`utils/api.dart`(kDebugMode 双环境 + envelope 解析 + ApiException)+ capture_page 接 image_picker 真传图,web 冒烟三用例全通(mock 200 → 结果页渲染 / 真 key 422 not_face → SnackBar 指引留页 / 断服 → 网络异常 SnackBar);修 multipart contentType 坑(octet-stream 被 400,http_parser 显式 `image/*`),workerd 端口残留坑已记 W3 文档。**切片 E 本地历史(2026-07-10)**:`utils/history.dart`(shared_preferences,KEY `skn_history`/MAX 20/新→旧序平移 uni history.ts)+ ResultPage 真保存(沿用 server id/createdAt + 防重)+ MinePage 历史列表回看(RouteObserver.didPopNext ≈ uni onShow,回看态隐藏保存钮),web 冒烟保存→列表→回看→刷新持久化全通。**切片 F 合规文案核对(2026-07-10)**:免责落点符合 ADR 0008(inline 完整声明两端均只在结果页一处,「我的」完整声明入口保留,首页短句为 uni 定稿轻量提示逐字平移),flutter 全量中文文案抽取对照 app-uni 零出入无新造,违禁词扫描全为否定式声明文案;顺带修根 README 合规段旧规则(「结果页+启动页」→「收敛结果页一处」),app 代码零改动。**切片 G 出包(2026-07-13)**:`app-release.apk`(debug 签名,release API 指线上);本机 gradle loopback 坑(AF_UNIX connect 系统性 EINVAL → `JAVA_TOOL_OPTIONS=-Djdk.net.unixdomain.tmpdir=<不存在目录>` 强制回退 TCP)已入档。**切片 H 装机反馈改造(2026-07-13)**:用户首次装机两反馈(取景框靠顶偏小 / 无实时画面)一次解决 —— `camera ^0.12.0+1` 页面内实时取景 + 「拍照」直拍进原确认态(前置优先,初始化/拍摄失败全链静默降级 image_picker 系统相机 = uni 原体验;**flutter 独有扩展,uni APK 侧无此能力**,双端差异入档)+ `_FaceGuide` 随取景区放大居中(高度预算含文案行高防极矮溢出);web 冒烟(面板 block camera = 天然降级用例)语义全在、零 overflow;APK 重出 **47.7MB**;剩装机复测(真机在用户侧)。详见 `tasks/W3-frontend-app-flutter.md`。

🟡 **W2 前端起步(app-uni,H5 优先):** uniapp(Vue3 vite-ts)骨架 + 设计 token/类型两条生成脚本(`pnpm gen:tokens` / `gen:types`,产物禁手改)。**已建成四页 + 底部 tab 并 H5 验证通过**:首页(品牌 + 人脸拓扑网格取景意象[MediaPipe canonical 468 点投影程序生成 + 扫描光带]+ 双 CTA)、拍照页(深色相机 + 取景/拍摄要求 + `uni.chooseImage` + 分析中蒙层)、结果卡(四维双极光谱含敏感「参考」态 + 逐维度科普展开 + 分区评估 + 护理建议 + 免责声明 + 「保存报告」写本地历史)、我的(游客态 + 我的检测本地历史列表 + 免责/隐私/关于底部弹层完整声明入口)。自绘暖调底部 tab(检测 / 我的,CSS 图标走 token,`components/tab-bar`)统领导航:首页 ↔ 我的为 tab 根级(`reLaunch` 切换),拍照 / 结果为全屏二级页(navigateTo/redirectTo,不挂 tab);Fraunces 数字体 + 暖调美妆 token 全生效;`vue-tsc` 类型检查过。微信小程序端已过编译层(补 `loadFontFace`、变量本就落 `page`、`build:mp-weixin` 通过 + 产物双证),真机视觉待微信开发者工具确认(本环境无)。**已与本地 server 联调通(切片 E)**:拍照页真传图 → `/analyze` → 结果卡渲染 server envelope、「保存报告」沿用 server id(Playwright 真传图 E2E + 断服失败路径均验证)。

🟢 **W1 后端主链路全通(含真实 VL 调用,2026-07-09 切片 D 完成):** `/analyze`(R2 临时图 → 千问 VL 真调 → 四维派生 code/名 → 契约校验 → D1 落库 → 用后删图)+ `/history` 端到端验证过(纯本地不碰远程);16 型手册映射已接入、CORS 已挂。真调配置:用户 MaaS 专属端点 `/compatible-mode/v1` + `qwen3-vl-plus`(key 有模型级限制,需控制台放行;`qwen3.7-max` 纯文本不吃图),真图实测 200(~3.7s,D-R-F-N 干皮、敏感维置信 0.3 如约偏低);空 key 仍走 mock。W1 两条验收达成。**切片 E 输入质检完成(2026-07-10)**:同一次 VL 调用前置 gate(非人脸/翻拍/太远/低质),不合格 `/analyze` 返 422 + `{error: 重拍指引}`(fail-open、拒绝不落库、前端零改动);名人/著名图片会被模型自我审查拒为 not_face(接受,真实用户拍自己不受影响),详见 `tasks/W1` 切片 E 落地小节。

## 下一步

**前端(W3 flutter,进行中):**
- ✅ 切片 A 脚手架(2026-07-10):SDK 3.44.6 装 `E:\dev\flutter` + `app-flutter` 建成,analyze/format 双过;环境坑(PUB_CACHE / 镜像 / bat 路径)已记 W3 文档。
- ✅ 切片 B 生成线(2026-07-10):`node tool/gen.mjs` 一键 quicktype 契约模型 + DTCG token → Dart 常量(产物自动 format 幂等);Fraunces variable ttf(google/fonts 原件)进 assets。
- ✅ 切片 C 四页 UI + 导航(2026-07-10):四页 + 双 tab + 二级页导航全落地,web 冒烟全页通过(交互/文案/低置信「参考」态/弹层/返回栈全对齐 app-uni),a11y 双重朗读已修;详见 W3 文档切片 C。
- ✅ 切片 D `/analyze` 联调(2026-07-10):image_picker 真传图 + envelope 进结果页,mock 200 / 真 key 422 指引 / 断服三用例 web 冒烟全通;contentType(http_parser)与 workerd 端口残留两坑已记 W3 文档切片 D。
- ✅ 切片 E 本地历史(2026-07-10):`utils/history.dart`(shared_preferences,KEY/MAX 20/新→旧序平移 uni history.ts)+「保存报告」真写(沿用 server id/createdAt + 防重)+「我的」列表回看(RouteObserver.didPopNext ≈ uni onShow,回看隐藏保存钮);web 冒烟保存→列表→回看→刷新持久化全通;详见 W3 文档切片 E。
- ✅ 切片 F 合规文案核对(2026-07-10):免责落点符合 ADR 0008、全量中文文案对照 app-uni 零出入无新造、违禁词扫描通过;修根 README 合规段旧规则;app 代码零改动;详见 W3 文档切片 F。
- ✅ 切片 G 出包(2026-07-13):`app-flutter/build/app/outputs/flutter-apk/app-release.apk`(debug 签名,上架再议);Android Studio(D 盘)+ JBR 21 环境与 gradle loopback 坑(AF_UNIX EINVAL → JAVA_TOOL_OPTIONS 回退 TCP)已入档 W3 文档切片 G。
- ✅ 切片 H 装机反馈改造(2026-07-13):camera 插件页面内实时取景直拍(失败全链降级 image_picker;flutter 独有,uni 侧无)+ 取景框放大居中;web 冒烟通过,APK 重出 47.7MB;详见 W3 文档切片 H。
- ✅ 装机复测通过(2026-07-13):补 release 包 `INTERNET` 权限(flutter 模板坑,详见 W3 切片 H)后,用户真机确认 APK 可用、实时取景直拍 + 分析全流程 OK。**W3 收官**。

**前端(W2 续):**
- ✅ **H5 线上 3 项 UI 修复已部署 + 线上验证生效(2026-07-13)**:预览 0 高改绝对定位、100vh 滚动条改 dvh 双声明(B1–B3 详见 `tasks/W2` 已知问题 ✅ 小节);线上实测三项全过(CSS 特征 + 矮视口行为 + 相册选图预览渲染)。用户真机复验可选;我的页小屏(<696)空态残余滚动为已知项,真机仍碍眼再压余量。
- ✅ app-uni 四页静态端 + 底部 tab 完成(首页/拍照/结果卡/我的),H5 导航闭环通、免责声明双入口可达、结果卡→本地历史(uni Storage)→「我的」回看闭环通。
- 🟡 微信小程序端代码 + 编译层已过一遍(审计无逻辑属性 / CSS 变量本就落 `page` / 补 `uni.loadFontFace` 静默降级 / `build:mp-weixin` 编译通过 + 产物双证);**待真机**:`mp-weixin.appid` 空(测试号可预览,发布填自有)+ woff2 字体配 `downloadFile` 合法域名,渲染 / Fraunces 效果需微信开发者工具确认(本环境无)。
- ✅ 与 server `/analyze` 联调通(2026-07-08,切片 E):`utils/api.ts` 传图 → envelope 暂存直达结果卡,保存沿用 server id;本地 server 起 8890(`pnpm dev --port 8890`,8787/8788 被他项目占)。
- 📋 结果页分享(2026-07-08 审计,**未排期**,详见 `tasks/W2` 切片 G):16 型标签内容天然适合分享,但前提 = 联调完成 + 有公开可达端;切法 P1 小程序转发卡片 + H5 兜底(排联调后)→ P2 canvas 海报(缓)→ V2 链接分享(需公开 report 端点,不做现在);免责须延伸到分享物、海报不含人脸。
- 🆕 uniapp App(APK)目标(2026-07-08 决,ADR 0009):手机 / 平板装机,与 flutter APK 并存双栈;平板用 CSS max-width 容器限宽居中(不走 rpx:`maxWidth` 仅 H5、rpx 封顶字段 Vue3 App 存疑)。限宽容器已落地(定值 600px,`App.vue` 全局 `.skn-shell` + 四页 / tab / 弹层套用,拍照页深色底全屏、内容居中)、App 端 Fraunces 字体已接(`loadFontFace` 条件编译放宽到 `APP-PLUS || MP-WEIXIN`,`uni build -p app` 编译通过 + 产物含字体调用);✅ 云打包配置就绪(2026-07-13):manifest 补 `modules.Camera`(App 端 chooseImage 原生依赖,原空 `{}` 出包必挂)+ 应用名「肤镜」+ API_BASE 复核(App build 走线上完整 URL);✅ 出包完成(2026-07-13,用户 HBuilderX 云打包,14.95MB)并上传 Release v0.1.0 + 落地页第三卡启用,装机自测留用户(见上「部署」段)。

**后端(W1 收尾,自然暂停点):**
- ✅ 切片 D 完成(2026-07-09):真实千问 VL 调用通(`src/qwen.ts`,用户 MaaS 专属端点 `/compatible-mode/v1` + `qwen3-vl-plus`,base64 传图 + prompt 约束 + 宽松解析 + validateReport 后校验;空 key 仍 mock)。真图实测 `/analyze` 200 → 落库 → 删图 → `/history` 读回。远程部署时 key 用 `wrangler secret` 配。详见 `tasks/W1-backend-pipeline.md`。
- ✅ 切片 E 输入质检完成(2026-07-10,起因:线上非人脸照仍出报告):`qwen.ts` gate 前置判定 + `extractGate` fail-open,`index.ts` 不合格返 422 + `{error: 指引}`,拒绝不落库、前端零改、契约未动;本地验证 mock 回归 / 非人脸 422 / too_far 422 / 特写 200 / H5 端到端全通(详见 `tasks/W1` 切片 E)。**已提交推送(2026-07-10,commit 9f23446,git 连仓自动部署 worker)**。

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

**代码托管:** 公开仓库 <https://github.com/aotushi/skin-checker>(2026-07-09 建仓并推送 master;提交信息沿用 `[Skip CI]` 前缀惯例,推前本地测试 + 征得同意)。本地 dev server 配置在父目录 `E:\code\github\.claude\launch.json`(`skin-server` port 8890;`skin-landing` port 4321)。
