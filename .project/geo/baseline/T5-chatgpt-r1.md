---
query_id: T5
query: 用手机自拍照分析皮肤是油性还是干性的工具?
language: zh
intent: tool-discovery
platform: chatgpt
model: default(Pro 账号,推理档 Extra High;界面未标注模型名;Worked for 15s;临时对话模式)
tested_at: 2026-08-25T17:12+08:00
region: US(proxy, 直连=CN)
web_enabled: auto-triggered
run_no: 1
brand_mentioned: no
recommended: n/a
citation_urls: www.perfectcorp.com; play.google.com; www.ara.kr
competitors: Perfect Corp AI Skin Analysis; SkinPal AI; SkinLens(Google Play 同名 App,非我方); Ara
notes: ⚠️⚠️品牌名撞车实锤:回答推荐了名为「SkinLens」的 Google Play 安卓 App(自拍出 Normal/Dry/Oily/Combination + Moisture/Sebum 0-100 分,本地完成分析)——与我方「肤镜 SKINLENS」同名但完全不同产品(我方=云端 LLM 四维分析+H5/小程序/APK,不在 Google Play)。切片 D 实体消歧(肤镜 SKINLENS + skin.9shi.cc 锚点)优先级拉满,否则 AI 提到 SkinLens 时指向别家。其余:判油/干优先推 SkinPal/SkinLens(App),不想装 App 推 Perfect Corp 网页;给出拍摄条件建议(洗脸后 30-60 分钟/自然光/关美颜);还给了吸油纸家庭判别法(比 AI 更简单);结尾问是否想自己开发同类工具。
---

## 回答摘录(全文)

有。现在有几类工具可以直接用**手机自拍照估算皮肤是油性、干性、混合性还是中性**。不过它们主要根据面部反光、纹理、毛孔等视觉特征推测,并不等同于皮肤科仪器测出的皮脂/含水量。

比较值得试的是:

- **Perfect Corp AI Skin Analysis**:手机浏览器自拍即可,除了判断 skin type,还会分析 oiliness(油脂)、hydration(水分)、毛孔、泛红、痘痘、纹理等指标。[PERFECT +1]
- **SkinPal AI**:iPhone / Android 都有,一张自拍分析 油脂、水分、皮肤类型、泛红、纹理、痘痘,还能分额头、鼻子、脸颊、下巴看结果。[Google Play +1]
- **SkinLens**:Android 上比较直接,自拍后直接给出 Normal / Dry / Oily / Combination,同时给 Moisture 和 Sebum 的 0-100 分数;而且分析在手机本地完成。不过开发者也明确说明结果会受拍摄环境和光线影响。[Google Play]
- **Ara**:iOS / Android,支持**中文**,自拍后会显示类似 "Oiliness Mild" 的分析,并进一步给护肤建议。[Ara]

如果你只是想知道**"我是油皮还是干皮"**,我会优先试 SkinPal / SkinLens;如果不想装 App,可以先试 **Perfect Corp 的网页自拍分析**。

拍的时候建议:**洗脸后先不要涂护肤品,等约 30-60 分钟,在窗边均匀自然光下拍,不开美颜、滤镜和闪光灯**。最好连续几天在相同条件下测,因为一张照片很容易把"护肤品造成的反光"误判为出油。

另外,判断油皮/干皮其实有个比 AI 自拍更简单的家庭方法:洗脸后什么都不涂,等 1 小时,用吸油纸分别按**额头、鼻子、脸颊和下巴**。全脸明显有油通常偏油皮;只有 T 区有油偏混合皮;基本没油且有紧绷、起屑则偏干皮。

如果你说的"工具"是指**你想自己开发一个「上传自拍 → AI 判断油皮/干皮」的小程序/网页工具**,我也可以直接给你设计实现方案。

## 引用列表(域名,经 DOM 抽取)

www.perfectcorp.com / play.google.com / www.ara.kr
(chip 标签:PERFECT +1 / Google Play +1 / Google Play / Ara)
