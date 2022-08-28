import 'package:flutter/material.dart';
import 'package:mana_studio/config/ui_config.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip(
    this.body, {
    this.tooltip,
    Key? key,
  }) : super(key: key);

  final String? tooltip;
  final Widget body;

  @override
  Widget build(BuildContext context) => tooltip == null
      ? body
      : Tooltip(
          message: tooltip,
          decoration: BoxDecoration(
            color: pitchBlackColor.withOpacity(0.95),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          textStyle: lightTextStyle,
          waitDuration: const Duration(milliseconds: 500),
          child: body,
        );
}
