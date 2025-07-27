import 'package:flutter/material.dart';

extension TextStylingExtension on String {
  // Font family
  static const String _fontFamily = 'Poppins';

  // TextSize 24
  Text text24DarkGreen() => Text(
    this,
    style: const TextStyle(
      fontSize: 24,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600, // SemiBold
      color: Color(0xFF1E3F42),
    ),
  );

  Text text24White() => Text(
    this,
    style: const TextStyle(
      fontSize: 24,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFFFFFF),
    ),
  );

  Text text24Black() => Text(
    this,
    style: const TextStyle(
      fontSize: 24,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFF000000),
    ),
  );

  Text text24BlackCenter() => Text(
    this,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 24,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFF000000),
    ),
  );

  Text text22White() => Text(
    this,
    style: const TextStyle(
      fontSize: 22,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFFFFFF),
    ),
  );

  // TextSize 20
  Text text20Black() => Text(
    this,
    style: const TextStyle(
      fontSize: 20,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFF000000),
    ),
  );

  Text text20White() => Text(
    this,
    style: const TextStyle(
      fontSize: 20,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );

  Text text20white() => Text(
    this,
    style: const TextStyle(
      fontSize: 20,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFFFF),
    ),
  );
  Text text20DarkGrey() => Text(
    this,
    style: const TextStyle(
      fontSize: 20,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFF4D4D4D),
    ),
  );

  Text text18Black() => Text(
    this,
    style: const TextStyle(
      fontSize: 18,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF000000),
    ),
  );

  Text text18White() => Text(
    this,
    textAlign: TextAlign.justify,
    style: const TextStyle(
      fontSize: 18,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFFFF),
    ),
  );

  Text text18White500() => Text(
    maxLines: 15,
    this,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 18,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFFFF),
    ),
  );

  // TextSize 16
  Text text16White() => Text(
    this,
    textAlign: TextAlign.justify,
    style: const TextStyle(
      fontSize: 16,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFFFF),
    ),
  );

  Text text16White500() => Text(
    maxLines: 15,
    this,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 16,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFFFF),
    ),
  );

  Text text16Grey() => Text(
    this,
    style: const TextStyle(
      fontSize: 16,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF737373),
    ),
  );

  Text text16Black() => Text(
    this,
    style: const TextStyle(
      fontSize: 16,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF000000),
    ),
  );

  Text text16Profile() => Text(
    this,
    style: const TextStyle(
      fontSize: 16,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFF438B92),
    ),
  );

  Text text16LightGreen() => Text(
    this,
    style: const TextStyle(
      fontSize: 16,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xff009A64),
    ),
  );

  Text text16DarkGrey() => Text(
    this,
    style: const TextStyle(
      fontSize: 16,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF4D4D4D),
    ),
  );

  // TextSize 14

  Text text14Black() => Text(
    maxLines: 15,
    this,
    style: const TextStyle(
      fontSize: 14,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF000000),
    ),
  );

  Text text14White() => Text(
    maxLines: 15,
    this,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 14,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFFFF),
    ),
  );

  Text text14White500() => Text(
    maxLines: 15,
    this,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 14,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFFFF),
    ),
  );

  Text text14Grey() => Text(
    maxLines: 15,
    this,
    style: const TextStyle(
      fontSize: 14,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF666666),
    ),
  );

  Text text14Blue() => Text(
    maxLines: 15,
    this,
    style: const TextStyle(
      fontSize: 14,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF22A7D3),
    ),
  );

  // TextSize 12
  Text text12Black() => Text(
    maxLines: 15,
    this,
    style: const TextStyle(
      fontSize: 12,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF000000),
    ),
  );

  // Text text14Red() => Text(
  //   maxLines: 15,
  //   this,
  //   style: const TextStyle(
  //     fontSize: 14,
  //     fontFamily: _fontFamily,
  //     fontWeight: FontWeight.w400,
  //     color: Color(0xFFFF3951),
  //   ),
  // );

  Text text12Grey() => Text(
    this,
    style: const TextStyle(
      fontSize: 12,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    ),
  );

  Text text12DarkGrey() => Text(
    this,
    style: const TextStyle(
      fontSize: 12,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFF4D4D4D),
    ),
  );

  Text text12White() => Text(
    this,
    style: const TextStyle(
      fontSize: 12,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFFFF),
    ),
  );
  Text text12Red() => Text(
    this,
    style: const TextStyle(
      fontSize: 12,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: Color(0xFFEA0001),
    ),
  );

  // TextSize 10
  Text text10DarkGrey() => Text(
    this,
    style: const TextStyle(
      fontSize: 10,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w300,
      color: Color(0xFF4D4D4D),
    ),
  );

  // TextColor (size-agnostic versions)
  Text textColorGrey(double size) => Text(
    this,
    style: TextStyle(
      fontSize: size,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF737373),
    ),
  );

  Text textColorWhite(double size) => Text(
    this,
    style: TextStyle(
      fontSize: size,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFFFFFFF),
    ),
  );

  Text textColorProfile(double size) => Text(
    this,
    style: TextStyle(
      fontSize: size,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF438B92),
    ),
  );
}





// How to use this extension

// import 'package:your_app/extensions/text_extensions.dart';

// ...

// Column(
//   children: [
//     'Profile Name'.text24DarkGreen(),
//     'Email Address'.text16Grey(),
//     'Settings'.text20Black(),
//     'Message'.text14Black(),
//     'Info'.text10DarkGrey(),
//     'Status'.textColorProfile(18),
//   ],
// )