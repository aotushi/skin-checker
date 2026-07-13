// 落地页文案单一来源(中文为主文案,类型以此为准);品牌与合规措辞对齐应用端:
// 定位「参考/建议」,不得出现诊断/疗效宣称;免责定稿文案见 shared/skin-report.schema.json
export const zh = {
  lang: 'zh-CN',
  locale: 'zh',
  ogLocale: 'zh_CN',

  seo: {
    title: '肤镜 SKINLENS — AI 肤质参考助手 · 拍照分析 16 型肤质',
    description:
      '拍一张正脸,AI 读出你的肤质四维。视觉大模型逐区分析 T 区、双颊与下巴,输出油脂·敏感·痘痘·色沉四维光谱与护肤建议;照片用后即删,历史仅存设备本地。仅供护肤参考,不构成医疗建议。',
    ogTitle: '肤镜 SKINLENS — AI 肤质参考助手',
    ogDesc: '拍一张正脸,AI 读出你的肤质四维:16 型肤质定位 + 四维光谱 + 护肤建议。仅供参考,非医疗诊断。',
    ogImageAlt: '肤镜 SKINLENS 落地页预览图',
  },

  nav: {
    features: '功能',
    how: '流程',
    download: '下载',
    tech: '技术',
    tryOnline: '在线体验',
    langSwitch: 'EN',
    langSwitchHref: '/en/',
  },

  hero: {
    overline: 'SKINLENS · AI 肤质参考助手',
    title: '拍一张正脸,读出你的肤质四维',
    sub: '视觉大模型逐区分析 T 区、双颊与下巴,给出 16 型肤质定位、油脂 · 敏感 · 痘痘 · 色沉四维光谱与护肤建议。',
    ctaPrimary: '在线体验',
    ctaPrimaryHref: 'https://skin.9shi.cc',
    ctaSecondary: '下载 Android 版',
    ctaSecondaryHref: '#download',
    note: '结果由 AI 生成,仅供护肤参考,不构成医疗建议。',
    shotAlt: '肤镜应用界面截图',
  },

  features: {
    label: '功能',
    title: '不止一个笼统结论',
    sub: '从分区读取到四维定位,每一步都给出可核对的依据与置信度。',
    items: [
      {
        t: 'AI 分区分析',
        d: 'T 区、双颊、下巴逐区读取,分区给出肤况评估,而不是一张脸一个分数。',
      },
      {
        t: '16 型四维光谱',
        d: '油脂 · 敏感 · 痘痘 · 色沉四条双极光谱定位,每一维附置信度,低置信明确标注「参考」。',
      },
      {
        t: '护肤建议',
        d: '基于 16 型肤质手册生成日常护理要点,全程「参考 / 建议」口径,不做功效承诺。',
      },
      {
        t: '隐私优先',
        d: '照片分析后即时删除,不长期存储;检测历史仅保存在你的设备本地。',
      },
    ],
  },

  how: {
    label: '流程',
    title: '三步拿到报告',
    steps: [
      {
        t: '拍摄正脸',
        d: '自然光、不化妆、露出全脸。Android 版支持页面内实时取景直拍。',
      },
      {
        t: 'AI 分析',
        d: '分析前自动质检:非人脸、翻拍屏幕、距离过远会被拦下并给出重拍指引,不出误导报告。',
      },
      {
        t: '查看报告',
        d: '四维光谱 + 分区评估 + 护理建议,可一键保存到本地,「我的」页随时回看。',
      },
    ],
  },

  download: {
    label: '下载',
    title: '两种方式开始',
    sub: 'H5 在线版免安装即用;Android 版支持实时取景直拍。',
    items: [
      {
        t: 'H5 在线版',
        d: '手机浏览器直接打开,无需安装,功能完整。',
        cta: '立即体验',
        href: 'https://skin.9shi.cc',
        meta: 'skin.9shi.cc',
        disabled: false,
      },
      {
        t: 'Android APK · Flutter 版',
        d: '页面内实时取景直拍。测试证书签名,安装时请允许「未知来源应用」。',
        cta: '前往下载',
        href: 'https://github.com/aotushi/skin-checker/releases/latest',
        meta: 'GitHub Releases · 约 48 MB',
        disabled: false,
      },
      {
        t: 'Android APK · uniapp 版',
        d: '与 H5 同源代码的原生装机版,平板适配限宽布局。测试证书签名,安装时请允许「未知来源应用」。',
        cta: '前往下载',
        href: 'https://github.com/aotushi/skin-checker/releases/latest',
        meta: 'GitHub Releases · 约 15 MB',
        disabled: false,
      },
    ],
  },

  tech: {
    label: '技术',
    title: '一套后端,双栈四端',
    sub: '这也是一个跨端工程样本:uniapp 与 Flutter 两套前端栈复刻同一套 API 与视觉,契约与设计 token 均为单一真相源。',
    archTop: ['uniapp · Vue3', 'H5 / 微信小程序 / App(APK)', 'Flutter', 'Android APK(实时取景)'],
    archMid: 'Cloudflare Workers + Hono · 统一 API(skin.9shi.cc/api)',
    archBottom: ['D1 · 报告存储', 'R2 · 图片暂存(用后即删)', '通义千问 VL · 多模态分析'],
    points: [
      {
        t: '契约单一真相源',
        d: '报告结构由一份 JSON Schema 唯一定义,脚本生成 TypeScript 与 Dart 类型;LLM 输出同样按 schema 校验兜底。',
      },
      {
        t: '设计 token SSOT',
        d: 'DTCG 格式 design-tokens.json 一份源,生成 SCSS 变量与 Dart 常量,双端视觉零漂移。',
      },
      {
        t: 'Cloudflare 边缘架构',
        d: 'Workers + Hono 承接 API,D1 存报告、R2 暂存图片;H5 与 API 同域部署,免 CORS。',
      },
      {
        t: 'AI 工程化',
        d: '同一次视觉调用前置输入质检:非人脸 / 翻拍 / 太远直接 422 + 重拍指引,失败不落库。',
      },
      {
        t: '隐私由架构保证',
        d: '图片用后即删 + R2 生命周期兜底双保险;历史只写设备本地,服务端不建个人档案。',
      },
      {
        t: '双端能力差异化',
        d: 'Flutter 版做页面内实时取景直拍(camera 插件),失败全链降级系统相机;uniapp 版以一码多端取胜。',
      },
    ],
    github: '查看源码',
    githubHref: 'https://github.com/aotushi/skin-checker',
  },

  compliance: {
    label: '合规与隐私',
    title: '先说清楚边界',
    disclaimerTitle: '免责声明',
    disclaimer: '本结果由 AI 生成,仅供护肤参考,不构成医疗建议,严重皮肤问题请就医。',
    privacyTitle: '隐私承诺',
    privacy: '上传照片仅用于本次分析,分析完成即刻删除;检测历史仅保存在你的设备本地,服务端不建立个人档案。',
  },

  footer: {
    tagline: 'AI 肤质参考 · 非医疗诊断',
    tryOnline: '在线体验',
    github: 'GitHub',
    copyright: '© 2026 SKINLENS · 肤镜',
  },
};

export type Strings = typeof zh;
