# server · Cloudflare Workers + Hono(三端共享后端)

🟡 **W1 起步:最小骨架已建(`/health`)。** 完整链路见 `../.project/tasks/W1-backend-pipeline.md`。

## 栈

- Cloudflare Workers + Hono
- D1(历史,只存结构化结果)+ R2(图片临时,分析后即删,见 `../docs/adr/0003-image-ephemeral-storage.md`)
- AI:通义千问 VL(OpenAI 兼容)/ Gemini
- 输出以 `../shared/skin-report.schema.json` 约束 + 校验

## 本地开发

```bash
pnpm install
pnpm typegen      # = wrangler types,生成 worker-configuration.d.ts(Env 类型,勿手写)
pnpm dev          # = wrangler dev,本地起 workerd;访问 /health 自检
```

## 密钥

- 千问VL key:`wrangler secret put QWEN_API_KEY`(远程)/ `.dev.vars`(本地,不入库)。
- 本地模板见 `.dev.vars.example`。

## 当前进度(W1)

- [x] scaffold:Workers + Hono + `/health`
- [ ] 图片上传 → R2 临时对象
- [ ] 千问VL 多模态分析 + schema 约束结构化输出
- [ ] ajv 校验 LLM 返回
- [ ] D1 建表 + 写入 / 读取历史
