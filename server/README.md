# server · Cloudflare Workers + Hono(三端共享后端)

⬜ **待 W1 scaffold。** 见 `../.project/tasks/W1-backend-pipeline.md`。

- 栈:Cloudflare Workers + Hono + D1(历史)+ R2(图片临时)
- AI:通义千问 VL(OpenAI 兼容)/ Gemini
- 输出契约以 `../shared/skin-report.schema.json` 约束 + 校验
- 密钥走 `wrangler secret` / `.dev.vars`(不入库)
