import 'package:flutter/cupertino.dart';
import 'package:mana_studio/utils/func.dart';

List<Widget> renderWidgetList(
  List<Widget> children, {
  double padding = 10,
  bool isVertical = true,
  bool isReversed = false,
}) {
  List<Widget> result = children
      .superJoin(
        SizedBox(
          width: !isVertical ? padding : 0,
          height: isVertical ? padding : 0,
        ),
      )
      .toList();
  return isReversed ? result.reversed.toList() : result;
}
