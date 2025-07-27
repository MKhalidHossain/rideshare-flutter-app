import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF5F5F5);

  static final Color primaryColorStatic = const Color(
    0xFFea0001,
  ); //Color.fromARGB(255, 58, 64, 234);

  static const Color secondaryColor = Color(0xFF282828);
  static const Color _secondaryActionColor = Color.fromARGB(255, 94, 68, 238);
  //Color.fromARGB(255, 58, 64, 234);
  //static const Color _actionColor =  Colors.orange;
  static Color hindTextColorForTextFromField = Color(
    0xFFFFFFFF,
  ).withOpacity(0.3);

  //a colors
  static const Color primaryTextBlack = secondaryColor;
  static Color primaryTextRed = primaryColorStatic;
  static const Color secondayText = Color(0xFF666666);
  static const Color textfieldBg = Color(0xFFE9E9E9);
  static const Color scaffoldBackgroundColor = Color(0xFF303644);

  /// [Other Colors]
  static Color error = primaryColorStatic;

  static final AppColors _lightInstance = AppColors._internalLight();
  static final AppColors _darkInstance = AppColors._internalDark();

  final Color textColor;
  final Color textGreyColor;
  final Color backgroundColor;
  final Color contentBoxColor;
  final Color contentBoxGreyColor;
  final Color iconColor;

  // final Color primaryColor;

  Color get primaryColor => primaryColorStatic;
  final Color secondaryAccentColor;
  final Color buttonContentColor;

  Color activeButtonColor = primaryColorStatic;
  final Color activeButtonContentColor;
  final Color inActiveButtonColor;
  final Color inActiveButtonContentColor;
  final Color buttonColor;
  final Color drawerColor;
  final Color fillColor;
  final Color hintColor;
  final Color labelColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color borderColor;
  final Color popupBackgroundColor;
  final Color popupContentColor;
  final Color dividerColor;
  final Color tabBarColor;
  final Color shadowColor;
  final Color errorColor;
  final Color smallContainerColor;
  final Color iconOutsideFillColor;
  final Color starIconColor;
  final Color filterSelectedTextColor;
  final Color filterUnselectedTextColor;

  AppColors._internalLight()
    : textColor = Colors.black,
      textGreyColor = Colors.grey.shade700,
      contentBoxColor = Colors.grey.shade100,
      contentBoxGreyColor = Colors.grey.shade300,
      backgroundColor = Colors.white,
      iconColor = Colors.white,
      secondaryAccentColor = _secondaryActionColor,
      buttonColor = Colors.black45,
      buttonContentColor = Colors.white,
      activeButtonContentColor = Colors.white,
      inActiveButtonContentColor = Colors.grey.shade200,
      inActiveButtonColor = Colors.grey.shade300,
      drawerColor = Colors.white,
      fillColor = Colors.transparent,
      hintColor = Colors.grey.shade700,
      labelColor = Colors.grey.shade800,
      focusedBorderColor = Colors.black, // same as text color
      enabledBorderColor = Colors.grey.shade700,
      borderColor = Color(0xffFDE6E680).withOpacity(0.5),
      dividerColor = Colors.grey.shade200,
      popupBackgroundColor = Colors.grey.shade200,
      popupContentColor = Colors.black,
      shadowColor = const Color(0x1F000000),
      errorColor = Colors.red,
      tabBarColor = Colors.white,
      smallContainerColor = Colors.grey.shade100,
      iconOutsideFillColor = Colors.grey.shade200,
      starIconColor = Colors.blueGrey.shade400,
      filterSelectedTextColor = Colors.white,
      filterUnselectedTextColor = Colors.black;

  AppColors._internalDark()
    : textColor = Colors.white,
      textGreyColor = Colors.grey,
      backgroundColor = Color.fromARGB(255, 17, 22, 31), //Colors.black,
      contentBoxColor = Colors.grey.shade900,
      contentBoxGreyColor = Colors.grey.shade800,
      iconColor = Colors.white,
      secondaryAccentColor = _secondaryActionColor,
      buttonColor = Colors.transparent,
      buttonContentColor = Colors.black,
      activeButtonContentColor = Colors.white,
      inActiveButtonContentColor = Colors.grey.shade500,
      inActiveButtonColor = Colors.transparent,
      drawerColor = Colors.black,
      fillColor = Colors.transparent,
      hintColor = Colors.grey.shade400,
      labelColor = Colors.grey.shade200,
      focusedBorderColor = Colors.white, // same as text color
      enabledBorderColor = Colors.grey.shade400,
      borderColor = Color(0xff438B92),
      dividerColor = Colors.grey.shade900,
      errorColor = Colors.red,
      popupBackgroundColor = Colors.black,
      popupContentColor = Colors.white,
      shadowColor = const Color.fromARGB(146, 124, 123, 123),
      tabBarColor = Colors.black,
      smallContainerColor = Colors.grey.shade600,
      iconOutsideFillColor = Colors.grey.shade600,
      starIconColor = Colors.yellow,
      filterSelectedTextColor = Colors.white,
      filterUnselectedTextColor = Colors.white;

  factory AppColors.light() {
    return _lightInstance;
  }

  factory AppColors.dark() {
    return _darkInstance;
  }

  factory AppColors.context(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _darkInstance
        : _lightInstance;
  }
}
