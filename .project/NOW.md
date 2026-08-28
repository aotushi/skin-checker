# NOW · skin-checker 当前状态

**最后更新:** 2026-08-28(**W6 🟡 切片 B 基线 run 3 三平台 57/57 完成=三轮零供给基线收官,切片 B 收口**——run 1+2+3 共 171 条(records.csv 172 行),五页始终未部署=严格零供给对照;⭐ r3 核心:①**E2 实体空位三平台收敛**——ChatGPT/Gemini 归属第三同名 iOS App、Perplexity 原文裁定「都不是拍脸测肤」=「SKINLENS 肤质分析工具」市面不存在被三平台各自确认,同名场增员(Solion Labs 成分扫描器)=先发窗口在变挤;②**U4 置信度肤质领域零供给三平台确认**=「方法与置信度」页入池概率全站最高,U2 Baumann 混淆三平台一致=四维消歧空位三重确认;③隐私叙事三轮三级跳至制度化(逐工具标配字段/检测完即销毁/收尾推荐轴)=「即删+仅本地」确定性最高卖点;④**Gemini 医疗横幅「确定性分类器」被 r3 打破**(U3/A4 失守)=平台行为版本性漂移;⑤数字占位双面实证(95% 被复述 vs 90%+ 被解构)=以「诚实边界+置信度」差异化。**「基线阶段小结(run 1–3)」已入 experiment-log(入池优先级/稳定卖点/消歧策略/波动警示/管线资产)。切片 C 五页同日部署上线(用户确认闸门后执行):datePublished 校准 08-28 → build 8 页 → `wrangler pages deploy` 直传 skin-checker-doc(d2e7922b;坑:env 里受限 CLOUDFLARE_API_TOKEN 403,`env -u` 回落 OAuth 成功),`doc.skin.9shi.cc` 五页+sitemap 全 200 线上验证——零供给对照期结束,归因窗口起算。当前=切片 D 实体/结构/技术检查**。详见 `tasks/W6-geo-ai-search-experiment.md` + `geo/experiment-log.md`「基线 run 3」+「基线阶段小结」章)

**前次状态(2026-07-14):** **W5 🟢 切片 A–E 全部上线**:FC 后端真 key 全通(公网域名 `https://skin-checker-egkggmemue.cn-hangzhou.fcapp.run`),大陆链路 **FC ~4s vs Workers ~35s(~9 倍)**;H5 + 双 APK 生产已切 FC 并全部发布(flutter/uniapp 新包均已传 Release v0.1.0);**切片 E 安全加固(`/analyze` per-IP 限流 + CORS 白名单)双链路生效**——Workers 部署验证 + FC 用户传 ZIP 后线上限流实测 10×400→2×429;⚠️ 发现 FC 网关对无 ACAO 响应兜底回显 Origin(CORS 在 FC 域名被网关放宽,该链路防线=限流,见 W5 切片 E);落地页架构文案已随 W5 更新重部署;剩用户真机真脸自测 + FC 实例数封顶/告警(用户侧),详见 `tasks/W5-server-fc-migration.md` / ADR 0010。

## 📋 新任务

### W6 · SKINLENS GEO / AI Search 最小可行实验

