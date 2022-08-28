import 'package:flutter/cupertino.dart';
import 'package:mana_studio/config/ui_config.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    this.color = primaryColor,
    this.height = 1,
    Key? key,
  }) : super(key: key);

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(border: Border.all(color: color)),
      );
}
