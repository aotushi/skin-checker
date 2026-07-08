-- 皮肤检测历史:只存结构化结果,不存原图(见 ../docs/adr/0003-image-ephemeral-storage.md)。
-- report_json 存完整 SkinReport(契约 SSOT),另拆 code/name/time 三列供列表查询与排序。

CREATE TABLE IF NOT EXISTS reports (
  id             TEXT PRIMARY KEY,     -- crypto.randomUUID()
  created_at     INTEGER NOT NULL,     -- epoch 毫秒
  skin_type_code TEXT NOT NULL,        -- 派生码,如 O-S-F-P
  skin_type_name TEXT NOT NULL,        -- 派生中文名,如 油敏色皮
  report_json    TEXT NOT NULL         -- 完整 SkinReport JSON
);

CREATE INDEX IF NOT EXISTS idx_reports_created_at ON reports (created_at DESC);
