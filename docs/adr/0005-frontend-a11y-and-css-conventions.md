# ADR 0005:前端样式与可访问性约定(a11y 分端原则;CSS 逻辑属性有限采纳,不引 polyfill)

- **状态:** 已采纳
- **日期:** 2026-06-17

## 背景

三端 UI 编码有两个横切关注点要先定调,避免 W2 写 `app-uni` / W3 写 `app-flutter` 时临时拍脑袋或过度工程:① 可访问性(a11y);② CSS 逻辑属性(`inline-size`/`block-size`/`margin-inline` 等)。

决策前核实到的关键事实:

- CSS 逻辑属性 `inline-size`/`block-size` 自 **2021 即 Baseline widely available**(~95%+),2026 **无需 polyfill / `postcss-logical`**。
- 逻辑属性的核心价值是 **RTL / 多书写方向 i18n**;本项目中文为主、三端锁国内,**无 RTL 需求**。
- 微信 **Skyline 渲染引擎不支持** `margin-inline-*`/`padding-inline-*`(控制台报警告 —— Skyline 是原生模拟、非真 CSS);`inline-size`/`block-size` 在 Skyline 支持状态官方表未明确。仅 WebView 模式取决于内核、现代可用。
- 选定的 **Oxlint(jsx-a11y)只作用于 `<script>`/JSX,不检查 Vue `<template>`**(oxc#15761);唯一能 lint Vue 模板 a11y 的 `eslint-plugin-vuejs-accessibility` 属 ESLint 生态,与 ADR 0004「不引 ESLint」冲突。

## 决策一:可访问性走「分端原则 + 人工 checklist」

| 端 | a11y 落地 |
| --- | --- |
| H5 | 语义化标签(`button`/`nav`/`main`…)+ 关键交互补 `aria-label`/`role`;图片 `alt`、表单 label 关联 |
| flutter | 用 `Semantics` widget(`label`/`button`/`image` 等)包裹关键控件 —— Flutter 原生无障碍 API,**非 ARIA** |
| 微信小程序 | 组件支持的 `aria-role`/`aria-label` 尽力补,不为其勉强全覆盖 |

- **自动校验:MVP 不引。** Oxlint 不覆盖 Vue `<template>`(oxc#15761),而能覆盖的 `eslint-plugin-vuejs-accessibility` 会把 ESLint 拖回来、违背 ADR 0004。故 W2 起靠**约定 + PR / 人工 checklist**。**复查点**:oxc#15761 补齐 Vue 模板 a11y 后,回收到 `vp check`(与 ADR 0004 测试池 #13001 一并跟)。
- **目标度**:关键路径(拍照按钮、结果可读、免责声明)可达可读即可,**不追 WCAG AA 全覆盖**(MVP showcase 阶段)。

## 决策二:CSS 逻辑属性「有限采纳,不引 polyfill」

- **不引 polyfill / `postcss-logical`** —— `inline-size`/`block-size` 等 2021 起 Baseline,无需。
- **H5 端**:**推荐**逻辑属性(`inline-size`/`block-size`/`margin-block`/`padding-inline` 等)作现代写法,**不强制**,可与 `width`/`height` 并存。
- **微信小程序端**:**避开**逻辑属性(Skyline 不支持 `margin-inline-*`/`padding-inline-*`,`inline-size`/`block-size` 状态未明),用物理属性 / uniapp `rpx`,差异用条件编译(`#ifdef MP-WEIXIN`)隔离。
- **flutter 端**:无 CSS;方向感知用 `EdgeInsetsDirectional`,与本约定无 PostCSS 关联。
- **定位**:逻辑属性主价值(RTL)本项目用不上,采纳**仅为统一现代写法**、非功能需求 → 不强制、不为它增构建链。

## 明确不做

- ❌ `postcss-logical` / 任何逻辑属性 polyfill。
- ❌ `eslint-plugin-vuejs-accessibility`(及随之而来的 ESLint)—— 除非 oxc 长期不补 Vue 模板 a11y 且后续判定必须自动门禁,届时另开 ADR 记例外。
- ❌ WCAG AA 全量合规(MVP 阶段)。

## 后果 / 注意

- ➕ a11y 有据可循、H5 / flutter 各用对的 API;CSS 写法现代但不过度工程。
- ⚠️ a11y **无自动门禁**,靠人工 —— W2 起落实 PR checklist;oxc#15761 复查点同 ADR 0004。
- ⚠️ 小程序逻辑属性是**禁区**:code review 注意别把 H5 带 `*-inline-*` 的样式直接复制过去。
