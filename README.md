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
| `server/` | Cloudflare Workers + Hono,三端共享后端 | 🟡 W1 主链路本地通(mock),待真实 qwen |
| `app-uni/` | uniapp → H5 + 微信小程序 + App(APK) | 🟡 W2:四页 + 自绘底部 tab + 科普 + 本地历史,H5 已通、导航闭环;小程序端编译层已过,待真机;App(APK)+ 平板限宽为新目标待实现(ADR 0009) |
| `app-flutter/` | flutter → APK | ⬜ 待 W3 |
| `shared/` | **契约单一真相源**(`skin-report.schema.json`) | ✅ 已建 |
| `docs/adr/` | 架构决策记录 | ✅ 已建 |
| `.project/` | 当前状态(`NOW.md`)+ 任务(`tasks/`) | ✅ 已建 |

## 技术栈

- **后端:** Cloudflare Workers + Hono + D1(历史)+ R2(图片临时)
- **AI:** 通义千问 VL(OpenAI 兼容接口)/ Gemini,多模态视觉分析
- **契约:** JSON Schema 单一真相源,后端约束 LLM 输出 + 生成两端类型(见 `shared/README.md`)
- **前端 A:** uniapp(Vue 技栈)　**前端 B:** flutter

## 当前状态

🟡 **W1 后端主链路本地全通(mock):** `/analyze`(R2 临时图 → 分析 → 四维派生 code/名 → 契约校验 → D1 落库 → 用后删图)+ `/history`,16 型手册映射已接入、CORS 已挂(H5 跨域),全程 unstable_dev 本地验证(不碰远程)。只差真实千问 VL 调用(切片 D,需 API key)。

🟡 **W2 前端起步(app-uni):** uniapp Vue3 骨架 + 设计 token/类型两条生成脚本(`pnpm gen:tokens` / `gen:types`);**首页 / 拍照页 / 结果卡 / 我的四页 + 自绘暖调底部 tab 已建成、H5 dev 验证通过**,底部 tab(检测 / 我的)切根级、拍照/结果全屏二级页。四维双极光谱含敏感「参考」态 + 逐维度科普展开(「?」手风琴,复用「科普四维卡」tint)、结果卡「保存报告」写本地历史 +「我的」历史列表点击回看(uni Storage,契合「仅存设备本地」承诺)、暖调美妆 token 生效、`vue-tsc` 通过。app-uni 静态页已全,微信小程序端已过编译层(`loadFontFace` / 变量落 `page` / `build:mp-weixin` 通过 + 产物双证),下一步:小程序真机验证(微信开发者工具,含 appid / 字体域名)+ 与 server 联调,见 `.project/NOW.md`。
