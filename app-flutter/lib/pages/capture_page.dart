// 拍照检测(全屏二级页,深色底):顶栏 + 取景/预览 + 拍摄要求 + 操作双钮 + 分析蒙层。
// 对齐 app-uni pages/capture/capture.vue;取图 image_picker,真传图 /analyze 见 utils/api.dart。
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/tokens.dart';
import '../utils/api.dart';
import '../widgets/dashed_outline.dart';
import '../widgets/press.dart';
import '../widgets/skn_shell.dart';
import 'result_page.dart';

enum _Source { album, camera }

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  final _picker = ImagePicker();
  XFile? _picked;
  Uint8List? _pickedBytes; // 预览 + 上传共用(web 无 dart:io File,统一走内存字节)
  var _analyzing = false;

  // 相册 / 相机取图:限宽 + 压质对齐 uni sizeType compressed,足够 VL 分析
  Future<void> _choose(_Source source) async {
    final file = await _picker.pickImage(
      source: source == _Source.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (file == null) return; // 用户取消选图
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() {
      _picked = file;
      _pickedBytes = bytes;
    });
  }

  void _reset() => setState(() {
    _picked = null;
    _pickedBytes = null;
  });

  // 真传图到 server /analyze:成功进结果页(replace,对齐 uni redirectTo);失败 SnackBar 留本页可重试
  Future<void> _analyze() async {
    final picked = _picked;
    final bytes = _pickedBytes;
    if (picked == null || bytes == null || _analyzing) return;
    setState(() => _analyzing = true);
    try {
      final envelope = await requestAnalyze(
        bytes,
        picked.name,
        picked.mimeType,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResultPage(report: envelope.report),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _analyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 深色底全屏铺满,不随内容限宽(避免平板两侧露出浅色底,ADR 0009)
      backgroundColor: SknColors.cameraBg,
      body: Stack(
        children: [
          SafeArea(
            child: SknShell(
              child: Padding(
                // uni 的顶 60 含 H5 无状态栏时的整段留白;状态栏由 SafeArea 承担,余量减半
                padding: const EdgeInsetsDirectional.fromSTEB(22, 24, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Bar(),
                    const SizedBox(height: 22),
                    Expanded(child: _Viewer(bytes: _pickedBytes)),
                    const SizedBox(height: 22),
                    const _Requirements(),
                    const SizedBox(height: 14),
                    const Text(
                      '照片仅用于本次分析,分析后即时删除',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SknTypography.sizeXs,
                        color: Color.fromRGBO(245, 233, 224, 0.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: _picked == null
                          ? [
                              Expanded(
                                child: _OpButton(
                                  label: '相册选图',
                                  main: false,
                                  onTap: () => _choose(_Source.album),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _OpButton(
                                  label: '拍照',
                                  main: true,
                                  onTap: () => _choose(_Source.camera),
                                ),
                              ),
                            ]
                          : [
                              Expanded(
                                child: _OpButton(
                                  label: '重拍',
                                  main: false,
                                  onTap: _reset,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _OpButton(
                                  label: '开始分析',
                                  main: true,
                                  onTap: _analyze,
                                ),
                              ),
                            ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 分析中蒙层(全屏,不随内容限宽)
          if (_analyzing) const _AnalyzingMask(),
        ],
      ),
    );
  }
}

/// 顶栏:返回圆钮 + 标题 + 等宽占位(保持标题居中)。
class _Bar extends StatelessWidget {
  const _Bar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(245, 233, 224, 0.08),
            ),
            child: const Text(
              '‹',
              style: TextStyle(
                fontSize: 24,
                height: 1,
                color: SknColors.onDark,
              ),
            ),
          ),
        ),
        const Text(
          '拍照检测',
          style: TextStyle(
            fontSize: SknTypography.sizeLg,
            fontWeight: FontWeight.w600,
            color: SknColors.onDark,
          ),
        ),
        const SizedBox(width: 34, height: 34),
      ],
    );
  }
}

/// 取景 / 预览:有图铺满(cover),空态画脸形虚线引导框。
class _Viewer extends StatelessWidget {
  const _Viewer({required this.bytes});

  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SknRadius.phone),
        color: const Color(0xFF1A1512),
      ),
      child: bytes != null
          ? SizedBox.expand(
              child: Image.memory(
                bytes!,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            )
          : OverflowBox(
              // 空态引导框装饰性:矮取景区(小屏)允许溢出,由外层 clip 上下对称裁切
              // (对齐 uni .viewer overflow:hidden + .viewer__empty 绝对定位)
              maxHeight: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = math.min(constraints.maxWidth * 0.58, 240.0);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: w,
                        height: w * 196 / 150, // 沿用原 150×196 的脸形比例
                        child: CustomPaint(
                          painter: DashedOutline(
                            color: const Color.fromRGBO(245, 233, 224, 0.42),
                            strokeWidth: 1.5,
                            dash: 6,
                            gap: 5,
                            // 脸形:上圆下宽的不对称椭圆角(50% 50% 46% 46% / 40% 40% 60% 60%)
                            rrectOf: (s) => RRect.fromRectAndCorners(
                              (Offset.zero & s).deflate(0.75),
                              topLeft: Radius.elliptical(
                                s.width * 0.5,
                                s.height * 0.4,
                              ),
                              topRight: Radius.elliptical(
                                s.width * 0.5,
                                s.height * 0.4,
                              ),
                              bottomRight: Radius.elliptical(
                                s.width * 0.46,
                                s.height * 0.6,
                              ),
                              bottomLeft: Radius.elliptical(
                                s.width * 0.46,
                                s.height * 0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '将正脸置于取景框内',
                        style: TextStyle(
                          fontSize: SknTypography.sizeSm,
                          letterSpacing: SknTypography.sizeSm * 0.04,
                          color: Color.fromRGBO(245, 233, 224, 0.6),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

/// 拍摄要求三点:正脸 · 自然光 · 不化妆。
class _Requirements extends StatelessWidget {
  const _Requirements();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _ReqItem('正脸'),
        SizedBox(width: 22),
        _ReqItem('自然光'),
        SizedBox(width: 22),
        _ReqItem('不化妆'),
      ],
    );
  }
}

class _ReqItem extends StatelessWidget {
  const _ReqItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: SknGradients.ctaTo,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: SknTypography.sizeSm,
            color: SknColors.onDark,
          ),
        ),
      ],
    );
  }
}

/// 操作钮:main = cta 渐变实底,sub = 深色态描边。
class _OpButton extends StatelessWidget {
  const _OpButton({
    required this.label,
    required this.main,
    required this.onTap,
  });

  final String label;
  final bool main;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Press(
      semanticLabel: label,
      pressedOpacity: 0.92,
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: main
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(SknRadius.lg),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [SknGradients.ctaFrom, SknGradients.ctaTo],
                ),
                boxShadow: const [SknShadows.cta],
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(SknRadius.lg),
                border: Border.all(
                  color: const Color.fromRGBO(245, 233, 224, 0.28),
                ),
              ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: SknTypography.sizeMd,
            fontWeight: FontWeight.w600,
            color: main ? Colors.white : SknColors.onDark,
          ),
        ),
      ),
    );
  }
}

/// 分析中蒙层:半透深底 + 旋转圈 + 文案。
class _AnalyzingMask extends StatelessWidget {
  const _AnalyzingMask();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color.fromRGBO(36, 30, 27, 0.88),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: SknGradients.ctaTo,
                backgroundColor: Color.fromRGBO(245, 233, 224, 0.2),
              ),
            ),
            SizedBox(height: 14),
            Text(
              'AI 正在分区分析…',
              style: TextStyle(
                fontSize: SknTypography.sizeLg,
                fontWeight: FontWeight.w600,
                color: SknColors.onDark,
              ),
            ),
            SizedBox(height: 14),
            Text(
              '通常需要几秒',
              style: TextStyle(
                fontSize: SknTypography.sizeXs,
                color: Color.fromRGBO(245, 233, 224, 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