- **文件:** [`tasks/W6-geo-ai-search-experiment.md`](tasks/W6-geo-ai-search-experiment.md)
- **状态:** 🟡 进行中(切片 A ✅;切片 B **✅ 收官**——**run 1(08-26)+ run 2(08-27)+ run 3(08-28)三平台各 19/19 = 171 条记录,三轮零供给对照基线成立;**切片 C 五页已部署上线(08-28 用户确认闸门后执行,`doc.skin.9shi.cc` 五页 200+sitemap 收录,零供给对照期结束)**;当前=切片 D**。**r3 增量:** E2 实体空位三平台收敛(CG/GM 归属第三同名 iOS App、P 原文裁定「都不是拍脸测肤」)+同名场增员(Solion Labs)、U4 置信度领域零供给三平台确认、U2 Baumann 混淆三平台一致=四维消歧空位、隐私叙事制度化、Gemini 医疗横幅确定性分类器被打破(U3/A4 失守)、基线阶段小结已入 experiment-log(详见「基线 run 3」+「基线阶段小结」章)。**r2 增量:** ChatGPT E2 主动点名「网页版/微信小程序」空位、Perplexity E2 孪生 App 掉出解析池+口碑真空确认、Gemini E1 医疗术语垄断/E2 孪生入参数记忆、U2 定义权窗口关闭中、隐私最小化成跨平台排序权重(详见 experiment-log「基线 run 2」章)。**run 1 基线:**⭐ 核心发现:**E 组品牌零点三平台确认**——同名场扩大到 4 实体:「皮肤镜」医疗术语 / skin-lens.com FDA 皮肤镜硬件(Perplexity 精确域名匹配首选)/ App Store 成分扫描器 / **「SkinLens: AI Skin Analysis」拍照测肤孪生 App**(同名同功能,上架不久=先发窗口仍在);但 Perplexity 会在答案内主动列多义项消歧=实体页有接收方,且措辞决定解析(「肤质分析工具」→App 场)→ **切片 C/D 核心=实体消歧**;U2 四维词汇=无主公共框架(定义权先占);引用枢纽=CCTV/丁香医生/药监局系/Mayo zh;M 组单源垄断(zhihu 贴/台湾博客)=低进入门槛;U4 Azure 同构阈值+重拍设计、PMC 层=**不发布准确率数字红线互证**;T4/T5「网页版+手机拍照」双词槽弱占据=我方精准缺口;A4 色沉大陆权威真空。**切片 C 五页写完并落地 Astro(2026-08-26,仅本地未部署,发布闸门=run 3+用户确认)**:规划稿 `geo/content-plan.md` → 草稿 `geo/drafts/` → `landing/` Article 布局+`/zh/` 五页(photo-guide/skin-dimensions/how-it-works/confidence-and-privacy/skincare-by-result),build 8 页全过+sitemap 收录+逐页元数据/Article JSON-LD+移动端无溢出+首页回归原样;UI 一致性核查通过(2026-08-26,五页截图比对首页基准,修移动端文章导航过挤——Article.astro 照搬 Nav 规则 ≤720px 隐藏 CTA)。⚠️ Gemini 两起误建普通对话在用户历史待处理(T2/M3);**Perplexity 19 条留存用户 Sessions(无隐身模式,已披露)**。过程与发现:`.project/geo/experiment-log.md`;逐条数据:`.project/geo/baseline/`)
- **优先级:** P1(本项目内,不改变上层求职冲刺排序)
- **范围:** 以 SKINLENS 为实验对象,建立 Query 基线、竞品/Citation 分析、约 5 个静态内容页、实体与技术优化、同条件复测及简历案例;SEO 分析项目仅作为可选辅助工具。
- **边界:** 第一轮不重写 H5/双端核心流程,不公开用户报告,不扩展具体品牌推荐,不做远程数据库变更。

## 部署(2026-07-09,用户同意远程操作后执行)

