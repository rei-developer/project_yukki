import 'package:flutter/cupertino.dart';
import 'package:mana_studio/router.dart';
import 'package:mana_studio/utils/handlers/main_handler.dart';
import 'package:mana_studio/utils/loaders/script_loader.dart';
import 'package:mana_studio/utils/script_runner.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<void> loadScript() async {
    final scriptLoader = ScriptLoader();
    final scripts = await scriptLoader.run();
    final runner = ScriptRunner(scripts.code);
    await runner.run();
  }

  @override
  Widget build(BuildContext context) {
    if (!MainHandler.isRunning) {
      loadScript();
    }
    MainHandler.init();
    return CupertinoApp(
      title: 'Test',
      initialRoute: '/',
      routes: getRoutes(context),
      // navigatorObservers: [MainApp.observer],
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        // primaryColor: PINK_COLOR,
        // scaffoldBackgroundColor: CupertinoColors.systemBackground,
      ),
      // locale: TranslationProvider.of(context).flutterLocale,
      // supportedLocales: LocaleSettings.supportedLocales,
      // localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
    );
  }
}
