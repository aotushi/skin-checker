// 虚线描边 painter:flutter 无原生 dashed border,按 RRect 路径分段描。
// 供拍照页取景引导框 / 结果页「参考」标 / 低置信滑块共用(对齐 CSS border dashed)。
import 'package:flutter/widgets.dart';

class DashedOutline extends CustomPainter {
  const DashedOutline({
    required this.rrectOf,
    required this.color,
    this.strokeWidth = 1,
    this.dash = 4,
    this.gap = 3,
  });

  /// 由绘制尺寸算描边路径(描边中心线,调用方自行 deflate 半个线宽)。
  final RRect Function(Size size) rrectOf;
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    final path = Path()..addRRect(rrectOf(size));
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  // rrectOf 为函数不可比;此处全为静态装饰,按外显参数比较足够。
  @override
  bool shouldRepaint(DashedOutline oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap;
}
