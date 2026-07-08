<template>
  <view class="tabbar skn-shell">
    <view class="tabbar__inner">
      <view
        class="tab"
        :class="{ 'tab--on': current === 'home' }"
        hover-class="tab--tap"
        @click="go('home')"
      >
        <view class="ic ic-cam">
          <view class="ic-cam__lens"></view>
          <view class="ic-cam__dot"></view>
        </view>
        <text class="tab__label">检测</text>
      </view>
      <view
        class="tab"
        :class="{ 'tab--on': current === 'mine' }"
        hover-class="tab--tap"
        @click="go('mine')"
      >
        <view class="ic ic-me">
          <view class="ic-me__head"></view>
          <view class="ic-me__body"></view>
        </view>
        <text class="tab__label">我的</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
// 自绘底部 tab(暖调,免图标资源);tab = 根级切换,reLaunch 清栈避免页面堆叠。
// 拍照 / 结果为流程二级页,不引入本组件即不显示 tab。
type TabKey = 'home' | 'mine'
const props = defineProps<{ current: TabKey }>()

const ROUTES: Record<TabKey, string> = {
  home: '/pages/index/index',
  mine: '/pages/mine/mine',
}

function go(target: TabKey) {
  if (target === props.current) return
  uni.reLaunch({ url: ROUTES[target] })
}
</script>

<style lang="scss" scoped>
.tabbar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 20;
  background: var(--skn-color-surface-card);
  border-top: 1px solid var(--skn-color-line-hairline);
  box-shadow: 0 -6px 20px rgba(160, 90, 72, 0.06);
  padding-bottom: env(safe-area-inset-bottom, 0px);
}
.tabbar__inner {
  height: 56px;
  display: flex;
}
.tab {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 5px;

  &--tap {
    opacity: 0.6;
  }
  &__label {
    font-size: var(--skn-typography-size-xs);
    color: var(--skn-color-text-faint);
  }
}
.tab--on .tab__label {
  color: var(--skn-color-brand-rose-deep);
  font-weight: 600;
}

/* 图标基座 */
.ic {
  position: relative;
  width: 24px;
  height: 24px;
}

/* 检测:镜头圆环 + 中心点 */
.ic-cam__lens {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 18px;
  height: 18px;
  border: 2px solid var(--skn-color-text-faint);
  border-radius: 50%;
  transform: translate(-50%, -50%);
}
.ic-cam__dot {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: var(--skn-color-text-faint);
  transform: translate(-50%, -50%);
}
.tab--on .ic-cam__lens {
  border-color: var(--skn-color-brand-rose-deep);
}
.tab--on .ic-cam__dot {
  background: var(--skn-color-brand-rose-deep);
}

/* 我的:头 + 肩剪影 */
.ic-me__head {
  position: absolute;
  left: 50%;
  top: 3px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--skn-color-text-faint);
  transform: translateX(-50%);
}
.ic-me__body {
  position: absolute;
  left: 50%;
  bottom: 3px;
  width: 16px;
  height: 9px;
  border-radius: 9px 9px 0 0;
  background: var(--skn-color-text-faint);
  transform: translateX(-50%);
}
.tab--on .ic-me__head,
.tab--on .ic-me__body {
  background: var(--skn-color-brand-rose-deep);
}
</style>