- **架构**:H5 与 API 同域 `skin.9shi.cc` —— Pages 服务页面,worker 只接 `/api/*` 路由(`index.ts` 挂 `basePath('/api')`,本地 dev 同为 `/api/*`);生产 H5 同域免 CORS。
- **worker**:`wrangler deploy` 已上(版本 6a897396),路由 `skin.9shi.cc/api/*`;`QWEN_API_KEY` 已 `wrangler secret put`;远程 D1 已建(id 见 wrangler.jsonc)+ 迁移 0001 已应用;R2 `skin-checker-img` 已建 + 1 天生命周期兜底删图。
- **Pages**:项目 `skin-checker`(production branch master),H5 产物直传部署,`skin-checker.pages.dev` 已 200。
- **域名已生效(2026-07-10)**:用户已在 dashboard 绑 `skin.9shi.cc` → `https://skin.9shi.cc` = H5、`/api/*` = worker,线上可用。如需 git 自动部署,可在 dashboard 把仓库连到既有 worker/Pages 项目(`[Skip CI]` 前缀会跳过自动构建,注意)。
- **🐛 H5 线上 3 项 UI 问题(2026-07-10 实测,同日已修,本地已验证)**:① 预览不显示(`height:100%` 在不定高 flex 链塌 0 高 → 改绝对定位铺满);②③ 拍照页 / 我的页矮视口滚动条(`100vh→100dvh` 双声明 + 取景区/空态可收缩)。仅动 3 文件 CSS;**已部署并线上验证生效(2026-07-13,用户 push 触发 CF 构建)**:线上样式命中三项修复特征(`.viewer__img` absolute / `.cap` 与 `uni-page-body` 100dvh),实测拍照页 375×550 无滚动、我的页 812 高无滚动、相册选图预览 331×508 正常渲染;我的页小屏(<696 可见高)空态残余滚动为已知项维持。详见 `tasks/W2` 「🐛 已知问题」各 ✅ 小节。
- **uniapp APK 已出包(2026-07-13;2026-07-14 随 W5 切 FC 重出并重传)**:用户 HBuilderX 云打包(14.95MB,测试证书);当前 Release v0.1.0 asset `skinlens-uniapp-v0.1.0-android.apk` = FC 后端版(SHA-1 `f5334d6e0001d4eae5344b77de74d78c84212017`,解包实证运行值 = FC 域名;注意云打包多次出包字节数相同、须按 SHA-1 区分)。**剩用户侧:装机自测拍照全流程**。小程序真机延后(届时后台配 uploadFile 合法域名 `skin.9shi.cc`)。
- **落地页(W4,2026-07-13)**:`landing/`(Astro 双语)→ Pages 项目 `skin-checker-doc`(产物直传,`skin-checker-doc.pages.dev` 已 200,根 301→/zh/);**双 APK 走 GitHub Release v0.1.0**(`releases/latest` 固定链,flutter 47.7MB + uniapp 14.95MB,SHA-1 均 in notes);下载三卡全启用(uniapp 第三卡 2026-07-13 出包后同日启用并重部署,线上抽查生效);**技术区架构文案已随 W5 更新为双云部署现状并重部署(2026-07-14,线上抽查生效)**;**`doc.skin.9shi.cc` 绑域已生效(2026-08-25 curl 确认:根 301→/zh/、/zh/ 200、标题正常)**。详见 `tasks/W4-landing-page.md`。

## 阶段

🟢 **W5 server 迁阿里云 FC(2026-07-14 启动,同日三切片全部上线):** 起因 = 大陆用户 `/analyze` 过长(CF 美西 PoP + 原图直传);方案 = server 加 FC(Web 函数,cn-hangzhou)为第二部署目标,Workers 保留(否决香港中转)。**切片 A 代码映射**:业务收敛 `src/app.ts`(`createApp` 工厂),平台差异进 `src/platform.ts`(`PlatformDeps`:图片暂存 / 历史 / 密钥),双入口 `index.ts`(Workers:R2+D1+secret)/ `index.fc.ts`(FC:`@hono/node-server` :9000、图片内存直读不落存储、历史 no-op V2 预留、key 走 FC 环境变量);`pnpm build:fc` esbuild 单文件。**切片 B FC 部署联调**:ZIP 上线 + 触发器改无需认证 + `QWEN_API_KEY` 配置(用户)后线上全通(mock 200 全链 + 真 key 422),公网域名 `https://skin-checker-egkggmemue.cn-hangzhou.fcapp.run`;**大陆链路实测 FC ~4s vs Workers ~35s(同图 2MB 真调,~9 倍提升)**。**切片 C H5 切换**:生产 `API_BASE` `#ifdef H5` 切 FC 域名,本地全验后部署 Pages,生产域名 `skin.9shi.cc` 验证生效(api chunk 运行值 = FC 域名)。**切片 D APK 双端切 FC(同日,用户指示)**:uniapp `#ifdef H5 || APP-PLUS` + flutter release URL 换 FC(App 原生请求不受 ICP/合法域名限制;小程序产物实证不受影响仍走 Workers);flutter 重出包 47.7MB(SHA-1 `2e8cbff5…`,libapp.so 实证仅含 FC URL)已传 Release 校验一致;**uniapp 新包(用户云打包,SHA-1 `f5334d6e…`,解包实证运行值 = FC)也已传 Release + notes 更新 + 回拉校验一致(2026-07-14),切片 D 收官**。**切片 E 安全加固(同日,用户指示「不带 token」)**:`app.ts` 共享层 `/analyze` per-IP 限流(10 次/分,429 走既有 `{error}` 前端零改;Workers 取 CF-Connecting-IP、FC 取 XFF 末跳防伪造)+ CORS 白名单收紧(`skin.9shi.cc` + 本地 dev;原生请求无 Origin 不受误伤);mock FC + wrangler dev 双跑全验(带图 200 回归 / CORS 三组 / 12 连打 10×400→2×429 / 伪造首跳不可绕),**Workers 部署生效(c09a5f36,线上验证过)+ FC 用户传 ZIP 后线上限流实测生效(12 连打 10×400→2×429),切片 E 双链路收官**;⚠️ 发现 **FC 网关对无 ACAO 响应兜底回显 Origin**(大写头=网关注入/小写=hono;CORS 白名单在 FC 域名被网关放宽,该链路浏览器防线失效可接受——防线=限流,Workers 链路 CORS 完整生效,不改代码,详见 W5 切片 E)。**✅ FC 实例封顶 + 费用告警已配(2026-08-25,W6 前置,Chrome 代操作)**:函数配额封顶 2 实例;账户级费用预算「月度费用护栏」¥20/月(60%/100% 双阈值,覆盖 FC+百炼,详见切片 E 尾注);**剩:用户真机真脸自测(补 200 路径,预期 ~35s→~5s)**;前端压图(H5 原图直传)为另一大头独立切片。详见 `tasks/W5-server-fc-migration.md` + `docs/adr/0010`。

