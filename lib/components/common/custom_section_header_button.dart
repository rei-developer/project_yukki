import 'package:flutter/cupertino.dart';
import 'package:mana_studio/components/common/custom_tooltip.dart';
import 'package:mana_studio/config/ui_config.dart';

class CustomSectionHeaderButton extends StatefulWidget {
  const CustomSectionHeaderButton({
    this.icon = CupertinoIcons.xmark,
    this.tooltip,
    this.callback,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String? tooltip;
  final VoidCallback? callback;

  @override
  State<CustomSectionHeaderButton> createState() =>
      _CustomSectionHeaderButtonState();
}

class _CustomSectionHeaderButtonState extends State<CustomSectionHeaderButton> {
  @override
  Widget build(BuildContext context) => CustomTooltip(
        Container(
          decoration: BoxDecoration(
            color: darkColor,
            border: Border.all(
              color: primaryLightColor,
            ),
          ),
          child: CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: 16,
              height: 16,
              child: Icon(widget.icon, size: 12, color: primaryColor),
            ),
            onPressed: () => widget.callback?.call(),
          ),
        ),
        tooltip: widget.tooltip,
      );
}
