import 'package:flutter/cupertino.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/utils/func.dart';

class CustomSection extends StatefulWidget {
  const CustomSection(
    this.label,
    this.body, {
    this.icon,
    this.headerButtons,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  final IconData? icon;
  final String label;
  final List<Widget>? headerButtons;
  final Widget body;
  final double? width;
  final double? height;

  @override
  State<CustomSection> createState() => _CustomSectionState();
}

class _CustomSectionState extends State<CustomSection> {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
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
                  horizontal: 10,
                ),
                child: Row(
                  children: [
                    if (widget.icon != null)
                      Icon(widget.icon, size: 13, color: darkColor),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          widget.label,
                          style: darkTextBoldStyle,
                        ),
                      ),
                    ),
                    if (widget.headerButtons != null)
                      Wrap(
                        children: [
                          ...widget.headerButtons!,
                        ].superJoin(const SizedBox(width: 2)).toList(),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: darkColor.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: widget.body,
                ),
              ),
            ),
          ],
        ),
      );
}
