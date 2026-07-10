# skin-checker · 皮肤检查工具(uniapp + flutter 双端)

> **定位:AI 肤质参考助手(非医疗诊断)。** 拍照 → AI 分区分析肤质 → 结构化肤质报告 + 护肤建议。
> 一套 Cloudflare 后端,uniapp 与 flutter 两端复刻同一 API,体现跨端能力 + 多模态 AI 集成。

📋 需求规划见 `resume/docs/求职准备项目需求文档-V0.1/02-projects/03-皮肤检查工具-uniapp-flutter双端.md`

## ⚠️ 合规免责(必须贯穿所有端)

本工具为 **AI 肤质参考助手,不是诊断工具**。结果文案统一用"参考/建议",不得出现疾病诊断或疗效宣称。每个结果页 + 启动页显著标注:

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
| `server/` | Cloudflare Workers + Hono,三端共享后端 | 🟢 W1 完成并上线(真实 VL + 输入质检 422) |
| `app-uni/` | uniapp → H5 + 微信小程序 + App(APK) | 🟡 W2:四页 + 自绘底部 tab + 科普 + 本地历史,H5 已通、导航闭环、**与 server 联调通(真传图 → 结果卡)**;小程序端编译层已过,待真机;App(APK)+ 平板限宽为新目标待实现(ADR 0009) |
| `app-flutter/` | flutter → APK | 🟡 W3:脚手架 + 生成线 + 四页 UI/导航完成(web 冒烟通),待 `/analyze` 联调(见 `.project/tasks/W3-frontend-app-flutter.md`) |
| `shared/` | **契约单一真相源**(`skin-report.schema.json`) | ✅ 已建 |
| `docs/adr/` | 架构决策记录 | ✅ 已建 |
| `.project/` | 当前状态(`NOW.md`)+ 任务(`tasks/`) | ✅ 已建 |

## 技术栈

- **后端:** Cloudflare Workers + Hono + D1(历史)+ R2(图片临时)
- **AI:** 通义千问 VL(OpenAI 兼容接口)/ Gemini,多模态视觉分析
- **契约:** JSON Schema 单一真相源,后端约束 LLM 输出 + 生成两端类型(见 `shared/README.md`)
- **前端 A:** uniapp(Vue 技栈)　**前端 B:** flutter

## 当前状态

🟢 **W1 后端主链路全通并已上线:** `/analyze`(R2 临时图 → VL 真调 → 四维派生 code/名 → 契约校验 → D1 落库 → 用后删图)+ `/history`,16 型手册映射已接入。OpenAI 兼容端点 + `qwen3-vl-plus`,空 key 自动走 mock(不计费)。生产:worker 路由 `skin.9shi.cc/api/*`(basePath `/api`),远程 D1/R2 + secret 已配,H5 同域免 CORS。

🟡 **W3 前端推进中(app-flutter):** 本机 Flutter 3.44.6 就绪(`E:\dev\flutter`),`app-flutter` 只锁 Android(`com.aotushi.skin_checker`);契约 + token 两条生成线已通(`node tool/gen.mjs` → `skin_report.dart` + `tokens.dart`,产物 format 幂等)。**四页 UI + 导航已落地**(首页/拍照/结果卡/我的,文案逐字平移 app-uni;自绘双 tab 根级 + 拍照/结果全屏二级页;四维双极光谱 + 低置信「参考」虚线态 + 科普手风琴 + 三弹层;600 限宽对齐 ADR 0009),flutter web 冒烟全页通过、`dart format` + `flutter analyze` 双绿。下一步:image_picker + `POST /analyze` 联调。详见 `.project/tasks/W3-frontend-app-flutter.md`。

🟡 **W2 前端起步(app-uni):** uniapp Vue3 骨架 + 设计 token/类型两条生成脚本(`pnpm gen:tokens` / `gen:types`);**首页 / 拍照页 / 结果卡 / 我的四页 + 自绘暖调底部 tab 已建成、H5 dev 验证通过**,底部 tab(检测 / 我的)切根级、拍照/结果全屏二级页。四维双极光谱含敏感「参考」态 + 逐维度科普展开(「?」手风琴,复用「科普四维卡」tint)、结果卡「保存报告」写本地历史 +「我的」历史列表点击回看(uni Storage,契合「仅存设备本地」承诺)、暖调美妆 token 生效、`vue-tsc` 通过。app-uni 静态页已全,微信小程序端已过编译层(`loadFontFace` / 变量落 `page` / `build:mp-weixin` 通过 + 产物双证);**已与本地 server 联调通**(拍照真传图 → `/analyze` → 结果卡渲染 server envelope,保存沿用 server id,`utils/api.ts`)。**H5 已部署 Cloudflare Pages**(项目 `skin-checker`,生产域名 `skin.9shi.cc` 待 dashboard 绑定;API_BASE 按 dev/build 自动切换)。小程序真机验证延后;APK 走 HBuilderX 云打包(App appid 已填)。详见 `.project/NOW.md`。
