import 'package:flutter/material.dart';

const _emojiAndroidFontFamily = 'Poppins';
const _emojiIOSFontFamily = 'Poppins';
//const _newDefaultFontFamily = 'Poppins';

class ThemeFonts {
  static TextStyle caption10({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle caption12({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle caption14({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle caption16({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle captionCustom({required double? fontSize, Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: fontSize,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle text10({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    // fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle text10Bold({Color? textColor}) => text10(textColor: textColor).copyWith(fontWeight: FontWeight.w700);

  static TextStyle text12({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle text12Bold({Color? textColor}) => text12(textColor: textColor).copyWith(fontWeight: FontWeight.w700);

  static TextStyle text14({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle text14Bold({Color? textColor}) => text14(textColor: textColor).copyWith(fontWeight: FontWeight.w700);
  static TextStyle text14Light({Color? textColor}) => text14(textColor: textColor).copyWith(fontWeight: FontWeight.w400);

  static TextStyle text16({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle text18({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle text16Bold({Color? textColor}) => text16(textColor: textColor).copyWith(fontWeight: FontWeight.w700);

  static TextStyle text18Bold({Color? textColor}) => text18(textColor: textColor).copyWith(fontWeight: FontWeight.w700);

  static TextStyle text16Light({Color? textColor}) => text16(textColor: textColor).copyWith(fontWeight: FontWeight.w600);
  static TextStyle text16Light2({Color? textColor}) => text16(textColor: textColor).copyWith(fontWeight: FontWeight.w400);

  static TextStyle text20({Color? textColor}) => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 20.0,
    fontFamilyFallback: const [_emojiIOSFontFamily, _emojiAndroidFontFamily],
    //fontFamily: _newDefaultFontFamily,
    color: textColor,
  );

  static TextStyle text20Bold({Color? textColor}) => text20(textColor: textColor).copyWith(fontWeight: FontWeight.w700);
}
