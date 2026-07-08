<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W2 · 前端 app-uni(uniapp → H5 / 微信小程序 / App(APK))

**最后更新**: 2026-07-08

> 目标:uniapp 端把已验证的 mock 后端契约落成可见成品,H5 优先、微信小程序随后。求职展示核心是「能跑的 demo」,故先做前端两端可见成品,后端正式回归测试后置(见 `W1-backend-pipeline.md` 注)。

## 📝 变更历史

| 日期 | 变更内容 | 修改人 |
|------|---------|--------|
| 2026-07-06 | 建 W2 文档;app-uni 骨架 + token/类型生成脚本 + 结果卡页 H5 验证通过 | Claude |
| 2026-07-06 | 建首页 + 拍照页并 H5 验证;三页导航闭环;结果卡按钮绑跳转 | Claude |
| 2026-07-07 | 建「我的」页(游客态 + 历史占位 + 免责/隐私/关于底部弹层完整声明入口);首页加右上「我的」入口;注册路由;H5 验证 | Claude |
| 2026-07-07 | 加自绘暖调底部 tab(检测/我的),导航改根级 reLaunch;拍照/结果保持全屏无 tab;移除首页右上 pill;H5 验证 | Claude |
| 2026-07-08 | 结果卡加逐维度科普展开(每维「?」手风琴 + tint 浅底,落地 ADR 0006「科普页逐维度讲解」意图、激活闲置 tint token);H5 验证四维 tint 命中、`vue-tsc` 过 | Claude |
| 2026-07-08 | 本地历史闭环(`utils/history.ts`,uni Storage):结果卡「保存报告」真写设备本地 + 已保存态防重、「我的」历史有数据态列表(型号码/名/时间,点击回看)、结果卡 `?id=` 回看态隐藏保存按钮;契合「本地保存」承诺,后端 D1 `/history` 留给 V2 登录;H5 验证全链路、`vue-tsc` 过 | Claude |
| 2026-07-08 | 微信小程序端过一遍(代码 + 编译层):补 `uni.loadFontFace`(`#ifdef MP-WEIXIN`、`global:true`、静默降级)、审计确认 src 无逻辑属性、CSS 变量本就 `:root,page` 双挂;`build:mp-weixin` 编译通过 + 产物双证(wxss 变量落 page / app.js 含 loadFontFace)、`vue-tsc` 过。appid 空 / 字体域名 / 真机视觉留用户微信开发者工具验 | Claude |
| 2026-07-08 | 决策:uniapp 也出 App(APK)手机/平板装机(与 flutter APK 并存双栈,ADR 0009);平板审查官方宽屏指南后定「CSS max-width 容器限宽居中」(不选 rpx:`maxWidth` 配置仅 H5、rpx 封顶字段 Vue3 App 存疑)。**仅文档**:新增 ADR 0009,改 0002 / 需求 4.6 / README / CLAUDE / NOW;代码(限宽容器 / appid / HBuilderX 出包)待实现,见切片 F | Claude |
| 2026-07-08 | 平板限宽定值 **600px**(13″ iPad 逻辑宽 1024pt、480 偏窄、中文舒适行宽 600–700)并**落地实现**:`App.vue` 全局 `.skn-shell` 限宽类,首页 / 结果 / 我的 + 底部 tab + 弹层套用,拍照页深色底全屏 + `.cap__inner` 内容居中;文档 480→600 同步(ADR 0009 / 需求 4.6 / CLAUDE / 本档切片 F)。H5 平板宽验证居中 + 背景无缝 | Claude |
| 2026-07-08 | App 端 Fraunces 字体补齐:`App.vue` 的 `loadFontFace` 条件编译分支 `#ifdef MP-WEIXIN` → `#ifdef APP-PLUS || MP-WEIXIN`(H5 仍走 index.html link)。`uni build -p app` 编译通过,产物 `app-service.js` 含 `loadFontFace({global:!0,family:"Fraunces"…})`;App 真机字体渲染留用户(同小程序) | Claude |
| 2026-07-08 | 结果页补返回入口(`navigationStyle: custom` 无原生返回):顶部自绘返回按钮 → `navigateBack`,栈内无上一页(H5 刷新 / 深链直达)兜底 `reLaunch` 回首页。H5 验证按钮渲染 + 定位左上、`vue-tsc` 过 | Claude |
| 2026-07-08 | 修返回按钮箭头不居中:`‹` 字形墨水随字体基线偏移且三端字体不一致,改 CSS 画箭头(两边框转 45° + `translateX` 光学补偿,同 tab-bar CSS 图标做法)。H5 DOM 量测垂直 0 偏差、水平亚像素;`vue-tsc` 过 | Claude |
| 2026-07-08 | 首页取景意象换人脸拓扑网格:原 4 色点(位置=分区、颜色=四维,无图例不可解 + 语义冲突 + 与「16 型四维」feat 重复)→ 经两轮否稿(14 节点稀疏网格 / 手绘五官线稿,脸型不真)→ 定稿 **MediaPipe canonical face model 正交投影**:`scripts/gen-face-mesh.py` 程序生成(官方 468 点 + 898 三角,外轮廓校验与官方 FACE_OVAL 索引吻合;数据 Apache-2.0 © Google,缓存 `scripts/data/` 供离线重跑)→ `static/face-scan.svg`(取景角标 + 拓扑网格 + gold 特征点 ×10)叠 CSS 扫描光带(`prefers-reduced-motion` 关)。三端走 `<image>`(小程序不支持 inline svg);token 色写在脚本内,改 token 需重跑。H5 验证 `imgComplete` / 光带动画在跑 / 零控制台错误;小程序 · App 真机渲染留用户 | Claude |
| 2026-07-08 | 审计「结果页分享」想法并记为切片 G(**未排期,仅文档**):方向成立(16 型四维是人格测试式标签内容,自带传播属性),但兑现前提 = 切片 E 联调完成 + 有公开可达端;切法 P1 小程序转发卡片 + H5 兜底(~半天,排切片 E 后)→ P2 canvas 海报(贵,缓)→ V2 链接式分享(需后端公开 report 端点,不做现在);合规免责须延伸到分享物、海报不含人脸 | Claude |
| 2026-07-08 | 切片 E 联调通:新增 `utils/api.ts`(`uni.uploadFile` → `POST /analyze`,envelope 模块级暂存单次取用传结果页),拍照页 `analyze()` 去 mock 定时器改真传图(失败 toast 留本页可重试、`finally` 收蒙层),结果页 `?from=analysis` 取暂存渲染、「保存报告」沿用 server id/时间(`saveHistory` 加可选 meta)。Playwright 真文件上传 E2E 全链路:选图 → 分析(CORS 预检 204 + POST 200,空 key mock 不计费)→ 结果卡渲染 server 报告(O-S-F-P ≠ 示例 O-S-A-N,敏感 41%「参考」态)→ 保存(本地 envelope = server uuid)→「我的」列表 → 回看;断服失败路径 toast + 蒙层收 + 留本页(仅 ERR_CONNECTION_REFUSED,无未捕获异常);`vue-tsc` 过。server 本地起 8890(8787/8788 被他项目 workerd 占) | Claude |
| 2026-07-08 | 拍照页取景引导框放大:定死 150×196(手机取景区面积仅占 ~17%,平板 600 壳内占比更低)→ 宽 58% + `aspect-ratio: 150/196` 保脸形比例,`max-width: 240`(恰兜进 min-height 360 取景区)+ `min-height: 196` 兜底旧 WebView 不识 aspect-ratio;`.viewer__empty` 补 `width:100%` 供百分比基准。H5 量测:375 手机 192×251(宽占 58%)、平板 240 封顶、600×650 短窗内容 350.9 无溢出,零控制台错误 | Claude |

