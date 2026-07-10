<template>
  <view class="cap">
    <!-- 内容限宽容器:深色底(.cap)全屏,内容锁 600 居中,避免平板露浅底(ADR 0009) -->
    <view class="cap__inner skn-shell">
    <!-- 顶栏 -->
    <view class="cap__bar">
      <view class="cap__back" hover-class="cap__back--tap" @click="back">
        <text class="cap__back-icon">‹</text>
      </view>
      <text class="cap__title">拍照检测</text>
      <view class="cap__back cap__back--holder"></view>
    </view>

    <!-- 取景 / 预览 -->
    <view class="viewer">
      <image v-if="picked" class="viewer__img" :src="picked" mode="aspectFill" />
      <view v-else class="viewer__empty">
        <view class="guide"></view>
        <text class="viewer__tip">将正脸置于取景框内</text>
      </view>
    </view>

    <!-- 拍摄要求 -->
    <view class="req">
      <view class="req__item"><text class="req__dot"></text><text class="req__t">正脸</text></view>
      <view class="req__item"><text class="req__dot"></text><text class="req__t">自然光</text></view>
      <view class="req__item"><text class="req__dot"></text><text class="req__t">不化妆</text></view>
    </view>

    <text class="cap__privacy">照片仅用于本次分析,分析后即时删除</text>

    <!-- 操作 -->
    <view class="cap__actions">
      <template v-if="!picked">
        <view class="op op--sub" hover-class="op--tap" @click="choose('album')">
          <text class="op__t">相册选图</text>
        </view>
        <view class="op op--main" hover-class="op--tap" @click="choose('camera')">
          <text class="op__t">拍照</text>
        </view>
      </template>
      <template v-else>
        <view class="op op--sub" hover-class="op--tap" @click="reset">
          <text class="op__t">重拍</text>
        </view>
        <view class="op op--main" hover-class="op--tap" @click="analyze">
          <text class="op__t">开始分析</text>
        </view>
      </template>
    </view>
    </view>

    <!-- 分析中蒙层(全屏,不随内容限宽) -->
    <view v-if="analyzing" class="mask">
      <view class="mask__spinner"></view>
      <text class="mask__t">AI 正在分区分析…</text>
      <text class="mask__sub">通常需要几秒</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { requestAnalyze, setPendingAnalysis } from '../../utils/api'

const picked = ref('')
const analyzing = ref(false)

// 相册 / 相机取图,两端(H5 / 小程序)统一走 uni.chooseImage
function choose(source: 'album' | 'camera') {
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    sourceType: source === 'camera' ? ['camera'] : ['album'],
    success: (res) => {
      const paths = res.tempFilePaths as string[]
      picked.value = paths[0]
    },
  })
}

function reset() {
  picked.value = ''
}

function back() {
  uni.navigateBack()
}

// 真传图到 server /analyze(切片 E):成功暂存 envelope 进结果卡;失败 toast 留在本页可重试
async function analyze() {
  if (!picked.value || analyzing.value) return
  analyzing.value = true
  try {
    setPendingAnalysis(await requestAnalyze(picked.value))
    uni.redirectTo({ url: '/pages/result/result?from=analysis' })
  } catch (err) {
    uni.showToast({ title: err instanceof Error ? err.message : '分析失败,请重试', icon: 'none' })
  } finally {
    analyzing.value = false
  }
}
</script>

<style lang="scss" scoped>
.cap {
  min-height: 100vh; /* dvh 不支持端(小程序/旧 WebView)的兜底 */
  min-height: 100dvh; /* 手机浏览器地址栏在场时 100vh > 可见高,恒撑出一条地址栏的滚动(W2 已知问题 B2) */
  background: var(--skn-color-camera-bg); /* 深色底全屏铺满,不随内容限宽(避免平板两侧露出浅色底,ADR 0009) */
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* 内容限宽容器:承载原 padding + 单列布局,宽度由全局 .skn-shell 锁 600 居中 */
.cap__inner {
  width: 100%;
  flex: 1;
  padding: 60px 22px 40px;
  display: flex;
  flex-direction: column;
}

/* ── 顶栏 ── */
.cap__bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 22px;
}
.cap__back {
  width: 34px;
  height: 34px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: rgba(245, 233, 224, 0.08);

  &--holder {
    background: transparent;
  }
  &--tap {
    background: rgba(245, 233, 224, 0.18);
  }
  &-icon {
    font-size: 24px;
    line-height: 1;
    color: var(--skn-color-on-dark);
  }
}
.cap__title {
  font-size: var(--skn-typography-size-lg);
  font-weight: 600;
  color: var(--skn-color-on-dark);
}

