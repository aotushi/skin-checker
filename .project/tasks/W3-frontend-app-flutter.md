<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W3 · 前端 app-flutter(flutter → Android APK)

**最后更新**: 2026-07-10
**状态:** 🟡 进行中(切片 A/B ✅;下一步切片 C 四页 UI + 导航)

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

### ⬜ C. 四页 UI + 导航
- 页面:首页(品牌 + 取景意象 + 双 CTA)/ 拍照页(深色 + 取景引导 + 拍摄要求)/ 结果卡(四维双极光谱 + 敏感「参考」态 + 逐维科普展开 + 分区评估 + 护理建议 + 免责声明单处)/ 我的(游客态 + 本地历史 + 免责/隐私/关于弹层)。
- 导航:底部双 tab(检测/我的)为根级;拍照/结果为全屏二级页(Navigator push,不挂 tab)—— 对齐 app-uni 结构。
- 取景意象:复用 `scripts/gen-face-mesh.py` 产物思路,SVG → flutter 用 `flutter_svg` 或转 PNG(定型时决策,倾向少一个依赖)。
- 平板限宽:内容区 `Center + ConstrainedBox(maxWidth: 600)` 对齐 ADR 0009 的 600px 决策;方向性边距用 `EdgeInsetsDirectional`(ADR 0005)。
- a11y:关键交互(拍照/保存/免责入口)套 `Semantics`(ADR 0005,flutter 侧非 ARIA)。

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
