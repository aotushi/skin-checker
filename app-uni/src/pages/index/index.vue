<template>
  <view class="home skn-shell">
    <!-- 品牌头:拉丁 overline + 中文主名 + 一句话定位 -->
    <view class="brand">
      <text class="brand__overline">SKINLENS · 肤质参考助手</text>
      <text class="brand__title">肤镜</text>
      <text class="brand__sub">拍一张正脸,AI 读出你的肤质四维</text>
    </view>

    <!-- 视觉主体:人脸拓扑网格(MediaPipe canonical 投影)+ 扫描光带 -->
    <view class="stage">
      <view class="stage__frame">
        <!-- 人脸拓扑网格(scripts/gen-face-mesh.py 程序生成):静态 svg 走 image 三端通用(小程序不支持 inline svg) -->
        <image class="stage__face" src="/static/face-scan.svg" mode="scaleToFill" />
        <!-- AI 扫描光带:CSS 位移动画(image 内 svg 动画在小程序不生效),reduced-motion 关闭 -->
        <view class="stage__scan"></view>
      </view>
      <text class="stage__hint">正脸 · 自然光 · 不化妆</text>
    </view>

    <!-- 能力亮点 -->
    <view class="feats">
      <view class="feat">
        <text class="feat__k fr">01</text>
        <view class="feat__body">
          <text class="feat__t">AI 分区分析</text>
          <text class="feat__d">T 区、双颊、下巴逐区读取</text>
        </view>
      </view>
      <view class="feat">
        <text class="feat__k fr">02</text>
        <view class="feat__body">
          <text class="feat__t">16 型四维</text>
          <text class="feat__d">油脂 · 敏感 · 痘痘 · 色沉,各带置信</text>
        </view>
      </view>
      <view class="feat">
        <text class="feat__k fr">03</text>
        <view class="feat__body">
          <text class="feat__t">隐私 · 用后即删</text>
          <text class="feat__d">照片分析后即时删除,不长期存储</text>
        </view>
      </view>
    </view>

    <!-- 操作 -->
    <view class="home__actions">
      <view class="cta" hover-class="cta--tap" @click="goCapture">
        <text class="cta__t">开始检测</text>
      </view>
      <view class="ghost" hover-class="ghost--tap" @click="goSample">
        <text class="ghost__t">先看一份示例报告</text>
      </view>
    </view>

    <text class="home__note">结果由 AI 生成,仅供护肤参考,不构成医疗建议。</text>

    <TabBar current="home" />
  </view>
</template>

<script setup lang="ts">
import TabBar from '../../components/tab-bar/tab-bar.vue'

function goCapture() {
  uni.navigateTo({ url: '/pages/capture/capture' })
}
// 示例报告直接进结果卡(当前 result 用 mock 数据),便于展示
function goSample() {
  uni.navigateTo({ url: '/pages/result/result' })
}
</script>

<style lang="scss" scoped>
.home {
  min-height: 100vh;
  padding: 64px 22px calc(76px + env(safe-area-inset-bottom, 0px));
  display: flex;
  flex-direction: column;
}

/* ── 品牌头 ── */
.brand {
  &__overline {
    display: block;
    font-size: var(--skn-typography-size-xs);
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--skn-color-text-muted);
  }
  &__title {
    display: block;
    margin-top: 14px;
    font-size: 34px;
    font-weight: 700;
    letter-spacing: 0.06em;
    color: var(--skn-color-brand-rose-wood);
  }
  &__sub {
    display: block;
    margin-top: 10px;
    font-size: var(--skn-typography-size-lg);
    line-height: var(--skn-typography-leading-body);
    color: var(--skn-color-text-brown);
  }
}

/* ── 取景意象 ── */
.stage {
  margin: 34px 0 30px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
}
.stage__frame {
  position: relative;
  width: 208px;
  height: 250px;
  border-radius: var(--skn-radius-phone);
  background: linear-gradient(160deg, var(--skn-gradient-photo-from), var(--skn-gradient-photo-to));
  box-shadow: var(--skn-shadow-phone);
  overflow: hidden;
}
/* 拓扑网格脸:svg viewBox 416×500 与取景框 208×250 同比,铺满 */
.stage__face {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}
/* AI 扫描光带:横向渐隐,自上而下往返(色值取自 cta/thumb #D2795C) */
.stage__scan {
  position: absolute;
  left: 26px;
  right: 26px;
  top: 44px;
  height: 8px;
  border-radius: 999px;
  background: linear-gradient(90deg, rgba(210, 121, 92, 0), rgba(210, 121, 92, 0.6), rgba(210, 121, 92, 0));
  animation: scan 3.2s ease-in-out infinite;
}
@keyframes scan {
  0%,
  100% {
    top: 44px;
    opacity: 0.35;
  }
  50% {
    top: 198px;
    opacity: 0.95;
  }
}
@media (prefers-reduced-motion: reduce) {
  .stage__scan {
    animation: none;
    top: 120px;
  }
}
.stage__hint {
  font-size: var(--skn-typography-size-sm);
  letter-spacing: 0.06em;
  color: var(--skn-color-text-muted);
}

/* ── 能力亮点 ── */
.feats {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.feat {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 13px 2px;
  border-bottom: 1px solid var(--skn-color-line-divider);

  &:last-child {
    border-bottom: none;
  }
  &__k {
    flex-shrink: 0;
    width: 26px;
    font-size: var(--skn-typography-size-xl);
    color: var(--skn-color-brand-clay);
  }
  &__body {
    display: flex;
    flex-direction: column;
    gap: 3px;
  }
  &__t {
    font-size: var(--skn-typography-size-md);
    font-weight: 600;
    color: var(--skn-color-text-ink);
  }
  &__d {
    font-size: var(--skn-typography-size-xs);
    color: var(--skn-color-text-muted);
  }
}

/* ── 操作 ── */
.home__actions {
  margin-top: 28px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.cta {
  height: 50px;
  border-radius: var(--skn-radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--skn-gradient-cta-from), var(--skn-gradient-cta-to));
  box-shadow: var(--skn-shadow-cta);

  &--tap {
    transform: scale(0.985);
    opacity: 0.94;
  }
  &__t {
    font-size: var(--skn-typography-size-lg);
    font-weight: 600;
    color: #fff;
  }
}
.ghost {
  height: 46px;
  border-radius: var(--skn-radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;

  &--tap {
    opacity: 0.6;
  }
  &__t {
    font-size: var(--skn-typography-size-md);
    color: var(--skn-color-text-muted);
  }
}
.home__note {
  margin-top: 18px;
  text-align: center;
  font-size: var(--skn-typography-size-xs);
  line-height: 1.6;
  color: var(--skn-color-text-faint);
}
</style>
