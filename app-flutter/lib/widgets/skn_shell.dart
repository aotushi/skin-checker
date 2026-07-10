// 平板(大屏)内容限宽:锁 600 逻辑像素居中,两侧透出全屏底(ADR 0009)。
// 手机(宽 < 600)不受影响照常铺满;仅大屏收窄 —— 对齐 app-uni 的 .skn-shell。
import 'package:flutter/widgets.dart';

class SknShell extends StatelessWidget {
  const SknShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: child,
      ),
    );
  }
}
