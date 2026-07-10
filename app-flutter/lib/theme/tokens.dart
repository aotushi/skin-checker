// ⚙️ 生成产物,请勿手改。
// 源:shared/design-tokens.json(DTCG 单一真相源,ADR 0007)
// 重新生成:node tool/gen.mjs
import 'package:flutter/painting.dart';

/// 色板
abstract final class SknColors {
  /// 主色:Tab 高亮 / 型号名 / 主要强调
  static const Color brandRoseDeep = Color(0xFFA85A48);

  /// 主色深:结果卡型号大字
  static const Color brandRoseWood = Color(0xFF8C4A3A);

  /// 敏感维度 / 次强调
  static const Color brandClay = Color(0xFFC77A5E);

  /// 油脂维度 / 香槟金
  static const Color brandGold = Color(0xFFC9913F);

  /// 主文本 / 标题
  static const Color textInk = Color(0xFF5A4A42);

  /// 次级深:引导句 / 色沉维度
  static const Color textBrown = Color(0xFF8C6A54);

  /// 描述文本
  static const Color textMuted = Color(0xFF9A8278);

  /// 辅助:未选 Tab / 副标题
  static const Color textMutedSoft = Color(0xFFB0917F);

  /// 极弱:chevron / 占位
  static const Color textFaint = Color(0xFFC0A294);

  /// 卡片底
  static const Color surfaceCard = Color(0xFFFFFDFB);

  /// 页面渐变·顶(180deg 起)
  static const Color surfaceBgTop = Color(0xFFFDF4EC);

  /// 页面渐变·底
  static const Color surfaceBgBottom = Color(0xFFF9E7D9);

  /// pill / 小标签底
  static const Color surfacePill = Color(0xFFF7E3D7);

  /// 免责 note 底
  static const Color surfaceNote = Color(0xFFF5EAE0);

  /// 油脂维度浅底
  static const Color tintGold = Color(0xFFFBF1E4);

  /// 敏感维度浅底
  static const Color tintClay = Color(0xFFFBEDE6);

  /// 痘痘维度浅底
  static const Color tintRose = Color(0xFFF8E7DF);

  /// 色沉维度浅底
  static const Color tintBrown = Color(0xFFF5ECE3);

  /// 光谱轨道
  static const Color spectrumTrack = Color(0xFFF2E4DA);

  /// 中线(含糊区)
  static const Color spectrumMidline = Color(0xFFE3CDBF);

  /// 滑块
  static const Color spectrumThumb = Color(0xFFD2795C);

  /// 低置信滑块(敏感,虚边)
  static const Color spectrumThumbSoft = Color(0xFFE0A981);

  /// Tab 顶边 / 分隔
  static const Color lineHairline = Color.fromRGBO(160, 90, 72, 0.10);

  /// 列表内分隔线
  static const Color lineDivider = Color.fromRGBO(160, 90, 72, 0.08);

  /// 相机深色态上的文字 / 图标
  static const Color onDark = Color(0xFFF5E9E0);

  /// 拍照取景深色底
  static const Color cameraBg = Color(0xFF241E1B);
}

/// 渐变起止色(角度见 shared JSON $description,使用侧拼 LinearGradient)
abstract final class SknGradients {
  /// 主按钮渐变起(与 cta-to 配,135deg)
  static const Color ctaFrom = Color(0xFFE3A381);

  /// 主按钮渐变止
  static const Color ctaTo = Color(0xFFD2795C);

  /// 照片 / 头像占位渐变起(与 photo-to 配,160deg)
  static const Color photoFrom = Color(0xFFE8C4AC);

  /// 照片 / 头像占位渐变止
  static const Color photoTo = Color(0xFFD5A184);
}

/// 字体 / 字号 / 字重 / 行高
abstract final class SknTypography {
  /// 正文 / UI 系统字栈
  static const List<String> familySans = [
    '-apple-system',
    'PingFang SC',
    'Microsoft YaHei',
    'sans-serif',
  ];

  /// 衬线,仅用于数字 / 型号码(.fr)
  static const List<String> familyDisplay = ['Fraunces', 'Georgia', 'serif'];

  static const FontWeight weightRegular = FontWeight.w400;

  static const FontWeight weightMedium = FontWeight.w500;

  static const FontWeight weightSemibold = FontWeight.w600;

  /// 副标 / 极小字
  static const double sizeXs = 11;

  /// 分组标题 / pill
  static const double sizeSm = 12;

  /// 描述正文
  static const double sizeBase = 13;

  /// 列表项标题
  static const double sizeMd = 14;

  /// 维度名 / 卡标题
  static const double sizeLg = 15;

  /// 页面标题栏
  static const double sizeXl = 17;

  /// Hero 主标题
  static const double sizeXl2 = 20;

  static const double leadingTight = 1.2;

  /// 描述文本行高
  static const double leadingBody = 1.55;
}

/// 圆角
abstract final class SknRadius {
  /// 小图标圆角
  static const double sm = 10;

  /// 维度图标块
  static const double md = 12;

  /// 入口条
  static const double lg = 14;

  /// 列表卡 / 记录条
  static const double xl = 16;

  /// 内容卡
  static const double xl2 = 18;

  /// 用户卡
  static const double xl3 = 20;

  /// 设备外框(仅 mockup 参考)
  static const double phone = 32;
}

/// 间距档位
abstract final class SknSpace {
  static const double s1 = 4;

  static const double s2 = 6;

  static const double s3 = 8;

  static const double s4 = 10;

  static const double s5 = 12;

  static const double s6 = 14;

  static const double s7 = 16;

  static const double s8 = 18;

  static const double s9 = 20;

  static const double s10 = 24;
}

/// 阴影(已按分量转 BoxShadow)
abstract final class SknShadows {
  /// 卡片
  static const BoxShadow card = BoxShadow(
    color: Color.fromRGBO(160, 90, 72, 0.06),
    offset: Offset(0, 4),
    blurRadius: 14,
  );

  /// 浮起(拍照屏)
  static const BoxShadow float = BoxShadow(
    color: Color.fromRGBO(160, 90, 72, 0.20),
    offset: Offset(0, 14),
    blurRadius: 36,
  );

  /// 设备外框
  static const BoxShadow phone = BoxShadow(
    color: Color.fromRGBO(160, 90, 72, 0.20),
    offset: Offset(0, 16),
    blurRadius: 44,
  );

  /// 主按钮
  static const BoxShadow cta = BoxShadow(
    color: Color.fromRGBO(200, 110, 80, 0.34),
    offset: Offset(0, 6),
    blurRadius: 16,
  );
}
