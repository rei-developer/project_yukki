import 'package:flutter/cupertino.dart';
import 'package:mana_studio/containers/main_container.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) => const CupertinoActivityIndicator(
        radius: 32,
      );
}
