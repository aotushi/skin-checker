<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W3 · 前端 app-flutter(flutter → Android APK)

**最后更新**: 2026-07-13
**状态:** 🟡 进行中(切片 A–F ✅ + G 出包 ✅ + H 装机反馈改造 ✅;剩装机复测,真机在用户侧)

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

### ✅ D. 拍照/相册 + `/analyze` 联调 + 结果渲染(2026-07-10 完成,web 冒烟三用例全通)
- `lib/utils/api.dart`:`requestAnalyze(bytes, filename, mimeType)` → multipart `POST $_apiBase/analyze`,`_apiBase` 用 `kDebugMode` 切换(debug = `127.0.0.1:8890/api`,release = `skin.9shi.cc/api`,对齐 app-uni `API_BASE`);envelope `{id, createdAt, report}` 解析,`report` 走生成的 `SkinReport.fromJson`;失败统一抛 `ApiException(message)`(422/非 200 取 `error` 字段,网络异常固定文案),message 可直接进 SnackBar。
- `capture_page.dart` 接入:`image_picker`(`pickImage` maxWidth 1600 + imageQuality 85,对齐 uni sizeType compressed;web 实测生效,输出 `scaled_*.jpg` 344KB)→ `XFile.readAsBytes` 存 `Uint8List` 预览+上传共用(web 无 `dart:io File`,`Image.memory` 渲染)→ 成功 `pushReplacement` 结果页(对齐 uni redirectTo);失败 SnackBar 留本页可重试;`_analyzing` 蒙层全程。Android 无需 manifest 改动(系统 photo picker / 相机 intent),真机验证留切片 G。
- **⚠️ contentType 坑(联调抓到的唯一 bug)**:dart `http.MultipartFile.fromBytes` 默认 part `content-type: application/octet-stream`,server 校验 MIME 必须 `image/*` → 400「仅支持图片」。修法:pubspec 显式加 `http_parser`(避免 depend_on_referenced_packages lint),`contentType: MediaType.parse(mimeType ?? 'image/jpeg')`,mimeType 取 `XFile.mimeType`。
- **分层验证法(仓库无可用真人正脸图:raw-data 全手册翻拍,名人图会被 VL 自我审查拒)**:
  - **mock 200 链路**:server `pnpm dev --port 8890 --var "QWEN_API_KEY:"`(空值覆盖 `.dev.vars` 走 mock)→ 传手册翻拍 1.jpg → 200 envelope → 结果页完整渲染(O-S-F-P、敏感 41%「参考」虚线态、分区、建议),请求 part 实测 `content-type: image/jpeg`,console 零报错。
  - **真 key 422 链路**:`.dev.vars` 真 key → 同图 → server 日志 `analyze rejected by input gate reason:not_face` + 422(~2s),响应 `{"error":"未检测到人脸,请正对镜头拍摄面部照片"}` → SnackBar 显示指引 + 留拍照页(语义树 MutationObserver 实录 SnackBar 文本节点;蒙层「AI 正在分区分析…」→ SnackBar 时序正确)。
  - **断服网络异常**:杀掉 server → 分析 → SnackBar「网络异常,请检查连接后重试」+ 留页。
- **⚠️ Windows 后台 wrangler 残留坑**:TaskStop/杀 pnpm 后 **workerd 子进程仍监听端口**,新旧 server 可同时 LISTEN 8890,请求被旧进程接走(新 server 日志空白、mock 幽灵复活)。切换 server 配置后必须 `netstat -ano | grep :8890` 核对并 `taskkill //F //PID` 清干净再验。
- ResultPage 仍只吃 `envelope.report`;`id`/`createdAt` 留切片 E 存历史时接。

