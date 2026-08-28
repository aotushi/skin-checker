<!-- 📋 自维护文档:修改任务内容时,必须更新“最后更新”和“变更历史” -->

# W6 · SKINLENS GEO / AI Search 最小可行实验

**最后更新:** 2026-08-28  
**状态:** 🟡 进行中(切片 A ✅;切片 B **✅ 收官**(run 1/2/3 共 171 条,三轮零供给对照基线成立);切片 C **✅ 五页已部署上线(2026-08-28,用户确认闸门后执行,`doc.skin.9shi.cc` 五页 200)——零供给对照期结束,归因窗口起算**;当前=切片 D 实体/结构/技术检查)  
**优先级:** P1（本项目内；不改变上层求职冲刺任务的既有排序）  
**相关站点:** `https://doc.skin.9shi.cc/`、`https://skin.9shi.cc/`  
**相关代码:** `landing/` 为公开内容与引用入口；`app-uni/` H5 为实际检测工具  
**任务性质:** 求职用真实 GEO 专项实践，同时改善产品的 AI Search 可发现性

> 目标：以 SKINLENS 为真实业务对象，完整走通一次“Query 设计 → 基线测试 → 竞品与 Citation 分析 → 小范围内容/实体/技术优化 → 复测 → 复盘”的 GEO 实验。第一轮追求方法和证据链完整，不预设一定获得 Mention、Citation 或增长结果。

## 1. 背景与选型结论

本任务来自 2026-08-25 的项目选择讨论。目标岗位同时要求传统 SEO、Technical SEO、内容策略、GEO / AI Search 测试及数据复盘。

候选方案曾包括：

1. 约 100 页的 WordPress / 英文 SEO 网站；
2. 页面较少的 SEO 分析项目；
3. SKINLENS AI 肤质参考工具。

最终选择 SKINLENS 作为第一轮 GEO 实验主体：

- WordPress 网站可以形成强案例，但第一轮涉及页面和历史结构较多，完整闭环成本偏高；
- SEO 分析项目适合承载 Query、Mention、Citation、竞品和复测数据，但单独作为实验对象容易形成“用 SEO 工具证明 SEO 工具”的自循环；
- SKINLENS 是可公开使用的真实消费者产品，具备自然的对话式搜索需求、独特交互和清晰转化路径，且公开内容规模小，适合快速建立第一套实验方法。

**角色分工：**

- SKINLENS：GEO 实验对象、内容与产品转化案例；
- SEO 分析项目：待手工流程和数据字段稳定后，可作为辅助记录/分析工具；第一轮不以开发工具为前置条件。

## 2. 产品边界（不得误读）

SKINLENS 的实际定位是**化妆与日常护肤场景下的 AI 肤质参考助手**：用户拍摄或上传正脸照片，系统分区读取 T 区、脸颊和下巴，输出四维肤质、16 型组合、置信度、分区表现及护理/产品品类建议。

它不是医疗诊断项目。W6 延续现有合规规则：

- 统一使用“参考、状态、表现、建议、护理、产品品类”等表达；
- 不新增疾病诊断、治疗、疗效或治愈宣称；
- 建议保持在成分/产品品类层，不扩展到具体品牌或药品；
- 不为 GEO 制造夸大准确率、功效数据或虚假用户背书；
- 用户照片仍按现有架构用后即删，不公开、不进入可索引页面；
- 免责声明继续以现有 schema 与 ADR 0008 为准，本任务不另造一套口径。

## 3. 2026-08-25 线上基线审计

### 3.1 已确认的良好基础

- `E:\code\github\resume\skin-checker` 与线上站点对应：仓库远程为 `https://github.com/aotushi/skin-checker.git`，`landing/` 配置与线上域名/文案一致。
- `doc.skin.9shi.cc` 是 Astro 静态站，原始 HTML 已包含正文，不依赖浏览器执行后才出现主要内容。
- 中英文页面已有 title、description、canonical、hreflang、Open Graph、Twitter Card 与 `SoftwareApplication` JSON-LD。
- robots 允许常规搜索抓取，且声明 `search=yes`、`use=reference`；sitemap-index 可访问。
- 线上落地页对产品功能、操作步骤、隐私、免责声明和技术实现已有完整介绍。
- H5 示例报告可以真实展示四维肤质、置信度、分区评估和成分/产品品类建议，业务闭环成立。

