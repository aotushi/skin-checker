---
query_id: T3
query: 免费的 AI 皮肤状态检测在线工具有哪些?
platform: gemini
model: default(Flash; Temporary Chat; JS click 激活)
tested_at: 2026-08-28T09:31+08:00
region: US(proxy, 直连=CN)
run_no: 3
brand_mentioned: no
recommended: no
---

# 回答全文

目前的免费 AI 皮肤检测工具主要分为美妆护肤品牌提供的网页版（体验顺畅、免下载）和专注于皮肤健康/病理筛查的 APP / Web 端（侧重色素痣、皮疹、痘痘等）。

整理了目前市面上较受好评且提供免费测试的 AI 测肤工具：

1. 免下载/网页端（美妆与肤质分析）

这类工具主要针对肌肤年龄、水分、毛孔、细纹、黑眼圈、暗沉等美容向指标。

怡丽丝尔 (ELIXIR / 资生堂) AI 线上肌肤检测 [watashi+]
形式： 网页端 / H5 [watashi+]
特点： 基于资生堂集团的肌肤数据库，分析脸部不同部位的松弛度、纹路、斑点等约 16 项指标，并生成专属的"水玉光"肌肤状态图表。 [Google Play +1]

Olay Skin Advisor (美境/网页版)
形式： 移动端网页 [watashi+ +1]
特点： 宝洁旗下的经典测肤 AI，通过上传素颜照评估"实际肌龄"，标出面部最年轻和最需要关注的区域（如眼周、T区），并推算肤质偏向。 [Google Play +1]

玩美移动 (Perfect Corp) AI 肤质/肌龄在线体验
形式： 网页 Demo [watashi+]
特点： 许多护肤大牌底层算法的提供商。官网上有免费体验入口，可实时检测平滑度、紧致度、黑眼圈及痘痘情况。 [Google Play +1]

SHINNO SKINLAB 星诺 AI 智能测肤 [SHINNO SKINLAB]
形式： H5 / 微信/LINE 扫码 [watashi+ +1]
特点： 无需额外下载 APP，直接在手机浏览器或社交软件中上传照片，即可快速获取肤质分析与打分。 [Google Play]

2. 侧重皮肤健康/瑕疵筛查（APP 与 Web）

这类工具更关注色斑、痣、痘痘、皮疹、皮肤红斑等具体症状的风险排查（仅作为日常自我监测参考，非医疗诊断）。

Skinive [App Store - Apple]
形式： iOS / Android APP [watashi+]
特点： 侧重皮肤病变与健康风险提示（如痘痘、斑点、异常痣等）。免费版提供基础的 AI 照片扫描和自查提示，界面直观。

Medgic (美技) [Google Play]
形式： Web / WebApp [watashi+]
特点： 专为皮肤状况/病变识别设计的开源/免费AI工具。上传局部皮肤照片后，AI 会分析视觉特征并给出常见皮肤问题的概率提示和护理建议。 [Google Play]

SkinAI (skinailab) [Skin AI]
形式： 网页版 [watashi+ +1]
特点： 基于Web的免费筛查工具，主要比对痣、皮疹、痤疮等 60 多种常见皮肤状况的视觉相似度。 [SHINNO SKINLAB]

💡 使用小贴士（如何获得最准确的结果）

光线与环境： 务必在自然光或均匀白光下拍摄，避免强侧光或过暗环境（光线差极易导致毛孔和细纹被放大误判）。

素颜拍摄： 不要带妆、涂抹高光或使用防晒霜（物理防晒剂可能被误判为肤色不均）。

注意隐私： 上传照片前，建议查看平台的隐私条款。大部分正规品牌的 H5 工具只会在本地浏览器或临时服务器中处理图像，检测完即销毁。

医疗免责声明： 所有消费级 AI 皮肤检测（无论美妆类还是健康类）均不可替代专业皮肤科医生的诊断。如果发现痣的形态短时间内有明显变化、出血或异常斑块，请直接前往医院皮肤科就诊。

# 引用

内联标记（grounding）: watashi+ / Google Play / App Store - Apple / SHINNO SKINLAB / Skin AI

# 观察

- 联网 grounding 回答（内联标记密集），与 T2 纯生成形成对比。
- 二分结构：美妆肤质分析（免下载网页端）vs 皮肤健康病理筛查 —— 我方属前者。
- ⭐ 资生堂描述再现「约 16 项指标」（T1 同）——「16」数字在 Gemini 供给侧被资生堂占据，与我方「16 型分类」存在措辞混淆风险/蹭点。
- ⭐ 隐私贴士「检测完即销毁」= 我方「分析后即删」卖点已是平台叙事构件，有对位土壤。
- 新实体（r3 Gemini 首见）：SHINNO SKINLAB 星诺、Skinive、Medgic、SkinAI(skinailab)、Olay Skin Advisor。
- 未提及 SKINLENS。就医红线含黑色素瘤观察项（痣变化/出血）。
