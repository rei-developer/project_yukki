import 'package:flutter/cupertino.dart';

class GameContainer extends StatefulWidget {
  const GameContainer({Key? key}) : super(key: key);

  @override
  State<GameContainer> createState() => _GameContainerState();
}

class _GameContainerState extends State<GameContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('하이'),
    );
  }
}
