// 本地检测历史(shared_preferences,JSON 字符串整存整取):对齐 app-uni utils/history.ts。
// 存完整 envelope({id, createdAt, report}):回看不再请求后端,列表要 code/名/时间也都在 report 里。
// 历史仅存设备本地(契合「我的」页「本地保存」承诺);D1 的 /history 留给 V2 登录后同步。
// 与 uni 版差异:flutter 导航直传 HistoryItem 对象回看,不走路由 query,故无需按 id 查询的 getHistoryItem。
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/skin_report.dart';

const _key = 'skn_history';
const _max = 20; // 与后端 listHistory 默认条数对齐,超出淘汰最旧

class HistoryItem {
  const HistoryItem({
    required this.id,
    required this.createdAt,
    required this.report,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
    id: json['id'] as String,
    createdAt: (json['createdAt'] as num).toInt(),
    report: SkinReport.fromJson(json['report'] as Map<String, dynamic>),
  );

  final String id;
  final int createdAt; // 毫秒时间戳
  final SkinReport report;

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt,
    'report': report.toJson(),
  };
}

/// 全部历史(已按新→旧存序,直接返回);存储缺失/损坏一律按无历史处理
Future<List<HistoryItem>> listHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_key);
  if (raw == null) return [];
  try {
    return [
      for (final e in jsonDecode(raw) as List)
        HistoryItem.fromJson(e as Map<String, dynamic>),
    ];
  } catch (_) {
    return [];
  }
}

/// 存一条到队头,超 MAX 淘汰最旧;新分析沿用 server 的 id/createdAt,缺省本地生成
Future<HistoryItem> saveHistory(
  SkinReport report, {
  String? id,
  int? createdAt,
}) async {
  final item = HistoryItem(
    id: id ?? _genId(),
    createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
    report: report,
  );
  final list = [item, ...await listHistory()].take(_max);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_key, jsonEncode([for (final it in list) it.toJson()]));
  return item;
}

/// 本地 id(时间基36 + 6 位随机段,对齐 uni genId):仅作列表 key/去重用,非安全场景
String _genId() {
  final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
  final rand = Random().nextInt(1 << 31).toRadixString(36).padLeft(6, '0');
  return '$ts-${rand.substring(0, 6)}';
}
