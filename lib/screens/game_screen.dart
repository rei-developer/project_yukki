import 'package:flutter/cupertino.dart';
import 'package:project_yukki/containers/game_container.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  final currentIndex = 0;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
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
        child: SafeArea(child: _widgets[currentIndex]),
      );

  List<Widget> get _widgets => [
        const GameContainer(),
      ];
}
