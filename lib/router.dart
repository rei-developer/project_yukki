import 'package:mana_studio/screens/game_screen.dart';
import 'package:mana_studio/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> getRoutes(context) => {
      '/': (BuildContext context) => const MainScreen(),
      '/main': (BuildContext context) => const MainScreen(),
      '/game': (BuildContext context) => const GameScreen(),
    };
