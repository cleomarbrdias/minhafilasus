import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:minhafilasaude/app/config/app_config.dart';
import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minhafilasaude/features/auth/presentation/widgets/accessibility_onboarding_sheet.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Estado da autenticação atual.
    final authState = ref.watch(authControllerProvider);

    // Estado atual dos recursos de acessibilidade.
    final accessibilityState = ref.watch(accessibilityControllerProvider);

    // Controller usado para alterar os valores da acessibilidade.
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
                  'Informações de ambiente, sessão atual e recursos de acessibilidade.',
            ),
            const SizedBox(height: 20),

            // Card com informações da sessão atual do usuário.
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
                    icon: Icons.schedule_rounded,
                    title: 'Último acesso nesta sessão',
                    subtitle: authState.sessionStartedAt == null
                        ? 'Nenhum acesso registrado'
                        : authState.sessionStartedAt!.toPtBrDateTime(),
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

            // Card com todos os controles de acessibilidade.
            Card(
              child: Column(
                children: <Widget>[
                  // Ativa alto contraste.
                  SwitchListTile.adaptive(
                    secondary: const Icon(Icons.contrast_rounded),
                    title: const Text('Ativar alto contraste'),
                    subtitle: const Text(
                      'Aumenta a distinção entre textos, ícones e componentes para facilitar a leitura.',
                    ),
                    value: accessibilityState.highContrastEnabled,
                    // Alteração salva automaticamente no armazenamento local.
                    onChanged: accessibilityController.setHighContrastEnabled,
                  ),
                  const Divider(height: 1),

                  // Ajuste da escala global do texto.
                  ListTile(
                    leading: const Icon(Icons.format_size_rounded),
                    title: const Text('Tamanho do texto'),
                    subtitle: Text(
                      'Escala atual: ${(accessibilityState.textScaleFactor * 100).round()}%',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Slider(
                      // Escala mínima e máxima de fonte do app.
                      min: 1.0,
                      max: 1.6,
                      divisions: 6,
                      value: accessibilityState.textScaleFactor,
                      label:
                          '${(accessibilityState.textScaleFactor * 100).round()}%',
                      // Alteração salva automaticamente no armazenamento local.
                      onChanged: accessibilityController.setTextScaleFactor,
                    ),
                  ),
                  const Divider(height: 1),

                  // Ativa modo daltônico.
                  SwitchListTile.adaptive(
                    secondary: const Icon(Icons.visibility_rounded),
                    title: const Text('Ativar modo daltônico'),
                    subtitle: const Text(
                      'Ajusta a paleta para facilitar a distinção entre status, avisos e elementos informativos.',
                    ),
                    value: accessibilityState.colorBlindAssistEnabled,
                    // Alteração salva automaticamente no armazenamento local.
                    onChanged:
                        accessibilityController.setColorBlindAssistEnabled,
                  ),
                  const Divider(height: 1),

                  // Ativa leitura automática ao abrir a tela inicial.
                  SwitchListTile.adaptive(
                    secondary: const Icon(Icons.record_voice_over_rounded),
                    title: const Text('Ler posição da fila automaticamente'),
                    subtitle: const Text(
                      'Quando ativado, o app anuncia em áudio a posição atual ao abrir a tela inicial.',
                    ),
                    value: accessibilityState.autoAnnounceQueuePosition,
                    // Alteração salva automaticamente no armazenamento local.
                    onChanged:
                        accessibilityController.setAutoAnnounceQueuePosition,
                  ),
                  const Divider(height: 1),

                  // Controle da velocidade da fala do TTS.
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
                      // Faixa ajustada para permitir fala mais lenta
                      // ou significativamente mais rápida, conforme teste do usuário.
                      min: 0.45,
                      max: 1.65,
                      divisions: 12,
                      value: accessibilityState.speechRate,
                      label: accessibilityState.speechRate.toStringAsFixed(2),
                      // Alteração salva automaticamente no armazenamento local.
                      onChanged: accessibilityController.setSpeechRate,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botão para reabrir o onboarding de acessibilidade.
            //
            // Mesmo após a primeira configuração, o usuário pode revisar
            // o fluxo guiado se desejar.
            OutlinedButton.icon(
              onPressed: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return const AccessibilityOnboardingSheet();
                  },
                );
              },
              icon: const Icon(Icons.accessibility_new_rounded),
              label: const Text('Revisar configuração inicial de acessibilidade'),
            ),
            const SizedBox(height: 20),

            // Encerra a sessão atual e redireciona para a tela inicial.
            FilledButton.icon(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  context.go('/');
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Encerrar sessão'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Item simples reutilizável da tela de ajustes.
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
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
    );
  }
}
