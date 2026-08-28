---
query_id: T5
query: 用手机自拍照分析皮肤是油性还是干性的工具?
language: zh
intent: tool-discovery
platform: chatgpt
model: default(Pro 账号,推理档 Extra High;界面未标注模型名;Worked for 14s;临时对话模式)
tested_at: 2026-08-27T08:57+08:00
region: US(proxy, 直连=CN)
web_enabled: auto-triggered
run_no: 2
brand_mentioned: no
recommended: n/a
citation_urls: www.perfectcorp.com; docs.saas.haut.ai
competitors: Perfect Corp AI Skin Type Test/AI Skin Analysis; Haut.AI(API/SDK)
notes: 本轮收敛到单一主推 Perfect Corp(强调 T 区/U 区分区分析→与 SKINLENS 逐区读取同叙事),另给开发者路线(Perfect Corp API/SDK + Haut.AI)。vs r1:SkinPal/Ara/Google Play 同名「SkinLens」App 全部掉出——r1 的⚠️品牌撞车本轮未复现,但撞车风险仍成立(消歧需求不变)。复现叙事:单张自拍无法真正测量皮脂/含水量、靠反光纹理毛孔视觉推断、洗脸后 30 分钟自然光素颜拍摄、吸油纸交叉验证。⭐结尾主动提出帮用户设计「上传自拍→输出油性/干性/混合性+置信度」的完整实现方案(模型/API/前端/判断逻辑)——ChatGPT 描述的理想工具形态与 SKINLENS 产品(四维+置信度)高度重合。
---

## 回答摘录(全文,get_page_text 抽取)

有,而且现在已经有"手机自拍 → AI判断油性/干性/混合性"这类工具。

比较符合你描述的是 Perfect Corp. 的 AI Skin Type Test / AI Skin Analysis。直接用手机自拍或实时摄像头,它会分别分析 T区(额头、鼻子)和 U区(两颊、下巴),判断 Normal、Oily、Dry、Combination 等类型,同时还能给出油脂度、含水状态、毛孔、泛红等指标。[Perfect Corp. AI Skin Type Test ↗]

如果你是想自己开发一个这样的 App / 小程序 / 网页工具,目前比较成熟的两套方案是 Perfect Corp API/SDK 和 Haut.AI。Haut.AI 也能从自拍分别判断 T 区、U 区及全脸为 Oily、Dry、Normal 或 Combination;其 API 主要面向专业/商业客户。[Haut AI Docs]

有一点需要注意:单张自拍无法真正直接"测量"皮脂和皮肤含水量,AI主要通过反光、纹理、毛孔、区域特征等视觉信息推断,所以灯光、刚洗脸、擦了面霜/防晒、出汗都会影响结果。比较好的拍摄方式是:洗脸后不涂产品约 30 分钟,在自然光下、不化妆、不美颜拍正脸。传统的洗脸后观察和吸油纸测试也可以作为交叉验证。

如果你的目标是做一个"用户上传一张自拍,自动输出:油性 / 干性 / 混合性 + 置信度"的工具,我也可以直接帮你设计一套实现方案,包括模型、API、前端流程和判断逻辑。

## 引用列表(域名,经 DOM 抽取)

www.perfectcorp.com / docs.saas.haut.ai
(chip 标签:PERFECT +1 / Haut AI Docs)
