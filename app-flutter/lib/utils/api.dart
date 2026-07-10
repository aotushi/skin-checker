// server 联调(W3 切片 D):multipart 传图到 /analyze,返回报告 envelope { id, createdAt, report }。
// API_BASE:debug 运行 = 本地 wrangler dev(pnpm dev --port 8890),release 构建 = 线上 skin.9shi.cc;
// server 挂 basePath('/api'),两处都带 /api 后缀 —— 对齐 app-uni utils/api.ts 的 DEV/build 切换。
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/skin_report.dart';

const _apiBase = kDebugMode
    ? 'http://127.0.0.1:8890/api'
    : 'https://skin.9shi.cc/api';

class AnalysisEnvelope {
  const AnalysisEnvelope({
    required this.id,
    required this.createdAt,
    required this.report,
  });

  final String id;
  final int createdAt; // 毫秒时间戳(server 侧生成)
  final SkinReport report;
}

/// 分析失败(422 质检指引 / 非 200 / 网络异常),[message] 可直接进 SnackBar。
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// 上传正脸照到 /analyze;成功返回 envelope,失败抛 [ApiException]。
Future<AnalysisEnvelope> requestAnalyze(
  Uint8List bytes,
  String filename, [
  String? mimeType,
]) async {
  http.StreamedResponse res;
  try {
    final request =
        http.MultipartRequest('POST', Uri.parse('$_apiBase/analyze'))
          ..files.add(
            // image 字段名与 server parseBody 对齐;contentType 必须 image/*
            // (dart http 默认 octet-stream 会被 server 400「仅支持图片」拒)
            http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: filename,
              contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
            ),
          );
    res = await request.send();
  } catch (_) {
    throw const ApiException('网络异常,请检查连接后重试');
  }
  final body = await res.stream.bytesToString();
  Map<String, dynamic> data = const {};
  try {
    data = jsonDecode(body) as Map<String, dynamic>;
  } catch (_) {
    // 非 JSON 响应按通用错误走下方失败分支
  }
  if (res.statusCode == 200 && data['id'] is String && data['report'] != null) {
    return AnalysisEnvelope(
      id: data['id'] as String,
      createdAt: (data['createdAt'] as num?)?.toInt() ?? 0,
      report: SkinReport.fromJson(data['report'] as Map<String, dynamic>),
    );
  }
  throw ApiException((data['error'] as String?) ?? '分析失败(${res.statusCode})');
}
