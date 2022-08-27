import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/apps/main_app.dart';
import 'package:mana_studio/i18n/strings.g.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1920, 1080),
    minimumSize: Size(600, 400),
    // center: true,
    backgroundColor: Color(0x00FFFFFF),
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: const MainApp(),
      ),
    ),
  );
}
