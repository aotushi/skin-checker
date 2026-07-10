<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W3 · 前端 app-flutter(flutter → Android APK)

**最后更新**: 2026-07-10
**状态:** 🟡 进行中(切片 A/B/C ✅;下一步切片 D image_picker + `/analyze` 联调)

> 目标:flutter 端复刻 app-uni 已验证的四页闭环(首页/拍照/结果卡/我的),消费同一 CF 后端与契约,产出 Android APK —— 兑现「uniapp + flutter 双端」定位。**不重新设计**:产品形态、文案、16 型语义、合规规则全部沿用 app-uni 定稿,flutter 只做技术栈平移。

## 范围(切片)

### ✅ A. 脚手架 + 工具链(2026-07-10 完成)
- Flutter SDK 本机安装(此前无):**3.44.6 stable / Dart 3.12.2**,装于 `E:\dev\flutter`(版本记死,升级需过 `flutter analyze` + 真机回归)。
- `flutter create`:`--platforms android --empty`,项目名 `skin_checker`,org `com.aotushi`(→ applicationId `com.aotushi.skin_checker` 已核实)。**只锁 Android**(ADR 0002:flutter 侧只出 APK;H5/小程序归 app-uni)。
- 验证:`flutter analyze` 零告警(No issues found)+ `dart format` 无 diff(模板 `main.dart` 与 Dart 3.12 新 formatter 有 1 处差异,已归一)。
- **⚠️ 安装实测坑(本机复现记录)**:
  - **PUB_CACHE 必须指到 `E:\dev\pub-cache`**(已 `setx` 用户级持久):Claude 桌面应用(MSIX 容器)把 `%LOCALAPPDATA%\Pub\Cache` 虚拟化重定向到 `C:\WpSystem\...\Packages\Claude_...` 包私有存储,pub 下载后 rename 跨卷报 `errno 17`(The system cannot move the file to a different disk drive),`flutter.bat` 首次重建 flutter_tools 时在 `dart pub upgrade` 无输出死循环。
  - **国内镜像 env**:命令行带 `PUB_HOSTED_URL=https://pub.flutter-io.cn` + `FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn`(直连 pub.dev / storage.googleapis.com 卡死)。
  - 解压:Git Bash 的 GNU tar 不识 zip,用 `/c/windows/system32/tar.exe -xf`。
- ⚠️ 本机**无 Android SDK / JDK**:`create/analyze/test` 不依赖;`flutter build apk` 之前需装(建议 Android Studio 一站式,顺带模拟器;或 cmdline-tools + 接受 licenses)。留切片 G 前置。

### ✅ B. 契约 + 设计 token 两条生成线(SSOT 派生,产物禁手改;2026-07-10 完成)
- **固化入口 `tool/gen.mjs`**(`node tool/gen.mjs`,两条线一次跑,末尾自动 `dart format` 产物保证「生成 → format 无 diff」幂等,已验证):
  - `shared/skin-report.schema.json` → `lib/models/skin_report.dart`:npx quicktype(命令与 `shared/README.md` 一致)。
  - `shared/design-tokens.json` → `lib/theme/tokens.dart`:DTCG 展平 → 6 个 namespace 类(`SknColors`/`SknGradients`/`SknTypography`/`SknRadius`/`SknSpace`/`SknShadows`),65 token;`$description` 落 doc comment;shadow CSS 串按分量转 `BoxShadow`,rgba → `Color.fromRGBO`;命名特判:纯数字段 `1`→`s1`、数字开头段 `2xl`→`xl2`。Style Dictionary 仍为备选(若引入需两端统一)。
- Fraunces 数字体:app-uni 走 jsdelivr 网络加载无本地文件,flutter 侧直接取 **google/fonts 原件 variable ttf**(经 `cdn.jsdelivr.net/gh/google/fonts` 镜像,360KB,免 woff2 转换)→ `assets/fonts/Fraunces-Variable.ttf`,`pubspec.yaml` 已声明 `family: Fraunces`(仅数字/型号码,正文系统字体,对齐 app-uni);variable 轴(wght 等)若需非默认字重,使用侧用 `FontVariation` 指定(切片 C 落地时留意)。
- 验证:`flutter analyze` 零告警、`flutter pub get` 过、重跑 gen 后 `dart format --set-exit-if-changed` 零 diff。

