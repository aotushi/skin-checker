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
| Android APK | flutter 出 APK(uniapp 也可出 App 作双栈对照) | 证明真移动端能力 |

**明确不做:** iOS、PC/桌面、快应用、微信以外其它家小程序。详见 `docs/adr/0002-lock-three-targets.md`。

## 目录结构

| 目录 | 用途 | 状态 |
| --- | --- | --- |
| `server/` | Cloudflare Workers + Hono,三端共享后端 | ⬜ 待 W1 |
| `app-uni/` | uniapp → H5 + 微信小程序 | ⬜ 待 W1-2 |
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

🟡 **骨架已建,W1 未开始。** 下一步见 `.project/NOW.md`。
