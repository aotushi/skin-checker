# shared · 契约单一真相源(Single Source of Truth)

`skin-report.schema.json` 是**皮肤分析结果契约的唯一定义**。三端 + LLM 全部从它派生,改契约只改这一处。

决策记录见 `../docs/adr/0001-contract-sharing-json-schema-ssot.md`。

## 一份 schema,四个用途

1. **约束千问VL 输出** —— 作为结构化输出(JSON Schema)的 schema 传给多模态 LLM,保证它吐对结构。
2. **后端校验** —— `server/` 用它(如 ajv)校验 LLM 返回值。
3. **生成 uniapp 类型(TypeScript)**
4. **生成 flutter 类型(Dart)**

## 生成命令(待各端骨架建好后接入)

> 现在 `app-uni/`、`app-flutter/` 还是空壳,以下命令在对应端 scaffold 后再跑。

```bash
# → uniapp(TypeScript)
npx json-schema-to-typescript shared/skin-report.schema.json \
  -o app-uni/src/types/skin-report.ts

# → flutter(Dart)
npx quicktype --src-lang schema shared/skin-report.schema.json \
  -l dart -o app-flutter/lib/models/skin_report.dart
```

## 规则

- 改契约 → **只改 `skin-report.schema.json`** → 重新跑上面两条生成命令。
- **禁止**手改生成出来的 `skin-report.ts` / `skin_report.dart`(下次生成会覆盖)。
- 建议把生成命令固化进各端 `package.json` 的 `scripts`(如 `gen:types`),W1/W3 落地时补。
