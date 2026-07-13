import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// CF_PAGES_URL 由 Cloudflare Pages 构建时注入;直传部署时以 SITE_URL / 默认值为准
const SITE_URL = process.env.SITE_URL || 'https://doc.skin.9shi.cc';

export default defineConfig({
  site: SITE_URL,
  output: 'static',
  integrations: [sitemap()],
});
