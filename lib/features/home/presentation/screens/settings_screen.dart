import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:minhafilasaude/app/config/app_config.dart';
import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return SafeArea(
      child: AppResponsiveBody(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionTitle(
              title: 'Ajustes',
              subtitle: 'Informações de ambiente, integração e sessão atual.',
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