### ✅ C. 四页 UI + 导航(2026-07-10 完成,flutter web 冒烟全页通过)
- 四页全部落地,文案/布局逐字段平移 app-uni 对应 vue(不新造):
  - `lib/pages/home_page.dart`:品牌 + face-scan.svg 取景意象(光带扫描 + 亮点)+ 三步说明 + 双 CTA + 底部合规一句。
  - `lib/pages/capture_page.dart`:深色全屏二级页(`Scaffold(backgroundColor: cameraBg)` 自带底,不透 RootShell 渐变),脸形虚线引导框(`DashedOutline` 四角不对称椭圆角)、拍摄要求三点、隐私一句、双操作钮、分析蒙层;取图/上传留切片 D 接入点(`_choose`/`_analyze` 占位)。
  - `lib/pages/result_page.dart`:hero(Fraunces 型号码 + AI 分析 pill)、四维双极光谱(`_AxisMeta.pick` 取值函数替代 TS keyof;enum `.name` 即判定码)、置信 <0.6 →「参考」虚线 pill + 虚线 thumb、? 科普手风琴(至多一维展开,TweenAnimationBuilder 入场)、分区评估(Fraunces 分数 + 渐变条 + chips)、护理建议、免责声明单处 note、重新分析(pushReplacement)/保存报告(暂翻本地状态 + SnackBar,真存储切片 E)。
  - `lib/pages/mine_page.dart`:游客卡、检测历史空态(去检测 CTA)、免责/隐私/关于三弹层(`showModalBottomSheet` + `constraints maxWidth 600` 对齐平板限宽,文案与 mine.vue 逐字一致)。
- 导航:`RootShell` 底部双 tab(自绘 `SknTabBar`,镜头/人形 glyph 免图标资源)为根级;拍照/结果 `Navigator.push` 全屏二级页。
- 共用件:`Press`(hover-class 平移:AnimatedScale/Opacity 90ms + Semantics label,label 非空时 `excludeSemantics` 防双重朗读)、`SknShell`(600 限宽,ADR 0009)、`SknCard`、`DashedOutline`(CustomPainter,`rrectOf` 参数化,取景框/「参考」pill/低置信 thumb 三处共用——flutter 无原生 dashed border)。
- 取景意象定案:`flutter_svg ^2.3.0` 直用 app-uni 同源 `assets/face-scan.svg`(SSOT,转 PNG 反而多一道生成)。
- 样式平移惯例:letter-spacing = fontSize × em 值;uni 页顶 60/28 留白含 H5 无状态栏假设,SafeArea 承担状态栏后减半(capture 24 / result 12);矮视口空态用 `OverflowBox` + 外层 clip 对齐 uni `overflow:hidden`。
- **web 冒烟法(本机无 Android SDK 的验证路径)**:`flutter create --platforms web .` 补 web 目录(**不入库**,`.gitignore` 已加 `/web/`;⚠️ 它会把 `.metadata` 的 android 迁移记录**替换**成 web,需还原;⚠️ 还会重建模板 `test/widget_test.dart` 引用不存在的 MyApp 挂 analyze,需删)→ `flutter run -d web-server --web-port=8895` → chrome-devtools MCP 驱动。**canvas 页面语义树激活**:初始 snapshot 只有占位钮且 click/合成 PointerEvent 均无效,正解 = `evaluate_script` 执行 `document.querySelector('flt-semantics-placeholder').click()`,之后 snapshot/click 全通。
- 冒烟结果:四页 + 弹层 + 科普展开 + 保存已保存态 + 重新分析 pushReplacement(返回栈正确)全部像素/行为对齐,console 零报错;a11y 双重朗读(「开始检测 开始检测」)已修(Press/SknTabBar `excludeSemantics`);`dart format` 零 diff + `flutter analyze` 零告警。

