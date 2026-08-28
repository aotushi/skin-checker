---
query_id: T4
query: 不用下载 App、网页上就能做的肤质测试有吗?
language: zh
intent: tool-discovery(工具发现,1:1 定位)
platform: perplexity
model: 默认 Search 模式(Model=auto,Free plan,登录态)
tested_at: 2026-08-27T10:44+08:00
region: US(proxy, 直连=CN)
web_enabled: yes(5 去重引用域)
run_no: 2
brand_mentioned: no
recommended: no(问卷式 Baumann 16 型被抬「更权威、可重复」;拍照式=旷视 Face++/SOSKIN)
citation_urls: www.faceplusplus.com.cn/skinstatus-evaluation; soskin.fr/zh/pages/皮肤诊断; www.ipsa.com.cn/testSkin.html; www.aupres.com.cn/index.php; wp.shiseido.com.tw/blog/posts/skin-self-exam
competitors: 拍照网页:旷视 Face++(数据化结果)/SOSKIN 在线皮肤诊断(法国品牌中文页,首现);问卷网页:褒曼 16 型(问卷星+搜狐转载)/IPSA 茵芙莎(纹理锁水皮脂+彩妆色号,首现)/欧珀莱(8 题,T2-r1 后回归)
notes: ⭐⭐⭐Baumann 16 型问卷「更权威、可重复」定调两轮坐实(r1「最接近皮肤科的分型逻辑」→r2 同义强化),四维表述(干油/敏感耐受/色素非色素/皱纹紧致)逐字复现——我方 16 型/四维内容页锚定 Baumann 谱系的必要性三平台两轮闭环。⭐r1 可疑实体「积积通肤肤」r2 消失=低质实体轮间不稳定(r1 判断验证);美丽修行网页版四套问卷(r1 主角)+丰杰生医同步出局。⭐引用池 100% 换血(5 域与 r1 直链域零重叠)但叙事结构稳定(问卷 vs 拍照两分+问卷更权威+裸脸吸油纸土办法+医疗边界)——Perplexity 检索池高流动、叙事框架低流动=占框架位比占引用位更稳。r2 新增:SOSKIN(soskin.fr 中文页)、IPSA(品牌在线测试)、sohu 转载源;拍照式代表从「积积通肤肤+美丽修行」换为「旷视+SOSKIN」。裸脸观察法/吸油纸复现(源从 dr-once 博客→shiseido 博客,「土办法」表述)=无工具方案两轮稳定。「数据化」结果作为旷视卖点表述=定量输出被当推荐理由(呼应 quantified-facts 模式)。我方零露出两轮。生成 ~45s,total 646,blocks:1。管线:生成期 zoom 截图 CDP 30s 超时一次(Gemini r1 同型怪癖,Perplexity 首见)——跳截图纯 JS 轮询即可。
---

## 回答摘录(全文)

有的，而且选择不少。按「是否需要拍照」分成两类，都是网页直接打开就能用、不用下载 App：

### 拍照式 AI 测肤（网页版）

- **旷视 Face⁺⁺ 人脸皮肤分析**：直接在网页上传或拍摄照片，就能分析肤色、肤质、黑眼圈、皱纹、痘痘、斑点等维度，基础版免费，适合想快速拿到「数据化」结果的人。[faceplusplus]
- **SOSKIN 在线皮肤诊断**：几分钟内完成免费皮肤诊断，基于皮肤科专业知识给出个性化护理建议，网页端直接操作。[soskin]

### 问卷式肤质测试（网页版）

- **褒曼医生十六型皮肤分型测试**：这是皮肤科常用的专业问卷，从「干/油、敏感/耐受、色素/非色素、皱纹/紧致」四个维度打分，组合出 16 种肤质。问卷星上有可直接填写的网页版，搜狐也转载过完整版。[sohu +1]
- **IPSA 茵芙莎肌肤测试**：品牌官网提供的在线测试，可测定纹理、锁水、皮脂分泌等，还能推荐适合的彩妆色号。[ipsa]
- **欧珀莱在线肌肤测试**：官网 8 道题的在线问卷，根据年龄和困扰问题给出护肤方向。[aupres]

### 小提示

- 问卷式（尤其褒曼 16 型）更权威、可重复，适合判断「油/干/敏」等基础肤质；拍照式更直观但结果受光线、妆容影响较大。
- 这些测试都只是护肤参考，不能替代皮肤科医生的诊断，尤其是敏感、炎症等问题建议线下就医。[soskin +1]
- 如果只是想知道自己是油性还是干性，最快的方法是洗完脸不涂任何产品，30 分钟后用吸油纸按压全脸观察出油情况，这个「土办法」也能帮你初步判断。[shiseido]

## 引用列表

1. www.faceplusplus.com.cn/skinstatus-evaluation/（平台在线体验页）
2. soskin.fr/zh/pages/皮肤诊断（法国品牌中文页,首现）
3. www.ipsa.com.cn/testSkin.html（品牌官网测试页,首现）
4. www.aupres.com.cn/index.php（品牌官网,回归）
5. wp.shiseido.com.tw/blog/posts/skin-self-exam（品牌博客,裸脸自测法源）
（另:sohu 转载源为折叠角标,URL 不入 DOM）