🟢 **W4 落地页完成(2026-07-13):** `landing/` Astro 5 双语静态站(/zh/ 默认 + /en/,根 CDN 级 301;文案单一来源 `src/i18n/zh.ts` + `Strings` 类型对齐 en)—— Nav/双机位 Hero(线上真截)/功能 2×2/三步/下载三卡(H5 + flutter APK→`releases/latest` + uniapp「即将提供」)/架构图 + 工程 6 点/合规双卡/Footer;SEO 全套(canonical/hreflang x-default→zh/OG 1200×630/JSON-LD/sitemap/robots),素材全可再生(og-src.html 定格截图)。验证:build 3 页 + Playwright 四组视口目检 + 链接断言(修 hero 网格出血 7px 溢出 → `overflow-x: clip`);线上 pages.dev 全路径 200。GitHub Release v0.1.0(tag@7632e60)挂 `skinlens-flutter-v0.1.0-android.apk`,`releases/latest` 302 实测。详见 `tasks/W4-landing-page.md`。

🟢 **W3 前端完成(app-flutter,切片 A–H 全 ✅ + 用户真机复测通过 2026-07-13):** 环境 = Flutter **3.44.6 stable / Dart 3.12.2**(`E:\dev\flutter`;PUB_CACHE 迁 `E:\dev\pub-cache` + flutter-io.cn 双镜像,详见 W3 文档切片 A);`app-flutter` 只锁 Android(`com.aotushi.skin_checker`)。**切片 B 生成线**:`tool/gen.mjs` 一键出契约模型 + 65 token 常量(产物 format 幂等);Fraunces variable ttf 进 assets。**切片 C 四页 UI + 导航(2026-07-10)**:首页/拍照/结果卡/我的全落地(文案逐字平移 app-uni),自绘双 tab 根级 + 拍照/结果全屏二级页;四维双极光谱 + 敏感「参考」虚线态 + 科普手风琴 + 三弹层齐;共用件 Press/SknShell(600 限宽)/SknCard/DashedOutline;**flutter web 冒烟全页通过**(web/ 目录不入库;canvas 语义树用 `flt-semantics-placeholder` 激活,坑已记 W3 文档),format/analyze 双绿。**切片 D `/analyze` 真联调(2026-07-10)**:`utils/api.dart`(kDebugMode 双环境 + envelope 解析 + ApiException)+ capture_page 接 image_picker 真传图,web 冒烟三用例全通(mock 200 → 结果页渲染 / 真 key 422 not_face → SnackBar 指引留页 / 断服 → 网络异常 SnackBar);修 multipart contentType 坑(octet-stream 被 400,http_parser 显式 `image/*`),workerd 端口残留坑已记 W3 文档。**切片 E 本地历史(2026-07-10)**:`utils/history.dart`(shared_preferences,KEY `skn_history`/MAX 20/新→旧序平移 uni history.ts)+ ResultPage 真保存(沿用 server id/createdAt + 防重)+ MinePage 历史列表回看(RouteObserver.didPopNext ≈ uni onShow,回看态隐藏保存钮),web 冒烟保存→列表→回看→刷新持久化全通。**切片 F 合规文案核对(2026-07-10)**:免责落点符合 ADR 0008(inline 完整声明两端均只在结果页一处,「我的」完整声明入口保留,首页短句为 uni 定稿轻量提示逐字平移),flutter 全量中文文案抽取对照 app-uni 零出入无新造,违禁词扫描全为否定式声明文案;顺带修根 README 合规段旧规则(「结果页+启动页」→「收敛结果页一处」),app 代码零改动。**切片 G 出包(2026-07-13)**:`app-release.apk`(debug 签名,release API 指线上);本机 gradle loopback 坑(AF_UNIX connect 系统性 EINVAL → `JAVA_TOOL_OPTIONS=-Djdk.net.unixdomain.tmpdir=<不存在目录>` 强制回退 TCP)已入档。**切片 H 装机反馈改造(2026-07-13)**:用户首次装机两反馈(取景框靠顶偏小 / 无实时画面)一次解决 —— `camera ^0.12.0+1` 页面内实时取景 + 「拍照」直拍进原确认态(前置优先,初始化/拍摄失败全链静默降级 image_picker 系统相机 = uni 原体验;**flutter 独有扩展,uni APK 侧无此能力**,双端差异入档)+ `_FaceGuide` 随取景区放大居中(高度预算含文案行高防极矮溢出);web 冒烟(面板 block camera = 天然降级用例)语义全在、零 overflow;APK 重出 **47.7MB**;剩装机复测(真机在用户侧)。详见 `tasks/W3-frontend-app-flutter.md`。