### ⬜ D. 拍照/相册 + `/analyze` 联调 + 结果渲染
- `image_picker`(相机/相册)→ multipart 传 `POST /analyze`(生产 `https://skin.9shi.cc/api`,本地 dev `127.0.0.1:8890/api`,双环境切换对齐 app-uni 的 `API_BASE` 条件化)。
- 422(输入质检,W1 切片 E)→ SnackBar/toast 显示 `error` 指引 + 留在拍照页可重拍;200 → envelope 进结果卡。
- 分析中蒙层、断服失败路径(toast + 留本页)对齐 app-uni 行为。

### ⬜ E. 本地历史闭环
- `shared_preferences`(或 `hive`,倾向前者够用)存 report envelope,MAX 20 淘汰最旧 —— 语义对齐 app-uni `utils/history.ts`(「仅存设备本地」承诺)。
- 结果卡「保存报告」防重、「我的」列表回看、回看态隐藏保存按钮。

### ⬜ F. 合规与文案核对
- 免责声明收敛结果页一处(ADR 0008);「我的」保留完整声明入口。
- 全部文案从 app-uni 平移,禁疾病/诊断/治疗措辞;flutter 端不新造文案。

### ⬜ G. APK 出包 + 装机自测(依赖 Android SDK,部分留用户)
- `flutter build apk --release`(签名先 debug key,上架再议);手机 + 平板装机跑通拍照全流程。
- 与 uniapp APK(HBuilderX 云打包,ADR 0009 双栈)各自出包,互不依赖。

## ⚠️ 注意

- **工具链(ADR 0004)**:`dart format` + `flutter analyze` + `flutter test`;Vite+/oxc 不适用 Dart,**不引** ESLint 系。正式测试后置策略与 W1/W2 一致(MVP 手动 E2E 兜底),`flutter test` 起步只挂冒烟级。
- **契约/token 单一真相源**:改契约只改 `shared/*.json` 后重跑生成;**禁手改** `skin_report.dart` / `tokens.dart`(CLAUDE.md 项目铁律)。
- **后端零改动**:flutter 是纯消费端;若联调发现后端问题,记 W1 不在此改。
- **本机环境**:Flutter SDK `E:\dev\flutter`(bash 里用 `E:/dev/flutter/bin/flutter.bat` / `dart.bat`;PATH 未全局注入,勿假设 `flutter` 直接可用);`PUB_CACHE=E:\dev\pub-cache` 已 setx(新 shell 生效,当前会话需显式 export);flutter/dart 命令一律带 flutter-io.cn 双镜像 env(见切片 A 坑);无 Android SDK/JDK(见切片 A ⚠️)。

## 验收

- 一张正脸照(相机或相册)→ flutter 端渲染符合契约的报告卡;不合格照收到 422 指引并可重拍。
- 本地历史保存/回看闭环。
- `flutter build apk` 出包,真机装机可用(依赖 Android SDK 就绪)。

## 📝 变更历史

| 日期 | 变更内容 | 修改人 |
|------|---------|--------|
| 2026-07-10 | 建 W3 文档(切片 A–G 规划);本机安装 Flutter 3.44.6 stable(`E:\dev\flutter`,此前无 SDK);切片 A 脚手架进行中 | Claude |
| 2026-07-10 | 切片 A ✅:`app-flutter` 脚手架建成(skin_checker / com.aotushi,Android only),analyze 零告警 + format 无 diff;记录 PUB_CACHE MSIX 重定向坑(迁 `E:\dev\pub-cache`)与 flutter-io.cn 镜像要求 | Claude |
| 2026-07-10 | 切片 B ✅:`tool/gen.mjs` 固化两条生成线(quicktype → `skin_report.dart`;DTCG 展平 → `tokens.dart` 65 token 6 类,shadow 转 BoxShadow),产物自动 format 幂等;Fraunces variable ttf(google/fonts 原件经 jsdelivr gh 镜像)进 assets + pubspec 声明;analyze 零告警 | Claude |
| 2026-07-10 | 切片 C ✅:四页 UI + 双 tab 导航全落地(文案逐字平移 app-uni);共用件 Press/SknShell/SknCard/DashedOutline/SknTabBar;flutter_svg 直用同源 face-scan.svg;flutter web 冒烟全页通过(web/ 不入库,记录 flt-semantics-placeholder 激活法、flutter create 重建 test 与改 .metadata 两坑);修 Press/SknTabBar 双重朗读(excludeSemantics);format+analyze 双绿 | Claude |