## 工具链(见 ADR 0004 的 2026-07-06 修订)

- 构建 / 多端:uniapp 自带 `uni` CLI(**不走 Vite+**);类型 `vue-tsc`;样式 `sass`。
- 生成脚本(产物禁手改,改源重跑):
  - `pnpm gen:tokens` — `shared/design-tokens.json` → `src/styles/tokens.scss`(CSS 变量 `--skn-*`)
  - `pnpm gen:types` — `shared/skin-report.schema.json` → `src/types/skin-report.ts`

## 切片

### ✅ A. 骨架 + 设计系统接线
- degit `dcloudio/uni-preset-vue#vite-ts` → `app-uni/`;scripts 收敛到三端(H5 / 小程序)+ gen 脚本。
- `scripts/gen-design-tokens.mjs` 展平 DTCG → 65 个 `--skn-*` 变量;`App.vue` 全局挂 `page{}` 渐变底 + `.fr` Fraunces 数字体(H5 由 `index.html` 的 link 载)。
- schema → `SkinReport` 类型生成。

### ✅ B. 结果卡(核心展示页 `pages/result/result.vue`)
- 定稿设计「双极光谱 + 敏感参考」:四维各一条双极滑块,thumb 位置 = 判定极 + 置信(越高越远离中点);低置信(<0.6,如敏感)用虚边 soft thumb + 「参考」标。
- 区块:报告头(型号码 Fraunces 大字 + 型号名)/ 四维光谱 / 分区评估(评分条 + 问题 chip)/ 护理建议 / 免责声明(单处)/ 底部操作。
- mock 数据 `src/mock/sample-report.ts`(严格对齐契约)。
- 逐维度科普展开(2026-07-08):每维「?」手风琴式展开一段科普(描述性、不作诊断,对齐 raw-data 四维语义),浅底复用 design-tokens「科普四维卡」tint(油脂 gold / 敏感 clay / 痘痘 rose / 色沉 brown,原闲置),落地 ADR 0006「科普页逐维度讲解」意图。同一时刻至多展开一维,再点收起。
- H5 dev 验证:snapshot 内容齐、computed 样式逐项命中 token、`vue-tsc` 过。(本环境 preview 截图能力不可用,改以 DOM / computed 校验。)

