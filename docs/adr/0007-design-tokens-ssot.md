# ADR 0007:设计 token 单一真相源(shared/design-tokens.json,DTCG 格式)

- **状态:** 已采纳
- **日期:** 2026-07-06

## 背景

UI 设计迭代出一套暖调美妆视觉(暖米渐变 / 玫瑰陶土 / 香槟金 + Fraunces 衬线仅用于数字),散落在若干 `show_widget` mockup 里。接下来 uniapp(H5 / 小程序)与 flutter 两端要落地同一套视觉。

若两端各自写色板 / 字号,必然漂移(改一处忘另一处),与 ADR 0001 为结果契约立的 SSOT 精神相悖。视觉常量本质和数据契约一样,需要一处真相源。

## 决策

新增 `shared/design-tokens.json` 作为**设计 token 的唯一定义**,与 `skin-report.schema.json` 并列同级:

- **格式:** DTCG(Design Token Community Group)—— 每个 token 为 `{ $value, $type?, $description? }`,分组 color / gradient / typography / radius / space / shadow。选 DTCG 而非私有 JSON,因它是 token 领域标准、`$description` 自带语义、且被工具链原生消费。
- **两端派生:** H5 / 小程序 → CSS 变量 / SCSS;flutter → Dart 常量。改 token 只改此文件,禁止手改生成产物 —— 与 schema→类型的机制同款。
- **生成工具待接入:** 候选 Style Dictionary(v4 支持 DTCG,一份出 SCSS + Dart),倾向采用;两端尚为空壳,scaffold(W2 / W3)时接入,在那之前先只维护 JSON —— 与 schema「生成命令待 scaffold 接入」同节奏。
- **复合值务实存储:** 渐变存起止色 + 角度记 `$description`,阴影存可直接用于 H5 的串;两端各自拼 `linear-gradient` / `LinearGradient`、`box-shadow` / `BoxShadow`。不为 MVP 追 DTCG 复合类型的严格建模。

## 理由

- **防漂移:** 一处改、两端生成,延续 ADR 0001。
- **标准格式:** DTCG 让 token 可被 Style Dictionary 等直接消费,作品也体现 design system 工程化,而非硬编码色值。
- **不过度:** 不立即装依赖、不为空壳目录生成、复合值务实处理 —— SSOT 先立、值先定,工具留到 scaffold。

备选:① 两端各写常量(否决 —— 必漂移);② 私有精简 JSON(否决 —— 放弃标准工具链与语义);③ 立即上 Style Dictionary 并生成(否决 —— 两端空壳无目标,过早)。

## 后果

- ➕ 视觉常量单一真相源、两端不漂移、格式标准、留清晰接入点。
- ➖ 多一份需维护的文件;半档微调(11.5 / 12.5 等 mockup 值)不入 token,落地靠就近档位取整。
- ⚠️ 生成工具(Style Dictionary)与 scss / dart 产物 W2 / W3 才落地;在此之前两端若需取值,以本 JSON 为准手工对齐,不得反向以端上硬编码为准。
- **2026-07-06(W2 落地更新):** app-uni 端**未上 Style Dictionary**,改用轻量自写脚本 `app-uni/scripts/gen-design-tokens.mjs`(`pnpm gen:tokens`)把本 JSON 展平为 `src/styles/tokens.scss` 的 CSS 变量(`--skn-*`)。理由:DTCG 展平逻辑很短、免依赖、与 server 的 `gen-skin-type-map.mjs` 同款约定。Style Dictionary 仍留作 flutter 端(W3)接 Dart 产物、需「一份出 SCSS+Dart」时的候选,届时再评估替换。
- 延续 ADR 0001 SSOT 精神,作用域为视觉 token(与结果契约正交)。
