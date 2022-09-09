import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/providers/project_provider.dart';
import 'package:project_yukki/screens/game_screen.dart';

class GameApp extends ConsumerStatefulWidget {
  const GameApp({
    Key? key,
    required this.args,
  }) : super(key: key);

  final Map? args;

  @override
  ConsumerState<GameApp> createState() => _GameAppState();
}

class _GameAppState extends ConsumerState<GameApp> {
  @override
  void initState() {
    super.initState();
    print("asdfsdafasd");
    _projectProvider.loadProject();
    // if (!MainHandler.isRunning) {
    //   _projectProvider.loadProject();
    // }
    // MainHandler.init();
    // widget.windowController.close();
  }

  @override
  Widget build(BuildContext context) => const CupertinoApp(
        title: 'Game Test',
        home: GameScreen(),
        theme: CupertinoThemeData(
          brightness: Brightness.dark,
          // primaryColor: PINK_COLOR,
          scaffoldBackgroundColor: CupertinoColors.systemBackground,
        ),
        // locale: TranslationProvider.of(context).flutterLocale,
        // supportedLocales: LocaleSettings.supportedLocales,
        // localizationsDelegates: GlobalMaterialLocalizations.delegates,
        debugShowCheckedModeBanner: false,
      );

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);
}
