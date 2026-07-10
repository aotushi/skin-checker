// To parse this JSON data, do
//
//     final skinReport = skinReportFromJson(jsonString);

import 'dart:convert';

SkinReport skinReportFromJson(String str) =>
    SkinReport.fromJson(json.decode(str));

String skinReportToJson(SkinReport data) => json.encode(data.toJson());

///皮肤分析结果契约 —— 三端共用 + 千问VL 结构化输出约束的单一真相源。分类体系(16型四维度)见 docs/adr/0006。
class SkinReport {
  ///免责声明标准文案(收敛到结果页一处展示,详见 docs/adr/0008):本结果由 AI 生成,仅供护肤参考,不构成医疗建议,严重皮肤问题请就医。
  String disclaimer;

  ///16型肌肤四维度,每维度自带判定值 + 独立置信度(详见 docs/adr/0006)
  SkinAxes skinAxes;

  ///四维派生码,如 O-S-F-P(后端按 skinAxes 拼出,两端直接渲染,不各自查表)
  String skinTypeCode;

  ///四维派生中文名,如 油敏色皮(后端按 16 型映射派生)
  String skinTypeName;

  ///护肤建议(按判定型号取该型护理思路,仅到成分/品类层,不含具体品牌/品名)
  List<String> suggestions;

  ///分区评估(部位问题点,与 16 型整脸分型正交互补)
  List<Zone> zones;

  SkinReport({
    required this.disclaimer,
    required this.skinAxes,
    required this.skinTypeCode,
    required this.skinTypeName,
    required this.suggestions,
    required this.zones,
  });

  factory SkinReport.fromJson(Map<String, dynamic> json) => SkinReport(
    disclaimer: json["disclaimer"],
    skinAxes: SkinAxes.fromJson(json["skinAxes"]),
    skinTypeCode: json["skinTypeCode"],
    skinTypeName: json["skinTypeName"],
    suggestions: List<String>.from(json["suggestions"].map((x) => x)),
    zones: List<Zone>.from(json["zones"].map((x) => Zone.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "disclaimer": disclaimer,
    "skinAxes": skinAxes.toJson(),
    "skinTypeCode": skinTypeCode,
    "skinTypeName": skinTypeName,
    "suggestions": List<dynamic>.from(suggestions.map((x) => x)),
    "zones": List<dynamic>.from(zones.map((x) => x.toJson())),
  };
}

///16型肌肤四维度,每维度自带判定值 + 独立置信度(详见 docs/adr/0006)
class SkinAxes {
  ///痘痘情况
  Acne acne;

  ///油脂分泌
  OilDry oilDry;

  ///色沉情况
  Pigment pigment;

  ///敏感程度(单张照片判定较不稳,通常低置信,前端以「参考」呈现)
  Sensitivity sensitivity;

  SkinAxes({
    required this.acne,
    required this.oilDry,
    required this.pigment,
    required this.sensitivity,
  });

  factory SkinAxes.fromJson(Map<String, dynamic> json) => SkinAxes(
    acne: Acne.fromJson(json["acne"]),
    oilDry: OilDry.fromJson(json["oilDry"]),
    pigment: Pigment.fromJson(json["pigment"]),
    sensitivity: Sensitivity.fromJson(json["sensitivity"]),
  );

  Map<String, dynamic> toJson() => {
    "acne": acne.toJson(),
    "oilDry": oilDry.toJson(),
    "pigment": pigment.toJson(),
    "sensitivity": sensitivity.toJson(),
  };
}

///痘痘情况
class Acne {
  ///该维度置信度 0-1;偏低时前端标「参考」
  double confidence;

  ///A 有痘 / F 无痘
  AcneValue value;

  Acne({required this.confidence, required this.value});

  factory Acne.fromJson(Map<String, dynamic> json) => Acne(
    confidence: json["confidence"]?.toDouble(),
    value: acneValueValues.map[json["value"]]!,
  );

  Map<String, dynamic> toJson() => {
    "confidence": confidence,
    "value": acneValueValues.reverse[value],
  };
}

///A 有痘 / F 无痘
enum AcneValue { A, F }

final acneValueValues = EnumValues({"A": AcneValue.A, "F": AcneValue.F});

///油脂分泌
class OilDry {
  ///该维度置信度 0-1;偏低时前端标「参考」
  double confidence;

  ///O 油 / D 干
  OilDryValue value;

  OilDry({required this.confidence, required this.value});

  factory OilDry.fromJson(Map<String, dynamic> json) => OilDry(
    confidence: json["confidence"]?.toDouble(),
    value: oilDryValueValues.map[json["value"]]!,
  );

  Map<String, dynamic> toJson() => {
    "confidence": confidence,
    "value": oilDryValueValues.reverse[value],
  };
}

///O 油 / D 干
enum OilDryValue { D, O }

final oilDryValueValues = EnumValues({"D": OilDryValue.D, "O": OilDryValue.O});

///色沉情况
class Pigment {
  ///该维度置信度 0-1;偏低时前端标「参考」
  double confidence;

  ///P 有色沉 / N 无色沉
  PigmentValue value;

  Pigment({required this.confidence, required this.value});

  factory Pigment.fromJson(Map<String, dynamic> json) => Pigment(
    confidence: json["confidence"]?.toDouble(),
    value: pigmentValueValues.map[json["value"]]!,
  );

  Map<String, dynamic> toJson() => {
    "confidence": confidence,
    "value": pigmentValueValues.reverse[value],
  };
}

///P 有色沉 / N 无色沉
enum PigmentValue { N, P }

final pigmentValueValues = EnumValues({
  "N": PigmentValue.N,
  "P": PigmentValue.P,
});

///敏感程度(单张照片判定较不稳,通常低置信,前端以「参考」呈现)
class Sensitivity {
  ///该维度置信度 0-1;偏低时前端标「参考」
  double confidence;

  ///S 敏感 / R 耐受
  SensitivityValue value;

  Sensitivity({required this.confidence, required this.value});

  factory Sensitivity.fromJson(Map<String, dynamic> json) => Sensitivity(
    confidence: json["confidence"]?.toDouble(),
    value: sensitivityValueValues.map[json["value"]]!,
  );

  Map<String, dynamic> toJson() => {
    "confidence": confidence,
    "value": sensitivityValueValues.reverse[value],
  };
}

///S 敏感 / R 耐受
enum SensitivityValue { R, S }

final sensitivityValueValues = EnumValues({
  "R": SensitivityValue.R,
  "S": SensitivityValue.S,
});

class Zone {
  ///分区名,如 T区 / 脸颊
  String area;

  ///该区问题点
  List<String> issues;

  ///分区评分 0-10,供卡片可视化
  int score;

  Zone({required this.area, required this.issues, required this.score});

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
    area: json["area"],
    issues: List<String>.from(json["issues"].map((x) => x)),
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "area": area,
    "issues": List<dynamic>.from(issues.map((x) => x)),
    "score": score,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
