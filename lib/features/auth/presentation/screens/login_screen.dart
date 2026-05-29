import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:minhafilasaude/app/config/app_config.dart';
import 'package:minhafilasaude/app/theme/app_theme.dart';
import 'package:minhafilasaude/core/widgets/app_brand_mark.dart';
import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minhafilasaude/features/auth/presentation/widgets/accessibility_onboarding_sheet.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';

/// Tela de entrada do aplicativo.
///
/// Nesta versão, ela também é responsável por abrir automaticamente o
/// onboarding inicial de acessibilidade quando o usuário entra pela primeira vez.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// Evita múltiplas aberturas do onboarding na mesma construção da tela.
  bool _hasRequestedOnboarding = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (
      AuthState? previous,
      AuthState next,
    ) {
      if (next.isAuthenticated) {
        context.go('/app');
      }

      if (next.status == AuthStatus.failure &&
          next.errorMessage != null &&
          next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

    final AuthState state = ref.watch(authControllerProvider);
    final AccessibilityState accessibilityState = ref.watch(
      accessibilityControllerProvider,
    );
    final ThemeData theme = Theme.of(context);

    // Abre o onboarding apenas depois que as preferências forem carregadas.
    if (accessibilityState.preferencesHydrated &&
        !accessibilityState.onboardingCompleted &&
        !_hasRequestedOnboarding) {
      _hasRequestedOnboarding = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) {
          return;
        }

        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            return const AccessibilityOnboardingSheet();
          },
        );
      });
    }

    return Scaffold(
      body: SafeArea(
        child: AppResponsiveBody(
          maxWidth: 520,
          child: Column(
            children: <Widget>[
              const Spacer(flex: 2),
              const AppBrandMark(size: 110),
              const SizedBox(height: 18),
              Text(
                'MinhaFila\nSaúde',
                style: theme.textTheme.headlineMedium?.copyWith(
                  height: 1.0,
                  color: const Color(0xFF183A63),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Text(
                'Consulte sua posição na fila do SUS de forma '
                'transparente e segura.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF202A36),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _InfoChip(
                    icon: Icons.verified_user_outlined,
                    label: AppConfig.isGovBrConfigured
                        ? 'Login gov.br configurado'
                        : 'Modo demonstração',
                  ),
                  const _InfoChip(
                    icon: Icons.accessibility_new_rounded,
                    label: 'Acessibilidade configurável',
                  ),
                  const _InfoChip(
                    icon: Icons.shield_outlined,
                    label: 'Validação pela SES',
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: state.isBusy
                    ? null
                    : () => ref
                          .read(authControllerProvider.notifier)
                          .signInWithGovBr(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.govBrBlue,
                  foregroundColor: Colors.white,
                ),
                icon: state.isBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(
                  state.isBusy ? 'Conectando...' : 'Entrar com gov.br',
                ),
              ),
              const SizedBox(height: 14),
              Text(
                AppConfig.isGovBrConfigured
                    ? 'Fluxo pronto para autenticação real.'
                    : 'Sem credenciais institucionais, o projeto abre em '
                          'modo mock para facilitar a defesa e a demonstração.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Botão opcional para reabrir manualmente o onboarding
              // caso o usuário queira revisar as escolhas antes do login.
              TextButton.icon(
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return const AccessibilityOnboardingSheet();
                    },
                  );
                },
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Configurar acessibilidade'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    );
  }
}
