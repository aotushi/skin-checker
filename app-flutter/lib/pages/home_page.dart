// 首页(检测 tab 根页):品牌头 + 人脸拓扑取景意象(扫描光带动画)+ 能力亮点 + 双 CTA。
// 对齐 app-uni pages/index/index.vue;文案全部平移不新造(W3 切片 F 规则)。
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/tokens.dart';
import '../widgets/press.dart';
import '../widgets/skn_shell.dart';
import 'capture_page.dart';
import 'result_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _goCapture(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CapturePage()));
  }

  // 示例报告直接进结果卡(mock 数据),便于展示 —— 对齐 app-uni goSample。
  void _goSample(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ResultPage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SknShell(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(22, 40, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Brand(),
                const SizedBox(height: 34),
                const _Stage(),
                const SizedBox(height: 30),
                const _Feats(),
                const SizedBox(height: 28),
                Press(
                  semanticLabel: '开始检测',
                  onTap: () => _goCapture(context),
                  child: Container(
                    height: 50,
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
                      '开始检测',
                      style: TextStyle(
                        fontSize: SknTypography.sizeLg,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Press(
                  semanticLabel: '先看一份示例报告',
                  pressedOpacity: 0.6,
                  pressedScale: 1,
                  onTap: () => _goSample(context),
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    child: const Text(
                      '先看一份示例报告',
                      style: TextStyle(
                        fontSize: SknTypography.sizeMd,
                        color: SknColors.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  '结果由 AI 生成,仅供护肤参考,不构成医疗建议。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SknTypography.sizeXs,
                    height: 1.6,
                    color: SknColors.textFaint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 品牌头:拉丁 overline + 中文主名 + 一句话定位。
class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SKINLENS · 肤质参考助手'.toUpperCase(),
          style: const TextStyle(
            fontSize: SknTypography.sizeXs,
            letterSpacing: SknTypography.sizeXs * 0.18,
            color: SknColors.textMuted,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          '肤镜',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: 34 * 0.06,
            color: SknColors.brandRoseWood,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          '拍一张正脸,AI 读出你的肤质四维',
          style: TextStyle(
            fontSize: SknTypography.sizeLg,
            height: SknTypography.leadingBody,
            color: SknColors.textBrown,
          ),
        ),
      ],
    );
  }
}

/// 取景意象:photo 渐变框 + 拓扑网格 svg + 扫描光带(自上而下往返;系统关动画时静止)。
class _Stage extends StatefulWidget {
  const _Stage();

  @override
  State<_Stage> createState() => _StageState();
}

class _StageState extends State<_Stage> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Curves.easeInOut,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 对齐 CSS prefers-reduced-motion:系统关动画则光带静止在中部。
    if (MediaQuery.of(context).disableAnimations) {
      _c.stop();
      _c.value = 0.5;
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 208,
          height: 250,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SknRadius.phone),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SknGradients.photoFrom, SknGradients.photoTo],
            ),
            boxShadow: const [SknShadows.phone],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/face-scan.svg',
                  fit: BoxFit.fill,
                ),
              ),
              AnimatedBuilder(
                animation: _t,
                builder: (context, _) {
                  final v = _t.value;
                  return Positioned(
                    left: 26,
                    right: 26,
                    top: 44 + (198 - 44) * v,
                    child: Opacity(
                      opacity: 0.35 + (0.95 - 0.35) * v,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(210, 121, 92, 0),
                              Color.fromRGBO(210, 121, 92, 0.6),
                              Color.fromRGBO(210, 121, 92, 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '正脸 · 自然光 · 不化妆',
          style: TextStyle(
            fontSize: SknTypography.sizeSm,
            letterSpacing: SknTypography.sizeSm * 0.06,
            color: SknColors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// 能力亮点三行:Fraunces 序号 + 标题 + 描述,行间细分隔线。
class _Feats extends StatelessWidget {
  const _Feats();

  static const _items = [
    ('01', 'AI 分区分析', 'T 区、双颊、下巴逐区读取'),
    ('02', '16 型四维', '油脂 · 敏感 · 痘痘 · 色沉,各带置信'),
    ('03', '隐私 · 用后即删', '照片分析后即时删除,不长期存储'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _items.length; i++)
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(2, 13, 2, 13),
            decoration: BoxDecoration(
              border: i == _items.length - 1
                  ? null
                  : const Border(
                      bottom: BorderSide(color: SknColors.lineDivider),
                    ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 26,
                  child: Text(
                    _items[i].$1,
                    style: const TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: SknTypography.sizeXl,
                      color: SknColors.brandClay,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _items[i].$2,
                        style: const TextStyle(
                          fontSize: SknTypography.sizeMd,
                          fontWeight: FontWeight.w600,
                          color: SknColors.textInk,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].$3,
                        style: const TextStyle(
                          fontSize: SknTypography.sizeXs,
                          color: SknColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
