<script setup lang="ts">
import { onLaunch, onShow, onHide } from "@dcloudio/uni-app";
onLaunch(() => {
  console.log("App Launch");
  // #ifdef APP-PLUS || MP-WEIXIN
  // 非 H5 端(App / 微信小程序)不走 index.html 的 link:型号码衬线体 Fraunces 运行时加载,global 全页面生效,fail 静默降级到 fallback(Georgia/serif)、不影响可读。
  // 小程序:woff2 需在小程序后台配 downloadFile 合法域名 cdn.jsdelivr.net(开发者工具可勾「不校验合法域名」)。
  // App:loadFontFace 支持网络字体、无合法域名限制;国内 CDN 不稳可换自托管 / OSS。
  uni.loadFontFace({
    global: true,
    family: "Fraunces",
    source: 'url("https://cdn.jsdelivr.net/npm/@fontsource-variable/fraunces@5.2.9/files/fraunces-latin-wght-normal.woff2")',
    fail: () => {},
  });
  // #endif
});
onShow(() => {
  console.log("App Show");
});
onHide(() => {
  console.log("App Hide");
});
</script>
<style lang="scss">
@import './styles/tokens.scss';

page {
  background: linear-gradient(180deg, var(--skn-color-surface-bg-top), var(--skn-color-surface-bg-bottom));
  min-height: 100vh;
  font-family: var(--skn-typography-family-sans);
  font-size: var(--skn-typography-size-base);
  line-height: var(--skn-typography-leading-body);
  color: var(--skn-color-text-ink);
}

/* 数字/型号码专用衬线体(Fraunces),H5 由 index.html 的 link 加载 */
.fr {
  font-family: var(--skn-typography-family-display);
  font-optical-sizing: auto;
}

/* 平板(大屏)内容限宽:锁 600px 居中,两侧透出全屏渐变底(ADR 0009)。
   手机(逻辑宽 < 600)不受影响、照常铺满;仅大屏收窄。
   用物理 margin(避开 Skyline 不支持的 margin-inline);沉浸深色页(拍照)深色底仍全屏,只此类承载的内容居中。 */
.skn-shell {
  box-sizing: border-box; /* 含 padding 锁在 600 内(uni-view 默认 content-box,否则实际带宽 = 600 + 左右 padding) */
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}
</style>
