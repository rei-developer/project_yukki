import 'package:flutter/cupertino.dart';
import 'package:project_yukki/components/common/section.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/utils/render/render_widget_list.dart';

void renderModalPopup(
  BuildContext context,
  Widget content, {
  String title = '알림',
  double width = 320,
  double height = 200,
  bool barrierDismissible = true,
  List<Widget>? bottomBar,
}) =>
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        final sw = MediaQuery.of(context).size.width;
        final sh = MediaQuery.of(context).size.height;
        final pos = ValueNotifier(Offset(sw / 2 - width / 2, sh / 2 - height / 2));
        return ValueListenableBuilder(
          builder: (context, value, _) => Stack(
            children: [
              Positioned(
                left: pos.value.dx,
                top: pos.value.dy,
                child: Section(
                  Draggable(
                    onDragUpdate: (offset) {
                      final dx = offset.localPosition.dx - 10;
                      final dy = offset.localPosition.dy - 10;
                      pos.value = Offset(dx, dy);
                    },
                    feedback: Container(),
                    child: Text(title, style: darkTextBoldStyle),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: renderWidgetList(
                      [
                        SizedBox(child: Text(title)),
                        Expanded(child: content),
                        if (bottomBar != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: bottomBar,
                          ),
                      ],
                    ),
                  ),
                  width: width,
                  height: height,
                  opacity: 0.95,
                ),
              ),
            ],
          ),
          valueListenable: pos,
        );
      },
    );
