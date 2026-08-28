---
query_id: T2
query: 拍照就能分析肤质的网站有推荐吗?
language: zh
intent: tool-discovery
platform: gemini
model: default(用户账号,模式 pill=Flash;Temporary Chat;窗口 hidden+泵帧管线)
tested_at: 2026-08-27T09:37+08:00
region: US(proxy, 直连=CN)
web_enabled: auto-triggered(grounding,inline 来源 chips ×8)
run_no: 2
brand_mentioned: no
recommended: n/a
citation_urls: chips 无直链,来源名照录:Perfect Corp. ×3, watashi+ ×3, Skin Beauty Pal ×2
competitors: 资生堂/怡丽丝尔 ELIXIR AI 肌肤检测(watashi+ H5,水玉光), 玩美移动 Perfect Corp Demo 体验页(SD/HD 分析), 修丽可肌肤检测小程序, 理肤泉 AI 祛痘/肌肤检测小程序, 美修测肤小程序(美丽修行同款), Skin Beauty Pal, 美丽修行 App
notes: ⭐⭐定调反转:r1 开篇「纯网页端免费深度 AI 肤质分析相对较少」(曾标记为我方最直接切入证据)→ r2 开篇「网页端(H5)和各大品牌的微信小程序里已经很成熟了」——Web 稀缺叙事一轮即翻转,属轮间噪声而非稳定结论,W6 复盘引用须标注两轮相反。但细看 r2 的「成熟」全由品牌方支撑(watashi+ H5/Perfect Corp demo/修丽可/理肤泉/美修=导购型),且贴士自认「受限于手机摄像头分辨率」——独立、非导购、分析后即删的定位空位不受反转影响。⭐微信小程序首次成为独立类目(r1 无),且获「无需下载 App,比网页更稳定」「小程序调用相机清晰度和光线适应度往往比纯 Web 好」正面评价——与我方 Web+微信小程序双形态完全对位。Perfect Corp 玩美移动连续第二条出现(T1 r2 首现)=本轮新崛起实体,以「大牌背后技术供应商」占「网页版 demo」位。竞品换血:Face++ 体验页、「你今天真好看」出局;Skin Beauty Pal 为两轮唯一稳定占位者(r1 网页类→r2 独立 App 类漂移)。尾贴士(自然光/素颜/仅供参考+严重痤疮皮炎就医)与 Gemini 固定安全话术同构。banner:可见性感知探测仅通用页脚 "Gemini is AI and can make mistakes." ×2,无医疗横幅=grounded-no-medical-banner 假设首个有效数据点(T1 探测因空壳 disclaimer 元素误报作废)。quirk #15 泵帧管线继续生效,生成 ~70s。
---

## 回答摘录(全文)

拍照测肤这个需求,现在在网页端(H5)和各大品牌的微信小程序里已经很成熟了!大多数都是各大护肤品牌或者美妆集团为了推荐产品而提供的免费 AI 测肤功能。[Perfect Corp.]

整理了几类体验较好且不需要额外面部硬件的测肤渠道:

### 1. 品牌官方网页 / H5(手机浏览器直接打开)

这类网站通常由大牌护肤集团开发,数据积累丰富,算法也相对成熟:

- **资生堂 / 怡丽丝尔 (ELIXIR) AI 肌肤检测** [watashi+]
  - 特点:依托资生堂的肌肤科学数据库,检测包括纹路、斑点、皮肤紧致度等多个维度,并生成专有的「水玉光」状态图表。[watashi+]
  - 使用方式:手机浏览器搜索「怡丽丝尔 AI 线上肌肤检测」打开 H5 页面即可拍照体验。[watashi+]
- **玩美移动 (Perfect Corp) Demo 体验页** [Perfect Corp.]
  - 特点:全球很多大牌(如理肤泉、雅诗兰黛等)背后的 AI 测肤技术提供商。网页版提供 SD/HD 的 AI 肤质分析演示,能测毛孔、黑头、细纹、红血丝等。[Perfect Corp. ×2;来源卡片摘要:「提供在线AI肤质检测及皮肤分析解决方案…HD皮肤分析以 2 倍分辨率分析照片,树立新标准」]

### 2. 微信小程序(无需下载 App,比网页更稳定)

在手机端,小程序调用相机的清晰度和光线适应度往往比纯 Web 网页更好,推荐直接在微信搜以下小程序:

- **修丽可 (Skinceuticals) 肌肤检测**:专注于皮肤屏障、油分、色斑和老化指标。
- **理肤泉 AI 祛痘 / 肌肤检测**:对痘痘、粉刺、敏感泛红等特定问题检测非常精准。
- **美修测肤(美丽修行 App 同款)**:结合了化妆品成分库,测完肤质后会直接推荐适合你肤质成分的产品。

### 3. 独立测肤工具 App

如果你想长期记录和对比肤质变化,独立 App 的历史对比功能会更完善:[Skin Beauty Pal]

- **Skin Beauty Pal**:支持测油分、毛孔、细纹、黑眼圈等,并提供分数化报告和趋势对比。[Skin Beauty Pal]
- **美丽修行**:偏向「肤质测试 + 成份匹配」,适合想避坑成分的护肤党。

💡 **拍照测肤小贴士(让结果更准)**:

- 自然光拍照:尽量在白天面对窗户(不要直射)拍,避免室内黄光或阴影影响红血丝、色斑的判断。
- 素颜检测:务必洗完脸、擦干且未涂抹护肤品时拍摄。
- 结果仅供参考:AI 拍照测肤受限于手机摄像头分辨率和光线,主要用于了解趋势和基础肤质分类。如果存在严重痤疮、皮炎等问题,建议直接去医院看皮肤科。

## 引用列表

inline source chips(无直链):Perfect Corp. ×3、watashi+ ×3、Skin Beauty Pal ×2(source-footnote ×8)
