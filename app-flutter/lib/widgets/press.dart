// 轻点反馈:按下缩放 + 降透明,对齐 app-uni 的 hover-class(cta--tap / ghost--tap)。
import 'package:flutter/material.dart';

class Press extends StatefulWidget {
  const Press({
    super.key,
    required this.onTap,
    required this.child,
    this.pressedScale = 0.985,
    this.pressedOpacity = 0.94,
    this.semanticLabel,
  });

  final VoidCallback onTap;
  final Widget child;
  final double pressedScale;
  final double pressedOpacity;
  final String? semanticLabel;

  @override
  State<Press> createState() => _PressState();
}

class _PressState extends State<Press> {
  var _down = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      // 给了 label 时排除子树语义,避免与子 Text 叠成双重朗读(如「开始检测 开始检测」)
      excludeSemantics: widget.semanticLabel != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _down ? widget.pressedScale : 1,
          duration: const Duration(milliseconds: 90),
          child: AnimatedOpacity(
            opacity: _down ? widget.pressedOpacity : 1,
            duration: const Duration(milliseconds: 90),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
