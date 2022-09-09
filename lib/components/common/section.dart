import 'package:flutter/cupertino.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/utils/func.dart';
import 'package:project_yukki/utils/render/render_widget_list.dart';

class Section extends StatefulWidget {
  const Section(
    this.label,
    this.body, {
    this.icon,
    this.headerChildren,
    this.width = double.infinity,
    this.height = 100,
    this.opacity = 0.5,
    Key? key,
  }) : super(key: key);

  final IconData? icon;
  final Widget label;
  final List<Widget>? headerChildren;
  final Widget body;
  final double width;
  final double height;
  final double opacity;

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
                  children: renderWidgetList(
                    [
                      if (widget.icon != null) Icon(widget.icon, size: 13, color: darkColor),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: widget.label,
                        ),
                      ),
                      if (widget.headerChildren != null)
                        Wrap(children: renderWidgetList(widget.headerChildren!, padding: 2, isVertical: false)),
                    ],
                    padding: 5,
                    isVertical: false,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: darkColor.withOpacity(widget.opacity),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Padding(padding: const EdgeInsets.all(10), child: widget.body),
              ),
            ),
          ],
        ),
      );
}
