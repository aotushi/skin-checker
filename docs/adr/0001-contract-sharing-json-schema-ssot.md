# ADR 0001:契约共享采用 JSON Schema 单一真相源

- **状态:** 已采纳
- **日期:** 2026-06-16

## 背景

结果契约(`skinType` / `confidence` / `zones` / `suggestions` / `disclaimer`)需在三处共用:`server`(TS)、`app-uni`(TS)、`app-flutter`(Dart,跨语言)。三处各自手写类型会导致**契约漂移**(改一处漏改两处 → 某端崩或显示错)。

## 决策

以 `shared/skin-report.schema.json`(JSON Schema,语言中立)为**单一真相源**:

- 后端用它约束千问VL 结构化输出 + 校验返回值;
- `app-uni` 用 `json-schema-to-typescript` 生成 TS 类型;
- `app-flutter` 用 `quicktype` 生成 Dart 类型。

## 理由

关键不在"防漂移"(契约较小),而在 **schema 为约束 LLM 输出本就必须存在**(需求文档 4.5)。既然必然存在,顺手生成两端类型几乎零成本,且兑现简历讲点"前后端共用一份结果契约"。

备选方案:

1. 后端 TS 为真相、两端手写 —— 零工具但易漂移。
2. OpenAPI 全栈生成 —— 连 API client 一起生成,但对 MVP 偏重。

均不如本方案契合本项目。

## 后果

- ➕ 改契约只动一处;两端类型自动一致;LLM 输出有 schema 兜底。
- ➖ 引入 `json-schema-to-typescript` / `quicktype` 两个生成工具 + 一个生成步骤(需固化进各端 `scripts`,禁止手改生成产物)。