🟡 **W2 前端起步(app-uni,H5 优先):** uniapp(Vue3 vite-ts)骨架 + 设计 token/类型两条生成脚本(`pnpm gen:tokens` / `gen:types`,产物禁手改)。**已建成四页 + 底部 tab 并 H5 验证通过**:首页(品牌 + 人脸拓扑网格取景意象[MediaPipe canonical 468 点投影程序生成 + 扫描光带]+ 双 CTA)、拍照页(深色相机 + 取景/拍摄要求 + `uni.chooseImage` + 分析中蒙层)、结果卡(四维双极光谱含敏感「参考」态 + 逐维度科普展开 + 分区评估 + 护理建议 + 免责声明 + 「保存报告」写本地历史)、我的(游客态 + 我的检测本地历史列表 + 免责/隐私/关于底部弹层完整声明入口)。自绘暖调底部 tab(检测 / 我的,CSS 图标走 token,`components/tab-bar`)统领导航:首页 ↔ 我的为 tab 根级(`reLaunch` 切换),拍照 / 结果为全屏二级页(navigateTo/redirectTo,不挂 tab);Fraunces 数字体 + 暖调美妆 token 全生效;`vue-tsc` 类型检查过。微信小程序端已过编译层(补 `loadFontFace`、变量本就落 `page`、`build:mp-weixin` 通过 + 产物双证),真机视觉待微信开发者工具确认(本环境无)。**已与本地 server 联调通(切片 E)**:拍照页真传图 → `/analyze` → 结果卡渲染 server envelope、「保存报告」沿用 server id(Playwright 真传图 E2E + 断服失败路径均验证)。

🟢 **W1 后端主链路全通(含真实 VL 调用,2026-07-09 切片 D 完成):** `/analyze`(R2 临时图 → 千问 VL 真调 → 四维派生 code/名 → 契约校验 → D1 落库 → 用后删图)+ `/history` 端到端验证过(纯本地不碰远程);16 型手册映射已接入、CORS 已挂。真调配置:用户 MaaS 专属端点 `/compatible-mode/v1` + `qwen3-vl-plus`(key 有模型级限制,需控制台放行;`qwen3.7-max` 纯文本不吃图),真图实测 200(~3.7s,D-R-F-N 干皮、敏感维置信 0.3 如约偏低);空 key 仍走 mock。W1 两条验收达成。**切片 E 输入质检完成(2026-07-10)**:同一次 VL 调用前置 gate(非人脸/翻拍/太远/低质),不合格 `/analyze` 返 422 + `{error: 重拍指引}`(fail-open、拒绝不落库、前端零改动);名人/著名图片会被模型自我审查拒为 not_face(接受,真实用户拍自己不受影响),详见 `tasks/W1` 切片 E 落地小节。

## 下一步

