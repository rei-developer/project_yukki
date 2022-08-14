import 'package:flutter_platform_alert/flutter_platform_alert.dart';

class AlertManager {
  static Future<CustomButton> show(
    String description, {
    String? title,
    String? iconPath = '',
    IconStyle iconStyle = IconStyle.none,
    String? yesLabel = '확인',
    String? noLabel,
    String? generalLabel = '',
    AlertWindowPosition position = AlertWindowPosition.parentWindowCenter,
    FlutterPlatformAlertOption? options,
    bool isPlayAlertSound = true,
  }) async {
    if (isPlayAlertSound) {
      await sound(iconStyle);
    }
    return await FlutterPlatformAlert.showCustomAlert(
      windowTitle: title ?? '알림',
      text: description,
      iconStyle: iconStyle,
      iconPath: iconPath,
      positiveButtonTitle: yesLabel,
      negativeButtonTitle: noLabel,
      neutralButtonTitle: generalLabel,
      windowPosition: position,
      options: options,
    );
  }

  static Future<void> sound([IconStyle iconStyle = IconStyle.none]) async =>
      FlutterPlatformAlert.playAlertSound(iconStyle: iconStyle);
}
