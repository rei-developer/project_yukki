import 'package:flutter/cupertino.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/utils/func.dart';
import 'package:mana_studio/utils/render/render_widget_list.dart';

class Section extends StatefulWidget {
  const Section(
    this.label,
    this.body, {
    this.icon,
    this.headerChildren,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  final IconData? icon;
  final String label;
  final List<Widget>? headerChildren;
  final Widget body;
  final double? width;
  final double? height;

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    if (widget.icon != null) Icon(widget.icon, size: 13, color: darkColor),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(widget.label, style: darkTextBoldStyle),
                      ),
                    ),
                    if (widget.headerChildren != null)
                      Wrap(children: renderWidgetList(widget.headerChildren!, padding: 2, isVertical: false)),
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