/* ── 取景 / 预览 ── */
.viewer {
  flex: 1;
  /* min-height 0(原 360):矮视口(小屏手机/地址栏在场)让取景区收缩吃掉全部高度缺口,
     页面不出滚动条(W2 已知问题 B2);空态引导框装饰性,超出部分由 overflow:hidden 裁切。 */
  min-height: 0;
  position: relative; /* .viewer__img 绝对定位的包含块 */
  border-radius: var(--skn-radius-phone);
  overflow: hidden;
  background: #1a1512;
  display: flex;
  align-items: center;
  justify-content: center;
}
.viewer__img {
  /* 绝对定位铺满:祖先链(.cap auto 高 → .cap__inner flex:1 → .viewer flex:1)无 definite height,
     普通流的 height:100% 解析为 auto、uni-image(背景图实现)无内在高 → 塌 0 图不可见(W2 已知问题 B1);
     绝对定位的百分比对已布局的包含块必然可解。 */
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}
.viewer__empty {
  /* 绝对定位:空态引导框(375 宽下高约 287)不参与 .viewer 内在尺寸,
     否则矮视口下仍会把页面撑出滚动条(min-height:0 只放开自身下限,拦不住内容向上传导);
     放不下时由 .viewer 的 overflow:hidden 上下对称裁切(装饰性,可裁)。 */
  position: absolute;
  left: 0;
  top: 0;
  width: 100%; /* 撑满取景区,.guide 的百分比宽以此为基准 */
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
}
.guide {
  width: 58%;
  max-width: 240px; /* 平板/桌面 600 壳内防过大;240×314 恰好兜进 min-height 360 的取景区 */
  aspect-ratio: 150 / 196; /* 沿用原 150×196 的脸形比例 */
  min-height: 196px; /* 旧 WebView 不识 aspect-ratio 时的兜底,避免塌成 0 高 */
  border: 1.5px dashed rgba(245, 233, 224, 0.42);
  border-radius: 50% 50% 46% 46% / 40% 40% 60% 60%;
}
.viewer__tip {
  font-size: var(--skn-typography-size-sm);
  letter-spacing: 0.04em;
  color: rgba(245, 233, 224, 0.6);
}

/* ── 拍摄要求 ── */
.req {
  margin-top: 22px;
  display: flex;
  justify-content: center;
  gap: 22px;
}
.req__item {
  display: flex;
  align-items: center;
  gap: 6px;
}
.req__dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: var(--skn-gradient-cta-to);
}
.req__t {
  font-size: var(--skn-typography-size-sm);
  color: var(--skn-color-on-dark);
}
.cap__privacy {
  margin-top: 14px;
  text-align: center;
  font-size: var(--skn-typography-size-xs);
  color: rgba(245, 233, 224, 0.5);
}

/* ── 操作 ── */
.cap__actions {
  margin-top: 24px;
  display: flex;
  gap: 12px;
}
.op {
  flex: 1;
  height: 50px;
  border-radius: var(--skn-radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;

  &--tap {
    transform: scale(0.985);
    opacity: 0.92;
  }
  &--sub {
    border: 1px solid rgba(245, 233, 224, 0.28);

    .op__t {
      color: var(--skn-color-on-dark);
    }
  }
  &--main {
    background: linear-gradient(135deg, var(--skn-gradient-cta-from), var(--skn-gradient-cta-to));
    box-shadow: var(--skn-shadow-cta);

    .op__t {
      color: #fff;
    }
  }
  &__t {
    font-size: var(--skn-typography-size-md);
    font-weight: 600;
  }
}

/* ── 分析中蒙层 ── */
.mask {
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background: rgba(36, 30, 27, 0.88);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 14px;
}
.mask__spinner {
  width: 34px;
  height: 34px;
  border: 3px solid rgba(245, 233, 224, 0.2);
  border-top-color: var(--skn-gradient-cta-to);
  border-radius: 50%;
  animation: cap-spin 0.8s linear infinite;
}
@keyframes cap-spin {
  to {
    transform: rotate(360deg);
  }
}
.mask__t {
  font-size: var(--skn-typography-size-lg);
  font-weight: 600;
  color: var(--skn-color-on-dark);
}
.mask__sub {
  font-size: var(--skn-typography-size-xs);
  color: rgba(245, 233, 224, 0.55);
}
</style>