### 3.2 当前 GEO 缺口

1. **可引用页面太少**：sitemap 当前只有根页、`/zh/`、`/en/` 三个 URL，本质上仍是一张双语产品页。
2. **H5 工具不是内容入口**：`skin.9shi.cc` 原始 HTML 只有应用壳；正文、标题变化和示例报告依赖前端运行，且结果使用 hash 路由，不能形成独立可索引页面。
3. **搜索意图覆盖不足**：当前内容主要回答“产品是什么”，尚未系统回答用户如何判断肤质、如何拍摄、四个维度是什么意思、检测结果如何用于选择产品品类等问题。
4. **页面主题混合**：同一落地页同时面向消费者和技术面试官；双云部署、类型契约、设计令牌等工程内容会稀释消费者搜索主题。
5. **品牌实体存在歧义**：英文名 `SKINLENS` 已被其他肤质分析产品使用；中文“肤镜”也接近通用词。AI Search 可能把品牌 Mention 归给其他实体。
6. **公开搜索可见性尚未建立**：本次公开搜索未发现本站结果。该观察不是 Search Console 的最终收录结论，但可作为第一轮 baseline；正式执行需以 Search Console / URL Inspection 为准。

## 4. 第一轮范围

### 4.1 要做

- 选定一个主语言和目标市场，第一轮只在该语言建立完整闭环；另一语言保持现状，不同步扩张内容。
- 建立 12–20 个可重复测试的非品牌 Query Set。
- 对 ChatGPT、Gemini、Perplexity 进行基线测试；Google AI Search 在实际可用时纳入。
- 记录品牌/竞品 Mention、Citation、Recommendation 及引用页面类型。
- 在 `landing/` 增加少量公开、静态、可抓取内容页。
- 加强 SKINLENS 的实体消歧、方法说明、隐私和产品边界。
- 完成相同条件下的复测与数据复盘。
- 形成一份可用于简历和面试讲述的 GEO 案例摘要。

### 4.2 不做

- 不改造或重写现有 AI 分析、报告契约、Flutter/uniapp 核心流程。
- 不处理 WordPress 约 100 页网站。
- 不在第一轮批量生成 16 型 × 双语的大量薄内容页。
- 不把私人用户报告变成公开 URL，不索引人脸照片或个人分析结果。
- 不为了 GEO 新增具体品牌推荐、联盟营销或产品数据库。
- 不在手工流程稳定前开发完整 GEO 分析平台。
- 不把“完成优化”写成“获得增长”；结果必须以复测数据为准。
- 不自动进行任何远程数据库变更；部署也须单独确认。

## 5. 任务切片

### A. 冻结实验口径 ✅（2026-08-25，冻结值全文见 `.project/geo/experiment-log.md` §1）

- [x] 确定第一轮主语言、目标地区和用户人群 —— **中文 × 海外三平台**（用户确认）；人群 = 全球中文护肤/化妆用户，Query 以大陆表达为蓝本。
- [x] 确定一致的品牌实体写法 —— 统一组合词「肤镜 SKINLENS」+ 域名锚点消歧，不新造修饰词品牌。
- [x] 确定平台、模型/产品版本、联网状态、地区和重复次数 —— 三平台默认入口、版本照录、联网默认、出口地区逐次记录、每 Query 目标 3 次（先全量 run 1 再补）。
- [x] 建立实验日志 —— `.project/geo/experiment-log.md`（口径 + 过程日志）+ `baseline/`（records.csv 汇总 + 单条证据文件模板）。

### B. 建立 Query Set 与基线

Query 分四组，每组约 3–5 个：

