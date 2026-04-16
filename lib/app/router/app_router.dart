import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:minhafilasaude/features/auth/presentation/screens/login_screen.dart';
import 'package:minhafilasaude/features/home/presentation/screens/app_shell_screen.dart';
import 'package:minhafilasaude/features/home/presentation/screens/status_screen.dart';

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/app',
        builder: (context, state) => const AppShellScreen(),
      ),
      GoRoute(
        path: '/status',
        builder: (context, state) {
          final args = state.extra is StatusScreenArgs
              ? state.extra! as StatusScreenArgs
              : StatusScreenArgs.validationReceived();
          return StatusScreen(args: args);
        },
      ),
    ],
  );
});
