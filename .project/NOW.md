# NOW · skin-checker 当前状态

**最后更新:** 2026-06-17

## 阶段

🟡 **W1 进行中:server 骨架已跑通(`/health`,tsc / wrangler types / dry-run 验证过)。** 目录 / 规范 / 契约 / ADR 已落地。

## 下一步(W1)

server 起步已完成。续做:图片上传(R2)→ 通义千问 VL → JSON Schema 结构化输出 → 校验 → D1 历史。
详见 `tasks/W1-backend-pipeline.md`。

## 关键决策(指针)

- 契约共享:JSON Schema 单一真相源 → `docs/adr/0001-contract-sharing-json-schema-ssot.md`
- 只锁三端 → `docs/adr/0002-lock-three-targets.md`
- 图片用后即删 → `docs/adr/0003-image-ephemeral-storage.md`
- 工具链(Vite+ 统一 `vp`;Sentry→V2)→ `docs/adr/0004-toolchain.md`
- 前端样式 / 可访问性(a11y 分端、逻辑属性有限采纳无 polyfill)→ `docs/adr/0005-frontend-a11y-and-css-conventions.md`

## 备注

项目3 为**非冲刺项**(当前优先级为 P0 就业冲刺包)。本骨架可随时暂停,W1 待排期。
