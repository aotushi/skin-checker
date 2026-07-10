// 结果卡开发期示例数据(联调前占位;字段严格对齐 shared/skin-report.schema.json)。
// 对齐 app-uni src/mock/sample-report.ts;切片 D 接通 POST /analyze 后真实报告走网络返回。
import '../models/skin_report.dart';

final sampleReport = SkinReport(
  skinAxes: SkinAxes(
    oilDry: OilDry(value: OilDryValue.O, confidence: 0.86),
    // 低置信 → 前端以「参考」呈现
    sensitivity: Sensitivity(value: SensitivityValue.S, confidence: 0.42),
    acne: Acne(value: AcneValue.A, confidence: 0.77),
    pigment: Pigment(value: PigmentValue.N, confidence: 0.68),
  ),
  skinTypeCode: 'O-S-A-N',
  skinTypeName: '油敏痘肌',
  zones: [
    Zone(area: 'T 区', issues: ['出油旺盛', '毛孔粗大'], score: 7),
    Zone(area: '脸颊', issues: ['泛红', '干燥缺水'], score: 4),
    Zone(area: '下巴', issues: ['闭口', '痘印'], score: 6),
  ],
  suggestions: [
    '温和氨基酸洁面,避免皂基与过度清洁',
    '控油可选烟酰胺、锌 PCA;水杨酸(BHA)低频疏通毛孔',
    '屏障修护:神经酰胺 + 泛醇,缓解泛红与敏感',
    '每日硬防晒 SPF30+,预防痘印与色沉加深',
  ],
  disclaimer: '本结果由 AI 生成,仅供护肤参考,不构成医疗建议,严重皮肤问题请就医。',
);