### ✅ C. 其余静态页
- ✅ 首页 `pages/index/index.vue`:品牌头 + 人脸拓扑网格取景意象(`static/face-scan.svg`:MediaPipe canonical face model 468 点正交投影 + 官方三角拓扑 + 取景角标 + gold 特征点,由 `scripts/gen-face-mesh.py` 程序生成;叠 CSS 扫描光带,`prefers-reduced-motion` 关)+「开始检测」/「看示例报告」双 CTA。三端走 `<image>`(小程序不支持 inline svg);token 色写在生成脚本内,改 design-tokens 需重跑脚本。
- ✅ 拍照页 `pages/capture/capture.vue`:深色相机氛围 + 取景引导 + 拍摄要求 + `uni.chooseImage`(相册 / 相机)+ 分析中蒙层。
- ✅ 我的 `pages/mine/mine.vue`:游客态用户卡 + 我的检测(本地历史有数据态 / 空态)+ 免责 / 隐私 / 关于底部弹层(免责声明完整入口,ADR 0008)。
- ✅ 底部 tab `components/tab-bar/tab-bar.vue`:自绘暖调双 tab(检测 / 我的),CSS 画图标免资源、走设计 token;首页 / 我的为 tab 根级页,`reLaunch` 切换;拍照 / 结果为全屏二级页不挂 tab。
- ✅ 本地历史闭环(2026-07-08,`utils/history.ts`,uni Storage):结果卡「保存报告」把完整 report envelope(`{ id, createdAt, report }`)写设备本地 + 已保存态防重复写;「我的」页 `onShow` 读列表渲染有数据态(型号码 Fraunces / 型号名 / 时间),点击 `result?id=` 回看该报告(回看态隐藏保存按钮);MAX 20 条淘汰最旧。契合「本地保存」hint + 隐私说明「仅存设备本地」承诺,后端 D1 `/history` 留给 V2 登录、此处不涉及。
- 导航:底部 tab 切 首页 ↔ 我的(reLaunch 根级);首页 →(navigateTo)拍照 →(redirectTo)结果;结果卡顶部返回(`navigateBack`,栈内无上一页兜底 `reLaunch` 回首页)、「重新分析」回拍照页、「保存报告」写本地历史(已保存态 + toast);弹层(免责等)z-index 盖过 tab。
- H5 验证:三页 computed 样式逐项命中 token、Fraunces 生效、路由跳转通、`vue-tsc` 过。(preview 合成 click 不触发 uni 事件委托,改用 `uni.navigateTo` 直调验证路由;真机点击正常。)

