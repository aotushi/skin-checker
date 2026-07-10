// 肤镜 flutter 端入口:根级双 tab(检测 / 我的)+ 拍照/结果全屏二级页(Navigator push)。
// 结构对齐 app-uni:tab 只挂两个根页,流程页不带 tab(W3 切片 C)。
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/mine_page.dart';
import 'theme/tokens.dart';
import 'widgets/skn_tab_bar.dart';

/// 全局路由观察:MinePage 靠 didPopNext 在二级页返回后刷新本地历史(≈ uni onShow)
final routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const SkinCheckerApp());
}

class SkinCheckerApp extends StatelessWidget {
  const SkinCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '肤镜',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        useMaterial3: true,
        // 正文走系统字栈(对齐 token typography.family.sans),不指定 fontFamily 即系统默认;
        // Fraunces 仅在数字/型号码处逐点指定。
        colorScheme: ColorScheme.fromSeed(seedColor: SknColors.brandRoseDeep),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const RootShell(),
    );
  }
}

/// 根壳:页面渐变底 + IndexedStack 双根页 + 自绘底部 tab。
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  var _current = SknTab.home;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 页面渐变底(180deg bg-top → bg-bottom),对齐 app-uni 全局 page 背景。
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [SknColors.surfaceBgTop, SknColors.surfaceBgBottom],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _current.index,
          children: const [HomePage(), MinePage()],
        ),
        bottomNavigationBar: SknTabBar(
          current: _current,
          onSwitch: (tab) => setState(() => _current = tab),
        ),
      ),
    );
  }
}
