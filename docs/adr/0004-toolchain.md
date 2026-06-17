# ADR 0004:工具链(Vite+ 统一入口;构建走 Vite;Dart 端独立;Sentry 下沉 V2)

- **状态:** 已采纳
- **日期:** 2026-06-16(2026-06-17 修订:Vite+ 由"不引入"改为"统一采纳",理由见背景)

## 背景

确定三端的构建 / lint / 格式化 / 测试 / 类型检查 / 监控工具,避免后期混栈。

- VoidZero(Vite / Vitest / Rolldown / Oxc / Oxlint / Oxfmt 母公司)于 **2026-06-04 被 Cloudflare 收购**,与本项目 Workers 后端**同源同厂**。
- **Vite+(`vp` CLI)** 是 VoidZero 把 Vite、Vitest、Oxlint、Oxfmt、Rolldown、tsdown、tsgo、运行时/包管理统一到一个入口的工具链产品;2026-03-13 起 alpha。
- 关键变化:Vite+ **已放弃原定的商业付费模式,改为完全 MIT 开源免费**,先前"避免 Vite+"的授权顾虑消失。
- 之前单列的 Oxlint / Oxfmt / Vitest **本就是 Vite+ 的组成部分**,分开装 = 手动拼装 Vite+ 的子集 → 统一收敛到 Vite+。

## 决策

### TS 两端(`server` / `app-uni`):统一用 Vite+ `vp`

| 关注点 | Vite+ 入口 | 底层 |
| --- | --- | --- |
| 运行时 / 包管理 | `vp env` / `vp install` | Node + pnpm |
| 开发 | `vp dev` | Vite |
| **构建** | `vp build` | **Vite(Rolldown + Oxc)** |
| Lint + Format + 类型检查 | `vp check` | Oxlint + Oxfmt + tsgo |
| 测试 | `vp test` | Vitest |

构建仍是 Vite —— `vp build` 即 Vite(Rolldown)产线,与"构建走 Vite"一致;Vite+ 只是把它和 lint/format/test/类型检查收进同一 CLI 与同一份根 `vite.config.ts`。

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
