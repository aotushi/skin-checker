# ADR 0009:uniapp 也出 App(APK)+ 平板限宽策略

- **状态:** 已采纳
- **日期:** 2026-07-08
- **修订对象:** ADR 0002 —— 把「uniapp 也可出 App 作双栈对照」从可选备注升为**正式打包目标**;0002 其余(锁定端范围、不做 iOS/PC/快应用等)不变。

## 背景

ADR 0002 把 uniapp 锁在 H5 + 微信小程序,Android APK 交给 flutter,「uniapp 也可出 App」仅作可选双栈对照。现需 uniapp **也正式出 App(APK)**,用于手机 / 平板真机安装使用(与 flutter APK **并存双栈**,「也添加」非取代)。平板是大屏,触发与 0002「不做大屏」的取舍,需定策略。

## 决策

### 1. uniapp 打包目标 = H5 / 微信小程序 / App(APK)

- uniapp App/APK 从「可选备注」升为**正式目标**;与 flutter APK 并存双栈对照。
- App 端能力差异继续用条件编译 `#ifdef APP-PLUS` 补(此前基本闲置,现启用)。

### 2. 平板(大屏)= 限宽居中,用 CSS max-width 容器,不做多列响应式

审查官方《宽屏适配指南》后定:

- 平板只求「能装、竖屏窄栏居中、阅读舒适」,**不追横屏多列 / 断点重排**——内容是报告卡 / 相机 / 我的单列扫描流,不天然多列;完整响应式过度,且推翻 0002「不做大屏」不值(非冲刺项)。
- 实现:一层 **CSS max-width 容器**(**600px** + 两侧留白居中),H5 / 小程序 / App 三端统一;手机(逻辑宽 < 600)照常铺满,仅平板收窄。
- **定值 600px 依据**:该宽度是 CSS 逻辑 px(非物理像素),13″ iPad Pro 竖屏也才 1024pt,锁 600 两侧仍留足白;480 属手机档、平板上偏窄;中文舒适阅读行宽约 600–700px(约每行 35 字),600 既打破手机档窄栏、又把卡片 / 光谱滑块的形变控制在最小(> 680 起需改组件、滑向响应式,不做)。
- **不选 rpx 等比**:要全站 px→rpx(推翻 `transformPx:false`、动到每处样式),且平板封顶字段风险见下。

### 3. 三个官方坑(记录备查)

- **`maxWidth` 页面配置项仅 H5(2.9.9+)**——「可见宽度 > maxWidth 两侧留白」在 App/APK 不生效,故限宽只能靠 CSS 容器,不能靠该字段。
- **rpx 封顶字段** `rpxCalcMaxDeviceWidth`(默认 960)/ `rpxCalcBaseDeviceWidth`(375)官方标注**「App(vue2 非 nvue)」**;本项目 Vue3,能否封顶不确定——是不走 rpx 路线的关键理由(平板恐「界面奇大无比」)。
- **出 APK 的工具链**:`uni build -p app` 只产出 App 资源,**真正打 APK 需 HBuilderX 云打包 / 本地离线打包 SDK**(本环境无),这步与小程序真机一样留用户。

## 后果

- 仍是三类目标端(H5 / 微信小程序 / Android APK),但 APK **双栈**(flutter + uniapp),uniapp 覆盖到 App。
- 新增一层 max-width 布局容器(**已落地**:`App.vue` 全局 `.skn-shell`(`max-width:600px` + 物理 `margin:auto`),首页 / 结果 / 我的根容器 + 底部 tab + 我的弹层面板套用;沉浸深色拍照页深色底全屏、仅新增 `.cap__inner` 内容居中)。
- `#ifdef APP-PLUS` 已启用:App 端 Fraunces 字体已接(`App.vue` 的 `loadFontFace` 分支从 `#ifdef MP-WEIXIN` 放宽为 `#ifdef APP-PLUS || MP-WEIXIN`,`uni build -p app` 编译通过 + 产物 `app-service.js` 含字体调用);`manifest.json` App appid、`#ifdef APP-PLUS` 其余能力按需补齐、出包走 HBuilderX 仍待办。
- 0002「不做大屏」收窄为「不做大屏**多列 / 响应式**」;平板以限宽居中兜底,不算违背。
- iOS / PC / 快应用 / 他家小程序仍不做(0002 不变)。