### ✅ E. 本地历史闭环(2026-07-10 完成,web 冒烟全链路通)
- `lib/utils/history.dart`:`shared_preferences` 存 JSON 字符串整存整取(web 落 localStorage `flutter.skn_history`),`HistoryItem{id, createdAt 毫秒, report}`,KEY `skn_history` / MAX 20 淘汰最旧 / 新→旧存序 —— 语义平移 app-uni `utils/history.ts`;损坏/缺失按无历史处理;与 uni 版差异:flutter 回看直传 `HistoryItem` 对象(不走路由 query),故不需要 `getHistoryItem(id)`。
- `result_page.dart`:构造器加 `analysisId`/`analysisCreatedAt`(对齐 uni `analysisMeta`,capture 从 envelope 带入),`_save()` 真写 `saveHistory`(沿用 server id/时间;先翻 `_saved` 态防异步间隙重入)→ SnackBar「已保存到本地」。
- `mine_page.dart`:历史列表(型号码 Fraunces + 型号名/`yyyy-MM-dd HH:mm` 时间 + › 箭头,行间 divider,对齐 mine.vue `.hist__row`),点击 `push ResultPage(report, fromHistory: true)` 回看(隐藏保存钮);空态原样保留。
- **uni `onShow` 的 flutter 对等**:全局 `RouteObserver`(main.dart 挂 `navigatorObservers`)+ MinePage `with RouteAware`,`didPopNext` 刷新列表 —— 保存只可能发生在二级页,pop 回根必触发;IndexedStack 常驻页订阅的是根 route,保存时停在哪个 tab 都能收到。`initState` 读首屏。
- web 冒烟(mock server)全链路:分析 → 保存(SnackBar + 按钮翻「已保存」,localStorage 实录 **server UUID id + server createdAt**,证明 meta 沿用非本地生成)→ 重复点击防重(仍 1 条)→ 我的列表出现 → 点击回看无保存钮 → 整页刷新后列表仍在(持久化);console 零报错;format+analyze 双绿。

### ✅ F. 合规与文案核对(2026-07-10 完成,app 代码零改动)
- **免责落点(ADR 0008)**:inline 完整声明(`report.disclaimer`)两端均只在结果页渲染一处(`result_page.dart` 免责 note ↔ result.vue `.note`);「我的 → 免责声明」完整声明弹层入口两端保留。首页底部短句「结果由 AI 生成,仅供护肤参考,不构成医疗建议。」是 uni 定稿的轻量提示(非那条完整声明;ADR 0008 对首页是「不再强制」非禁止),flutter 逐字平移一致。
- **全量文案对照(无新造)**:正则抽取 flutter `lib/` 全部中文字符串(四页 + tab + api 错误文案 + sample mock + 三弹层),逐条与 app-uni 对应 vue/ts 对照零出入;sample_report 两端逐字一致(含 disclaimer 全句);flutter 独有字符串仅 Semantics a11y 标签(「返回」「查看报告:…」「××维度说明」,ADR 0005 要求,非用户可见新造文案)。
- **违禁词扫描**(诊断/治疗/疗效/疾病/治愈/处方/医):flutter 命中全部为免责声明自身的否定式表述(「不构成医疗建议」「不是医疗诊断工具」「请及时就医」)与代码注释,与 uni 侧命中一一对应;科普 blurb「不对成因或病症下判断」为否定式且逐字平移。
- **修一处文档出入**:根 README 合规段仍写 ADR 0008 已取代的旧规则「每个结果页 + 启动页显著标注」(与 skin-checker CLAUDE.md 已同步的「收敛结果页一处」矛盾)→ 本切片改为收敛表述。

### 🟡 G. APK 出包 ✅(2026-07-13)+ 装机自测(留用户)
- `flutter build apk --release` ✅:`build/app/outputs/flutter-apk/app-release.apk`(46.0MB,fat APK 含全 ABI),debug key 签名(`build.gradle.kts` release 沿用 signingConfig debug,上架再议)。
- Android 环境(本机记录):Android Studio 装 **D 盘** `D:\Program Files\Android\Android Studio`(flutter doctor 不自动识别,注册表 `HKLM\SOFTWARE\Android Studio` 定位);JDK 用其 JBR 21,已 `flutter config --jdk-dir` 持久指向;SDK `%LOCALAPPDATA%\Android\Sdk`(cmdline-tools 缺失不挡 build,AGP 构建中还自动装了 CMake 3.22.1)。
- **⚠️ gradle loopback 坑(本机 build 必读)**:`flutter build apk` 一律报 `Unable to establish loopback connection` —— 根因是本机 **AF_UNIX `connect` 系统性 EINVAL**(afunix 驱动 RUNNING、Claude 沙箱内外一致,疑 WFP/winsock 层拦截),JDK 21 NIO Selector 的 wakeup pipe 优先走 Unix domain socket,UDS listener bind 成功后**不再回退 TCP**,gradle client 与 daemon 两侧全死在 `Selector.open()`。**修法:build 前 `export JAVA_TOOL_OPTIONS="-Djdk.net.unixdomain.tmpdir=C:/nonexistent-force-tcp-fallback"`**(指不存在目录 → UDS bind 失败 → 回退 TCP loopback pipe;env 覆盖 client/daemon/一切子 JVM)。⚠️ 写进 `org.gradle.jvmargs` 无效:gradle 把自定义 `-D` 当运行时可变属性延迟 setProperty,赶不上 JDK 静态初始化,daemon 照样死。根因未修,用户自己 Android Studio 构建预计同样中招(`netsh winsock reset` / 排查代理组件属用户决策)。
- ⬜ 手机 + 平板装机跑通拍照全流程 —— 真机在用户侧,留用户自测(image_picker 相机/相册首次真机验证;release 包 API 走线上 `skin.9shi.cc/api`)。
- 与 uniapp APK(HBuilderX 云打包,ADR 0009 双栈)各自出包,互不依赖。

