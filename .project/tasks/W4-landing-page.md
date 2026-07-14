<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W4 · 项目落地页(landing → doc.skin.9shi.cc)

**最后更新**: 2026-07-14
**状态:** 🟢 完成(线上 `skin-checker-doc.pages.dev` 全路径验证通过;自定义域 `doc.skin.9shi.cc` 绑定留用户 dashboard 操作)

> 目标:为项目提供介绍落地页,部署 Cloudflare Pages,地址 `doc.skin.9shi.cc`。结构参考 `resume/site-extensions/e1-google-ad-timing-probe/landing/` 既有样板;内容按项目生成。经用户确认:**Astro 静态站 / 中英双语 / 产品+技术混合基调 / 出口 = H5 + APK 双入口**;APK 承载定为 **GitHub Releases**(Pages 单文件 25MiB 限制装不下 47.7MB APK)。

## 范围(落地内容)

### ✅ A. Astro 子项目脚手架(`landing/`)
- astro ^5 + @astrojs/sitemap;`astro.config.mjs` `SITE_URL` 默认 `https://doc.skin.9shi.cc`,`output: 'static'`。
- i18n 双语路由:`/zh/`(默认)+ `/en/`;根路径 `public/_redirects` CDN 级 `301 → /zh/`,dev 由 `src/pages/index.astro` 的 `Astro.redirect` 兜底。
- 文案单一来源 `src/i18n/zh.ts`(导出 `Strings` 类型),`en.ts` 以同类型全量对齐 —— 增删文案改两个文件即可,结构不会漂移。

### ✅ B. 页面(8 组件 × 双语)
- **Nav**:sticky + blur,品牌「肤镜 SKINLENS」,锚点(功能/流程/下载/技术)+ 语言切换 + 在线体验 CTA。
- **Hero**:双机位视觉(线上真截 首页+报告页,face-scan.svg 网格垫底)+ 双 CTA(在线体验 / 下载 Android 版)+ inline 免责短句。
- **Features** 2×2:AI 分区分析 / 16 型四维光谱 / 护肤建议 / 隐私优先。
- **HowItWorks** 三步:拍摄正脸 → AI 分析(含 422 质检指引)→ 查看报告。
- **Download** 三卡:H5(→ skin.9shi.cc)/ Flutter APK / uniapp APK(均 → `github.com/aotushi/skin-checker/releases/latest`,固定链免改版;uniapp 卡初版为 disabled「即将提供」,2026-07-13 出包后启用)。
- **TechStack**:HTML 架构图(uniapp·Vue3 + Flutter → Workers+Hono 统一 API → D1/R2/千问 VL)+ 工程 6 点(契约 SSOT / token SSOT / 边缘架构 / AI 工程化 / 隐私由架构保证 / 双端差异化)+ GitHub 链接。
- **Compliance**:免责声明(与 schema `disclaimer` 字段一致)+ 隐私承诺双卡。
- **Footer**:品牌 + 在线体验 / GitHub。

