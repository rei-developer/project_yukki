import 'package:flutter/cupertino.dart';

const primaryColor = Color(0xFFEDA7B2);
const primaryLightColor = Color(0xFFF1C8CF);
const lightColor = Color(0xFFFFFFFF);
const darkColor = Color(0xFF222222);
const transparentColor = Color(0x00FFFFFF);

TextStyle get primaryTextStyle => _textStyle();

TextStyle get primaryTextBoldStyle => _textStyle(fontFamily: 'NanumSquareB');

TextStyle get lightTextStyle => _textStyle(color: lightColor);

TextStyle get lightTextBoldStyle => lightTextStyle.copyWith(
      fontFamily: 'NanumSquareB',
      fontWeight: FontWeight.w800,
    );

TextStyle get darkTextStyle => _textStyle(color: darkColor);

TextStyle get darkTextBoldStyle => darkTextStyle.copyWith(
      fontFamily: 'NanumSquareB',
      fontWeight: FontWeight.w800,
    );

TextStyle _textStyle({
  color,
  fontSize,
  fontWeight,
  fontFamily,
}) =>
    TextStyle(
      color: color ?? primaryColor,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.w200,
      fontFamily: fontFamily ?? 'NanumSquareR',
    );
