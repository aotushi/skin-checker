<template>
  <view class="report skn-shell">
    <!-- 顶栏:返回(navigationStyle custom 无原生返回,自绘) -->
    <view class="topbar">
      <view class="topbar__back" hover-class="topbar__back--tap" @click="goBack">
        <view class="topbar__back-icon"></view>
      </view>
    </view>

    <!-- 报告头:overline + 型号码(Fraunces 大字)+ 型号名 + 概述 -->
    <view class="hero">
      <text class="hero__overline">SKINLENS · 肤质参考报告</text>
      <text class="hero__code fr">{{ report.skinTypeCode }}</text>
      <view class="hero__name-row">
        <text class="hero__name">{{ report.skinTypeName }}</text>
        <text class="hero__badge">AI 分析</text>
      </view>
      <text class="hero__desc">综合四个维度判定,置信偏低的维度以「参考」呈现,结果仅供护肤参考。</text>
    </view>

    <!-- 四维双极光谱 -->
    <view class="card">
      <view class="card__head">
        <text class="card__title">肤质四维</text>
        <text class="card__hint">双极光谱</text>
      </view>
      <view class="axes">
        <view v-for="s in spectrums" :key="s.key" class="axis">
          <view class="axis__head">
            <view class="axis__label">
              <text class="axis__dot" :style="{ background: s.color }"></text>
              <text class="axis__name">{{ s.label }}</text>
              <view
                class="axis__info"
                :class="{ 'is-open': openAxis === s.key }"
                hover-class="axis__info--tap"
                @click="toggleAxis(s.key)"
              >
                <text class="axis__info-q">?</text>
              </view>
            </view>
            <view class="axis__verdict">
              <text class="axis__verdict-name" :style="{ color: s.color }">{{ s.activeName }}</text>
              <text v-if="s.low" class="axis__ref">参考</text>
            </view>
          </view>

          <view class="spectrum">
            <text class="spectrum__pole" :class="{ 'is-active': s.isLeft }">{{ s.left.code }}</text>
            <view class="spectrum__track">
              <view class="spectrum__mid"></view>
              <view
                class="spectrum__thumb"
                :class="{ 'is-soft': s.low }"
                :style="{ left: s.pos + '%', background: s.low ? 'var(--skn-color-spectrum-thumb-soft)' : s.color, borderColor: s.color }"
              ></view>
            </view>
            <text class="spectrum__pole" :class="{ 'is-active': !s.isLeft }">{{ s.right.code }}</text>
          </view>

          <view class="axis__foot">
            <text class="axis__poles-name">{{ s.left.name }} · {{ s.right.name }}</text>
            <text class="axis__conf">置信 <text class="fr">{{ s.percent }}</text>%</text>
          </view>

          <view v-if="openAxis === s.key" class="edu" :style="{ background: s.tint }">
            <text class="edu__text">{{ s.blurb }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 分区评估 -->
    <view class="card">
      <view class="card__head">
        <text class="card__title">分区评估</text>
        <text class="card__hint">{{ report.zones.length }} 个部位</text>
      </view>
      <view class="zones">
        <view v-for="z in report.zones" :key="z.area" class="zone">
          <view class="zone__top">
            <text class="zone__area">{{ z.area }}</text>
            <view class="zone__score">
              <text class="zone__score-num fr">{{ z.score }}</text>
              <text class="zone__score-max">/10</text>
            </view>
          </view>
          <view class="zone__bar">
            <view class="zone__bar-fill" :style="{ width: z.score * 10 + '%' }"></view>
          </view>
          <view class="zone__issues">
            <text v-for="issue in z.issues" :key="issue" class="chip">{{ issue }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 护理建议 -->
    <view class="card">
      <view class="card__head">
        <text class="card__title">护理建议</text>
        <text class="card__hint">成分 / 品类</text>
      </view>
      <view class="tips">
        <view v-for="(tip, i) in report.suggestions" :key="i" class="tip">
          <text class="tip__idx fr">{{ i + 1 }}</text>
          <text class="tip__text">{{ tip }}</text>
        </view>
      </view>
    </view>

    <!-- 免责声明(收敛结果页一处) -->
    <view class="note">
      <text class="note__text">{{ report.disclaimer }}</text>
    </view>

    <!-- 底部操作 -->
    <view class="actions">
      <view class="btn btn--ghost" hover-class="btn--tap" @click="restart"><text class="btn__t">重新分析</text></view>
      <view
        v-if="!fromHistory"
        class="btn btn--primary"
        :class="{ 'btn--done': saved }"
        hover-class="btn--tap"
        @click="save"
      >
        <text class="btn__t">{{ saved ? '已保存' : '保存报告' }}</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import type { SkinReport } from '@/types/skin-report'
import { sampleReport } from '@/mock/sample-report'
import { getHistoryItem, saveHistory } from '../../utils/history'
import { takePendingAnalysis } from '../../utils/api'

// report 来源:?id= 历史回看(读本地那条);?from=analysis 新分析(取拍照页暂存的 envelope);无参为示例(sampleReport)
const report = ref<SkinReport>(sampleReport)
const fromHistory = ref(false) // 回看态:隐藏「保存报告」(已在历史中)
const saved = ref(false) // 本次已存,防重复写入
const analysisMeta = ref<{ id: string; createdAt: number } | null>(null) // 新分析的 server id/时间,保存历史时沿用

onLoad((q) => {
  const id = q?.id
  if (id) {
    const item = getHistoryItem(id)
    if (item) {
      report.value = item.report
      fromHistory.value = true
    }
    return
  }
  // 新分析:暂存单次取用;H5 刷新后暂存已失(模块态),回落示例报告
  if (q?.from === 'analysis') {
    const p = takePendingAnalysis()
    if (p) {
      report.value = p.report
      analysisMeta.value = { id: p.id, createdAt: p.createdAt }
    }
  }
})

type AxisKey = keyof SkinReport['skinAxes']
interface AxisMeta {
  key: AxisKey
  label: string
  left: { code: string; name: string } // 左极:判定为此 code 时 thumb 偏左
  right: { code: string; name: string }
  color: string // 该维度主色(css var)
  tint: string // 科普展开浅底,与 color 成对(design-tokens「科普四维卡」)
  blurb: string // 逐维度科普:当前维度看什么,描述性、不作诊断(合规)
}

// 维度色 + 科普浅底沿用 design-tokens 语义配对(「科普四维卡图标浅底,与对应维度配色成对」):
// 油脂→gold、敏感→clay、痘痘→rose、色沉→brown。blurb = 逐维度科普(落地 ADR 0006「科普页逐维度讲解」意图),描述性、不作诊断。
const AXES: AxisMeta[] = [
  {
    key: 'oilDry', label: '油脂',
    left: { code: 'O', name: '偏油' }, right: { code: 'D', name: '偏干' },
    color: 'var(--skn-color-brand-gold)', tint: 'var(--skn-color-tint-gold)',
    blurb: '这一维度看皮脂分泌偏旺盛还是偏少。偏油时 T 区易泛光、毛孔较明显;偏干时洁面后易紧绷、换季易起皮。不少人是 T 区偏油、两颊偏干的混合状态。',
  },
  {
    key: 'sensitivity', label: '敏感',
    left: { code: 'S', name: '敏感' }, right: { code: 'R', name: '耐受' },
    color: 'var(--skn-color-brand-clay)', tint: 'var(--skn-color-tint-clay)',
    blurb: '这一维度看皮肤对外界刺激的耐受程度。偏敏感时遇冷热、换护肤品容易泛红或刺痛;耐受较好则不易受影响。个体差异较大,置信偏低时请当作「参考」看待。',
  },
  {
    key: 'acne', label: '痘痘',
    left: { code: 'A', name: '有痘' }, right: { code: 'F', name: '无痘' },
    color: 'var(--skn-color-brand-rose-deep)', tint: 'var(--skn-color-tint-rose)',
    blurb: '这一维度看照片中是否有较明显的粉刺、痘痘及其分布,常与油脂、清洁、作息相关。此处仅描述当前呈现的状态,不对成因或病症下判断。',
  },
  {
    key: 'pigment', label: '色沉',
    left: { code: 'P', name: '色沉' }, right: { code: 'N', name: '均匀' },
    color: 'var(--skn-color-text-brown)', tint: 'var(--skn-color-tint-brown)',
    blurb: '这一维度看肤色是否均匀,有无痘印、晒斑等色素沉着。均匀的肤色更显气色;日常做好防晒,是常见的护肤基础。',
  },
]

const LOW_CONF = 0.6 // 低于此判为「参考」

// 逐维度科普展开:手风琴式,同一时刻至多一维展开(再点已展开的则收起)
const openAxis = ref<AxisKey | ''>('')
function toggleAxis(k: AxisKey) {
  openAxis.value = openAxis.value === k ? '' : k
}

const spectrums = computed(() =>
  AXES.map((axis) => {
    const ax = report.value.skinAxes[axis.key]
    const isLeft = ax.value === axis.left.code
    const active = isLeft ? axis.left : axis.right
    // 置信越高越远离中点(50%);offset 上限 40%,clamp 保证 thumb 落在 [10%,90%]
    const offset = Math.min(Math.max(ax.confidence, 0), 1) * 40
    return {
      key: axis.key,
      label: axis.label,
      color: axis.color,
      tint: axis.tint,
      blurb: axis.blurb,
      left: axis.left,
      right: axis.right,
      isLeft,
      activeName: active.name,
      pos: isLeft ? 50 - offset : 50 + offset,
      percent: Math.round(ax.confidence * 100),
      low: ax.confidence < LOW_CONF,
    }
  })
)

// 返回上一页;无上一页(H5 刷新 / 深链直达)兜底回首页
function goBack() {
  if (getCurrentPages().length > 1) {
    uni.navigateBack()
  } else {
    uni.reLaunch({ url: '/pages/index/index' })
  }
}

// 重新分析回拍照页
function restart() {
  uni.redirectTo({ url: '/pages/capture/capture' })
}
// 保存报告到本地历史(uni Storage,游客态仅存设备本地);防重复写入;新分析沿用 server 的 id/时间
function save() {
  if (saved.value) return
  saveHistory(report.value, analysisMeta.value ?? undefined)
  saved.value = true
  uni.showToast({ title: '已保存到本地', icon: 'success' })
}
</script>

<style lang="scss" scoped>
.report {
  padding: 28px 16px 40px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

/* ── 顶栏(返回)── */
.topbar {
  display: flex;
}
.topbar__back {
  width: 34px;
  height: 34px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: var(--skn-color-surface-card);
  border: 1px solid var(--skn-color-line-hairline);

  &--tap {
    opacity: 0.6;
  }
  /* CSS 画左箭头(原 ‹ 字形墨水随字体基线偏移不居中,三端字体又不一致):
     两边框转 45° 成 <,墨水集中在旋转后菱形左半,translateX 补回光学居中 */
  &-icon {
    width: 9px;
    height: 9px;
    border-left: 2px solid var(--skn-color-text-brown);
    border-bottom: 2px solid var(--skn-color-text-brown);
    transform: translateX(3px) rotate(45deg);
  }
}

/* ── Hero ── */
.hero {
  padding: 4px 4px 2px;

  &__overline {
    display: block;
    font-size: var(--skn-typography-size-xs);
    letter-spacing: 0.18em;
    color: var(--skn-color-text-muted);
    text-transform: uppercase;
  }
  &__code {
    display: block;
    margin-top: 12px;
    font-size: 46px;
    line-height: 1.05;
    letter-spacing: 0.04em;
    color: var(--skn-color-brand-rose-wood);
  }
  &__name-row {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 12px;
  }
  &__name {
    font-size: var(--skn-typography-size-2xl);
    font-weight: 600;
    color: var(--skn-color-text-ink);
  }
  &__badge {
    font-size: var(--skn-typography-size-xs);
    color: var(--skn-color-brand-rose-deep);
    background: var(--skn-color-surface-pill);
    padding: 3px 9px;
    border-radius: 999px;
  }
  &__desc {
    display: block;
    margin-top: 12px;
    font-size: var(--skn-typography-size-base);
    line-height: var(--skn-typography-leading-body);
    color: var(--skn-color-text-muted);
  }
}

/* ── 卡片外壳 ── */
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
    letter-spacing: 0.05em;
    color: var(--skn-color-text-faint);
  }
}

/* ── 四维光谱 ── */
.axes {
  display: flex;
  flex-direction: column;
  gap: 18px;
}
.axis {
  &__head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 10px;
  }
  &__label {
    display: flex;
    align-items: center;
    gap: 7px;
  }
  &__dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
  }
  &__name {
    font-size: var(--skn-typography-size-md);
    font-weight: 500;
    color: var(--skn-color-text-ink);
  }
  &__info {
    width: 18px;
    height: 18px;
    border-radius: 50%;
    border: 1px solid var(--skn-color-line-hairline);
    display: flex;
    align-items: center;
    justify-content: center;

    &--tap {
      opacity: 0.5;
    }
    &.is-open {
      background: var(--skn-color-brand-rose-deep);
      border-color: var(--skn-color-brand-rose-deep);

      .axis__info-q {
        color: #fff;
      }
    }
  }
  &__info-q {
    font-size: 11px;
    line-height: 1;
    color: var(--skn-color-text-faint);
  }
  &__verdict {
    display: flex;
    align-items: center;
    gap: 6px;
  }
  &__verdict-name {
    font-size: var(--skn-typography-size-md);
    font-weight: 600;
  }
  &__ref {
    font-size: 10px;
    color: var(--skn-color-text-muted-soft);
    border: 1px dashed var(--skn-color-spectrum-thumb-soft);
    border-radius: 999px;
    padding: 1px 6px;
  }
  &__foot {
    display: flex;
    justify-content: space-between;
    margin-top: 8px;
  }
  &__poles-name {
    font-size: var(--skn-typography-size-xs);
    color: var(--skn-color-text-faint);
  }
  &__conf {
    font-size: var(--skn-typography-size-xs);
    color: var(--skn-color-text-muted);
  }
}
.spectrum {
  display: flex;
  align-items: center;
  gap: 10px;

  &__pole {
    flex-shrink: 0;
    width: 16px;
    text-align: center;
    font-size: var(--skn-typography-size-sm);
    font-weight: 600;
    color: var(--skn-color-text-faint);

    &.is-active {
      color: var(--skn-color-text-brown);
    }
  }
  &__track {
    position: relative;
    flex: 1;
    height: 6px;
    background: var(--skn-color-spectrum-track);
    border-radius: 999px;
  }
  &__mid {
    position: absolute;
    left: 50%;
    top: -3px;
    bottom: -3px;
    width: 1px;
    background: var(--skn-color-spectrum-midline);
  }
  &__thumb {
    position: absolute;
    top: 50%;
    width: 16px;
    height: 16px;
    border-width: 2px;
    border-style: solid;
    border-radius: 50%;
    transform: translate(-50%, -50%);
    box-shadow: 0 2px 6px rgba(160, 90, 72, 0.28);

    &.is-soft {
      border-style: dashed;
      box-shadow: none;
    }
  }
}