### ✅ C. SEO / 合规
- head 全套:canonical、hreflang zh/en/**x-default→zh**、OG(og-image 1200×630 绝对 URL)、Twitter Card、JSON-LD `SoftwareApplication`(LifestyleApplication / Android+Web / price 0 / softwareVersion 0.1.0)、theme-color。
- `robots.txt`(APIRoute)指 sitemap 绝对 URL;`@astrojs/sitemap` 出 sitemap-index。
- 合规口径全程「参考/建议」,免责文案与结果页一字不差;JSON-LD 描述带 reference only。

### ✅ D. 素材(全部可再生)
- `public/shots/{home,report}.png`:Playwright 390×844 截线上 skin.9shi.cc(注入 `::-webkit-scrollbar{display:none}` 去滚动条;report 经「先看一份示例报告」到达)。
- `public/face-scan.svg`:app-uni 同源复制(SSOT)。
- `public/favicon.svg`:品牌镜头意象(渐变圆角方 + 圆环 + 取景四角,色值同 design-tokens)。
- `public/og-image.png`:由 `landing/og-src.html`(1200×630)Playwright 定格截图产出,改源文件重截即可再生。

### ✅ E. 验证(2026-07-13)
- `pnpm build` 过:3 页(/ /zh/ /en/)+ robots + sitemap;产物 SEO 特征逐项核对(canonical/hreflang/og 绝对 URL/根 meta-refresh+noindex)。
- Playwright 目检:1280 桌面 + 375 移动 × 双语四组全页截图,布局无破损;链接断言(skin.9shi.cc / releases/latest / github / 四锚点 / 语言互切 zh↔en)全过。
- **修一处**:375 视口 7px 水平溢出(`.hero__mesh` 出血设计撑出滚动)→ `.hero` 加 `overflow-x: clip`(不建滚动容器,不影响锚点),四组视口溢出归零。

### ✅ F. GitHub Release v0.1.0(APK 承载,2026-07-13,经用户同意)
- `gh release create v0.1.0 --target master`(7632e60):asset `skinlens-flutter-v0.1.0-android.apk`(47.7MB,SHA-1 `fb455b11…bb11` 写入 notes);notes 含测试证书/未知来源说明 + H5/落地页入口 + 免责句。
- `releases/latest` 302 → v0.1.0 已验证,落地页固定链生效。
- tag 经 API 创建,不触发 CF Builds(其只监听分支 push)。
- **uniapp APK 补传(2026-07-13 同日,用户 HBuilderX 出包后)**:`gh release upload v0.1.0` 加 `skinlens-uniapp-v0.1.0-android.apk`(14.95MB,SHA-1 `12248f10…55b1`);notes 改双包对照表(大小/特点/SHA-1)。

### ✅ G. Pages 部署(2026-07-13,经用户同意的方案)
- `wrangler pages project create skin-checker-doc --production-branch=master` + `wrangler pages deploy dist`(产物直传,与 skin-checker H5 项目同模式,不连 git)。
- 线上验证:根 `301 → /zh/`,`/zh/ /en/ /og-image.png /robots.txt /sitemap-index.xml` 全 200;canonical/hreflang 指最终域;Playwright 线上首屏目检通过。
- ⚠️ 刚部署边缘未就绪时短暂 522,约 20s 后正常(非故障)。
- **剩用户侧**:dashboard → Pages → skin-checker-doc → Custom domains → 绑 `doc.skin.9shi.cc`(9shi.cc 已在 CF,自动出 CNAME)。

### 遗留(挂起项)
- ~~uniapp APK 出包后补传 Release + 启用第三卡~~ → **已完成(2026-07-13)**:APK 已上传 v0.1.0,`src/i18n/{zh,en}.ts` 第三卡去 disabled 填 `releases/latest`,重 build + Playwright 本地断言(三卡全 `<a>`)+ 重 deploy,线上抽查生效。
- dev server:父目录 `E:\code\github\.claude\launch.json` 已加 `skin-landing`(port 4321)。

## 验收

- ✅ 双语落地页线上可达(pages.dev),内容覆盖 功能/流程/下载/技术/合规。
- ✅ H5 与 APK 双入口可用(skin.9shi.cc / releases/latest 302 实测)。
- ⏳ `doc.skin.9shi.cc` 解析生效(等用户绑域后自验)。

## 📝 变更历史

| 日期 | 变更内容 | 修改人 |
|------|---------|--------|
| 2026-07-13 | 建 W4:landing/ Astro 双语落地页全量建成(8 组件 + SEO 全套 + 素材可再生);本地 build + Playwright 四组视口验证(修 hero 网格出血 7px 溢出);GitHub Release v0.1.0 挂 flutter APK(47.7MB + SHA-1);Pages 项目 skin-checker-doc 建成并部署,线上全路径验证通过;绑域 doc.skin.9shi.cc 留用户 | Claude |
| 2026-07-13 | uniapp APK 收尾:用户 HBuilderX 出包(14.95MB)→ 补传 Release v0.1.0(notes 改双包对照表)→ 第三卡启用(zh/en 去 disabled,cta 指 releases/latest,补测试证书句)→ build + Playwright 本地断言 → 重 deploy,线上抽查生效(zh「前往下载」×2 / en 无 Coming soon) | Claude |
| 2026-07-14 | 技术区架构文案随 W5 更新(zh/en 同步):archMid 改「Hono 统一 API · 双云部署:阿里云 FC(大陆直连)+ Cloudflare Workers(小程序/兜底)」;archBottom 三框改 D1/R2 标注 Workers 链路、千问 VL 标注 FC 同区域直连、新增「滥用防护 · per-IP 限流 + CORS 白名单」;points[2] 由「Cloudflare 边缘架构」整点替换为「双云双部署,一套业务」(原「H5 与 API 同域免 CORS」已不成立);build + dev server 双语双视口文案/几何断言 → 重 deploy(`3dfda63e.skin-checker-doc.pages.dev`),线上 zh/en curl 抽查生效 | Claude |