### ✅ D. 微信小程序端过一遍(代码 + 编译层)
- 逐维度审计:src **无** `margin-inline-*` 等逻辑属性(本就物理属性 + px,`transformPx:false`),Skyline 无对应告警项;tab-bar 图标纯 `view` 无 `::before`,`hover-class` 原生态。
- CSS 变量早已 `:root, page` 双挂(gen-tokens 脚本产出),小程序端 `page` 半边生效 —— 产物 `app.wxss` 确认 `:root,page{--skn-…}`。
- `uni.loadFontFace` 补 Fraunces:`App.vue` onLaunch 内 `#ifdef MP-WEIXIN`,`global:true` 全页面生效、`fail` 静默降级到 fallback(Georgia/serif);源用 `@fontsource-variable/fraunces@5.2.9` 的 latin-wght woff2(jsdelivr) —— 产物 `app.js` 确认编入。
- 验证:`pnpm build:mp-weixin` 编译通过(仅 sass legacy 弃用告警,无错)、`vue-tsc` 过;产物双证(wxss 变量落 `page` + app.js 含 `loadFontFace({global:!0,…})`)。
- ⚠️ 留用户 / 真机(本环境无微信开发者工具):`manifest.json` 的 `mp-weixin.appid` 空 —— 导入开发者工具走测试号可预览,发布需填自有 appid;woff2 网络字体需在小程序后台配 `downloadFile` 合法域名 `cdn.jsdelivr.net`(开发者工具可勾「不校验合法域名」),真机 Fraunces / 整体渲染效果需开发者工具确认。

### ✅ E. 与 server 联调(2026-07-08)
- `utils/api.ts`:`requestAnalyze(filePath)` 用 `uni.uploadFile` 传 `image` 字段到 `POST /analyze`(与 server `parseBody` 对齐),返回 `{ id, createdAt, report }` envelope;`API_BASE = http://127.0.0.1:8890` 本地联调地址(8787/8788 被他项目占),部署后换线上域名 —— 小程序 / App 真机还需 https + 各端后台配请求合法域名,H5 跨域由 server CORS 放行。
- envelope 传递:模块级暂存 `setPendingAnalysis` / `takePendingAnalysis` 单次取用(redirectTo 不便携带大对象);**不自动写历史**,保存仍由用户在结果卡点「保存报告」。
- 拍照页:`analyze()` 由 mock 定时器改真上传;失败 toast(server error message 直显)留本页可重试,`finally` 收分析蒙层。
- 结果页:`?from=analysis` 取暂存渲染(H5 刷新后模块暂存已失,回落示例报告);「保存报告」沿用 server 的 id/createdAt(`saveHistory` 加可选 meta,示例报告仍本地自生成),后续「我的」回看 `?id=` 即 server uuid。
- 验证(Playwright 真文件上传 E2E;`.dev.vars` 空 key 走 mock 不计费):选图 → 分析 → 结果卡渲染 server 报告(O-S-F-P 油敏色皮,敏感 0.41 →「参考」态)→ 保存(localStorage envelope id = server uuid)→「我的」列表 → 点击回看(隐藏保存按钮);server 日志 CORS 预检 204 + POST 200、无删图错误;断服失败路径:toast + 蒙层收 + 留本页,console 无未捕获异常;`vue-tsc` 过。`GET /history` 属 V2 登录侧,本切片不接(本地历史已闭环)。

