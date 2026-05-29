import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class MinhaFilaSaudeApp extends ConsumerWidget {
  const MinhaFilaSaudeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final accessibilityState = ref.watch(accessibilityControllerProvider);

    return MaterialApp.router(
      title: 'MinhaFila Saúde',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(
        highContrast: accessibilityState.highContrastEnabled,
      ),
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(accessibilityState.textScaleFactor),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: router,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const <Locale>[
        Locale('pt', 'BR'),
        Locale('en'),
      ],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
