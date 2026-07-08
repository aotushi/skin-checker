# ADR 0004:工具链(Vite+ 统一入口;构建走 Vite;Dart 端独立;Sentry 下沉 V2)

- **状态:** 已采纳
- **日期:** 2026-06-16(2026-06-17 修订:Vite+ 由"不引入"改为"统一采纳",理由见背景;**2026-07-06 再修订:app-uni 改用 uniapp 自带 `uni` CLI、Vite+ 收窄到 `server`**,见「决策」开头)

## 背景

确定三端的构建 / lint / 格式化 / 测试 / 类型检查 / 监控工具,避免后期混栈。

- VoidZero(Vite / Vitest / Rolldown / Oxc / Oxlint / Oxfmt 母公司)于 **2026-06-04 被 Cloudflare 收购**,与本项目 Workers 后端**同源同厂**。
- **Vite+(`vp` CLI)** 是 VoidZero 把 Vite、Vitest、Oxlint、Oxfmt、Rolldown、tsdown、tsgo、运行时/包管理统一到一个入口的工具链产品;2026-03-13 起 alpha。
- 关键变化:Vite+ **已放弃原定的商业付费模式,改为完全 MIT 开源免费**,先前"避免 Vite+"的授权顾虑消失。
- 之前单列的 Oxlint / Oxfmt / Vitest **本就是 Vite+ 的组成部分**,分开装 = 手动拼装 Vite+ 的子集 → 统一收敛到 Vite+。

## 决策

> **⚠️ 2026-07-06 修订(app-uni 工具链,优先级高于下方原表述):** 实测确认 uniapp 多端编译(H5 / 微信小程序)**必须走它自带的 `uni` CLI**(`@dcloudio/vite-plugin-uni` 驱动,底层钉死 Vite 5 + Rollup);Vite+ 的 Rolldown 会打断针对 Rollup 写的 uni 插件链。故 **`app-uni` 不采纳 Vite+ `vp`**,改用:
>
> - **dev / build / 多端编译** → `uni` CLI(`uni`、`uni build`、`uni -p mp-weixin`、`uni build -p mp-weixin`,见 `app-uni/package.json`)
> - **类型检查** → `vue-tsc --noEmit`(tsgo 对 `.vue` SFC 支持未就绪)
> - **样式 / 生成** → `sass` + `pnpm gen:tokens`(`design-tokens.json` → `src/styles/tokens.scss`)、`pnpm gen:types`(schema → `src/types/skin-report.ts`);两脚本仿 server 的 `gen-skin-type-map.mjs`,不引重型工具
> - **版本敏感**:钉死 DCloud 预设版本(`3.0.0-408…` / vite `5.2.8`),不擅自升级
>
> **净结果:Vite+ `vp` 收窄到只服务 `server` 端**(server 构建 / dev / 部署本就走 wrangler,`vp` 仅备用于 `vp check` 与待 #13001 的测试)。下方"TS 两端统一 Vite+"表中 **app-uni 部分作废**,server 部分维持。

### TS 两端(`server` / `app-uni`):统一用 Vite+ `vp`

| 关注点 | Vite+ 入口 | 底层 |
| --- | --- | --- |
| 运行时 / 包管理 | `vp env` / `vp install` | Node + pnpm |
| 开发 | `vp dev` | Vite |
| **构建** | `vp build` | **Vite(Rolldown + Oxc)** |
| Lint + Format + 类型检查 | `vp check` | Oxlint + Oxfmt + tsgo |
| 测试 | `vp test` | Vitest |

构建仍是 Vite —— `vp build` 即 Vite(Rolldown)产线,与"构建走 Vite"一致;Vite+ 只是把它和 lint/format/test/类型检查收进同一 CLI 与同一份根 `vite.config.ts`。

> **`server` 例外(W1 落地校准)**:`server` 是 Cloudflare Workers,构建 / 本地 dev / 部署走 `wrangler`(内置 esbuild),**不走 `vp build` / `vite`**;`vp` 在 server 端只用于 `vp check`(lint/format/类型)与(待 #13001)测试。`vp build` / `vp dev` / `vite.config.ts` 主要服务 `app-uni`。

### ⚠️ 唯一例外:`server` 测试池

`@cloudflare/vitest-pool-workers` 在 workerd 内跑 Vitest,会 import `vitest/worker` 子路径,而 Vite+ 的测试层(`@voidzero-dev/vite-plus-test`)当前未 re-export 该子路径 → 运行期 `No such module "vitest/worker"`(workers-sdk Issue #13001,截至本 ADR **未确认修复**)。

- **缓解:** `server` 端测试**暂不走 `vp test`**,用原版 `vitest` + `@cloudflare/vitest-pool-workers`;`app-uni` 用 `vp test` 无碍。
- 收购后 pool 与 Vite+ 测试层同属 Cloudflare,#13001 已被官方跟踪,预期收敛;接 `server` 测试时(W1 或之后)复查该 issue,若已修则统一回 `vp test`。

### `app-flutter`(Dart,独立工具链)

`dart format` + `flutter analyze`(配 `flutter_lints` 或 `very_good_analysis`)+ `flutter test`。
**Vite+ / oxc 均 JS/TS only,不适用 Dart。**

### 监控 / 可观测性

- **MVP 不引入 Sentry。** 理由:① `server` 用 Cloudflare 原生 observability(Workers Logs / Tail / `observability` 配置)已够;② showcase 阶段无真实用户,YAGNI;③ 三端各接一套 SDK + DSN,成本与一个月节奏不匹配。
- **下沉 V2**:小程序正式发布 / APK 分发、有真实用户后,再上 Sentry(尤其 flutter 崩溃上报 + 前端错误)。

## 明确不引入

- **ESLint / Prettier** —— 已被 `vp check`(Oxlint/Oxfmt)取代,不并存。
- **Biome** —— oxc 竞品,与 Vite+ 功能重叠。
- **Turborepo / Nx** —— 本项目平铺多端、各自独立 git 仓、无 workspace 根;真要编排有 `vp run`,当前用不上。

## 后果 / 注意

- ➕ 全栈 Vite+/Cloudflare 同源,一个 `vp` 管 dev/build/check/test,亦为简历讲点。
- ⚠️ **Vite+ 仍 alpha**(非 GA):`package.json` 钉死版本,勿用 `^`;升级前看 changelog。
- ⚠️ **`server` 测试**走原版 vitest pool(见上),非 `vp test`,直到 #13001 修复。
- ⚠️ `app-uni` 的 `.vue`:Oxfmt 格式化 与 tsgo 对 SFC 的类型检查支持需在接入时实测;模板类型检查不行则补 `vue-tsc`,格式化不行则该部分暂用 Prettier 兜。