### ✅ H. 装机反馈改造:页面内实时取景 + 取景框放大(2026-07-13)
- **起因(用户首次装机反馈)**:① 取景框位置过于靠顶部、整体面积较小;② APK 没有实时摄像头画面。两问题一次取景区改造解决。
- **实时取景(flutter 端扩展,超出 app-uni 能力的双端差异点)**:`camera ^0.12.0+1`(Android = camera_android_camerax,CAMERA 权限插件自动 merge 进 manifest,无手改)。前置镜头优先(`firstWhere front` fallback 首个),`ResolutionPreset.veryHigh` + `enableAudio: false`;`CameraPreview` 用 FittedBox(cover)+ previewSize 宽高互换铺满取景区(竖屏假设),溢出由外层圆角 clip 裁切。**「拍照」钮改页面内直拍**:`takePicture` → bytes 进原确认态(重拍/开始分析结构不变)→ `pausePreview`;`_reset` 时 `resumePreview` 或重建;`WidgetsBindingObserver` 生命周期(inactive/paused dispose,resumed 且无已拍图重建)。**全链降级**:初始化/拍摄任何失败(含无权限、web 无摄像头)静默回落 image_picker 系统相机(= uni 侧原体验),空态仍显引导框;按钮文案零新造。**注意 uni APK 侧无此能力**(chooseImage 只能拉系统相机),为 flutter 侧独有扩展,双端差异入档。
- **取景框放大居中(_FaceGuide 重构)**:原 OverflowBox 固定 150×196 顶部偏置 → LayoutBuilder 随取景区自适应(宽 72% 封顶 320;高度预算先扣 44「间距+文案行高」再取 82%,防极矮取景区 Column 溢出;矮到 <24 整体隐去兜底),框+文案整体居中;脸形 rrect 比例与虚线参数原样保留。
- **web 冒烟(面板 block camera = 天然降级用例)**:拍照页直开渲染不崩,语义树 9 节点全在(返回/标题/「将正脸置于取景框内」/正脸/自然光/不化妆/隐私句/相册选图/拍照),日志零 overflow/exception;format + analyze 双绿。真机实时预览路径留装机复测。
- **⚠️ web 冒烟工具坑(本轮新增)**:web-server 设备改代码必须重启 flutter run(dwds 无重编译通道,hot restart 假成功);面板浏览器 camera 权限 block 后 tab 渲染管线可能整体冻结(rAF 0 帧),resize 不再触发重排,语义树是冻结前旧视口残影 → **先 resize 后 reload** 让首帧直接在目标视口渲染;`ext.flutter.debugDumpApp`(node WebSocket 连 VM service)可拿 MediaQuery 实证逻辑视口;面板对 canvas 页 screenshot 超时、语义节点 getBoundingClientRect 因多层 transform 不可靠,以语义 DOM 文本 + debugDump 为证据。
- 出包:`app-release.apk` **47.7MB**(camera 插件 +1.7MB,debug 签名同前)。
- **⚠️ 装机复测第二轮:release 包缺 INTERNET 权限(2026-07-13 已修)**:真机点「开始分析」必报「网络异常,请检查连接后重试」—— flutter 模板的 `INTERNET` 权限只在 `src/debug`/`src/profile` manifest(注释明说仅供开发期调试通道),`src/main/AndroidManifest.xml` 默认**不声明**,release 构建不合并 debug manifest → 整包无网络权限,http 一律 SocketException 落网络异常兜底文案。CAMERA 能用是 camera 插件 manifest 自动 merge,`http` 纯 Dart 包不带 manifest;web 冒烟无 manifest 概念测不到,首次真机走到分析才暴露。修法:main manifest 加 `<uses-permission android:name="android.permission.INTERNET"/>`,重出 APK 并 `aapt dump permissions` 实证 INTERNET 已进包(线上 API 同步 curl 200 排除服务端因素)。