1. **工具发现**：寻找在线 AI 肤质/skin type 分析工具；
2. **方法问题**：如何通过正脸照片了解偏油、偏干或混合状态；
3. **结果理解**：油脂、敏感、痘痘、色沉四个维度如何理解；
4. **行动建议**：某种肤质状态适合什么护理方式或产品品类。

- [x] Query 以真实用户表达为主，不只使用品牌词 —— Query Set v1 已冻结（`.project/geo/query-set.md`：主集 17 条全非品牌 5/4/4/4，另设品牌探针 E1/E2 不计入主集）。
- [ ] 每个 Query 在每个平台独立测试约 3 次，记录随机性。
- [ ] 建立优化前 baseline，不删除未出现品牌或无 Citation 的结果。
- [ ] 汇总主要竞品、被引用域名、页面类型、推荐理由与内容缺口。

建议最小记录字段：

| 字段                     | 说明                      |
| ------------------------ | ------------------------- |
| `query_id` / `query`     | 固定编号与原始问题        |
| `language` / `intent`    | 语言与意图分组            |
| `platform` / `model`     | 平台及可见的模型/产品版本 |
| `tested_at` / `region`   | 测试时间和地区            |
| `web_enabled` / `run_no` | 是否联网、同 Query 第几次 |
| `brand_mentioned`        | 是否出现 SKINLENS / 肤镜  |
| `recommended`            | 是否明确推荐使用          |
| `citation_urls`          | 引用 URL 与域名           |
| `competitors`            | 同回答出现的竞品          |
| `notes`                  | 推荐理由、回答差异和异常  |

### C. 建立最小公开内容集

第一轮目标为**现有落地页 + 约 5 个高价值页面**，而不是建设大型内容站。

> **五页已写完并落地 Astro**（2026-08-26）：规划稿 v1（`.project/geo/content-plan.md`，五页主题/URL/优先级 + 逐页基线缺口映射，回答 §8-3，用户已认可）→ C1-C5 草稿（`.project/geo/drafts/`，App 事实逐条核对）→ Astro 页面（`landing/src/layouts/Article.astro` + `landing/src/pages/zh/` 五页，本地 build/sitemap/元数据/移动端全验证）。**发布闸门未动：部署必须等 run 2-3 基线补测完成后单独确认，当前仅本地。**

候选主题：

- [ ] AI 肤质分析如何工作、能看什么、不能看什么；
- [ ] 如何拍摄适合肤质分析的正脸照片；
- [ ] 16 型肤质与油脂/敏感/痘痘/色沉四个维度说明；
- [ ] 如何把肤质结果用于选择清洁、防晒、保湿等产品品类；
- [ ] 分析方法、置信度、隐私与结果边界；
- [ ] 可选：无真人照片、无个人数据的公开示例报告说明页。

内容要求：

- 由 Astro 静态输出，原始 HTML 直接包含主要正文；
- 每页对应明确用户问题，提供本项目独有的方法、界面或示例，不做通用知识拼接；
- 可在正文自然解释 SKINLENS 的四维框架、分区方法和置信度，而非反复堆品牌名；
- 可见内容与结构化数据一致；
- 一种语言先做完，另一语言待第一轮复盘后决定是否复制。

### D. 实体、站点结构与技术检查

- [ ] 明确 `doc.skin.9shi.cc` 为公开内容/引用入口，`skin.9shi.cc` 为检测与转化入口；第一轮不重写 H5 为 SSR。
- [ ] 从消费者主页面弱化或拆出工程实现内容，技术作品信息保留在独立 `/tech/` 或 GitHub，不删除既有证据。
- [ ] 为新页面补齐 title、description、canonical、内部链接、sitemap 与必要的 hreflang。
- [ ] 检查品牌名、产品描述、官网 URL、GitHub 和应用入口在页面与 JSON-LD 中的一致性。
- [ ] 审核 robots 中与 Search/AI 相关的 crawler 策略，明确哪些是搜索引用、哪些是模型训练；不盲目全开。
- [ ] 通过 Search Console 提交 sitemap、检查 URL，并保存索引状态证据。
- [ ] 不将 hash 结果页当作可索引内容；公开示例使用独立静态页面。