/* ── 逐维度科普展开 ── */
.edu {
  margin-top: 10px;
  padding: 11px 13px;
  border-radius: var(--skn-radius-lg);
  animation: edu-in 0.22s ease;
}
.edu__text {
  font-size: var(--skn-typography-size-xs);
  line-height: 1.75;
  color: var(--skn-color-text-brown);
}
@keyframes edu-in {
  from {
    opacity: 0;
    transform: translateY(-4px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* ── 分区评估 ── */
.zones {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.zone {
  &__top {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    margin-bottom: 8px;
  }
  &__area {
    font-size: var(--skn-typography-size-md);
    font-weight: 500;
    color: var(--skn-color-text-ink);
  }
  &__score {
    display: flex;
    align-items: baseline;
    gap: 1px;
  }
  &__score-num {
    font-size: var(--skn-typography-size-2xl);
    line-height: 1;
    color: var(--skn-color-brand-rose-deep);
  }
  &__score-max {
    font-size: var(--skn-typography-size-xs);
    color: var(--skn-color-text-faint);
  }
  &__bar {
    height: 5px;
    margin-bottom: 10px;
    background: var(--skn-color-spectrum-track);
    border-radius: 999px;
    overflow: hidden;
  }
  &__bar-fill {
    height: 100%;
    border-radius: 999px;
    background: linear-gradient(90deg, var(--skn-gradient-photo-from), var(--skn-gradient-cta-to));
  }
  &__issues {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }
}
.chip {
  font-size: var(--skn-typography-size-xs);
  color: var(--skn-color-text-brown);
  background: var(--skn-color-tint-rose);
  padding: 3px 10px;
  border-radius: 999px;
}

/* ── 护理建议 ── */
.tips {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.tip {
  display: flex;
  gap: 11px;
  align-items: flex-start;

  &__idx {
    flex-shrink: 0;
    width: 16px;
    font-size: var(--skn-typography-size-lg);
    line-height: 1.5;
    color: var(--skn-color-brand-rose-deep);
  }
  &__text {
    flex: 1;
    font-size: var(--skn-typography-size-base);
    line-height: var(--skn-typography-leading-body);
    color: var(--skn-color-text-brown);
  }
}

/* ── 免责声明 ── */
.note {
  background: var(--skn-color-surface-note);
  border-radius: var(--skn-radius-md);
  padding: 12px 14px;

  &__text {
    font-size: var(--skn-typography-size-xs);
    line-height: 1.6;
    color: var(--skn-color-text-muted);
  }
}

/* ── 底部操作 ── */
.actions {
  display: flex;
  gap: 10px;
  margin-top: 4px;
}
.btn {
  flex: 1;
  height: 46px;
  border-radius: var(--skn-radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;

  &--tap {
    transform: scale(0.98);
    opacity: 0.92;
  }
  &__t {
    font-size: var(--skn-typography-size-md);
    font-weight: 600;
  }
  &--ghost {
    background: var(--skn-color-surface-card);
    border: 1px solid var(--skn-color-line-hairline);

    .btn__t {
      color: var(--skn-color-text-brown);
    }
  }
  &--primary {
    background: linear-gradient(135deg, var(--skn-gradient-cta-from), var(--skn-gradient-cta-to));
    box-shadow: var(--skn-shadow-cta);

    .btn__t {
      color: #fff;
    }
  }
  &--done {
    opacity: 0.55;
    box-shadow: none;
  }
}
</style>
