# skin-checker · 皮肤检查工具(uniapp + flutter 双端)

> **定位:AI 肤质参考助手(非医疗诊断)。** 拍照 → AI 分区分析肤质 → 结构化肤质报告 + 护肤建议。
> 一套 Cloudflare 后端,uniapp 与 flutter 两端复刻同一 API,体现跨端能力 + 多模态 AI 集成。

📋 需求规划见 `resume/docs/求职准备项目需求文档-V0.1/02-projects/03-皮肤检查工具-uniapp-flutter双端.md`

## ⚠️ 合规免责(必须贯穿所有端)

本工具为 **AI 肤质参考助手,不是诊断工具**。结果文案统一用"参考/建议",不得出现疾病诊断或疗效宣称。免责声明**收敛到结果页一处**显著标注(见 `docs/adr/0008-disclaimer-single-placement.md`;「我的 → 免责声明」保留完整声明入口):

> 本结果由 AI 生成,仅供护肤参考,不构成医疗建议,严重皮肤问题请就医。

用户上传图片分析后**不长期存储**(R2 临时对象,用后即删)。详见 `docs/adr/0003-image-ephemeral-storage.md`。

## 打包范围(只锁三端)

| 端 | 来源 | 说明 |
| --- | --- | --- |
| H5 | uniapp 编译 | 移动端浏览器 / 分享落地页 |
| 微信小程序 | uniapp 编译 | 国内传播主入口 |
| Android APK | flutter + uniapp 双栈出 APK(见 `docs/adr/0009-uniapp-app-target-and-tablet.md`) | 真移动端能力;手机 / 平板装机 |

**平板(大屏):** uniapp App/APK 用一层 CSS max-width 容器限宽居中,不做多列响应式(见 `docs/adr/0009-uniapp-app-target-and-tablet.md`)。

**明确不做:** iOS、PC/桌面、快应用、微信以外其它家小程序。详见 `docs/adr/0002-lock-three-targets.md`。

## 目录结构

| 目录 | 用途 | 状态 |
| --- | --- | --- |
| `server/` | Hono 三端共享后端,双部署目标:CF Workers + 阿里云 FC(ADR 0010) | 🟢 W1 完成并上线;🟢 W5 完成(FC 线上真 key 全通,大陆链路 ~9 倍提升;H5 生产已切 FC 链路);🟡 切片 E 安全加固(`/analyze` 限流 + CORS 白名单)本地全验待重部署 |
| `app-uni/` | uniapp → H5 + 微信小程序 + App(APK) | 🟡 W2:四页 + 自绘底部 tab + 科普 + 本地历史,H5 已通、导航闭环、**与 server 联调通(真传图 → 结果卡)**;小程序端编译层已过,待真机;**App(APK)已出包(2026-07-13,HBuilderX 云打包 14.95MB)并上传 Release v0.1.0**,装机自测留用户(ADR 0009) |
| `app-flutter/` | flutter → APK | 🟢 W3 完成:四页闭环 + `/analyze` 真联调 + 本地历史 + 合规核对 + **页面内实时取景直拍**(camera 插件,flutter 独有扩展)+ APK 出包(47.7MB debug 签名),**用户真机装机复测通过(2026-07-13)**(见 `.project/tasks/W3-frontend-app-flutter.md`) |
| `landing/` | Astro 双语落地页 → Pages `skin-checker-doc`(`doc.skin.9shi.cc`) | 🟢 W4 完成:线上 pages.dev 已 200,绑域留用户(见 `.project/tasks/W4-landing-page.md`) |
| `shared/` | **契约单一真相源**(`skin-report.schema.json`) | ✅ 已建 |
| `docs/adr/` | 架构决策记录 | ✅ 已建 |
| `.project/` | 当前状态(`NOW.md`)+ 任务(`tasks/`) | ✅ 已建 |

## 技术栈

- **后端:** Hono(跨 runtime)双部署目标 —— Cloudflare Workers(D1 历史 + R2 图片临时)+ 阿里云 FC Web 函数(大陆链路,图片内存直读、历史 V2 预留),见 ADR 0010
- **AI:** 通义千问 VL(OpenAI 兼容接口)/ Gemini,多模态视觉分析
- **契约:** JSON Schema 单一真相源,后端约束 LLM 输出 + 生成两端类型(见 `shared/README.md`)
- **前端 A:** uniapp(Vue 技栈)　**前端 B:** flutter

## 当前状态

🟢 **W5 server 迁阿里云 FC 完成(2026-07-14):** 大陆用户 `/analyze` 耗时优化 —— server 映射双部署目标(一套 Hono 业务:`app.ts` 工厂 + `platform.ts` 平台接口,Workers 入口 `index.ts` / FC 入口 `index.fc.ts`),`pnpm build:fc` 出单文件 ZIP 包。FC 线上全通(cn-hangzhou,默认域名,无需认证 + `QWEN_API_KEY`):mock 200 全链 + 真 key 422;**大陆链路实测 FC ~4s vs Workers ~35s(同图 2MB 真调,~9 倍提升)**。前端分流:**H5 与 App(双 APK)生产走 FC,小程序仍走 Workers**(fcapp.run 无 ICP 进不了小程序合法域名)——H5 已部署 Pages 并线上验证生效(`skin.9shi.cc` api chunk 运行值 = FC 域名);flutter APK 已重出包(47.7MB,内含 FC URL 实证)待重传 Release,uniapp APK 待 HBuilderX 云打包;剩用户真机真脸自测(预期 ~35s→~5s)。详见 `.project/tasks/W5-server-fc-migration.md` 与 `docs/adr/0010-dual-deploy-worker-and-fc.md`。