**前端(W3 flutter,进行中):**
- ✅ 切片 A 脚手架(2026-07-10):SDK 3.44.6 装 `E:\dev\flutter` + `app-flutter` 建成,analyze/format 双过;环境坑(PUB_CACHE / 镜像 / bat 路径)已记 W3 文档。
- ✅ 切片 B 生成线(2026-07-10):`node tool/gen.mjs` 一键 quicktype 契约模型 + DTCG token → Dart 常量(产物自动 format 幂等);Fraunces variable ttf(google/fonts 原件)进 assets。
- ✅ 切片 C 四页 UI + 导航(2026-07-10):四页 + 双 tab + 二级页导航全落地,web 冒烟全页通过(交互/文案/低置信「参考」态/弹层/返回栈全对齐 app-uni),a11y 双重朗读已修;详见 W3 文档切片 C。
- ✅ 切片 D `/analyze` 联调(2026-07-10):image_picker 真传图 + envelope 进结果页,mock 200 / 真 key 422 指引 / 断服三用例 web 冒烟全通;contentType(http_parser)与 workerd 端口残留两坑已记 W3 文档切片 D。
- ✅ 切片 E 本地历史(2026-07-10):`utils/history.dart`(shared_preferences,KEY/MAX 20/新→旧序平移 uni history.ts)+「保存报告」真写(沿用 server id/createdAt + 防重)+「我的」列表回看(RouteObserver.didPopNext ≈ uni onShow,回看隐藏保存钮);web 冒烟保存→列表→回看→刷新持久化全通;详见 W3 文档切片 E。
- ✅ 切片 F 合规文案核对(2026-07-10):免责落点符合 ADR 0008、全量中文文案对照 app-uni 零出入无新造、违禁词扫描通过;修根 README 合规段旧规则;app 代码零改动;详见 W3 文档切片 F。
- ✅ 切片 G 出包(2026-07-13):`app-flutter/build/app/outputs/flutter-apk/app-release.apk`(debug 签名,上架再议);Android Studio(D 盘)+ JBR 21 环境与 gradle loopback 坑(AF_UNIX EINVAL → JAVA_TOOL_OPTIONS 回退 TCP)已入档 W3 文档切片 G。
- ✅ 切片 H 装机反馈改造(2026-07-13):camera 插件页面内实时取景直拍(失败全链降级 image_picker;flutter 独有,uni 侧无)+ 取景框放大居中;web 冒烟通过,APK 重出 47.7MB;详见 W3 文档切片 H。
- ✅ 装机复测通过(2026-07-13):补 release 包 `INTERNET` 权限(flutter 模板坑,详见 W3 切片 H)后,用户真机确认 APK 可用、实时取景直拍 + 分析全流程 OK。**W3 收官**。

**前端(W2 续):**
- ✅ **H5 线上 3 项 UI 修复已部署 + 线上验证生效(2026-07-13)**:预览 0 高改绝对定位、100vh 滚动条改 dvh 双声明(B1–B3 详见 `tasks/W2` 已知问题 ✅ 小节);线上实测三项全过(CSS 特征 + 矮视口行为 + 相册选图预览渲染)。用户真机复验可选;我的页小屏(<696)空态残余滚动为已知项,真机仍碍眼再压余量。
- ✅ app-uni 四页静态端 + 底部 tab 完成(首页/拍照/结果卡/我的),H5 导航闭环通、免责声明双入口可达、结果卡→本地历史(uni Storage)→「我的」回看闭环通。
- 🟡 微信小程序端代码 + 编译层已过一遍(审计无逻辑属性 / CSS 变量本就落 `page` / 补 `uni.loadFontFace` 静默降级 / `build:mp-weixin` 编译通过 + 产物双证);**待真机**:`mp-weixin.appid` 空(测试号可预览,发布填自有)+ woff2 字体配 `downloadFile` 合法域名,渲染 / Fraunces 效果需微信开发者工具确认(本环境无)。
- ✅ 与 server `/analyze` 联调通(2026-07-08,切片 E):`utils/api.ts` 传图 → envelope 暂存直达结果卡,保存沿用 server id;本地 server 起 8890(`pnpm dev --port 8890`,8787/8788 被他项目占)。
- 📋 结果页分享(2026-07-08 审计,**未排期**,详见 `tasks/W2` 切片 G):16 型标签内容天然适合分享,但前提 = 联调完成 + 有公开可达端;切法 P1 小程序转发卡片 + H5 兜底(排联调后)→ P2 canvas 海报(缓)→ V2 链接分享(需公开 report 端点,不做现在);免责须延伸到分享物、海报不含人脸。
- 🆕 uniapp App(APK)目标(2026-07-08 决,ADR 0009):手机 / 平板装机,与 flutter APK 并存双栈;平板用 CSS max-width 容器限宽居中(不走 rpx:`maxWidth` 仅 H5、rpx 封顶字段 Vue3 App 存疑)。限宽容器已落地(定值 600px,`App.vue` 全局 `.skn-shell` + 四页 / tab / 弹层套用,拍照页深色底全屏、内容居中)、App 端 Fraunces 字体已接(`loadFontFace` 条件编译放宽到 `APP-PLUS || MP-WEIXIN`,`uni build -p app` 编译通过 + 产物含字体调用);✅ 云打包配置就绪(2026-07-13):manifest 补 `modules.Camera`(App 端 chooseImage 原生依赖,原空 `{}` 出包必挂)+ 应用名「肤镜」+ API_BASE 复核(App build 走线上完整 URL);✅ 出包完成(2026-07-13,用户 HBuilderX 云打包,14.95MB)并上传 Release v0.1.0 + 落地页第三卡启用,装机自测留用户(见上「部署」段)。

