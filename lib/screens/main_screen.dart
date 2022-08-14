import 'package:flutter/cupertino.dart';
import 'package:mana_studio/containers/main_container.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  final currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('test'),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.camera_viewfinder),
          onPressed: () => print('test'),
        ),
      ),
      child: SafeArea(
        child: _widgets[currentIndex],
      ),
    );
  }

  List<Widget> get _widgets => [
        const MainContainer(),
      ];
}
