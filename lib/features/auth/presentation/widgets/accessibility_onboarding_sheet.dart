import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minhafilasaude/core/providers/audio_announcement_provider.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';

/// Bottom sheet exibido no primeiro acesso para o usuário escolher
/// como prefere visualizar o aplicativo.
///
/// Observação de manutenção:
/// esta tela não substitui a área de ajustes. Ela apenas oferece
/// uma configuração inicial guiada. Depois disso, o usuário continua
/// podendo alterar tudo em "Ajustes".
///
/// Evolução de acessibilidade:
/// além da leitura visual, esta versão também oferece instruções em áudio.
/// Isso ajuda usuários com dificuldade de leitura ou baixa alfabetização
/// a entenderem o que cada opção faz.
class AccessibilityOnboardingSheet extends ConsumerStatefulWidget {
  const AccessibilityOnboardingSheet({super.key});

  @override
  ConsumerState<AccessibilityOnboardingSheet> createState() =>
      _AccessibilityOnboardingSheetState();
}

class _AccessibilityOnboardingSheetState
    extends ConsumerState<AccessibilityOnboardingSheet> {
  /// Evita repetir a leitura automática toda vez que a tela reconstrói.
  bool _hasPlayedInitialInstructions = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Toca uma orientação inicial automaticamente na primeira abertura.
    //
    // A chamada fica no post frame para garantir que o bottom sheet
    // já esteja montado e visível antes do áudio começar.
    if (!_hasPlayedInitialInstructions) {
      _hasPlayedInitialInstructions = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _speakGeneralInstructions();
        }
      });
    }
  }

  @override
  void dispose() {
    // Interrompe qualquer leitura em andamento quando o usuário fecha o sheet.
    ref.read(audioAnnouncementServiceProvider).stop();
    super.dispose();
  }

  /// Lê uma orientação geral do onboarding.
  ///
  /// Esse áudio explica:
  /// - o objetivo da tela;
  /// - a ordem das opções;
  /// - como concluir a configuração.
  Future<void> _speakGeneralInstructions() async {
    final AccessibilityState accessibilityState = ref.read(
      accessibilityControllerProvider,
    );

    await ref.read(audioAnnouncementServiceProvider).speakAccessibilityOnboarding(
      speechRate: accessibilityState.speechRate,
    );
  }

  /// Lê a explicação de uma opção específica.
  ///
  /// Essa função foi criada para evitar repetição de código e facilitar
  /// futuras alterações no texto falado.
  Future<void> _speakOptionDescription(String message) async {
    final AccessibilityState accessibilityState = ref.read(
      accessibilityControllerProvider,
    );

    await ref.read(audioAnnouncementServiceProvider).speakText(
      message,
      speechRate: accessibilityState.speechRate,
    );
  }

  /// Interrompe a leitura atual.
  Future<void> _stopAudio() async {
    await ref.read(audioAnnouncementServiceProvider).stop();
  }

  @override
  Widget build(BuildContext context) {
    final AccessibilityState accessibilityState = ref.watch(
      accessibilityControllerProvider,
    );
    final AccessibilityController accessibilityController = ref.read(
      accessibilityControllerProvider.notifier,
    );
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Como você prefere usar o app?',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Escolha recursos que podem facilitar sua navegação. '
                'Você poderá alterar essas opções depois na tela de Ajustes.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Botões rápidos de áudio.
              //
              // O primeiro reproduz novamente a explicação completa.
              // O segundo interrompe qualquer áudio em andamento.
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _speakGeneralInstructions,
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Ouvir instruções'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _stopAudio,
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('Parar áudio'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Card(
                child: Column(
                  children: <Widget>[
                    _OnboardingAudioSwitchTile(
                      icon: Icons.contrast_rounded,
                      title: 'Ativar alto contraste',
                      subtitle:
                          'Aumenta a distinção entre fundo, texto e componentes.',
                      value: accessibilityState.highContrastEnabled,
                      onChanged:
                          accessibilityController.setHighContrastEnabled,
                      onReadPressed: () => _speakOptionDescription(
                        'Ativar alto contraste. '
                        'Essa opção aumenta a distinção entre fundo, texto '
                        'e componentes para facilitar a leitura.',
                      ),
                    ),
                    const Divider(height: 1),
                    _OnboardingAudioSwitchTile(
                      icon: Icons.visibility_rounded,
                      title: 'Ativar modo daltônico',
                      subtitle:
                          'Ajusta as cores para facilitar a leitura de status e avisos.',
                      value: accessibilityState.colorBlindAssistEnabled,
                      onChanged:
                          accessibilityController.setColorBlindAssistEnabled,
                      onReadPressed: () => _speakOptionDescription(
                        'Ativar modo daltônico. '
                        'Essa opção ajusta as cores para facilitar a distinção '
                        'entre status, avisos e elementos informativos.',
                      ),
                    ),
                    const Divider(height: 1),
                    _OnboardingAudioSwitchTile(
                      icon: Icons.record_voice_over_rounded,
                      title: 'Ler posição da fila automaticamente',
                      subtitle:
                          'Quando ativado, o app anuncia em áudio a posição ao abrir a tela inicial.',
                      value: accessibilityState.autoAnnounceQueuePosition,
                      onChanged:
                          accessibilityController.setAutoAnnounceQueuePosition,
                      onReadPressed: () => _speakOptionDescription(
                        'Ler posição da fila automaticamente. '
                        'Quando ativado, o aplicativo anuncia em áudio '
                        'a posição da fila ao abrir a tela inicial.',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.format_size_rounded),
                      title: const Text('Tamanho do texto'),
                      subtitle: Text(
                        'Escala atual: ${(accessibilityState.textScaleFactor * 100).round()}%',
                      ),
                      trailing: IconButton(
                        tooltip: 'Ouvir explicação sobre tamanho do texto',
                        onPressed: () => _speakOptionDescription(
                          'Tamanho do texto. '
                          'Use a barra deslizante abaixo para aumentar ou diminuir '
                          'o tamanho das letras do aplicativo.',
                        ),
                        icon: const Icon(Icons.volume_up_rounded),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Slider(
                        min: 1.0,
                        max: 1.6,
                        divisions: 6,
                        value: accessibilityState.textScaleFactor,
                        label:
                            '${(accessibilityState.textScaleFactor * 100).round()}%',
                        onChanged: accessibilityController.setTextScaleFactor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Botão para seguir sem customização.
              OutlinedButton(
                onPressed: () async {
                  await _stopAudio();
                  await accessibilityController.resetToDefaults();
                  await accessibilityController.completeOnboarding();

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Usar configuração padrão'),
              ),
              const SizedBox(height: 12),

              // Botão para confirmar as escolhas feitas.
              FilledButton(
                onPressed: () async {
                  await _stopAudio();
                  await accessibilityController.completeOnboarding();

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Salvar preferências'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tile reutilizável do onboarding com:
/// - ícone visual;
/// - texto da configuração;
/// - botão de áudio para leitura da explicação;
/// - switch para ativar ou desativar a opção.
///
/// Essa composição facilita manutenção porque todas as opções com áudio
/// passam a seguir o mesmo padrão visual e de comportamento.
class _OnboardingAudioSwitchTile extends StatelessWidget {
  const _OnboardingAudioSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.onReadPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onReadPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: SizedBox(
        width: 108,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              tooltip: 'Ouvir explicação',
              onPressed: onReadPressed,
              icon: const Icon(Icons.volume_up_rounded),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
