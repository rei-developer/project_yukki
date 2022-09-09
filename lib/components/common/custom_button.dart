import 'package:flutter/cupertino.dart';
import 'package:project_yukki/config/ui_config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
    this.label, {
    this.width = 50,
    this.color = primaryColor,
    this.icon,
    this.onSubmitted,
    Key? key,
  }) : super(key: key);

  final double width;
  final String label;
  final Color color;
  final IconData? icon;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        onPressed: onSubmitted,
        child: Container(
          width: width,
          height: 18,
          decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(2))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, size: 12, color: darkColor),
                Text(label, style: darkTextBoldStyle),
              ],
            ),
          ),
        ),
      );
}
