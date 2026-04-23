import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:minhafilasaude/app/config/app_config.dart';
import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final accessibilityState = ref.watch(accessibilityControllerProvider);
    final accessibilityController = ref.read(
      accessibilityControllerProvider.notifier,
    );

    return SafeArea(
      child: AppResponsiveBody(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: ListView(
          children: <Widget>[
            const SectionTitle(
              title: 'Ajustes',
              subtitle:
                  'Informações de ambiente, integração, sessão atual e acessibilidade.',
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: <Widget>[
                  _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title:
                        authState.user?.fullName ?? 'Usuário não autenticado',
                    subtitle: authState.user?.cpfMasked ?? '',
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.apartment_rounded,
                    title: 'Ambiente',
                    subtitle: AppConfig.environmentName,
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.verified_user_outlined,
                    title: 'gov.br',
                    subtitle: AppConfig.isGovBrConfigured
                        ? 'Configuração real habilitada'
                        : 'Modo mock ativo',
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.hub_outlined,
                    title: 'API SES',
                    subtitle: AppConfig.isSesConfigured
                        ? AppConfig.apiBaseUrl
                        : 'Ainda não conectada. Mock em execução.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: <Widget>[
                  SwitchListTile.adaptive(
                    secondary: const Icon(Icons.record_voice_over_rounded),
                    title: const Text('Ler posição da fila automaticamente'),
                    subtitle: const Text(
                      'Quando ativado, o app anuncia em áudio a posição atual ao abrir a tela inicial.',
                    ),
                    value: accessibilityState.autoAnnounceQueuePosition,
                    onChanged:
                        accessibilityController.setAutoAnnounceQueuePosition,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.speed_rounded),
                    title: const Text('Velocidade da fala'),
                    subtitle: Text(
                      'Valor atual: ${accessibilityState.speechRate.toStringAsFixed(2)}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Slider(
                      value: accessibilityState.speechRate,
                      min: 0.3,
                      max: 0.65,
                      divisions: 7,
                      label: accessibilityState.speechRate.toStringAsFixed(2),
                      onChanged: accessibilityController.setSpeechRate,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                ref.invalidate(dashboardControllerProvider);

                if (context.mounted) {
                  context.go('/');
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
