// 自绘底部 tab(暖调,免图标资源),对齐 app-uni components/tab-bar:
// 检测 = 镜头圆环 + 中心点,我的 = 头 + 肩剪影;高亮 rose-deep,未选 faint。
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum SknTab { home, mine }

class SknTabBar extends StatelessWidget {
  const SknTabBar({super.key, required this.current, required this.onSwitch});

  final SknTab current;
  final ValueChanged<SknTab> onSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SknColors.surfaceCard,
        border: Border(top: BorderSide(color: SknColors.lineHairline)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(160, 90, 72, 0.06),
            offset: Offset(0, -6),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _TabItem(
                label: '检测',
                selected: current == SknTab.home,
                icon: _CameraGlyph(on: current == SknTab.home),
                onTap: () => onSwitch(SknTab.home),
              ),
              _TabItem(
                label: '我的',
                selected: current == SknTab.mine,
                icon: _MeGlyph(on: current == SknTab.mine),
                onTap: () => onSwitch(SknTab.mine),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        // 排除子树语义,避免 label 与子 Text 叠成双重朗读(如「检测 检测」)
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: SknTypography.sizeXs,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? SknColors.brandRoseDeep
                      : SknColors.textFaint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 检测:镜头圆环 + 中心点。
class _CameraGlyph extends StatelessWidget {
  const _CameraGlyph({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final color = on ? SknColors.brandRoseDeep : SknColors.textFaint;
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ],
      ),
    );
  }
}

/// 我的:头 + 肩剪影。
class _MeGlyph extends StatelessWidget {
  const _MeGlyph({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final color = on ? SknColors.brandRoseDeep : SknColors.textFaint;
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          Positioned(
            top: 3,
            left: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
          Positioned(
            bottom: 3,
            left: 4,
            child: Container(
              width: 16,
              height: 9,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
