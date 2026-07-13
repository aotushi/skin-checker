// 拍照检测(全屏二级页,深色底):顶栏 + 实时取景/预览 + 拍摄要求 + 操作双钮 + 分析蒙层。
// 对齐 app-uni pages/capture/capture.vue;flutter 端扩展:camera 插件页面内实时取景直拍
// (uni APK 侧无此能力;初始化失败降级 image_picker 系统相机)。真传图 /analyze 见 utils/api.dart。
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
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

class _CapturePageState extends State<CapturePage> with WidgetsBindingObserver {
  final _picker = ImagePicker();
  XFile? _picked;
  Uint8List? _pickedBytes; // 预览 + 上传共用(web 无 dart:io File,统一走内存字节)
  var _analyzing = false;
  CameraController? _cam; // 非空即 initialize 成功;失败/无权限保持 null 走降级
  var _camOpening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cam?.dispose();
    super.dispose();
  }

  // 切后台/锁屏释放相机,回前台重建(官方样板;确认态显示静态图,回来不急着重建)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      final cam = _cam;
      if (cam != null) {
        _cam = null;
        cam.dispose();
        if (mounted) setState(() {});
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_pickedBytes == null) _initCamera();
    }
  }

  // 打开前置相机做页面内实时取景;任何失败(权限拒/无摄像头/web 无设备)静默降级:
  // 取景区回空态引导框,「拍照」走 image_picker 系统相机(保底可用)
  Future<void> _initCamera() async {
    if (_camOpening || _cam != null) return;
    _camOpening = true;
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) return;
      final desc = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cams.first,
      );
      final cam = CameraController(
        desc,
        ResolutionPreset.veryHigh, // 1080p,与相册取图 maxWidth 1600 同量级,够 VL 分析
        enableAudio: false,
      );
      await cam.initialize();
      if (!mounted) {
        await cam.dispose();
        return;
      }
      setState(() => _cam = cam);
    } on Exception {
      // 静默降级,不打断页面
    } finally {
      _camOpening = false;
    }
  }

  // 确认态由静态图盖住取景区,暂停预览流省电;失败无碍(已被覆盖)
  Future<void> _pausePreview() async {
    try {
      await _cam?.pausePreview();
    } on CameraException {
      // 忽略
    }
  }

  // 页面内直拍:取实时帧进确认态;实时相机不可用/拍摄失败退回系统相机
  Future<void> _shoot() async {
    final cam = _cam;
    if (cam == null) return _choose(_Source.camera);
    if (cam.value.isTakingPicture) return;
    try {
      final file = await cam.takePicture();
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _picked = file;
        _pickedBytes = bytes;
      });
    } on CameraException {
      if (!mounted) return;
      return _choose(_Source.camera);
    }
    await _pausePreview();
  }

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
    await _pausePreview();
  }

  // 重拍/重选:回取景态;相机曾被生命周期回收则重建,否则恢复预览流
  void _reset() {
    setState(() {
      _picked = null;
      _pickedBytes = null;
    });
    final cam = _cam;
    if (cam == null) {
      _initCamera();
    } else {
      cam.resumePreview().catchError((_) {});
    }
  }

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
          // id/createdAt 一并带给结果页:「保存报告」沿用 server 侧生成的这份 meta
          builder: (_) => ResultPage(
            report: envelope.report,
            analysisId: envelope.id,
            analysisCreatedAt: envelope.createdAt,
          ),
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
                    Expanded(
                      child: _Viewer(bytes: _pickedBytes, camera: _cam),
                    ),
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
                                  onTap: _shoot,
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

/// 取景 / 预览:有图铺满(cover);无图时实时相机取景 + 脸形引导框叠加,
/// 相机不可用(权限拒/无摄像头/web)退回引导框空态。
class _Viewer extends StatelessWidget {
  const _Viewer({required this.bytes, required this.camera});

  final Uint8List? bytes;
  final CameraController? camera;

  @override
  Widget build(BuildContext context) {
    final cam = camera;
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
          : Stack(
              fit: StackFit.expand,
              children: [
                if (cam != null)
                  // cover 铺满:previewSize 是传感器横向尺寸,竖屏 UI 宽高互换,
                  // FittedBox 等比放大,溢出由外层圆角 clip 裁切
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: cam.value.previewSize?.height ?? 1,
                      height: cam.value.previewSize?.width ?? 1,
                      child: CameraPreview(cam),
                    ),
                  ),
                const _FaceGuide(),
              ],
            ),
    );
  }
}

/// 脸形虚线引导框 + 文案:随取景区尺寸放大(宽 72% 封顶 320;高度预算先扣
/// 间距与文案行高再取 82%,避免极矮取景区 Column 溢出),整体居中。
class _FaceGuide extends StatelessWidget {
  const _FaceGuide();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = math.min(
          math.min(constraints.maxWidth * 0.72, 320.0),
          math.max(constraints.maxHeight - 44, 0) * 0.82 * 150 / 196,
        );
        // 矮到放不下引导框时整体隐去(分屏/横屏小窗兜底)
        if (w < 24) return const SizedBox.shrink();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    topLeft: Radius.elliptical(s.width * 0.5, s.height * 0.4),
                    topRight: Radius.elliptical(s.width * 0.5, s.height * 0.4),
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