## ⚠️ 注意

- **工具链(ADR 0004)**:`dart format` + `flutter analyze` + `flutter test`;Vite+/oxc 不适用 Dart,**不引** ESLint 系。正式测试后置策略与 W1/W2 一致(MVP 手动 E2E 兜底),`flutter test` 起步只挂冒烟级。
- **契约/token 单一真相源**:改契约只改 `shared/*.json` 后重跑生成;**禁手改** `skin_report.dart` / `tokens.dart`(CLAUDE.md 项目铁律)。
- **后端零改动**:flutter 是纯消费端;若联调发现后端问题,记 W1 不在此改。
- **本机环境**:Flutter SDK `E:\dev\flutter`(bash 里用 `E:/dev/flutter/bin/flutter.bat` / `dart.bat`;PATH 未全局注入,勿假设 `flutter` 直接可用);`PUB_CACHE=E:\dev\pub-cache` 已 setx(新 shell 生效,当前会话需显式 export);flutter/dart 命令一律带 flutter-io.cn 双镜像 env(见切片 A 坑);Android SDK/JDK 已就绪,**build 必带 `JAVA_TOOL_OPTIONS` loopback workaround**(见切片 G ⚠️)。

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
| 2026-07-10 | 切片 D ✅:`utils/api.dart`(kDebugMode 双环境 + envelope 解析 + ApiException)+ capture_page 接入 image_picker 真传图;修 multipart contentType 坑(octet-stream 被 server 400,http_parser MediaType 显式指定);web 冒烟三用例全通(mock 200 → 结果页 / 真 key 422 not_face → SnackBar 指引留页 / 断服 → 网络异常 SnackBar);记录 workerd 端口残留坑;format+analyze 双绿 | Claude |
| 2026-07-10 | 切片 E ✅:`utils/history.dart`(shared_preferences,KEY/MAX/存序平移 uni history.ts)+ ResultPage 真保存(沿用 server id/createdAt,防重)+ MinePage 历史列表回看(RouteObserver.didPopNext ≈ uni onShow);web 冒烟保存→列表→回看→刷新持久化全通;format+analyze 双绿 | Claude |
| 2026-07-10 | 切片 F ✅:合规文案核对(免责落点符合 ADR 0008、flutter 全量中文文案抽取对照 app-uni 零出入无新造、违禁词扫描全为否定式声明文案);修根 README 合规段旧规则「结果页+启动页」→「收敛结果页一处」;app 代码零改动 | Claude |
| 2026-07-13 | 切片 G 出包 ✅:`app-release.apk` 46.0MB(debug 签名);排障本机 AF_UNIX connect EINVAL 致 gradle loopback 全挂 → `JAVA_TOOL_OPTIONS` 强制 UDS 回退 TCP workaround 入档;Android Studio(D 盘)/JBR 21/SDK 环境入档;装机自测留用户 | Claude |
| 2026-07-13 | 切片 H ✅:装机反馈改造 —— camera 插件页面内实时取景直拍(前置优先/降级 image_picker 全链兜底/生命周期挂 observer;flutter 独有扩展,uni 侧无)+ `_FaceGuide` 随取景区放大居中(高度预算含文案防溢出);web 冒烟降级路径通过、语义全在;APK 重出 47.7MB;web-server 无热重载/面板 camera block 冻结渲染两坑入档 | Claude |
| 2026-07-13 | 修装机复测「开始分析」网络异常:main manifest 补 `INTERNET` 权限(flutter 模板只给 debug/profile,release 整包无网络权限致 http 全挂);重出 APK,aapt 实证权限进包;坑入档切片 H | Claude |
