import 'package:flutter/material.dart';
import 'package:mana_studio/config/ui_config.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip(this.message, this.body, {Key? key}) : super(key: key);

  final String message;
  final Widget body;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: message,
        decoration: const BoxDecoration(color: darkColor),
        textStyle: primaryTextBoldStyle,
        child: body,
      );
}
