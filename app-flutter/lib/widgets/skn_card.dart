// 内容卡外壳:card 底 + hairline 边 + 18 圆角 + 卡片阴影,对齐 app-uni 的 .card。
import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

class SknCard extends StatelessWidget {
  const SknCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SknColors.surfaceCard,
        border: Border.all(color: SknColors.lineHairline),
        borderRadius: BorderRadius.circular(SknRadius.xl2),
        boxShadow: const [SknShadows.card],
      ),
      child: child,
    );
  }
}