🟢 **W4 落地页上线(2026-07-13):** `landing/` Astro 5 双语静态站(/zh/ + /en/,SEO 全套),部署 Cloudflare Pages `skin-checker-doc`(产物直传,根 301→/zh/);下载区三入口全启用 = H5(skin.9shi.cc)+ flutter APK + uniapp APK(均走 **GitHub Release v0.1.0** `releases/latest` 固定链,双包 47.7MB / 14.95MB,SHA-1 in notes)。自定义域 `doc.skin.9shi.cc` 绑定留用户 dashboard。详见 `.project/tasks/W4-landing-page.md` 与 `landing/README.md`。

🟢 **W1 后端主链路全通并已上线:** `/analyze`(R2 临时图 → VL 真调 → 四维派生 code/名 → 契约校验 → D1 落库 → 用后删图)+ `/history`,16 型手册映射已接入。OpenAI 兼容端点 + `qwen3-vl-plus`,空 key 自动走 mock(不计费)。生产:worker 路由 `skin.9shi.cc/api/*`(basePath `/api`),远程 D1/R2 + secret 已配,H5 同域免 CORS。

🟢 **W3 前端完成(app-flutter):** 本机 Flutter 3.44.6 就绪(`E:\dev\flutter`),`app-flutter` 只锁 Android(`com.aotushi.skin_checker`);契约 + token 两条生成线已通(`node tool/gen.mjs` → `skin_report.dart` + `tokens.dart`,产物 format 幂等)。**四页 UI + 导航已落地**(首页/拍照/结果卡/我的,文案逐字平移 app-uni;自绘双 tab 根级 + 拍照/结果全屏二级页;四维双极光谱 + 低置信「参考」虚线态 + 科普手风琴 + 三弹层;600 限宽对齐 ADR 0009),flutter web 冒烟全页通过、`dart format` + `flutter analyze` 双绿。**已与 server 联调通**(image_picker 真传图 → `POST /analyze` → 结果页渲染 envelope;mock 200 / 真 key 422 指引留页 / 断服网络异常三用例 web 冒烟全通,`utils/api.dart` 按 debug/release 切本地与线上)。**本地历史闭环已通**(`utils/history.dart` shared_preferences 平移 app-uni history.ts:保存沿用 server id + 防重、「我的」列表回看、回看态隐藏保存钮、刷新持久化,web 冒烟全链路验证)。**合规文案核对完成**(免责落点符合 ADR 0008:inline 完整声明两端均只在结果页一处;flutter 全量中文文案对照 app-uni 零出入、无新造、无违禁措辞)。**APK 已出包(2026-07-13)**:`flutter build apk --release` → `app-release.apk`(debug 签名,上架再议;本机 gradle loopback 坑与 `JAVA_TOOL_OPTIONS` 解法见 W3 文档切片 G)。**装机反馈改造(2026-07-13,切片 H)**:camera 插件页面内实时取景 + 「拍照」直拍(前置优先,失败全链降级 image_picker 系统相机;flutter 独有扩展,uni APK 侧无此能力)+ 取景框随取景区放大居中 + release 包补 `INTERNET` 权限(flutter 模板坑);APK 47.7MB。**用户真机装机复测通过(2026-07-13),W3 收官**。详见 `.project/tasks/W3-frontend-app-flutter.md`。

🟡 **W2 前端起步(app-uni):** uniapp Vue3 骨架 + 设计 token/类型两条生成脚本(`pnpm gen:tokens` / `gen:types`);**首页 / 拍照页 / 结果卡 / 我的四页 + 自绘暖调底部 tab 已建成、H5 dev 验证通过**,底部 tab(检测 / 我的)切根级、拍照/结果全屏二级页。四维双极光谱含敏感「参考」态 + 逐维度科普展开(「?」手风琴,复用「科普四维卡」tint)、结果卡「保存报告」写本地历史 +「我的」历史列表点击回看(uni Storage,契合「仅存设备本地」承诺)、暖调美妆 token 生效、`vue-tsc` 通过。app-uni 静态页已全,微信小程序端已过编译层(`loadFontFace` / 变量落 `page` / `build:mp-weixin` 通过 + 产物双证);**已与本地 server 联调通**(拍照真传图 → `/analyze` → 结果卡渲染 server envelope,保存沿用 server id,`utils/api.ts`)。**H5 已部署 Cloudflare Pages**(项目 `skin-checker`,生产域名 `skin.9shi.cc` 已生效;API_BASE 按 dev/build 自动切换;三项线上 UI 修复已部署并线上验证生效,2026-07-13)。小程序真机验证延后;**App(APK)已出包(2026-07-13)**:manifest 补 Camera 模块 + 应用名「肤镜」后,用户 HBuilderX 云打包成功(14.95MB,测试证书),已上传 GitHub Release v0.1.0 并启用落地页第三卡,装机自测留用户。详见 `.project/NOW.md`。
