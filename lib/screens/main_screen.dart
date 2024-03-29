import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/config/auth_config.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/containers/main_container.dart';
import 'package:project_yukki/i18n/strings.g.dart';
import 'package:project_yukki/providers/auth_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final currentIndex = 0;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: const Color(0x00000000),
          middle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(t.title, style: lightTextBoldStyle)],
          ),
          trailing: Wrap(
            children: [
              CupertinoButton(
                minSize: 0,
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.at,
                  size: 16,
                  color: CupertinoColors.inactiveGray,
                ),
                onPressed: () => _authProvider.signIn(googleAuth),
              ),
              const SizedBox(width: 10),
              CupertinoButton(
                minSize: 0,
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.star,
                  size: 16,
                  color: CupertinoColors.inactiveGray,
                ),
                onPressed: () => print('test'),
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                opacity: 0.1,
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _widgets[currentIndex],
                ),
              ),
            ),
          ),
        ),
      );

  List<Widget> get _widgets => [
        const MainContainer(),
      ];

  AuthProvider get _authProvider => ref.read(authProvider.notifier);
}
