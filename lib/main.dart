import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/providers/project_provider.dart';
import 'package:mana_studio/router.dart';
import 'package:mana_studio/utils/handlers/main_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

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
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Test',
      initialRoute: '/',
      routes: getRoutes(context),
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        // primaryColor: PINK_COLOR,
        scaffoldBackgroundColor: CupertinoColors.systemBackground,
      ),
      // locale: TranslationProvider.of(context).flutterLocale,
      // supportedLocales: LocaleSettings.supportedLocales,
      // localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
    );
  }

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);
}
