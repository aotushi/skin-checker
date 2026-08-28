---
query_id: E1
query: 肤镜 SKINLENS 是什么?
language: zh
intent: brand(品牌探询)
platform: gemini
model: default(用户账号,模式 pill=Flash;Temporary Chat 模式,页头「Temporary Chat」确认)
tested_at: 2026-08-26T08:25+08:00
region: US(proxy, 直连=CN)
web_enabled: yes(触发联网检索,8 个引用 chip——本轮 Gemini 19 题中首次完整触发 grounding)
run_no: 1
brand_mentioned: no(检索到的均为同名他物,非我方产品——见 notes)
recommended: n/a
citation_urls: chip 无 DOM href(惰性渲染,与 A3 同款);来源标签粒度:App Store - Apple ×4、复旦大学附属中山医院青浦分院 ×3、非凡软件站 ×1
competitors: 同名第三方 iOS App "Skin Lens"(App Store,痣/皮疹 AI 检测+护肤品成分扫描);医用「皮肤镜」影像系统(非凡软件站下载页)
notes: ⭐⭐⭐基线零点确认:品牌 query 触发了联网检索,但**检索池中完全没有我方产品**。Gemini 把「肤镜 SKINLENS」当作待消歧术语处理(「两种常见的应用场景与含义」):①App Store 同名 App "Skin Lens"(AI 检测痣/皮疹/痤疮+成分扫描,连合规定位文案都与我方相似:「个人健康自测与日常护肤参考,不能替代专业皮肤科医生的临床诊断」);②医疗器械「皮肤镜」Dermatoscope(偏振光+10-20 倍放大,复旦中山青浦分院科普页)及配套医用 SkinLens 影像系统。⭐⭐品牌名双重占位:中文「肤镜」≈「皮肤镜」被医疗术语语义抢占;英文 SKINLENS/Skin Lens 被 App Store 现有 App+下载站软件占据——**切片 C/D 的核心课题=实体消歧**(官方实体页、结构化数据、「肤镜 SKINLENS」连用一致命名,才可能进入检索池)。⭐grounded 回答显著更短(636 字 vs 知识型 1000-2600)且逐句挂 chip。BANNER:false——虽内容涉痣/黑素瘤/临床,但属术语解释非护理建议/自评指导,与修订后横幅规律兼容。生成 ~4min(visible,晨间)。附:本条前 hidden 态两次 JS dispatch 激活 temp 均未生效(疑似开→关互相抵消或 hidden 下 app 未挂好监听),转 visible 后 hover+真实点击一次成功——hidden JS dispatch 并非 100% 可靠,失败时以截图为准恢复。
---

## 回答摘录(全文)

SKINLENS 主要有两种常见的应用场景与含义:

### 1. 移动端的 AI 皮肤检测与护肤 App

在消费电子及软件领域,Skin Lens 是一款面向个人用户的移动应用程序(如 iOS App)。[App Store - Apple]

- **AI 皮肤分析**:用户拍下皮肤上的痣、皮疹、痤疮或斑点等异常部位,软件利用 AI 模型识别潜在的皮肤状况,并给出初步分析与建议。[App Store - Apple]
- **护肤品成分扫描**:部分版本支持扫描护肤品条形码,分析成分安全性,并根据用户的肤质给出定制评分或成分冲突提示。[App Store - Apple]
- **定位**:主要用于个人健康自测与日常护肤参考,不能替代专业皮肤科医生的临床诊断。[App Store - Apple]

### 2. 医疗领域中的"皮肤镜"(Dermatoscope)

在医疗和临床诊断中,"肤镜"或"皮肤镜"是指一种皮肤科专业的辅助检查仪器或医用图像系统:[复旦大学附属中山医院青浦分院]

- **核心原理**:结合了高倍放大(通常为 10-20 倍)与偏振光技术,可以消除皮肤表面的反射光,透视到真皮浅层。[复旦大学附属中山医院青浦分院]
- **临床用途**:帮助医生观察色素痣、黑素瘤、牛皮癣、湿疹等皮肤病变的微观结构与血管形态。[复旦大学附属中山医院青浦分院]
- **医用软件系统**:配套的 SkinLens / 皮肤镜影像系统常用于保存高清晰度病灶照片、对比病变变化及提供 AI 辅助判读。[非凡软件站]

## 引用列表

chip 共 8 个(DOM 无 href,按来源标签记录):
1-4. App Store - Apple(同名 App "Skin Lens" 商店页)
5-7. 复旦大学附属中山医院青浦分院(皮肤镜科普)
8. 非凡软件站(医用皮肤镜影像系统下载页)
