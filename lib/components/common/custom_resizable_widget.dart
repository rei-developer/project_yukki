import 'package:flutter/cupertino.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:resizable_widget/resizable_widget.dart';

class CustomResizableWidget extends StatelessWidget {
  const CustomResizableWidget(
    this.children, {
    this.percentages,
    this.isHorizontal = false,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;
  final List<double>? percentages;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) => ResizableWidget(
        separatorColor: transparentColor,
        separatorSize: 10,
        percentages: percentages,
        isHorizontalSeparator: isHorizontal,
        isDisabledSmartHide: true,
        children: children,
      );
}
