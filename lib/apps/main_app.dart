import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/i18n/strings.g.dart';
import 'package:project_yukki/providers/project_provider.dart';
import 'package:project_yukki/router.dart';
import 'package:project_yukki/handlers/main_handler.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    if (!MainHandler.isRunning) {
      _projectProvider.loadProject();
    }
    MainHandler.init();
  }

  @override
  Widget build(BuildContext context) => CupertinoApp(
        title: 'Test',
        initialRoute: '/',
        routes: getRoutes(context),
        theme: CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: CupertinoColors.systemBackground,
          textTheme: CupertinoTextThemeData(
            primaryColor: primaryColor,
            textStyle: primaryTextStyle,
          ),
        ),
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: LocaleSettings.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        debugShowCheckedModeBanner: false,
      );

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);
}
