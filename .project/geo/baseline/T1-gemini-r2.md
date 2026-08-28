---
query_id: T1
query: 有什么在线 AI 测肤质的工具?
language: zh
intent: tool-discovery
platform: gemini
model: default(用户账号,模式 pill=Flash;Temporary Chat;窗口 hidden 态+截图泵帧管线,生成 ~70s)
tested_at: 2026-08-27T09:30+08:00
region: US(proxy, 直连=CN)
web_enabled: auto-triggered(grounding,inline 来源 chips ×12)
run_no: 2
brand_mentioned: no
recommended: n/a
citation_urls: chips 无直链,来源名照录:美丽修行大数据 ×4, SkinRun ×1, AILab Tools ×3, watashi+ ×3, Face⁺⁺ ×1
competitors: 美丽修行(App/小程序,内置旷视 FaceStyle 算法,首位), 肌肤管家(微信小程序/网页,SkinRun/AILab Tools 引用), 电商美妆平台内置工具(淘宝/天猫/小红书搜「AI测肤」), 资生堂/ELIXIR 怡丽丝尔 watashi+(松弛/纹路/斑点/水玉光), 理肤泉/雅诗兰黛/兰蔻官方公众号小程序, AILab Tools(AI 皮肤分析网页版,上传照片), 旷视 FaceStyle/玩美移动 Perfect Corp(官网 Demo/API)
notes: 复现 r1 中国生态主导+grounded,但竞品名单大幅换血:Skinive(CE 医疗级)与 SHINNO SKINLAB 出局;新进肌肤管家(SkinRun)、AILab Tools、⭐玩美移动 Perfect Corp——Perfect Corp 首次在 Gemini 中文 T1 出现,与 ChatGPT 生态(两轮首推 Perfect Corp)首次交汇。⭐「网页版」类目两轮稳定存在,占位者轮换:r1 SHINNO SKINLAB(网页/Line 免安装)→r2 AILab Tools(「打开网页上传照片即可检测」)——我方(纯 Web 免安装)可争取的类目持续在,但每轮被不同实体占据=空位流动性高。美丽修行两轮榜首=Gemini 中文测肤生态锚定实体(r2 明确点出其算法来自旷视 FaceStyle)。分类从 r1 四分类(专业 App/成分科普/品牌官方/病理级)变为 r2 三分类(消费级 App&小程序/品牌官方/网页版&开发者专业工具),病理级(Skinive)类目整个消失。小贴士三条同构(光线均匀/素颜/仅供参考+就医);r2 就医句升级为「医院皮肤科专业检测(如 VISIA 皮肤检测仪)」=专业仪器对照首次进 Gemini T 组。管线:⭐⭐新怪癖 #15——窗口 hidden 态下发送冻结(JS 派发/CDP 点击/Enter/JS KeyboardEvent 全部静默失效,但 temp 开关吃 JS 派发),破解=点击后立刻连环截图/zoom 泵帧(CDP 强制 BeginFrame 恢复 rAF 一拍);泵帧管线下生成仅 ~70s,远快于 r1 可见态 ~4min 与 hidden 态 13-20min。banner 探针(message-warning 等选择器)返回 true 但疑似 DOM 脚手架假阳性(election/finance-disclaimer 等空元素常驻),T2 起改可见性判定;grounded-no-banner 假说本条无有效观测。
---

## 回答摘录(全文)

目前市场上有很多基于人工智能(AI)和计算机视觉技术的在线测肤工具,主要分为App/小程序端(偏日常护肤消费)和品牌/专业平台端(偏定制化推荐/开发测试)。[美丽修行大数据]

以下是几种最常用且容易体验到的 AI 在线测肤途径:

### 一、常用消费级 App & 小程序

这类工具适合日常自测,通常只需用手机前置摄像头拍一张清晰素颜照,结合问卷就能快速生成分析报告。[美丽修行大数据]

**美丽修行(App / 微信小程序)**
- 特点:国内知名度极高。内置了旷视(FaceStyle)的 AI 测肤算法。[美丽修行大数据]
- 功能:能够识别干/油性、敏感/耐受、黑头、痘痘、毛孔及细纹等情况,并根据你的测肤报告和成分库推荐匹配的护肤品。[美丽修行大数据]

**肌肤管家(微信小程序 / 网页)**
- 特点:专注于皮肤分析和智能检测的平台。[SkinRun]
- 功能:通过照片检测面部斑点、痘痘、黑头、细纹和肌龄,并提供定期的皮肤健康追踪。[AILab Tools]

**各大电商/美妆平台(如淘宝/天猫/小红书等内置工具)**

在部分美妆旗舰店或平台活动页中,搜索"AI测肤"或"测肤质",通常能找到内置的快测入口,主要用于匹配对应品牌的护肤方案。

### 二、知名美妆品牌官方在线 AI 测肤

许多大牌美妆利用玩美移动(Perfect Corp)等的技术,推出了自己的官方在线测肤体验:

**资生堂 / ELIXIR 怡麗絲爾(AI 線上肌膚檢測)**
- 特点:基于资生堂集团的肌肤科学数据开发。[watashi+]
- 功能:可检测脸部多个维度的松弛、纹路、斑点及"水玉光"状态,并给出护肤建议。[watashi+]

**理肤泉 / 雅诗兰黛 / 兰蔻 等官方公众号或小程序**

许多品牌的微信公众号/小程序菜单栏中均设有"AI 测肤"或"肌龄检测"入口,分析肤质的同时会为你精准匹配适合的精华或乳霜。

### 三、网页版 / 开发者与专业工具

如果你想在网页端直接体验,或了解背后的技术 API:

**AILab Tools(AI 皮肤分析网页版)**
- 特点:打开网页上传清晰面部照片即可检测。[AILab Tools]
- 功能:提供黑斑、皱纹、水分状态、肌理等维度的分析报告。[AILab Tools]

**旷视 FaceStyle / 玩美移动 Perfect Corp**

这两家是业界主流的 AI 美妆技术提供商,在其官网(如 Face++)上通常提供 Demo 示范体验或 API 接口试用。[Face⁺⁺]

💡 **使用 AI 在线测肤的小贴士**

- 光线要均匀:尽量在自然光或无强烈阴影的白光下拍摄,避免侧光或过暗环境。
- 保持素颜:化妆、涂抹高光/遮瑕或带有滤镜拍照会极大地影响 AI 对瑕疵和出油情况的判断。
- 结果仅供参考:AI 测肤受限于手机摄像头像素、光线和算法,不能替代专业皮肤科医生的诊断。如果有严重的皮肤炎症、痤疮或敏感问题,建议前往医院皮肤科进行专业检测(如 VISIA 皮肤检测仪)。

## 引用列表

inline source chips(自定义元素 source-inline-chip,无直链 href,footnotes ×12):美丽修行大数据 ×4、SkinRun ×1、AILab Tools ×3、watashi+ ×3、Face⁺⁺ ×1
