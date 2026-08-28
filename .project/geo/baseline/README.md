# 基线记录(优化前)

每次测试一个证据文件:`<query_id>-<platform>-r<run_no>.md`(如 `T1-perplexity-r1.md`),按下方模板填写;`records.csv` 为汇总表,字段顺序与表头一致。未出现品牌、无 Citation 的结果同样入库。

## 单条证据模板

```markdown
---
query_id: T1
query: (逐字)
language: zh
intent: tool-discovery | method | understanding | action | entity-probe
platform: chatgpt | gemini | perplexity
model: (界面可见值;不可见写 default)
tested_at: 2026-08-25T00:00+08:00
region: (出口地区)
web_enabled: yes | no | auto-triggered
run_no: 1
brand_mentioned: yes | no
recommended: yes | no | n/a
citation_urls: (逐条;无则 none)
competitors: (回答中出现的其它工具/品牌;无则 none)
notes: (推荐理由、排序位置、异常)
---

## 回答摘录
(全文或关键段落)

## 引用列表
(平台展示的 citation 原样抄录:标题 + URL)
```
