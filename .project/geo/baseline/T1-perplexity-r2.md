---
query_id: T1
query: 有什么在线 AI 测肤质的工具?
language: zh
intent: tool-discovery(工具发现)
platform: perplexity
model: 默认 Search 模式(Model=auto,Free plan,登录态)
tested_at: 2026-08-27T10:34+08:00
region: US(proxy, 直连=CN)
web_enabled: yes(8 去重引用域;DOM cites 16)
run_no: 2
brand_mentioned: no
recommended: no(首推竞品:美丽修行 App/ELIXIR 小程序)
citation_urls: bebd.bevol.com/news/detail/6; wp.shiseido.com.tw/pages/aiskinanalyzer; ai.meitu.com/algorithm/faceTechnology/skinanlysis; apps.microsoft.com/detail/xp89lnvt1ngb6k; www.perfectcorp.com/zh-cn/business/products/ai-ski; www.faceplusplus.com.cn/skin-check; www.skinrun.me/lab.html; www.yiyuan.ai/person
competitors: 消费者:美丽修行(首位,绑旷视合作叙事)/ELIXIR 资生堂(16 项目+水玉光图表)/美图 AI 开放平台(40 级肤色)/测肤质 App(微软商店);B 端:玩美移动/旷视 FaceStyle/肌肤管家 SkinRun Lab/宜远智能美肤镜
notes: ⭐⭐⭐结构重组:r1「网页端 vs 手机 App」→r2「消费者 App/小程序 vs 品牌 B 端 API」——「在线/网页端」消费者分类消失,品牌网页工具(玩美/旷视)被改叙为 B 端方案,消费者侧只剩 App/小程序 →「网页版+手机拍照」独立网页工具空位在 r2 更彻底,我方精准缺口两轮强化。⭐引用池大换血:8 域仅 3 条与 r1 重叠(shiseido.tw/meitu/faceplusplus);r1 首推「你今天真好看」+MEDGIC+Skin Beauty Pal+Google Play ×2+fashion.sina 2021 旧文全部出局;新入 bebd.bevol.com(美丽修行系内容站——自家内容站给自家 App 供证据链=GEO 教科书样本)、apps.microsoft.com(Windows 商店来源首现)、skinrun.me、yiyuan.ai。美丽修行从 r1 次位(查成分+测肤)升 r2 首位(绑定旷视 FaceStyle 合作技术叙事+四类问卷)=「16 种肤质分型」直接竞品地位上升。r1 的拍摄环境建议+医疗边界「小建议」段 r2 整段消失(纯工具罗列化)。尾部转化话术复现(「需要我针对某个具体工具再深入查一下吗」)。我方零露出两轮确认。生成 ~40s,total 931(r1 更长);blocks:1。管线更新:hidden 态 JS insertText+回显核对一次成功;JS 完整事件序列派发 aria-label=Submit 按钮一次成功(React 委托事件比 Gemini Angular 好伺候);泵帧沿用。⚠️Perplexity 已上线 incognito 功能(r1 时无)——为保持与 r1 同口径(普通 session)未使用,Sessions 留存继续;r3 同。
---

## 回答摘录(全文)

目前市面上有不少在线 AI 测肤质工具，主要分两类：面向普通消费者的 App/小程序，以及面向品牌的 B 端 API 方案。下面按用途整理。

### 消费者可直接使用的工具

- **美丽修行 App（AI 拍照测肤）**：与旷视 FaceStyle 合作上线，通过拍照几秒钟即可检测毛孔、痘痘、黑眼圈、色斑等，并给出肤龄和得分；同时提供干油、敏感、色素、皱纹四类问卷测试，还能推荐对应护肤产品。[bebd.bevol]
- **ELIXIR 怡丽丝尔 AI 线上肌肤检测**：资生堂集团开发，可检测脸部不同部位的松弛、纹路、斑点等共 16 个项目，并生成「水玉光图表」和专属护肤建议，适合想了解日系护肤方案的用户。[shiseido]
- **美图 AI 开放平台的测肤功能**：提供肤质、肤色、肤龄、痘、斑、痣、皱纹、黑眼圈、毛孔、黑头等分析，肤色按国际标准分为 40 个等级。[meitu]
- **测肤质 App**：微软应用商店上架的专业肌肤测试与分析工具，通过 AI 和大数据分析提供个性化皮肤状况分析。[microsoft]

### 面向品牌/商家的 B 端方案

- **玩美移动（Perfect Corp）AI 测肤**：由 AI 深度学习算法支持的实时皮肤检测，可做超精确皮肤分析和产品推荐，主要服务美妆品牌和零售商。[perfectcorp]
- **旷视 FaceStyle 智能测肤**：覆盖干油性、敏感度、色素沉着、衰老、痤疮等分析，支持移动端 SDK、API、H5 接入，赋能品牌做数字化营销。[faceplusplus]
- **肌肤管家 SkinRun Lab**：提供在线拍照测肤，开放 API 接口，面向化妆品品牌、门店、美容院等。[skinrun]
- **宜远智能高颜值美肤镜**：评估皱纹、斑点、黑头、毛孔、粗糙等问题，并根据结果定制护肤程序。[yiyuan]

### 选择建议

- 如果你只是想快速了解自己的肤质，直接下载「美丽修行」App 或使用「ELIXIR 怡丽丝尔」这类品牌方小程序即可，操作简单、报告直观。
- 如果你是美妆品牌或商家，想在自己的 App/小程序/门店里嵌入测肤功能，可以考虑旷视 FaceStyle、玩美移动或肌肤管家的 API/SDK 方案。

需要我针对某个具体工具（比如操作步骤或准确性）再深入查一下吗？

## 引用列表

1. bebd.bevol.com/news/detail/6（美丽修行系内容站）
2. wp.shiseido.com.tw/pages/aiskinanalyzer（品牌官网工具页）
3. ai.meitu.com/algorithm/faceTechnology/skinanlysis（平台算法页）
4. apps.microsoft.com/detail/xp89lnvt1ngb6k（微软应用商店页,首现）
5. www.perfectcorp.com/zh-cn/business/products/ai-ski…（品牌官网产品页）
6. www.faceplusplus.com.cn/skin-check（平台产品页）
7. www.skinrun.me/lab.html（B 端工具站）
8. www.yiyuan.ai/person（B 端工具站）
