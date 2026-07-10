// 结果报告(全屏二级页):hero 型号 + 四维双极光谱(逐维科普手风琴)+ 分区评估 + 护理建议 + 免责 note + 操作。
// 对齐 app-uni pages/result/result.vue;report 缺省渲染示例数据,切片 D 接真实分析、切片 E 接历史回看与保存。
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../mock/sample_report.dart';
import '../models/skin_report.dart';
import '../theme/tokens.dart';
import '../widgets/dashed_outline.dart';
import '../widgets/press.dart';
import '../widgets/skn_card.dart';
import '../widgets/skn_shell.dart';
import 'capture_page.dart';

/// 维度静态元信息。色 + 科普浅底沿用 design-tokens 语义配对(「科普四维卡图标浅底,与对应维度配色成对」):
/// 油脂→gold、敏感→clay、痘痘→rose、色沉→brown。blurb = 逐维度科普(落地 ADR 0006「科普页逐维度讲解」意图),
/// 描述性、不作诊断(合规)。
class _AxisMeta {
  const _AxisMeta({
    required this.label,
    required this.leftCode,
    required this.leftName,
    required this.rightCode,
    required this.rightName,
    required this.color,
    required this.tint,
    required this.blurb,
    required this.pick,
  });

  final String label;

  /// 左极:判定为此 code 时 thumb 偏左
  final String leftCode;
  final String leftName;
  final String rightCode;
  final String rightName;
  final Color color;
  final Color tint;
  final String blurb;

  /// 从报告取该维度 (判定码, 置信度);Dart 无 TS 的 keyof 动态索引,以取值函数替代
  final (String, double) Function(SkinAxes axes) pick;
}

final _axes = [
  _AxisMeta(
    label: '油脂',
    leftCode: 'O',
    leftName: '偏油',
    rightCode: 'D',
    rightName: '偏干',
    color: SknColors.brandGold,
    tint: SknColors.tintGold,
    blurb:
        '这一维度看皮脂分泌偏旺盛还是偏少。偏油时 T 区易泛光、毛孔较明显;偏干时洁面后易紧绷、换季易起皮。不少人是 T 区偏油、两颊偏干的混合状态。',
    pick: (a) => (a.oilDry.value.name, a.oilDry.confidence),
  ),
  _AxisMeta(
    label: '敏感',
    leftCode: 'S',
    leftName: '敏感',
    rightCode: 'R',
    rightName: '耐受',
    color: SknColors.brandClay,
    tint: SknColors.tintClay,
    blurb:
        '这一维度看皮肤对外界刺激的耐受程度。偏敏感时遇冷热、换护肤品容易泛红或刺痛;耐受较好则不易受影响。个体差异较大,置信偏低时请当作「参考」看待。',
    pick: (a) => (a.sensitivity.value.name, a.sensitivity.confidence),
  ),
  _AxisMeta(
    label: '痘痘',
    leftCode: 'A',
    leftName: '有痘',
    rightCode: 'F',
    rightName: '无痘',
    color: SknColors.brandRoseDeep,
    tint: SknColors.tintRose,
    blurb: '这一维度看照片中是否有较明显的粉刺、痘痘及其分布,常与油脂、清洁、作息相关。此处仅描述当前呈现的状态,不对成因或病症下判断。',
    pick: (a) => (a.acne.value.name, a.acne.confidence),
  ),
  _AxisMeta(
    label: '色沉',
    leftCode: 'P',
    leftName: '色沉',
    rightCode: 'N',
    rightName: '均匀',
    color: SknColors.textBrown,
    tint: SknColors.tintBrown,
    blurb: '这一维度看肤色是否均匀,有无痘印、晒斑等色素沉着。均匀的肤色更显气色;日常做好防晒,是常见的护肤基础。',
    pick: (a) => (a.pigment.value.name, a.pigment.confidence),
  ),
];