### E. 优化、复测与复盘

- [ ] 将每项页面改动对应到 baseline 中的具体假设，避免“为了 GEO”无目标改版。
- [ ] 内容上线并确认可抓取/索引后，使用同一 Query、平台、条件和重复次数复测。
- [ ] 比较 Mention、Citation、Recommendation、竞品构成和引用来源的变化。
- [ ] 分开记录“已实施”“已被索引”“AI 回答发生变化”，不把三者混为因果。
- [ ] 输出成功、无变化和反向变化三类结论；没有漂亮增长也要保留。
- [ ] 形成面试案例：背景、假设、方法、实施、数据、限制、下一轮计划。

## 6. 验收标准

第一轮 W6 完成不以“被 AI 推荐”作为唯一条件，而以证据链完整为准：

- [ ] 项目选型、产品边界和非医疗口径保持一致；
- [ ] Query Set、平台条件和优化前 baseline 可复现；
- [ ] 竞品与 Citation 来源分析有原始记录；
- [ ] 约 5 个静态内容页上线、可抓取并进入 sitemap；
- [ ] 页面改动与实验假设逐项对应；
- [ ] 完成至少一轮同条件复测；
- [ ] 对结果的不确定性、索引延迟和平台随机性有明确说明；
- [ ] 产出一段不夸大的简历项目描述和一份可展开讲述的面试案例。

## 7. 简历表述边界

完成 baseline、内容优化和第一轮复测后，可以如实描述：

> 以自研 AI 肤质参考工具为对象建立 GEO / AI Search Query Set，对 ChatGPT、Gemini、Perplexity 等平台进行品牌 Mention、Citation 与竞品曝光测试；根据引用来源和用户意图优化公开内容、品牌实体与 Technical SEO，并在统一条件下持续复测和复盘。

只有数据支持时，才补充具体变化。不得提前写“提升 AI 曝光”“建立成熟 GEO 体系”或虚构百分比。

## 8. 开始本任务前需要决定

1. 第一轮主语言与目标市场；
2. 品牌是否增加稳定修饰词以处理同名实体；
3. 约 5 个页面的最终主题、URL 和优先级；
4. 第一轮使用表格/Markdown 手工记录，还是复用 SEO 分析项目的已有能力；
5. 上线后的最低观察周期与复测日期。

## 9. 参考指针

- **实验产物（口径/Query/基线记录）：`.project/geo/`**
- 现有落地页任务：`.project/tasks/W4-landing-page.md`
- 落地页代码：`landing/`
- H5 工具：`app-uni/`
- 产品需求：`E:\code\github\resume\docs\求职准备项目需求文档-V0.1\02-projects\03-皮肤检查工具-uniapp-flutter双端.md`
- 合规规则：`CLAUDE.md`、`docs/adr/0008-disclaimer-single-placement.md`
- 图片隐私：`docs/adr/0003-image-ephemeral-storage.md`
- 线上地址：`https://doc.skin.9shi.cc/`、`https://skin.9shi.cc/`

## 📝 变更历史

