import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

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
/// além da leitura visual, esta versão oferece:
/// - instruções em áudio;
/// - botão flutuante para abrir conteúdo em Libras.
///
/// Nesta fase, o conteúdo em Libras será exibido dentro do próprio app,
/// por meio de uma tela dedicada com vídeo local em asset.
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
  Future<void> _speakGeneralInstructions() async {
    final AccessibilityState accessibilityState = ref.read(
      accessibilityControllerProvider,
    );

    await ref
        .read(audioAnnouncementServiceProvider)
        .speakAccessibilityOnboarding(
          speechRate: accessibilityState.speechRate,
        );
  }

  /// Lê a explicação de uma opção específica.
  Future<void> _speakOptionDescription(String message) async {
    final AccessibilityState accessibilityState = ref.read(
      accessibilityControllerProvider,
    );

    await ref
        .read(audioAnnouncementServiceProvider)
        .speakText(message, speechRate: accessibilityState.speechRate);
  }

  /// Interrompe a leitura atual.
  Future<void> _stopAudio() async {
    await ref.read(audioAnnouncementServiceProvider).stop();
  }

  /// Abre o vídeo de boas-vindas em Libras em uma tela própria.
  ///
  /// Essa abordagem é mais estável do que usar dialog para vídeo,
  /// facilita o fechamento e melhora a experiência do usuário.
  Future<void> _openLibrasWelcomeVideo(BuildContext context) async {
    await _stopAudio();

    if (!context.mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const _LibrasVideoScreen(
          title: 'Boas-vindas em Libras',
          assetPath: 'assets/video_libras/boas_vindas.mp4',
        ),
      ),
    );
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _LibrasFloatingButton(
        onTap: () => _openLibrasWelcomeVideo(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          // Padding inferior menor, porque agora o FAB é gerenciado
          // pelo Scaffold e não precisa reservar uma faixa grande.
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                        onChanged: accessibilityController
                            .setAutoAnnounceQueuePosition,
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

                // Espaço extra para evitar que o FAB cubra os botões finais.
                const SizedBox(height: 88),
              ],
            ),
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
            Switch.adaptive(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

/// Botão flutuante para abrir o conteúdo em Libras.
///
/// Nesta versão ele usa:
/// - FloatingActionButton.small
/// - ícone SVG configurado no projeto
/// - tooltip e semântica para acessibilidade
class _LibrasFloatingButton extends StatelessWidget {
  const _LibrasFloatingButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Abrir boas-vindas em Libras',
      child: FloatingActionButton.small(
        onPressed: onTap,
        heroTag: 'libras_onboarding_fab',
        tooltip: 'Abrir Libras',
        child: SvgPicture.asset(
          'assets/icons/access_icon.svg',
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}

/// Tela dedicada para exibir o vídeo em Libras.
///
/// Esta abordagem foi escolhida para:
/// - evitar problemas de usabilidade com dialog;
/// - facilitar o fechamento;
/// - dar mais previsibilidade ao fluxo.
class _LibrasVideoScreen extends StatefulWidget {
  const _LibrasVideoScreen({required this.title, required this.assetPath});

  final String title;
  final String assetPath;

  @override
  State<_LibrasVideoScreen> createState() => _LibrasVideoScreenState();
}

class _LibrasVideoScreenState extends State<_LibrasVideoScreen> {
  late final VideoPlayerController _controller;
  bool _isReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize()
          .then((_) {
            if (!mounted) {
              return;
            }

            _controller.setLooping(false);

            setState(() {
              _isReady = true;
            });

            _controller.play();
          })
          .catchError((Object error) {
            if (!mounted) {
              return;
            }

            setState(() {
              _errorMessage =
                  'Não foi possível abrir o vídeo em Libras. '
                  'Verifique se o arquivo está configurado corretamente nos assets.';
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: _errorMessage != null
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            color: Colors.black,
                            child: _isReady
                                ? AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  )
                                : const AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 54),
                    ),
                    onPressed: _isReady
                        ? () {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                            setState(() {});
                          }
                        : null,
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(
                      _controller.value.isPlaying ? 'Pausar' : 'Reproduzir',
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                    onPressed: _isReady
                        ? () {
                            _controller.seekTo(Duration.zero);
                            _controller.play();
                            setState(() {});
                          }
                        : null,
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Repetir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
