<!-- 🔄 自维护文档:修改任务内容时,必须更新"最后更新"和"变更历史" -->

# W1 · CF 后端核心链路

**最后更新:** 2026-06-17
**状态:** ⬜ 未开始

## 目标

跑通后端 demo:图片上传 → 多模态分析 → 结构化结果 → 历史落库。

## 范围

- [ ] `server/` scaffold:Cloudflare Workers + Hono(`wrangler.toml`、`.dev.vars`)
- [ ] 图片上传接口 → R2 临时对象(用后即删,见 ADR 0003)
- [ ] 调通义千问 VL 多模态分析,传入 `shared/skin-report.schema.json` 约束结构化输出
- [ ] 用 schema 校验 LLM 返回值(如 ajv)
- [ ] D1 建表 + 写入历史(只存结构化结果,不存原图)
- [ ] 本地 `wrangler dev` 验证全链路(远程操作需用户同意)

## ⚠️ 注意

- **schema 喂 LLM 的关键字兼容**:`confidence` / `score` 的 `minimum` / `maximum` 在 OpenAI 严格 `json_schema` 模式**不被支持**(`enum` 支持)。千问VL 兼容接口若走 strict 会被拒。先实测;不吃则降级为 JSON mode + ajv 后校验(schema 保留 min/max 给 ajv 用,不动)。

## 验收

- 一张正脸照 → 返回符合 `skin-report.schema.json` 的结果 JSON。
- 历史接口能读回该条记录。

## 📝 变更历史

| 日期 | 变更内容 | 修改人 |
|------|---------|--------|
| 2026-06-16 | 创建任务,W1 范围与验收 | Claude |
| 2026-06-17 | 补 schema 喂 LLM 的 min/max strict 兼容注意 | Claude |