| 日期       | 变更内容                                                                                                                                 | 修改人 |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| 2026-08-25 | 新建 W6：确认以 SKINLENS 为 GEO 实验主体、SEO 分析项目为可选辅助工具；记录线上基线、最小内容范围、测试字段、切片、非目标、验收与简历边界 | Codex  |
| 2026-08-25 | 切片 A 完成：主语言中文×海外三平台（用户确认）、实体写法「肤镜 SKINLENS」+域名锚点、平台/次数等口径冻结入 `.project/geo/experiment-log.md`；切片 B Query Set v1 定稿（17 非品牌 + 2 品牌探针）与基线记录模板建立 | Claude |
| 2026-08-25/26 | 切片 B 基线 run 1（用户 Chrome 代跑）：**ChatGPT 19/19 全部归档**；**Gemini 9/19**（T1-T5、M1-M4）后被 Chrome 窗口后台化（visibility:hidden 挂起 Gemini 交互）硬阻塞，剩 U/A/E 组 10 条待窗口前台时续跑；Perplexity 待用户本人登录。⚠️ Gemini 两起误建普通对话留在用户历史（T2、M3，ID 见 experiment-log）。战略发现与管线怪癖全录 `.project/geo/experiment-log.md`，逐条数据 `.project/geo/baseline/` | Claude |
| 2026-08-26 | 切片 B Gemini run 1 续跑完成（用户前台化 Chrome 后 U/A/E 组 10 条全部归档，**Gemini 19/19 ✅**）：⭐ E1/E2 品牌零点确认——品牌 query 必触发联网但检索池无我方，「肤镜」被医疗术语「皮肤镜」、SKINLENS 被 App Store 同名 App 双重占位，评价 query 被同名 App 完整测评劫持 → 切片 C/D 核心=实体消歧；U1/U2 Baumann 锚定四维术语合法性、U4 置信度字段被品类叙事背书、A 组品牌二跳/成分层同构我方合规边界、A4 趋势叙事首次定量（色沉 3-6 个月）；医疗横幅规律两度修订（grounded 不挂横幅假说待 run 2）。续跑发现与怪癖补录（hidden 态分工/MCP BLOCKED/chip 无 href）见 `.project/geo/experiment-log.md`。剩：Perplexity 19 条待用户登录后代跑；run 2-3 复测同批补齐 | Claude |
| 2026-08-26 | 切片 B Perplexity run 1 完成（用户本人 OAuth 登录后代跑 19/19，08:55-09:55 无中断，**基线 run 1 三平台全完成=57 条**）：Perplexity 19/19 全联网（vs Gemini 5/19）。⭐ E 组同名场扩大到 4 实体（+skin-lens.com FDA 皮肤镜硬件、+「SkinLens: AI Skin Analysis」拍照测肤**孪生 App**），我方三平台全零，但平台会在答案内主动消歧列多义项=实体页有接收方；措辞决定解析（「肤质分析工具」→App 场）。⭐ U2 四维词汇=无主公共框架（定义权先占）；引用枢纽=CCTV/丁香医生/药监局系/Mayo zh；M 组单源垄断（zhihu 贴 ×6、台湾博客 ×5）=低进入门槛；U4 Azure 同构我方阈值+重拍设计、PMC 拆穿准确率宣称=**不发布准确率数字红线三平台互证**；T4/T5「网页版+手机拍照」双词槽位弱占据=我方精准缺口；A4 色沉大陆权威真空。管线：browser_batch ~4 往返/条、多 .prose 块 TOTAL 判定、断连先验状态、无隐身（**19 条留存用户 Sessions 已披露**）。详见 experiment-log.md Perplexity 章节。剩：run 2-3 复测；切片 C 内容页可开工 | Claude |
| 2026-08-26 | 切片 C 开工（写作先行，发布闸门=run 2-3 完成后）：**内容规划稿 v1**（`.project/geo/content-plan.md`）——五页定稿提案 C1 拍照指南 `/zh/photo-guide/`（M3 单源垄断+平台明示外化 App 引导）→ C2 四维与 16 型 `/zh/skin-dimensions/`（U2 定义权先占+U1 Baumann 对照消歧）→ C3 如何工作 `/zh/how-it-works/`（M2 准/不准双列共识）→ C4 置信度隐私边界 `/zh/confidence-and-privacy/`（U4+E2 负责任叙事槽）→ C5 结果→品类 `/zh/skincare-by-result/`（A1-A4+NMPA 定量+色沉真空），每页附基线证据文件指针（满足切片 E 可追溯要求）；示例报告页列后备。**C1 样稿 v1**（`.project/geo/drafts/C1-photo-guide.md`，App 事实核对过：三点要求/取景框文案/置信度 60% 阈值）待用户确认文风后批量写余四页并落地 Astro | Claude |
| 2026-08-26 | 切片 C 五页草稿全部完成（用户认可规划与 C1 文风后）：C2-C5 写入 `.project/geo/drafts/`，写前逐页核对 App 真实事实——C2 用 result.vue 四维 blurb 骨架+16 型全名单（skin-type-map.ts）+Baumann 对照表（第四维 A/F vs W/T 诚实声明）+「混合皮=分区正交信息非第 17 型」（ADR 0006）；C3 用 qwen.ts 真实链路（**gate 前置质检退回+重拍指引、建议取自人工手册不交 LLM 防幻觉**=负责任叙事硬供给），能看/不能看双列对齐 M2 共识，明说不发布准确率数字及原因；C4 逐维置信度+60% 阈值「参考」态+敏感维天然低置信诚实设计+隐私三条（即删/仅本地/不公开）+就医转介线+免责定稿；C5 六类策略层（控油/抗氧化/舒缓/修护/防晒/剥脱）按维度展开+油敏皮/干痘皮组合示例+NMPA 防晒定量+误区表,零品牌。下一步：落地 Astro（Article 布局+五页+元数据），部署仍守 run 2-3 闸门 | Claude |
| 2026-08-26 | 切片 C 五页落地 Astro 完成（**仅本地构建，未部署——发布闸门=run 2-3 完成+用户单独确认**）：`landing/src/layouts/Base.astro` 加可选逐页元数据（title/description/ogType/jsonLd 覆盖 + hreflang 改可选，中文独占页不输出 alternate；首页三项 hreflang/SoftwareApplication/og:type=website 回归验证原样）；新建 `Article.astro` 布局（精简导航〔首页锚点在内容页无效故不复用 Nav〕+720px 阅读宽+正文排版全局样式+页尾统一「关于肤镜 SKINLENS」实体模块+延伸阅读+Article JSON-LD，datePublished 暂 08-26 部署时随实际上线日校准）；五页 `landing/src/pages/zh/{photo-guide,skin-dimensions,how-it-works,confidence-and-privacy,skincare-by-result}.astro` 正文与 drafts 逐字对应。验证：`pnpm build` 8 页全过、sitemap 收录五新 URL、逐页 title/description/canonical/og:type=article/Article JSON-LD 抽查、五页浏览器巡检（结构/内链/免责句/零品牌/误区表 5 行）+ 移动端 375px 表格最重页无横向溢出 + console 全程零错误 | Claude |
| 2026-08-26 | 切片 C UI 一致性核查通过（用户要求，run 2 前置）：五页全页截图逐页与首页设计基准比对（Playwright headless；Browser pane 不可用）——导航/暖渐变背景/rose-wood 标题层级/链接与表格卡片样式/实体卡/页脚全一致；唯一真问题=**移动端 375px 文章导航过挤致「返回首页」「在线体验」按钮内文字折行**，修复=Article.astro 照搬 Nav.astro 同规则（≤720px 隐藏 CTA，留品牌+返回首页 pill），375px 复测单行零溢出、桌面 CTA 原样、`pnpm build` 8 页复过。dev 模式截图会撞 astro-dev-toolbar 悬浮件（生产构建无此元素，非页面问题）。run 2 复测明日（08-27）执行 | Claude |
| 2026-08-27 | **切片 B 基线 run 2 三平台 57/57 单日完成**（同口径复测，五页仍未部署=零供给对照；ChatGPT 08:48-09:21 → Gemini 09:30-10:30 → Perplexity 10:44-13:49，归档 `<id>-<平台>-r2.md` ×57 + records.csv 至 115 行）。⭐ 核心：①**E 组同名场演变**——ChatGPT E2 主动点名「网页版/微信小程序」实体空位（=部署后最直接收口点）；Gemini E1 剧变单义医疗术语垄断+E2 孪生 App 进参数记忆（混淆入权重）；Perplexity E1 词捕获加深（主动裁决默认义项）+E2 孪生 App 掉出解析池（先发窗口扩大）+「无第三方测评难评价」口碑真空官方确认；我方 6 条探针两轮全零（预期）。②**U2 定义权窗口在关闭**：三平台同轮出现归属化信号→部署时间敏感性提高。③**隐私最小化上升为跨平台排序权重**（ChatGPT/Gemini T3/T4）=我方「即删+仅本地」现成对位。④Gemini 医疗横幅规律收口（query 级确定性分类器，两轮零漂移）；Baumann 16 型跨组上浮；VISIA 分层定位三平台合流；r2 整体更倾向补就医红线。管线：Gemini 怪癖 #15 hidden 冻结+**泵帧破解**（60 分钟跑完 19 条）；Perplexity insert 静默失败 ~1/3+渲染节流 5 例（判稳协议硬化=稳定×2 后必泵帧复核）。详见 experiment-log.md「基线 run 2」章。剩：run 3（拟 08-28）→ 部署闸门 | Claude |
| 2026-08-28 | **切片 B 基线 run 3 三平台 57/57 完成=三轮零供给基线收官,切片 B 收口**（同口径第三轮,五页仍未部署;ChatGPT → Gemini → Perplexity 单日完成,Perplexity 段跨一次 usage limit 中断续跑;归档 `<id>-<平台>-r3.md` ×57 + records.csv 至 172 行=57×3 全量）。⭐ 核心：①**E2 实体空位三平台收敛**——ChatGPT/Gemini 双双归属第三同名 iOS App、Perplexity 双实体消歧后原文裁定「都不是拍脸测肤」=「SKINLENS 肤质分析工具」市面不存在被三平台各自确认;同名场增员（Solion Labs 成分扫描器 2026-05 上架）=先发窗口仍开但在变挤。②**U4 置信度肤质领域零供给三平台确认**（引用全为通用 AI 文档）=「方法与置信度」页入池概率全站最高;U2 Baumann 混淆三平台一致（Gemini 幻觉自创痘痘维/Perplexity 半改编自纠）=四维消歧空位三重确认。③**隐私叙事三轮三级跳至制度化**（ChatGPT 逐工具标配字段/Gemini「检测完即销毁」/Perplexity 收尾推荐轴）=我方「即删+仅本地」确定性最高卖点。④数字占位双面实证（L'Oréal 95% 被复述 vs 90%+ 被解构）=不发准确率数字约束的代价/收益并存,以「诚实边界+置信度」差异化。⑤权威源结构变化：NMPA×5/福建药监局/官媒（CCTV/新华网）上位;ChatGPT A 组引用位收缩至 A4 唯一稳定;**Gemini 医疗横幅「确定性分类器」被 r3 打破**（U3/A4 正例失守）=平台行为版本性漂移,单轮结论须跨轮标注。⑥分区叙事三平台共九现;平台自留三平台全面化=内容页目标为被引用而非被点击。**「基线阶段小结（run 1–3,切片 B 收口）」章已入 experiment-log**（入池优先级排序/稳定卖点对位/E 组消歧策略/轮间波动警示/管线资产）。**部署闸门开启（待用户单独确认）→ 切片 D** | Claude |
| 2026-08-28 | **切片 C 五页部署上线（用户确认闸门后执行,切片 C 收官）**：部署前按既定动作校准 `Article.astro` datePublished 2026-08-26→2026-08-28（随实际上线日）→ `pnpm build` 8 页全过+产物抽查（五页目录/日期/sitemap 8 URL 含五新页）→ `wrangler pages deploy dist` 直传 `skin-checker-doc` master（部署 d2e7922b）。⚠️ 环境坑：环境变量 `CLOUDFLARE_API_TOKEN` 为权限受限 token（缺 Pages 写）触发 403 AuthenticationError,`env -u CLOUDFLARE_API_TOKEN` 回落 OAuth 登录态（含 pages write scope）后部署成功。线上验证：`doc.skin.9shi.cc` 五页+/zh/+sitemap-0.xml 全 200、根 301→/zh/ 原样、首页 title 回归原样、内容页 title/canonical/datePublished=08-28 抽查生效。**零供给对照期结束,平台露出归因窗口自本日起算（experiment-log 已记部署标记）→ 切片 D 实体/结构/技术检查** | Claude |
