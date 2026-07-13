import type { Strings } from './zh';

// 英文文案:与 zh.ts 同结构(类型由 zh 推导),合规口径一致(reference only, not medical advice)
export const en: Strings = {
  lang: 'en',
  locale: 'en',
  ogLocale: 'en_US',

  seo: {
    title: 'SKINLENS — AI Skin Reference Assistant · Photo-Based 16-Type Skin Analysis',
    description:
      'Take one front-facing photo and let AI read your skin across four dimensions. A vision LLM analyzes the T-zone, cheeks and chin region by region, producing a 16-type skin profile with care suggestions. Photos are deleted right after analysis; history stays on your device. Reference only — not medical advice.',
    ogTitle: 'SKINLENS — AI Skin Reference Assistant',
    ogDesc: 'One selfie, four skin dimensions: 16-type profile + spectrum report + care suggestions. Reference only, not a medical diagnosis.',
    ogImageAlt: 'SKINLENS landing page preview',
  },

  nav: {
    features: 'Features',
    how: 'How it works',
    download: 'Download',
    tech: 'Tech',
    tryOnline: 'Try online',
    langSwitch: '中文',
    langSwitchHref: '/zh/',
  },

  hero: {
    overline: 'SKINLENS · AI SKIN REFERENCE ASSISTANT',
    title: 'One selfie, four skin dimensions',
    sub: 'A vision LLM analyzes your T-zone, cheeks and chin region by region, mapping you to one of 16 skin types with a four-dimension spectrum report and care suggestions.',
    ctaPrimary: 'Try online',
    ctaPrimaryHref: 'https://skin.9shi.cc',
    ctaSecondary: 'Get Android app',
    ctaSecondaryHref: '#download',
    note: 'Results are AI-generated, for skincare reference only — not medical advice.',
    shotAlt: 'SKINLENS app screenshots',
  },

  features: {
    label: 'Features',
    title: 'More than a single vague score',
    sub: 'From per-region reads to a four-dimension profile, every step comes with evidence and a confidence level.',
    items: [
      {
        t: 'Region-by-region analysis',
        d: 'T-zone, cheeks and chin are read separately, each with its own assessment — not one score for the whole face.',
      },
      {
        t: '16-type spectrum report',
        d: 'Four bipolar spectrums — oil, sensitivity, acne, pigmentation — each with a confidence level; low-confidence results are clearly marked as tentative.',
      },
      {
        t: 'Care suggestions',
        d: 'Daily care tips derived from a 16-type skin handbook, always phrased as reference and suggestions — no efficacy claims.',
      },
      {
        t: 'Privacy first',
        d: 'Photos are deleted immediately after analysis and never stored long-term; your history lives only on your device.',
      },
    ],
  },

  how: {
    label: 'How it works',
    title: 'Three steps to your report',
    steps: [
      {
        t: 'Take a front-facing photo',
        d: 'Natural light, no makeup, full face visible. The Android app offers an in-page live viewfinder.',
      },
      {
        t: 'AI analysis',
        d: 'Input is quality-checked first: non-face photos, screen re-shots and distant shots are rejected with retake guidance — no misleading reports.',
      },
      {
        t: 'Read your report',
        d: 'Spectrum report + per-region assessment + care suggestions. Save locally and revisit anytime from the “Me” tab.',
      },
    ],
  },

  download: {
    label: 'Download',
    title: 'Two ways to start',
    sub: 'The web version needs no install; the Android app adds a live viewfinder.',
    items: [
      {
        t: 'Web (H5)',
        d: 'Open in your mobile browser — no install, full functionality.',
        cta: 'Try now',
        href: 'https://skin.9shi.cc',
        meta: 'skin.9shi.cc',
        disabled: false,
      },
      {
        t: 'Android APK · Flutter',
        d: 'In-page live viewfinder capture. Signed with a test certificate — allow “unknown sources” when installing.',
        cta: 'Download',
        href: 'https://github.com/aotushi/skin-checker/releases/latest',
        meta: 'GitHub Releases · ~48 MB',
        disabled: false,
      },
      {
        t: 'Android APK · uniapp',
        d: 'Native build sharing the H5 codebase, with width-capped tablet layout. Signed with a test certificate — allow “unknown sources” when installing.',
        cta: 'Download',
        href: 'https://github.com/aotushi/skin-checker/releases/latest',
        meta: 'GitHub Releases · ~15 MB',
        disabled: false,
      },
    ],
  },

  tech: {
    label: 'Tech',
    title: 'One backend, two stacks, four targets',
    sub: 'Also a cross-platform engineering sample: uniapp and Flutter frontends replicate the same API and visual language, with single sources of truth for both the data contract and design tokens.',
    archTop: ['uniapp · Vue3', 'H5 / WeChat MP / App (APK)', 'Flutter', 'Android APK (live viewfinder)'],
    archMid: 'Cloudflare Workers + Hono · unified API (skin.9shi.cc/api)',
    archBottom: ['D1 · report storage', 'R2 · transient images (deleted after use)', 'Qwen VL · multimodal analysis'],
    points: [
      {
        t: 'Single-source data contract',
        d: 'The report structure is defined once in JSON Schema; scripts generate TypeScript and Dart types, and LLM output is validated against the same schema.',
      },
      {
        t: 'Design-token SSOT',
        d: 'One DTCG design-tokens.json generates SCSS variables and Dart constants — zero visual drift between stacks.',
      },
      {
        t: 'Cloudflare edge architecture',
        d: 'Workers + Hono serve the API with D1 for reports and R2 for transient images; H5 and API share one domain, no CORS.',
      },
      {
        t: 'AI engineering',
        d: 'Input quality gating runs inside the same vision call: non-face / re-shot / too-far photos get a 422 with retake guidance and are never persisted.',
      },
      {
        t: 'Privacy by architecture',
        d: 'Images are deleted after use with an R2 lifecycle rule as backstop; history is written only to local device storage.',
      },
      {
        t: 'Per-stack strengths',
        d: 'The Flutter build adds an in-page live viewfinder (camera plugin) with full fallback to the system camera; the uniapp build wins on one-codebase-many-targets.',
      },
    ],
    github: 'View source',
    githubHref: 'https://github.com/aotushi/skin-checker',
  },

  compliance: {
    label: 'Compliance & privacy',
    title: 'Boundaries, stated upfront',
    disclaimerTitle: 'Disclaimer',
    disclaimer: 'Results are AI-generated and for skincare reference only. They do not constitute medical advice — please see a doctor for serious skin conditions.',
    privacyTitle: 'Privacy promise',
    privacy: 'Uploaded photos are used only for the current analysis and deleted as soon as it completes; your history is stored only on your device — no personal profile is kept server-side.',
  },

  footer: {
    tagline: 'AI skin reference · not a medical diagnosis',
    tryOnline: 'Try online',
    github: 'GitHub',
    copyright: '© 2026 SKINLENS',
  },
};
