// 我的(tab 根页):游客态用户卡 + 我的检测(本地历史)+ 免责/隐私/关于底部弹层。
// 对齐 app-uni pages/mine/mine.vue;文案全部平移。本地历史 shared_preferences:有记录出列表点击回看,空态去检测。
import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/tokens.dart';
import '../utils/history.dart';
import '../widgets/press.dart';
import '../widgets/skn_card.dart';
import '../widgets/skn_shell.dart';
import 'capture_page.dart';
import 'result_page.dart';

/// 完整声明文案:合规定位「参考/建议」,不含诊断/疗效宣称(结果页 inline note 之外的可点完整入口,ADR 0008)。
const _sheets = {
  'disclaimer': (
    '免责声明',
    [
      '肤镜是一款 AI 肤质参考助手,不是医疗诊断工具。',
      '分析结果由 AI 模型生成,仅供护肤参考,不构成任何医疗建议或诊断结论。',
      '结果可能存在偏差,置信度较低的维度已标注「参考」,请理性看待。',
      '如有严重或持续的皮肤问题,请及时就医,遵从专业皮肤科医生的判断。',
    ],
  ),
  'privacy': (
    '隐私说明',
    ['你上传的照片仅用于本次肤质分析。', '照片在分析完成后即时删除,不做长期存储。', '分析生成的报告默认仅保存在你的设备本地。'],
  ),
  'about': (
    '关于肤镜',
    [
      '肤镜 SKINLENS · 肤质参考助手 v0.1(MVP)。',
      '拍照 → AI 分区分析 → 结构化肤质报告 + 护理建议。',
      '一套 Cloudflare 后端,uniapp 与 flutter 双端复刻同一 API。',
    ],
  ),
};

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with RouteAware {
  var _history = <HistoryItem>[];

  // 进页读一次 + 每次二级页返回再刷(didPopNext ≈ uni onShow:结果页保存后返回即更新)。
  // IndexedStack 里本页常驻,订阅的是根 route,保存时不管停在哪个 tab 都能收到。
  Future<void> _load() async {
    final list = await listHistory();
    if (!mounted) return;
    setState(() => _history = list);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() => _load();

  // 历史回看:直传本地那条的 report,fromHistory 隐藏「保存报告」(已在历史中)
  void _openReport(HistoryItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResultPage(report: item.report, fromHistory: true),
      ),
    );
  }

  void _openSheet(BuildContext context, String key) {
    final (title, paras) = _sheets[key]!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: SknColors.surfaceCard,
      barrierColor: const Color.fromRGBO(60, 40, 34, 0.44),
      constraints: const BoxConstraints(maxWidth: 600), // 平板限宽对齐 skn-shell
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SknRadius.xl3),
        ),
      ),
      builder: (context) => _Sheet(title: title, paras: paras),
    );
  }

  void _goCapture(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CapturePage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SknShell(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 36, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(6, 0, 6, 2),
                        child: Text(
                          '我的',
                          style: TextStyle(
                            fontSize: SknTypography.sizeXl2,
                            fontWeight: FontWeight.w700,
                            color: SknColors.brandRoseWood,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const _UserCard(),
                      const SizedBox(height: 14),
                      _HistoryCard(
                        items: _history,
                        onGoCapture: () => _goCapture(context),
                        onOpen: _openReport,
                      ),
                      const SizedBox(height: 14),
                      _InfoList(onOpen: (k) => _openSheet(context, k)),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 20),
                        child: Text(
                          'SKINLENS · 肤质参考助手',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SknTypography.sizeXs,
                            letterSpacing: SknTypography.sizeXs * 0.14,
                            color: SknColors.textFaint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 用户卡:MVP 无登录,游客态。
class _UserCard extends StatelessWidget {
  const _UserCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(6, 4, 6, 8),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [SknGradients.photoFrom, SknGradients.ctaTo],
              ),
              boxShadow: [SknShadows.cta],
            ),
            child: const Text(
              '肤',
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: SknTypography.sizeXl2,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '游客',
                style: TextStyle(
                  fontSize: SknTypography.sizeXl,
                  fontWeight: FontWeight.w600,
                  color: SknColors.textInk,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '本地体验 · 未登录',
                style: TextStyle(
                  fontSize: SknTypography.sizeXs,
                  color: SknColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 我的检测:本地历史。有记录出列表(型号码 + 名/时间,点击回看),无记录空态(去检测 CTA)。
class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.items,
    required this.onGoCapture,
    required this.onOpen,
  });

  final List<HistoryItem> items;
  final VoidCallback onGoCapture;
  final ValueChanged<HistoryItem> onOpen;

  // yyyy-MM-dd HH:mm(平移 uni fmt,不为此引 intl)
  String _fmt(int ts) {
    final d = DateTime.fromMillisecondsSinceEpoch(ts);
    String p(int n) => n < 10 ? '0$n' : '$n';
    return '${d.year}-${p(d.month)}-${p(d.day)} ${p(d.hour)}:${p(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return SknCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '我的检测',
                style: TextStyle(
                  fontSize: SknTypography.sizeLg,
                  fontWeight: FontWeight.w600,
                  color: SknColors.textInk,
                ),
              ),
              Text(
                '本地保存',
                style: TextStyle(
                  fontSize: SknTypography.sizeXs,
                  color: SknColors.textFaint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (items.isNotEmpty)
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: SknColors.lineDivider,
                ),
              _HistoryRow(
                item: items[i],
                time: _fmt(items[i].createdAt),
                onOpen: onOpen,
              ),
            ]
          else
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 6),
              child: Column(
                children: [
                  const Text(
                    '还没有检测记录',
                    style: TextStyle(
                      fontSize: SknTypography.sizeMd,
                      fontWeight: FontWeight.w500,
                      color: SknColors.textBrown,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    '完成一次拍照分析后,报告会显示在这里',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SknTypography.sizeXs,
                      height: 1.6,
                      color: SknColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Press(
                    semanticLabel: '去检测',
                    pressedScale: 0.98,
                    pressedOpacity: 0.92,
                    onTap: onGoCapture,
                    child: Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        24,
                        9,
                        24,
                        9,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SknRadius.lg),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [SknGradients.ctaFrom, SknGradients.ctaTo],
                        ),
                        boxShadow: const [SknShadows.cta],
                      ),
                      child: const Text(
                        '去检测',
                        style: TextStyle(
                          fontSize: SknTypography.sizeMd,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 历史行:型号码(Fraunces)+ 型号名/时间 + › 箭头,对齐 uni .hist__row。
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.item,
    required this.time,
    required this.onOpen,
  });

  final HistoryItem item;
  final String time;
  final ValueChanged<HistoryItem> onOpen;

  @override
  Widget build(BuildContext context) {
    return Press(
      semanticLabel: '查看报告:${item.report.skinTypeName} $time',
      pressedScale: 1,
      pressedOpacity: 0.55,
      onTap: () => onOpen(item),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(2, 13, 2, 13),
        child: Row(
          children: [
            Text(
              item.report.skinTypeCode,
              style: const TextStyle(
                fontFamily: 'Fraunces',
                fontSize: SknTypography.sizeMd,
                letterSpacing: SknTypography.sizeMd * 0.06,
                color: SknColors.brandRoseWood,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.report.skinTypeName,
                    style: const TextStyle(
                      fontSize: SknTypography.sizeMd,
                      fontWeight: FontWeight.w500,
                      color: SknColors.textInk,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: SknTypography.sizeXs,
                      color: SknColors.textFaint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '›',
              style: TextStyle(fontSize: 18, color: SknColors.textFaint),
            ),
          ],
        ),
      ),
    );
  }
}

/// 信息列表:免责声明 / 隐私说明 / 关于肤镜。
class _InfoList extends StatelessWidget {
  const _InfoList({required this.onOpen});

  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return SknCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
      child: Column(
        children: [
          _row(
            label: '免责声明',
            trailing: _arrow(),
            onTap: () => onOpen('disclaimer'),
          ),
          _divider(),
          _row(
            label: '隐私说明',
            trailing: _arrow(),
            onTap: () => onOpen('privacy'),
          ),
          _divider(),
          _row(
            label: '关于肤镜',
            trailing: const Text(
              'v0.1 · MVP',
              style: TextStyle(
                fontSize: SknTypography.sizeXs,
                color: SknColors.textFaint,
              ),
            ),
            onTap: () => onOpen('about'),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, thickness: 1, color: SknColors.lineDivider);

  Widget _arrow() => const Text(
    '›',
    style: TextStyle(fontSize: 18, color: SknColors.textFaint),
  );

  Widget _row({
    required String label,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Press(
      semanticLabel: label,
      pressedScale: 1,
      pressedOpacity: 0.55,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: SknTypography.sizeMd,
                color: SknColors.textInk,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// 底部弹层:grip + 标题 + 段落 + 「我知道了」。
class _Sheet extends StatelessWidget {
  const _Sheet({required this.title, required this.paras});

  final String title;
  final List<String> paras;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(22, 12, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: SknColors.spectrumMidline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: SknTypography.sizeXl,
                fontWeight: FontWeight.w700,
                color: SknColors.brandRoseWood,
              ),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < paras.length; i++) ...[
              if (i > 0) const SizedBox(height: 11),
              Text(
                paras[i],
                style: const TextStyle(
                  fontSize: SknTypography.sizeBase,
                  height: 1.7,
                  color: SknColors.textBrown,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Press(
              semanticLabel: '我知道了',
              pressedScale: 0.99,
              pressedOpacity: 0.93,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SknRadius.lg),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [SknGradients.ctaFrom, SknGradients.ctaTo],
                  ),
                  boxShadow: const [SknShadows.cta],
                ),
                child: const Text(
                  '我知道了',
                  style: TextStyle(
                    fontSize: SknTypography.sizeMd,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