**后端(W5 FC 迁移,三切片全部上线 2026-07-14):**
- ✅ 切片 A 平台适配层:`platform.ts` + `app.ts` 工厂 + 双入口 + `build:fc`/`start:fc`;`tsc` 全绿;本地 FC mock 200 全链 / 真 key 422 / Workers 回归通过;ADR 0010。
- ✅ 切片 B FC 部署联调:ZIP 上线(WebIDE 验证 = esbuild 产物)→ 触发器改无需认证(签名认证在网关挡匿名请求,实测 400)→ mock 冒烟全过 → `QWEN_API_KEY` 配置(用户)→ 真 key 422 验证。公网域名 **`https://skin-checker-egkggmemue.cn-hangzhou.fcapp.run`**;耗时对比(同一张 2MB 图真调):**FC ~4s vs Workers ~35s,~9 倍提升**(Workers 慢在大陆→美西上传 + R2 中转 + 跨洋调百炼)。真人脸 200 留前端切换后真机验证。
- ✅ 切片 C 前端切换(2026-07-14):H5 生产 `API_BASE` 已切 FC 域名(`api.ts` `#ifdef H5` 赋值覆盖式条件编译);本地全验(vue-tsc / H5·mp-weixin 双端产物 grep / 浏览器跨域端到端 canvas 图真调 422 + CORS 全通)后,用户同意执行 `wrangler pages deploy dist/build/h5` 部署 Pages,生产域名 `skin.9shi.cc` 验证生效(index.html 主入口 = 新构建,api chunk 线上运行值 = FC 域名;首拉曾撞 CDN 旧缓存数秒)。**剩用户真机真脸自测(补 200 路径,预期 ~35s→~5s)**。
- ✅ 切片 D APK 双端切 FC(2026-07-14,用户指示,推翻 C 的「App 暂不切」):uniapp `#ifdef H5 || APP-PLUS`(App 产物运行值实证 = FC;小程序产物仅含 `skin.9shi.cc` 不受影响——fcapp.run 无 ICP 进不了合法域名)+ flutter `api.dart` release URL 换 FC;flutter format/analyze 双绿 + `flutter build apk --release` 重出包 **47.7MB**(SHA-1 `2e8cbff5625728e9408039158fbb489e8b9ceaba`,APK 内 libapp.so 实证仅含 FC URL)。flutter 新包已上传 Release v0.1.0(同名替换,`releases/latest` 回拉 SHA-1 校验一致,notes 已更新);**uniapp 新包也已上传(2026-07-14,用户云打包 SHA-1 `f5334d6e…`,解包实证运行值 = FC,同名替换回拉校验一致)——切片 D 收官**;已装旧包用户仍走 Workers,双入口长期并存。
- ✅ 切片 E 安全加固(2026-07-14,用户指示「不带 token」,双链路收官):`app.ts` 共享层 —— `/analyze` per-IP 限流 10 次/分(实例级内存 Map,429 走既有 `{error}` 两端前端零改;IP 取法防伪造:Workers=CF-Connecting-IP、FC=XFF 末跳)+ CORS 收紧为白名单(`skin.9shi.cc` + 本地 dev;小程序/App/脚本无 Origin 不经此层不误伤)。本地 mock FC + wrangler dev 双跑全验(带图 200 / CORS 三组 / 10×400→2×429 / 首跳轮换伪造不可绕 / 换末跳独立桶)。**Workers 部署生效(2026-07-14,c09a5f36,线上验证:白名单回显 / evil 无 ACAO / 空 POST 400;部署后数十秒混版传播窗口,复测确认);FC 用户传 ZIP 后线上限流实测生效(12 连打空 POST 10×400→2×429,零成本验证)**。⚠️ **FC 网关 CORS 兜底回显**:函数响应无 ACAO 时网关自动回显请求 Origin(大写头=网关/小写=hono)→ CORS 白名单在 FC 域名被放宽,该链路防线=限流(可接受,不改代码);Workers 链路 CORS 完整生效。✅ 配套加固已配(2026-08-25,用户授权 Chrome 代操作):FC 函数 skin-checker 弹性配置「函数配额」封顶 **2 实例**;账户级**费用预算「月度费用护栏」**(费用预算,全部范围含百炼,月滚动 ¥20/预算总额 340,2026-08~2027-12;本期实际值 60%/100% 双阈值 → 邮件+短信+站内信,接收人已验证联系人;创建时附带完成 AliyunConsumeNotificationRole 授权;首次预算 T+2 天才显示实际值)。云监控调用量告警未配——费用维度已由预算兜底,按量告警需要时再加。
- ⏳ 用户侧:开通 SLS 后在函数「日志」配置启用日志监控(否则线上盲调)。
- 📋 前端 canvas 压图(H5 `sizeType:['compressed']` 不生效,原图 3-10MB 直传,为耗时最大头)独立切片待排。

