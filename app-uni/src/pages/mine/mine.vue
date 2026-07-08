<template>
  <view class="mine skn-shell">
    <view class="mine__bar"><text class="mine__bar-title">我的</text></view>

    <!-- 用户卡(MVP 无登录,游客态) -->
    <view class="user">
      <view class="user__avatar"><text class="user__avatar-txt fr">肤</text></view>
      <view class="user__meta">
        <text class="user__name">游客</text>
        <text class="user__sub">本地体验 · 未登录</text>
      </view>
    </view>

    <!-- 我的检测(历史占位) -->
    <view class="card">
      <view class="card__head">
        <text class="card__title">我的检测</text>
        <text class="card__hint">本地保存</text>
      </view>
      <view v-if="history.length" class="hist">
        <view
          v-for="it in history"
          :key="it.id"
          class="hist__row"
          hover-class="hist__row--tap"
          @click="openReport(it.id)"
        >
          <text class="hist__code fr">{{ it.report.skinTypeCode }}</text>
          <view class="hist__meta">
            <text class="hist__name">{{ it.report.skinTypeName }}</text>
            <text class="hist__time">{{ fmt(it.createdAt) }}</text>
          </view>
          <text class="hist__arrow">›</text>
        </view>
      </view>
      <view v-else class="empty">
        <text class="empty__t">还没有检测记录</text>
        <text class="empty__d">完成一次拍照分析后,报告会显示在这里</text>
        <view class="empty__cta" hover-class="empty__cta--tap" @click="goCapture">
          <text class="empty__cta-t">去检测</text>
        </view>
      </view>
    </view>

    <!-- 信息列表 -->
    <view class="card card--list">
      <view class="row" hover-class="row--tap" @click="openSheet('disclaimer')">
        <text class="row__label">免责声明</text>
        <text class="row__arrow">›</text>
      </view>
      <view class="row" hover-class="row--tap" @click="openSheet('privacy')">
        <text class="row__label">隐私说明</text>
        <text class="row__arrow">›</text>
      </view>
      <view class="row" hover-class="row--tap" @click="openSheet('about')">
        <text class="row__label">关于肤镜</text>
        <text class="row__value">v0.1 · MVP</text>
      </view>
    </view>

    <text class="mine__foot">SKINLENS · 肤质参考助手</text>

    <TabBar current="mine" />

    <!-- 底部弹层:完整声明 / 隐私 / 关于 -->
    <view v-if="sheet" class="sheet" @click="closeSheet">
      <view class="sheet__panel skn-shell" @click.stop>
        <view class="sheet__grip"></view>
        <text class="sheet__title">{{ sheetData.title }}</text>
        <view class="sheet__body">
          <text v-for="(p, i) in sheetData.paras" :key="i" class="sheet__p">{{ p }}</text>
        </view>
        <view class="sheet__close" hover-class="sheet__close--tap" @click="closeSheet">
          <text class="sheet__close-t">我知道了</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import TabBar from '../../components/tab-bar/tab-bar.vue'
import { listHistory, type HistoryItem } from '../../utils/history'

type SheetKey = 'disclaimer' | 'privacy' | 'about'
const sheet = ref<SheetKey | ''>('')

// 完整声明文案:合规定位「参考/建议」,不含诊断/疗效宣称(结果页 inline note 之外的可点完整入口,ADR 0008)
const SHEETS: Record<SheetKey, { title: string; paras: string[] }> = {
  disclaimer: {
    title: '免责声明',
    paras: [
      '肤镜是一款 AI 肤质参考助手,不是医疗诊断工具。',
      '分析结果由 AI 模型生成,仅供护肤参考,不构成任何医疗建议或诊断结论。',
      '结果可能存在偏差,置信度较低的维度已标注「参考」,请理性看待。',
      '如有严重或持续的皮肤问题,请及时就医,遵从专业皮肤科医生的判断。',
    ],
  },
  privacy: {
    title: '隐私说明',
    paras: [
      '你上传的照片仅用于本次肤质分析。',
      '照片在分析完成后即时删除,不做长期存储。',
      '分析生成的报告默认仅保存在你的设备本地。',
    ],
  },
  about: {
    title: '关于肤镜',
    paras: [
      '肤镜 SKINLENS · 肤质参考助手 v0.1(MVP)。',
      '拍照 → AI 分区分析 → 结构化肤质报告 + 护理建议。',
      '一套 Cloudflare 后端,uniapp 与 flutter 双端复刻同一 API。',
    ],
  },
}

const sheetData = computed(() => (sheet.value ? SHEETS[sheet.value] : { title: '', paras: [] }))

function openSheet(k: SheetKey) {
  sheet.value = k
}
function closeSheet() {
  sheet.value = ''
}
function goCapture() {
  uni.navigateTo({ url: '/pages/capture/capture' })
}

