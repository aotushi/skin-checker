# landing · 项目落地页(doc.skin.9shi.cc)

> Astro 5 静态站,中英双语介绍页。结构参考 `resume/site-extensions/e1-google-ad-timing-probe/landing/`,视觉复用 `shared/design-tokens.json` 关键色(暖调美妆,与应用端同源)。

## 命令

```bash
pnpm install
pnpm dev          # http://localhost:4321(父目录 launch.json 有 skin-landing 配置)
pnpm build        # 产物 dist/(/zh/ /en/ + robots.txt + sitemap)
```

## 结构

- `src/i18n/zh.ts` — 全站文案单一来源(`en.ts` 用 `Strings` 类型对齐)
- `src/layouts/Base.astro` — SEO head 全套(canonical / hreflang x-default→zh / OG / JSON-LD)+ 全局样式 token
- `src/components/` — Nav / Hero(双机位)/ Features / HowItWorks / Download / TechStack / Compliance / Footer
- `public/_redirects` — 根路径 CDN 级 301 → `/zh/`(dev 由 `src/pages/index.astro` 兜底)
- `public/shots/` — 线上 H5 真截(Playwright 390×844,注入隐藏滚动条 CSS)
- `og-src.html` — og-image.png 生成源(1200×630),改后用 Playwright 重截即可再生

## 部署

Cloudflare Pages 项目 **skin-checker-doc**(production branch: master),产物直传:

```bash
pnpm build
npx wrangler pages deploy dist --project-name=skin-checker-doc --branch=master
```

自定义域 `doc.skin.9shi.cc` 在 dashboard 绑定(Pages 项目 → Custom domains)。

## 合规口径

全程「参考 / 建议」,不得诊断 / 疗效宣称;免责文案与 `shared/skin-report.schema.json` 的 `disclaimer` 一致。下载三卡(H5 / flutter APK / uniapp APK)已全部启用,APK 均指 GitHub Release `releases/latest` 固定链;发新版 APK 只需发新 Release tag,落地页无需改版。
