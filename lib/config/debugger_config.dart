import 'package:flutter/cupertino.dart';
import 'package:project_yukki/config/ui_config.dart';

// type
const defaultDebug = 'DEFAULT';
const infoDebug = 'INFO';
const normalDebug = 'NORMAL';
const warningDebug = 'WARNING';
const errorDebug = 'ERROR';

// color
const defaultDebugColor = primaryColor;
const infoDebugColor = Color(0xFFB2CCFF);
const normalDebugColor = Color(0xFFCEF279);
const warningDebugColor = Color(0xFFFAED7D);
const errorDebugColor = Color(0xFFF15F5F);
const dateTimeDebugColor = Color(0xFFFAFAFA);

// function
Color getDebugColor(String type) {
  switch (type) {
    case infoDebug:
      return infoDebugColor;
    case normalDebug:
      return normalDebugColor;
    case warningDebug:
      return warningDebugColor;
    case errorDebug:
      return errorDebugColor;
    default:
      return defaultDebugColor;
  }
}