**后端(W1 收尾,自然暂停点):**
- ✅ 切片 D 完成(2026-07-09):真实千问 VL 调用通(`src/qwen.ts`,用户 MaaS 专属端点 `/compatible-mode/v1` + `qwen3-vl-plus`,base64 传图 + prompt 约束 + 宽松解析 + validateReport 后校验;空 key 仍 mock)。真图实测 `/analyze` 200 → 落库 → 删图 → `/history` 读回。远程部署时 key 用 `wrangler secret` 配。详见 `tasks/W1-backend-pipeline.md`。
- ✅ 切片 E 输入质检完成(2026-07-10,起因:线上非人脸照仍出报告):`qwen.ts` gate 前置判定 + `extractGate` fail-open,`index.ts` 不合格返 422 + `{error: 指引}`,拒绝不落库、前端零改、契约未动;本地验证 mock 回归 / 非人脸 422 / too_far 422 / 特写 200 / H5 端到端全通(详见 `tasks/W1` 切片 E)。**已提交推送(2026-07-10,commit 9f23446,git 连仓自动部署 worker)**。

## 关键决策(指针)

- 契约共享:JSON Schema 单一真相源 → `docs/adr/0001-…`
- 只锁三端 → `docs/adr/0002-…`
- 图片用后即删 → `docs/adr/0003-…`
- 工具链(**app-uni 用 uni CLI;Vite+ 收窄到 server;2026-07-06 修订**)→ `docs/adr/0004-…`
- 前端样式 / a11y → `docs/adr/0005-…`
- 16 型四维 → `docs/adr/0006-…`
- 设计 token SSOT(DTCG;app-uni 用自写 gen 脚本)→ `docs/adr/0007-…`
- 免责声明单处收敛 → `docs/adr/0008-…`
- uniapp 也出 App(APK)+ 平板限宽 → `docs/adr/0009-…`
- server 双部署目标(Workers + 阿里云 FC)→ `docs/adr/0010-…`

## 备注

项目3 为**非冲刺项**(当前优先级为 P0 就业冲刺包)。可随时暂停;前端两端可见成品优先于后端补测(经确认 MVP 靠已验证手动 E2E 兜底)。

**代码托管:** 公开仓库 <https://github.com/aotushi/skin-checker>(2026-07-09 建仓并推送 master;提交信息沿用 `[Skip CI]` 前缀惯例,推前本地测试 + 征得同意)。本地 dev server 配置在父目录 `E:\code\github\.claude\launch.json`(`skin-server` port 8890;`skin-landing` port 4321)。
