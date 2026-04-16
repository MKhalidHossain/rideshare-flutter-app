import 'package:flutter/material.dart';

import '../themes/app_color.dart';


class AppText {
  AppText._(); // Prevent instantiation

  static const String _fontFamily = 'notoSansKR';

  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.primaryTextBlack,
    );
  }

  // Font sizes with common labels:
  // xs: 12, sm: 14, md: 16, lg: 18, xl: 20, xl2: 22, xxl: 24, xxxl: 40

  // XXXL (e.g., Onboarding title)
  static final TextStyle xxxlSemiBold_40 = _style(
    fontSize: 40,
    fontWeight: FontWeight.w600,
  );

  // XXL
  static final TextStyle xxlSemiBold_24 = _style(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // XL2
  static final TextStyle xl2Medium_22 = _style(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  // XL
  static final TextStyle xlSemiBold_20 = _style(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  // LG
  static final TextStyle lgMedium_18 = _style(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  // MD
  static final TextStyle mdSemiBold_16 = _style(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle mdMedium_16 = _style(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle mdRegular_16 = _style(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // SM
  static final TextStyle smMedium_14 = _style(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle smRegular_14 = _style(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // XS
  static final TextStyle xsMedium_12 = _style(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle xsRegular_12 = _style(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