// 本地历史:onShow 每次进页刷新(结果卡保存后返回即更新);点击回看对应报告
const history = ref<HistoryItem[]>([])
onShow(() => {
  history.value = listHistory()
})
function openReport(id: string) {
  uni.navigateTo({ url: '/pages/result/result?id=' + id })
}
function fmt(ts: number) {
  const d = new Date(ts)
  const p = (n: number) => (n < 10 ? '0' + n : '' + n)
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`
}
</script>

<style lang="scss" scoped>
.mine {
  min-height: 100vh;
  padding: 60px 16px calc(76px + env(safe-area-inset-bottom, 0px));
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.mine__bar {
  padding: 0 6px 2px;
}
.mine__bar-title {
  font-size: var(--skn-typography-size-2xl);
  font-weight: 700;
  color: var(--skn-color-brand-rose-wood);
}

/* ── 用户卡 ── */
.user {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 4px 6px 8px;
}
.user__avatar {
  width: 54px;
  height: 54px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--skn-gradient-photo-from), var(--skn-gradient-cta-to));
  box-shadow: var(--skn-shadow-cta);
  display: flex;
  align-items: center;
  justify-content: center;
}
.user__avatar-txt {
  font-size: var(--skn-typography-size-2xl);
  color: #fff;
}
.user__meta {
  display: flex;
  flex-direction: column;
  gap: 3px;
}
.user__name {
  font-size: var(--skn-typography-size-xl);
  font-weight: 600;
  color: var(--skn-color-text-ink);
}
.user__sub {
  font-size: var(--skn-typography-size-xs);
  color: var(--skn-color-text-muted);
}

/* ── 卡片(沿用结果页视觉) ── */
.card {
  background: var(--skn-color-surface-card);
  border: 1px solid var(--skn-color-line-hairline);
  border-radius: var(--skn-radius-2xl);
  padding: 16px;
  box-shadow: var(--skn-shadow-card);

  &__head {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    margin-bottom: 14px;
  }
  &__title {
    font-size: var(--skn-typography-size-lg);
    font-weight: 600;
    color: var(--skn-color-text-ink);
  }
  &__hint {
    font-size: var(--skn-typography-size-xs);
    color: var(--skn-color-text-faint);
  }
  &--list {
    padding: 4px 16px;
  }
}

/* ── 历史列表(有数据态) ── */
.hist {
  display: flex;
  flex-direction: column;
}
.hist__row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 13px 2px;
  border-bottom: 1px solid var(--skn-color-line-divider);

  &:last-child {
    border-bottom: none;
  }
  &--tap {
    opacity: 0.55;
  }
}
.hist__code {
  flex-shrink: 0;
  font-size: var(--skn-typography-size-md);
  letter-spacing: 0.06em;
  color: var(--skn-color-brand-rose-wood);
}
.hist__meta {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.hist__name {
  font-size: var(--skn-typography-size-md);
  font-weight: 500;
  color: var(--skn-color-text-ink);
}
.hist__time {
  font-size: var(--skn-typography-size-xs);
  color: var(--skn-color-text-faint);
}
.hist__arrow {
  flex-shrink: 0;
  font-size: 18px;
  color: var(--skn-color-text-faint);
}

/* ── 空态 ── */
.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 7px;
  padding: 12px 0 6px;

  &__t {
    font-size: var(--skn-typography-size-md);
    font-weight: 500;
    color: var(--skn-color-text-brown);
  }
  &__d {
    font-size: var(--skn-typography-size-xs);
    line-height: 1.6;
    text-align: center;
    color: var(--skn-color-text-muted);
  }
  &__cta {
    margin-top: 8px;
    padding: 9px 24px;
    border-radius: var(--skn-radius-lg);
    background: linear-gradient(135deg, var(--skn-gradient-cta-from), var(--skn-gradient-cta-to));
    box-shadow: var(--skn-shadow-cta);

    &--tap {
      transform: scale(0.98);
      opacity: 0.92;
    }
  }
  &__cta-t {
    font-size: var(--skn-typography-size-md);
    font-weight: 600;
    color: #fff;
  }
}

/* ── 列表行 ── */
.row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 15px 0;
  border-bottom: 1px solid var(--skn-color-line-divider);

  &:last-child {
    border-bottom: none;
  }
  &--tap {
    opacity: 0.55;
  }
  &__label {
    font-size: var(--skn-typography-size-md);
    color: var(--skn-color-text-ink);
  }
  &__value {
    font-size: var(--skn-typography-size-xs);
    color: var(--skn-color-text-faint);
  }
  &__arrow {
    font-size: 18px;
    color: var(--skn-color-text-faint);
  }
}
.mine__foot {
  margin-top: auto;
  padding-top: 20px;
  text-align: center;
  font-size: var(--skn-typography-size-xs);
  letter-spacing: 0.14em;
  color: var(--skn-color-text-faint);
}

/* ── 底部弹层 ── */
.sheet {
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background: rgba(60, 40, 34, 0.44);
  display: flex;
  align-items: flex-end;
  z-index: 40;
}
.sheet__panel {
  width: 100%;
  background: var(--skn-color-surface-card);
  border-radius: var(--skn-radius-3xl) var(--skn-radius-3xl) 0 0;
  padding: 12px 22px calc(28px + env(safe-area-inset-bottom, 0px));
  box-shadow: var(--skn-shadow-float);
  animation: sheet-up 0.26s ease;
}
@keyframes sheet-up {
  from {
    transform: translateY(100%);
  }
  to {
    transform: translateY(0);
  }
}
.sheet__grip {
  width: 38px;
  height: 4px;
  border-radius: 999px;
  background: var(--skn-color-spectrum-midline);
  margin: 0 auto 16px;
}
.sheet__title {
  display: block;
  font-size: var(--skn-typography-size-xl);
  font-weight: 700;
  color: var(--skn-color-brand-rose-wood);
  margin-bottom: 14px;
}
.sheet__body {
  display: flex;
  flex-direction: column;
  gap: 11px;
  margin-bottom: 20px;
}
.sheet__p {
  font-size: var(--skn-typography-size-base);
  line-height: 1.7;
  color: var(--skn-color-text-brown);
}
.sheet__close {
  height: 48px;
  border-radius: var(--skn-radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--skn-gradient-cta-from), var(--skn-gradient-cta-to));
  box-shadow: var(--skn-shadow-cta);

  &--tap {
    transform: scale(0.99);
    opacity: 0.93;
  }
}
.sheet__close-t {
  font-size: var(--skn-typography-size-md);
  font-weight: 600;
  color: #fff;
}
</style>