const _lowConf = 0.6; // 低于此判为「参考」

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, this.report, this.fromHistory = false});

  /// 为空时渲染示例报告(首页「先看一份示例报告」入口)
  final SkinReport? report;

  /// 历史回看态:隐藏「保存报告」(已在历史中)
  final bool fromHistory;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? _openAxis; // 科普手风琴:同一时刻至多一维展开(存维度 label)
  var _saved = false; // 本次已存,防重复写入

  SkinReport get _report => widget.report ?? sampleReport;

  void _toggleAxis(String key) =>
      setState(() => _openAxis = _openAxis == key ? null : key);

  // 重新分析回拍照页(对齐 uni redirectTo:替换当前页)
  void _restart() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const CapturePage()));
  }

  // 保存报告到本地历史:切片 E 接 shared_preferences 真实写入,当前先翻 UI 态
  void _save() {
    if (_saved) return;
    setState(() => _saved = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已保存到本地')));
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;
    return Container(
      // 页面渐变底(180deg bg-top → bg-bottom),二级页自带(RootShell 的底不随 push 路由走)
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [SknColors.surfaceBgTop, SknColors.surfaceBgBottom],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SknShell(
            child: SingleChildScrollView(
              child: Padding(
                // uni 的顶 28 含 H5 无状态栏时的留白;状态栏由 SafeArea 承担,余量减半
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _TopBar(),
                    const SizedBox(height: 14),
                    _Hero(report: report),
                    const SizedBox(height: 14),
                    SknCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _CardHead(title: '肤质四维', hint: '双极光谱'),
                          for (var i = 0; i < _axes.length; i++) ...[
                            if (i > 0) const SizedBox(height: 18),
                            _AxisView(
                              meta: _axes[i],
                              axes: report.skinAxes,
                              open: _openAxis == _axes[i].label,
                              onToggle: () => _toggleAxis(_axes[i].label),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SknCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _CardHead(
                            title: '分区评估',
                            hint: '${report.zones.length} 个部位',
                          ),
                          for (var i = 0; i < report.zones.length; i++) ...[
                            if (i > 0) const SizedBox(height: 16),
                            _ZoneView(zone: report.zones[i]),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SknCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _CardHead(title: '护理建议', hint: '成分 / 品类'),
                          for (
                            var i = 0;
                            i < report.suggestions.length;
                            i++
                          ) ...[
                            if (i > 0) const SizedBox(height: 12),
                            _TipRow(index: i + 1, text: report.suggestions[i]),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // 免责声明(收敛结果页一处,ADR 0008)
                    Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        14,
                        12,
                        14,
                        12,
                      ),
                      decoration: BoxDecoration(
                        color: SknColors.surfaceNote,
                        borderRadius: BorderRadius.circular(SknRadius.md),
                      ),
                      child: Text(
                        report.disclaimer,
                        style: const TextStyle(
                          fontSize: SknTypography.sizeXs,
                          height: 1.6,
                          color: SknColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Press(
                            semanticLabel: '重新分析',
                            pressedScale: 0.98,
                            pressedOpacity: 0.92,
                            onTap: _restart,
                            child: Container(
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: SknColors.surfaceCard,
                                border: Border.all(
                                  color: SknColors.lineHairline,
                                ),
                                borderRadius: BorderRadius.circular(
                                  SknRadius.lg,
                                ),
                              ),
                              child: const Text(
                                '重新分析',
                                style: TextStyle(
                                  fontSize: SknTypography.sizeMd,
                                  fontWeight: FontWeight.w600,
                                  color: SknColors.textBrown,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (!widget.fromHistory) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: Press(
                              semanticLabel: _saved ? '已保存' : '保存报告',
                              pressedScale: 0.98,
                              pressedOpacity: 0.92,
                              onTap: _save,
                              child: Opacity(
                                opacity: _saved ? 0.55 : 1,
                                child: Container(
                                  height: 46,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      SknRadius.lg,
                                    ),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        SknGradients.ctaFrom,
                                        SknGradients.ctaTo,
                                      ],
                                    ),
                                    boxShadow: _saved
                                        ? null
                                        : const [SknShadows.cta],
                                  ),
                                  child: Text(
                                    _saved ? '已保存' : '保存报告',
                                    style: const TextStyle(
                                      fontSize: SknTypography.sizeMd,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 顶栏返回钮:自绘 < 箭头(文字 ‹ 的墨水随字体基线偏移不居中,三端字体不一)。
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Press(
          semanticLabel: '返回',
          pressedScale: 1,
          pressedOpacity: 0.6,
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SknColors.surfaceCard,
              border: Border.all(color: SknColors.lineHairline),
            ),
            // 两边框转 45° 成 <,墨水集中在旋转后菱形左半,右移 3 补回光学居中
            child: Transform.translate(
              offset: const Offset(3, 0),
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: SknColors.textBrown, width: 2),
                      bottom: BorderSide(color: SknColors.textBrown, width: 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 报告头:overline + 型号码(Fraunces 大字)+ 型号名 + 概述。
class _Hero extends StatelessWidget {
  const _Hero({required this.report});

  final SkinReport report;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SKINLENS · 肤质参考报告',
            style: TextStyle(
              fontSize: SknTypography.sizeXs,
              letterSpacing: SknTypography.sizeXs * 0.18,
              color: SknColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            report.skinTypeCode,
            style: const TextStyle(
              fontFamily: 'Fraunces',
              fontSize: 46,
              height: 1.05,
              letterSpacing: 46 * 0.04,
              color: SknColors.brandRoseWood,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                report.skinTypeName,
                style: const TextStyle(
                  fontSize: SknTypography.sizeXl2,
                  fontWeight: FontWeight.w600,
                  color: SknColors.textInk,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsetsDirectional.fromSTEB(9, 3, 9, 3),
                decoration: BoxDecoration(
                  color: SknColors.surfacePill,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'AI 分析',
                  style: TextStyle(
                    fontSize: SknTypography.sizeXs,
                    color: SknColors.brandRoseDeep,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '综合四个维度判定,置信偏低的维度以「参考」呈现,结果仅供护肤参考。',
            style: TextStyle(
              fontSize: SknTypography.sizeBase,
              height: SknTypography.leadingBody,
              color: SknColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// 卡片头:标题 + 右侧弱提示,基线对齐。
class _CardHead extends StatelessWidget {
  const _CardHead({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: SknTypography.sizeLg,
              fontWeight: FontWeight.w600,
              color: SknColors.textInk,
            ),
          ),
          Text(
            hint,
            style: const TextStyle(
              fontSize: SknTypography.sizeXs,
              letterSpacing: SknTypography.sizeXs * 0.05,
              color: SknColors.textFaint,
            ),
          ),
        ],
      ),
    );
  }
}

/// 单维度:判定行 + 双极光谱 + 两极名/置信 + 科普展开。
class _AxisView extends StatelessWidget {
  const _AxisView({
    required this.meta,
    required this.axes,
    required this.open,
    required this.onToggle,
  });

  final _AxisMeta meta;
  final SkinAxes axes;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final (code, confidence) = meta.pick(axes);
    final isLeft = code == meta.leftCode;
    final activeName = isLeft ? meta.leftName : meta.rightName;
    // 置信越高越远离中点(50%);offset 上限 40%,保证 thumb 落在 [10%,90%]
    final offset = confidence.clamp(0.0, 1.0) * 40;
    final pos = isLeft ? 50 - offset : 50 + offset;
    final percent = (confidence * 100).round();
    final low = confidence < _lowConf;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: meta.color,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  meta.label,
                  style: const TextStyle(
                    fontSize: SknTypography.sizeMd,
                    fontWeight: FontWeight.w500,
                    color: SknColors.textInk,
                  ),
                ),
                const SizedBox(width: 7),
                Press(
                  semanticLabel: '${meta.label}维度说明',
                  pressedScale: 1,
                  pressedOpacity: 0.5,
                  onTap: onToggle,
                  child: Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: open ? SknColors.brandRoseDeep : null,
                      border: Border.all(
                        color: open
                            ? SknColors.brandRoseDeep
                            : SknColors.lineHairline,
                      ),
                    ),
                    child: Text(
                      '?',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1,
                        color: open ? Colors.white : SknColors.textFaint,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  activeName,
                  style: TextStyle(
                    fontSize: SknTypography.sizeMd,
                    fontWeight: FontWeight.w600,
                    color: meta.color,
                  ),
                ),
                if (low) ...[
                  const SizedBox(width: 6),
                  CustomPaint(
                    foregroundPainter: DashedOutline(
                      color: SknColors.spectrumThumbSoft,
                      dash: 3,
                      gap: 2.5,
                      rrectOf: (s) => RRect.fromRectAndRadius(
                        (Offset.zero & s).deflate(0.5),
                        const Radius.circular(999),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(6, 1, 6, 1),
                      child: Text(
                        '参考',
                        style: TextStyle(
                          fontSize: 10,
                          color: SknColors.textMutedSoft,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _Pole(code: meta.leftCode, active: isLeft),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 16,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    return Stack(
                      children: [
                        // 轨道(6 高居中)
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 5,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: SknColors.spectrumTrack,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        // 中线(含糊区界)
                        Positioned(
                          left: w / 2 - 0.5,
                          top: 2,
                          bottom: 2,
                          child: Container(
                            width: 1,
                            color: SknColors.spectrumMidline,
                          ),
                        ),
                        // 滑块:低置信 = 软色底 + 虚线边、无阴影
                        Positioned(
                          left: w * pos / 100 - 8,
                          top: 0,
                          child: low
                              ? CustomPaint(
                                  foregroundPainter: DashedOutline(
                                    color: meta.color,
                                    strokeWidth: 2,
                                    dash: 3,
                                    gap: 2.5,
                                    rrectOf: (s) => RRect.fromRectAndRadius(
                                      (Offset.zero & s).deflate(1),
                                      const Radius.circular(8),
                                    ),
                                  ),
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: SknColors.spectrumThumbSoft,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: meta.color,
                                    border: Border.all(
                                      color: meta.color,
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(
                                          160,
                                          90,
                                          72,
                                          0.28,
                                        ),
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            _Pole(code: meta.rightCode, active: !isLeft),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${meta.leftName} · ${meta.rightName}',
              style: const TextStyle(
                fontSize: SknTypography.sizeXs,
                color: SknColors.textFaint,
              ),
            ),
            Text.rich(
              TextSpan(
                text: '置信 ',
                children: [
                  TextSpan(
                    text: '$percent',
                    style: const TextStyle(fontFamily: 'Fraunces'),
                  ),
                  const TextSpan(text: '%'),
                ],
              ),
              style: const TextStyle(
                fontSize: SknTypography.sizeXs,
                color: SknColors.textMuted,
              ),
            ),
          ],
        ),
        if (open)
          TweenAnimationBuilder<double>(
            // 展开入场(fade + 上移 4,对齐 edu-in);切换维度时 key 变化重播;系统关动画则直出
            key: ValueKey('edu-${meta.label}'),
            tween: Tween(begin: 0, end: 1),
            duration: MediaQuery.of(context).disableAnimations
                ? Duration.zero
                : const Duration(milliseconds: 220),
            curve: Curves.ease,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, -4 * (1 - t)),
                child: child,
              ),
            ),
            child: Container(
              margin: const EdgeInsetsDirectional.only(top: 10),
              padding: const EdgeInsetsDirectional.fromSTEB(13, 11, 13, 11),
              decoration: BoxDecoration(
                color: meta.tint,
                borderRadius: BorderRadius.circular(SknRadius.lg),
              ),
              child: Text(
                meta.blurb,
                style: const TextStyle(
                  fontSize: SknTypography.sizeXs,
                  height: 1.75,
                  color: SknColors.textBrown,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 光谱两极字母:判定侧加深。
class _Pole extends StatelessWidget {
  const _Pole({required this.code, required this.active});

  final String code;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      child: Text(
        code,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: SknTypography.sizeSm,
          fontWeight: FontWeight.w600,
          color: active ? SknColors.textBrown : SknColors.textFaint,
        ),
      ),
    );
  }
}

/// 分区行:部位 + 评分大字 + 进度条 + 问题 chips。
class _ZoneView extends StatelessWidget {
  const _ZoneView({required this.zone});

  final Zone zone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              zone.area,
              style: const TextStyle(
                fontSize: SknTypography.sizeMd,
                fontWeight: FontWeight.w500,
                color: SknColors.textInk,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${zone.score}',
                  style: const TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: SknTypography.sizeXl2,
                    height: 1,
                    color: SknColors.brandRoseDeep,
                  ),
                ),
                const SizedBox(width: 1),
                const Text(
                  '/10',
                  style: TextStyle(
                    fontSize: SknTypography.sizeXs,
                    color: SknColors.textFaint,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 5,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: SknColors.spectrumTrack,
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: zone.score / 10,
            heightFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [SknGradients.photoFrom, SknGradients.ctaTo],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final issue in zone.issues)
              Container(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 3, 10, 3),
                decoration: BoxDecoration(
                  color: SknColors.tintRose,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  issue,
                  style: const TextStyle(
                    fontSize: SknTypography.sizeXs,
                    color: SknColors.textBrown,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// 建议行:Fraunces 序号 + 正文。
class _TipRow extends StatelessWidget {
  const _TipRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 16,
          child: Text(
            '$index',
            style: const TextStyle(
              fontFamily: 'Fraunces',
              fontSize: SknTypography.sizeLg,
              height: 1.5,
              color: SknColors.brandRoseDeep,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: SknTypography.sizeBase,
              height: SknTypography.leadingBody,
              color: SknColors.textBrown,
            ),
          ),
        ),
      ],
    );
  }
}