### 🟡 F. App(APK)目标 + 平板限宽(2026-07-08 定,ADR 0009)
- 目标:uniapp 也出 App(APK)手机 / 平板装机,与 flutter APK 并存双栈(「也添加」非取代)。
- 平板策略:一层 CSS max-width 容器(600px + 居中留白)限宽,H5 / 小程序 / App 统一;**不**做多列响应式、**不**走 rpx(`maxWidth` 配置仅 H5、rpx 封顶字段官方标注「App vue2 非 nvue」、Vue3 存疑)。
- ✅ 限宽容器已落地:`App.vue` 全局 `.skn-shell`(`max-width:600px` + 物理 `margin:auto` 居中,Skyline 安全),首页 / 结果 / 我的根容器 + 底部 tab + 我的弹层面板套用;沉浸深色拍照页深色底全屏、仅新增 `.cap__inner` 内容居中(避免平板露浅底)。H5 平板宽验证居中 + 背景无缝。
- ✅ App 端 Fraunces 字体已接:`App.vue` onLaunch 的 `loadFontFace` 分支从 `#ifdef MP-WEIXIN` 放宽为 `#ifdef APP-PLUS || MP-WEIXIN`(H5 仍走 index.html 的 Google Fonts link;App / 小程序运行时加载、`fail` 静默降级到 serif)。`uni build -p app` 编译通过,产物 `app-service.js` 含 `loadFontFace({global:!0,family:"Fraunces"…})`;真机字体渲染留用户(同小程序)。
- 待实现:`manifest.json` App appid;`#ifdef APP-PLUS` 其余能力(相机 / 存储权限等)按需补齐;出包 = HBuilderX 云打包 / 本地离线 SDK(`uni build -p app` 只产资源,本环境无 HBuilderX,留用户)。

### ⬜ G. 结果页分享(2026-07-08 审计立项,未排期)

- **判断**:16 型四维是"人格测试式"标签内容(类 MBTI),自带身份标签传播属性,结果页是全项目最值得做分享的一页;对求职线也是好谈资(跨端条件编译 / canvas 海报 / 分享 SDK / 合规设计一个功能覆盖四个面试点)。但收益三端极不均匀,且**兑现前提**:① 切片 E 联调完成(分享 mock 报告无增长意义);② 有公开可达端(H5 公开部署 / 小程序上架)。
- **P1(~半天,收益/成本比最高,排切片 E 之后)**:小程序 `onShareAppMessage` / `onShareTimeline` 转发卡片(标题 = 型号名 + 钩子文案)+ H5 `navigator.share` / 复制文案兜底。
- **P2(贵,缓)**:canvas 分享海报(型号 + 四维光谱 + 免责声明,**不含人脸** —— 照片分析后即删、服务端拿不回,隐私卖点与分享设计不冲突反而简化构图)。成本大头:三端 canvas API 差异 + Fraunces 字体在 canvas 内加载 + 双极光谱重绘,与非冲刺项定位冲突,慎入。
- **V2(不做现在)**:链接式公开报告页 —— server 现仅 `/health` `/analyze` `/history`,需新增公开 `GET /report/:id`,无鉴权体系下要不可枚举 id + 过期策略,属后端隐私新面;App 端 `uni.share`(微信 SDK + manifest 配置)等 HBuilderX 出包流程跑通再说。
- **合规**:分享卡片 / 海报是新的展示面,必须带"AI 生成,仅供参考"(ADR 0008 免责收敛延伸到分享物),文案不得出现诊断措辞;健康类小程序传播扩大后注意类目审核风险。

## 验收(W2)

- [x] H5:结果卡 + 拍照 + 首页 + 我的可跑通,免责声明可达(结果页 inline + 我的完整声明双入口)。
- [~] 微信小程序:`build:mp-weixin` 编译通过、无逻辑属性 / Skyline 告警项、`loadFontFace` 已补、变量落 `page`;真机渲染 + Fraunces 生效待微信开发者工具确认(本环境无)。
- [x] 与本地 server(wrangler dev,8890)联调,渲染一份真实 report(envelope 直达结果卡 + 保存沿用 server id,Playwright 真传图 E2E)。
