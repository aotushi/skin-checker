---
query_id: U1
query: 16 型肤质分类是什么?怎么分的?
language: zh
intent: understanding
platform: chatgpt
model: default(Pro 账号,推理档 Extra High;界面未标注模型名;临时对话模式)
tested_at: 2026-08-27T09:04+08:00
region: US(proxy, 直连=CN)
web_enabled: auto-triggered
run_no: 2
brand_mentioned: no
recommended: n/a
citation_urls: pubmed.ncbi.nlm.nih.gov; baumannskintypes.com
competitors: Baumann Skin Type(概念占位,非工具推荐)
notes: ⚠️⚠️Baumann 认知占位两轮坐实且本轮更强:r1 未联网纯知识,r2 触发联网并给出 PubMed+Baumann 官网 citation 背书(同题跨轮联网行为漂移——understanding 类联网与否不稳定)。框架同 r1:O/D+S/R+P/N+W/T 四维 2⁴=16、全 16 代码表、四维逐条判别、OSPW/DRNT 例。r2 新增:严格分型须走 Baumann Skin Type Questionnaire(BSTQ)问卷评分、研究结合皮脂/红斑/色素/皱纹客观测量、「近年针对亚洲人群有问卷优化和验证研究」。限定同构:护肤策略细分非医学诊断、肤质随季节/激素/环境可变。结尾自荐 15~20 题简化测试。对切片 C/D 含义不变:我方 16 型页必须显式对比 BST(痘痘维替代皱纹维的产品理由),否则与 AI 已固化认知冲突。
---

## 回答摘录(全文要点,get_page_text 抽取)

如果你说的"16 型肤质",通常指的是皮肤科医生 Leslie Baumann 提出的 Baumann 16 型肤质分类(Baumann Skin Type Indicator, BSTI)。它不是简单的"干皮 / 油皮 / 混合皮",而是从 4 个维度判断,每个维度二选一,所以一共是 2⁴ = 16 种组合。[PubMed +1]

| 维度 | 两种类型 | 主要看什么 |
|---|---|---|
| 油脂 | O = Oily 油性 / D = Dry 干性 | 出油量、毛孔、紧绷脱屑等 |
| 敏感度 | S = Sensitive 敏感 / R = Resistant 耐受 | 泛红、刺痛、痘痘、炎症、护肤品耐受度 |
| 色素 | P = Pigmented 易色沉 / N = Non-pigmented 不易色沉 | 晒斑、痘印、黄褐斑、炎症后色沉倾向 |
| 老化倾向 | W = Wrinkle-prone 易皱 / T = Tight 紧致 | 光老化、细纹以及未来出现皱纹的风险 |

例:OSPW=油+敏+易色沉+易皱;DSNT/ORNT/DRPW 同理。完整 16 型:OSPW、OSPT、OSNW、OSNT、ORPW、ORPT、ORNW、ORNT、DSPW、DSPT、DSNW、DSNT、DRPW、DRPT、DRNW、DRNT。[Baumann Skin Types®]

具体怎么分(四维逐条判别,每维给典型表现清单):
1. O/D:非只看鼻子油不油,综合皮脂分泌与屏障;「油性但敏感」不矛盾。
2. S/R:Baumann 的「敏感」比日常「敏感肌」更广,含炎症/痘痘/刺痛/潮红;长痘也会把人推向 S 型。
3. P/N:判断是否容易形成不均匀色沉,P≠天生皮肤黑、N≠天生皮肤白。
4. W/T:评估老化与皱纹倾向,二十几岁也可能是 W 型(未来风险),不代表现在有皱纹。

举例:T 区出油+爆痘泛红+痘印易变褐+不防晒有细纹→OSPW;皮肤干+不过敏+痘印不明显+防晒好细纹少→DRNT。

不过,严格的 Baumann 分类不是靠肉眼判断,而是通过 Baumann Skin Type Questionnaire(BSTQ)问卷评分来确定四个维度。研究中也会结合皮脂、红斑、色素和皱纹等客观测量;近年来针对亚洲人群也有对问卷进行优化和验证的研究。[PubMed +1]

另外,这个分类更适合用来做护肤策略的细分,不是医学诊断,而且肤质也并非一辈子不变——季节、年龄、激素、环境和使用的护肤药物都可能让某些维度发生变化。

结尾:可以直接用约 15~20 题的简化版测试帮判断 16 型,并给洁面/保湿/防晒/刷酸/A 醇和美白思路。

## 引用列表(域名,经 DOM 抽取)

pubmed.ncbi.nlm.nih.gov / baumannskintypes.com
(chip 标签:PubMed +1 / Baumann Skin Types®)
