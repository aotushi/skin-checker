---
query_id: T4
query: 不用下载 App、网页上就能做的肤质测试有吗?
language: zh
intent: tool-discovery
platform: chatgpt
model: default(Pro 账号,推理档 Extra High;界面未标注模型名;Worked for 7s;临时对话模式)
tested_at: 2026-08-27T08:56+08:00
region: US(proxy, 直连=CN)
web_enabled: auto-triggered
run_no: 2
brand_mentioned: no
recommended: n/a
citation_urls: www.skinstacker.com; dermapproved.com; www.laroche-posay.ca; www.cerave.com
competitors: Skin Stacker Skin Quiz; DermApproved Skin Type Quiz; La Roche-Posay Routine Finder; CeraVe quiz
notes: ⭐本轮解读大转向:把「不用下载 App」进一步理解为「不上传自拍、直接浏览器答题」,4 款全是问卷 quiz,零拍照分析工具(r1 还留了 LRP MyRoutine AI 自拍位)。vs r1:Skin Type Solutions(Baumann 16 型)掉出——r1 的⭐发现本轮未复现,说明该推荐不稳定;Skin Stacker 新进且列首推,首推理由=「免费、无需注册/邮箱、答案只保存在浏览器里」——隐私最小化再次成为排序权重。连任:DermApproved/CeraVe;LRP 从 MyRoutine AI(自拍)换成 Routine Finder(答题)。品牌测试被明确降权标注(理肤泉/CeraVe「最后会偏向推荐自家产品」)。新增洗脸后 30 分钟观察法(引 CeraVe 指南)。
---

## 回答摘录(全文,get_page_text 抽取)

有,而且可以做到不下载 App、不上传自拍、直接浏览器答题。我刚查了几款目前还能用的:

- **Skin Stacker Skin Quiz**:我最推荐。约 60 秒,免费、无需注册/邮箱,答案只保存在浏览器里;会判断肤质和主要皮肤困扰。[直接做 Skin Stacker 测试 ↗]
- **DermApproved Skin Type Quiz**:9 道题、约 2 分钟,会区分油皮 / 干皮 / 混合皮 / 中性皮,同时看敏感和缺水情况,比只分四种肤质稍细。[直接做 DermApproved 测试 ↗]
- **La Roche-Posay 理肤泉 Routine Finder**:网页直接答题,会问敏感程度、肤质和主要问题;缺点是最后会偏向推荐自家产品。[打开理肤泉测试 ↗]
- **CeraVe**:也有网页版测试,除了肤质还可以选洁面、保湿或整套护肤流程;同样属于品牌测试,所以产品推荐会偏 CeraVe。[打开 CeraVe 肤质测试页面 ↗]

如果你只是想知道自己到底是油皮、干皮、混合皮,还是"外油内干/缺水",我会先做 DermApproved;如果最在意不用注册和隐私,选 Skin Stacker。

另外,测试前最好正常洗脸后什么都不涂,等约 30 分钟再观察,这样判断出油和紧绷会更准。CeraVe 的肤质判断指南也是采用洗脸后约 30 分钟观察的方法。

## 引用列表(域名,经 DOM 抽取)

www.skinstacker.com / dermapproved.com / www.laroche-posay.ca / www.cerave.com
(chip 标签:Skin Stacker / DermApproved / La Roche-Posay / CeraVe +1)
