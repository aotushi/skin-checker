# skin-checker · 项目约定

> AI 肤质参考助手(uniapp + flutter 双端,共享 CF 后端)。需求见 `resume/docs/求职准备项目需求文档-V0.1/02-projects/03-皮肤检查工具-uniapp-flutter双端.md`。

## 数据安全(继承父级)

- **严禁**自动执行远程数据库变更(任何带 `--remote` 的 `wrangler d1` 命令)。
- 必须先本地验证,再明确征得用户同意才能操作远程。

## 契约单一真相源(重要)

- 结果契约的唯一定义 = `shared/skin-report.schema.json`。
- 改契约**只改这个文件**,然后重新生成两端类型(命令见 `shared/README.md`)。
- **禁止**手改各端生成出来的类型文件;后端 LLM 输出也以此 schema 约束 + 校验。

## 合规文案规则(贯穿所有端)

- 定位"参考/建议",**不得**出现疾病诊断、疗效、治疗等宣称。
- 免责声明**收敛到结果页一处**展示(详见 `docs/adr/0008`;文案见 `shared/skin-report.schema.json` 的 `disclaimer` 字段);启动页不再强制。「我的 → 免责声明」为可点查看的完整声明入口,与 inline note 不同,保留。

## 三端打包范围

- 只锁 **H5 / 微信小程序 / Android APK**,其它端口不适配、不处理。
- **APK 双栈**:flutter 出 APK,uniapp **也**出 App(APK)手机/平板装机(2026-07-08,见 ADR 0009);uniapp 编译目标 = H5 / 微信小程序 / App。
- uniapp 端差异用条件编译补齐(`#ifdef MP-WEIXIN / H5 / APP-PLUS`,APP-PLUS 现启用),不为未覆盖端做响应式/兼容。
- **平板(大屏)**:用一层 CSS max-width 容器限宽居中(600px),不做多列响应式;`maxWidth` 配置项仅 H5、rpx 封顶字段 Vue3 App 存疑,故走 CSS 容器(见 ADR 0009)。

## 密钥管理

- 通义千问 VL 等 API key 走 `wrangler secret` / `.dev.vars`(**不入库**,已在 `.gitignore`)。

## 图片处理

- 用户上传图片**分析后即删**(R2 临时对象设过期 / 用后删),不长期存储。

## 工具链(详见 docs/adr/0004-toolchain.md)

- **app-uni(uniapp)**:用 uniapp **自带 `uni` CLI** —— `uni` / `uni build`(H5)、`uni -p mp-weixin` / `uni build -p mp-weixin`(小程序);类型 `vue-tsc --noEmit`;样式 `sass` + `pnpm gen:tokens`(design-tokens→tokens.scss)、`pnpm gen:types`(schema→类型)。**不走 Vite+**(Rolldown 会打断针对 Rollup 的 uni 插件链);DCloud 预设版本钉死勿升。(2026-07-06 定,见 ADR 0004 修订)
- **server(Workers)**:构建 / dev / 部署走 `wrangler`;**Vite+ `vp` 收窄到只服务 server**,仅备用于 `vp check` 与(待 workers-sdk #13001)测试 —— 测试暂用原版 `vitest` + `@cloudflare/vitest-pool-workers`。
- **app-flutter(Dart)**:`dart format` + `flutter analyze` + flutter test。**Vite+/oxc 不适用 Dart**。
- **Vite+ 仍 alpha**:`package.json` 钉死版本,勿用 `^`。
- **不引入**:ESLint/Prettier、Biome、Turborepo/Nx(已被 `vp` 覆盖或本项目用不上)。
- **监控**:MVP 不上 Sentry,靠 CF 原生 observability;Sentry 下沉 V2。

## 前端样式与可访问性(详见 docs/adr/0005-frontend-a11y-and-css-conventions.md)

- **可访问性(a11y)**:分端落地 —— H5 语义化标签 + 关键交互补 `aria-label`/`role`;flutter 用 `Semantics` widget(**非 ARIA**);微信小程序 `aria-*` 尽力而为。MVP **不引自动 a11y lint**(Oxlint 不覆盖 Vue `<template>`,oxc#15761;不为此引 ESLint),靠**约定 + 人工 checklist**;关键路径(拍照 / 结果 / 免责声明)可达可读即可,不追 WCAG AA 全覆盖。
- **CSS 逻辑属性**:H5 端推荐 `inline-size`/`block-size` 等现代写法(**不强制**);**不引 polyfill**(2021 起 Baseline)。**微信小程序避开** `margin-inline-*`/`padding-inline-*`(Skyline 不支持、报警告),用物理属性 / `rpx` + 条件编译兜;flutter 用 `EdgeInsetsDirectional`。

## 自维护文档链(继承 resume 约定)

修改代码后按链路更新:`代码注释 → .project/tasks/ → .project/NOW.md → README.md`。
