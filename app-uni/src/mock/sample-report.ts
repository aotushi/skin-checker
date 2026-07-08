import type { SkinReport } from '@/types/skin-report'

// 结果卡开发期示例数据(联调前占位;字段严格对齐 shared/skin-report.schema.json)。
// 后端接通后由 POST /analyze 返回真实 report,此文件仅供本地页面渲染。
export const sampleReport: SkinReport = {
  skinAxes: {
    oilDry: { value: 'O', confidence: 0.86 },
    sensitivity: { value: 'S', confidence: 0.42 }, // 低置信 → 前端以「参考」呈现
    acne: { value: 'A', confidence: 0.77 },
    pigment: { value: 'N', confidence: 0.68 },
  },
  skinTypeCode: 'O-S-A-N',
  skinTypeName: '油敏痘肌',
  zones: [
    { area: 'T 区', issues: ['出油旺盛', '毛孔粗大'], score: 7 },
    { area: '脸颊', issues: ['泛红', '干燥缺水'], score: 4 },
    { area: '下巴', issues: ['闭口', '痘印'], score: 6 },
  ],
  suggestions: [
    '温和氨基酸洁面,避免皂基与过度清洁',
    '控油可选烟酰胺、锌 PCA;水杨酸(BHA)低频疏通毛孔',
    '屏障修护:神经酰胺 + 泛醇,缓解泛红与敏感',
    '每日硬防晒 SPF30+,预防痘印与色沉加深',
  ],
  disclaimer: '本结果由 AI 生成,仅供护肤参考,不构成医疗建议,严重皮肤问题请就医。',
}
