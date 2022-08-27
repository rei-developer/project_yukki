import 'package:flutter/cupertino.dart';
import 'package:mana_studio/config/ui_config.dart';

class CustomSection extends StatelessWidget {
  const CustomSection(
    this.label,
    this.body, {
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  final String label;
  final Widget body;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height ?? 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Text(
                  label,
                  style: darkTextBoldStyle,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: darkColor.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: body,
                ),
              ),
            ),
          ],
        ),
      );
}
