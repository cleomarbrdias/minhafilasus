import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:minhafilasaude/core/services/accessibility_preferences_service.dart';

/// Estado global de acessibilidade do aplicativo.
///
/// Esta classe concentra preferências que afetam:
/// - leitura por voz;
/// - contraste;
/// - modo daltônico;
/// - escala global do texto;
/// - controle do onboarding inicial de acessibilidade.
class AccessibilityState {
  const AccessibilityState({
    required this.autoAnnounceQueuePosition,
    required this.speechRate,
    required this.highContrastEnabled,
    required this.colorBlindAssistEnabled,
    required this.textScaleFactor,
    required this.onboardingCompleted,
    required this.preferencesHydrated,
  });

  /// Estado inicial padrão do app.
  ///
  /// Observações de manutenção:
  /// - [onboardingCompleted] começa como `false`, porque o usuário ainda não
  ///   passou pela escolha inicial de acessibilidade.
  /// - [preferencesHydrated] começa como `false` e só vira `true` depois que
  ///   as preferências forem carregadas do armazenamento local.
  const AccessibilityState.initial()
    : autoAnnounceQueuePosition = false,
      speechRate = 1.05,
      highContrastEnabled = false,
      colorBlindAssistEnabled = false,
      textScaleFactor = 1.0,
      onboardingCompleted = false,
      preferencesHydrated = false;

  /// Define se a posição da fila será anunciada automaticamente ao abrir a tela.
  final bool autoAnnounceQueuePosition;

  /// Velocidade da fala usada no TTS.
  ///
  /// Faixa adotada no projeto:
  /// - 0.45 = mais lenta
  /// - 1.05 = padrão atual
  /// - 1.65 = mais rápida
  final double speechRate;

  /// Ativa tema de alto contraste para melhorar leitura visual.
  final bool highContrastEnabled;

  /// Ativa ajustes visuais voltados a usuários com daltonismo.
  final bool colorBlindAssistEnabled;

  /// Fator de escala do texto aplicado globalmente no app.
  final double textScaleFactor;

  /// Indica se o usuário já concluiu o onboarding inicial de acessibilidade.
  ///
  /// Quando `false`, a tela inicial pode abrir o fluxo guiado de primeira
  /// configuração.
  final bool onboardingCompleted;

  /// Indica que as preferências já foram carregadas do armazenamento local.
  ///
  /// Esse campo é importante para evitar que a interface tente abrir o
  /// onboarding antes de terminar a leitura das preferências salvas.
  final bool preferencesHydrated;

  /// Cria uma cópia do estado atual alterando apenas os campos informados.
  AccessibilityState copyWith({
    bool? autoAnnounceQueuePosition,
    double? speechRate,
    bool? highContrastEnabled,
    bool? colorBlindAssistEnabled,
    double? textScaleFactor,
    bool? onboardingCompleted,
    bool? preferencesHydrated,
  }) {
    return AccessibilityState(
      autoAnnounceQueuePosition:
          autoAnnounceQueuePosition ?? this.autoAnnounceQueuePosition,
      speechRate: speechRate ?? this.speechRate,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      colorBlindAssistEnabled:
          colorBlindAssistEnabled ?? this.colorBlindAssistEnabled,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      preferencesHydrated: preferencesHydrated ?? this.preferencesHydrated,
    );
  }
}

/// Provider do serviço responsável por salvar e carregar preferências.
///
/// Mantido separado do controller para reduzir acoplamento.
final accessibilityPreferencesServiceProvider =
    Provider<AccessibilityPreferencesService>((Ref ref) {
      return AccessibilityPreferencesService();
    });

/// Provider principal do controller de acessibilidade.
///
/// Expõe:
/// - o estado atual;
/// - os métodos para atualizar as preferências;
/// - a hidratação automática das preferências salvas localmente.
final accessibilityControllerProvider =
    StateNotifierProvider<AccessibilityController, AccessibilityState>((
      Ref ref,
    ) {
      return AccessibilityController(
        ref.read(accessibilityPreferencesServiceProvider),
      );
    });

/// Controller responsável por alterar o estado de acessibilidade do app.
///
/// Além de alterar o estado em memória, este controller também:
/// - carrega preferências salvas ao ser criado;
/// - persiste cada alteração feita pelo usuário;
/// - controla a conclusão do onboarding inicial de acessibilidade.
class AccessibilityController extends StateNotifier<AccessibilityState> {
  AccessibilityController(this._preferencesService)
    : super(const AccessibilityState.initial()) {
    _loadSavedPreferences();
  }

  final AccessibilityPreferencesService _preferencesService;

  /// Carrega do armazenamento local as preferências previamente salvas.
  ///
  /// Esse método é chamado automaticamente ao criar o controller.
  /// Caso ocorra falha na leitura, o app mantém os valores padrão
  /// para não comprometer a experiência do usuário.
  Future<void> _loadSavedPreferences() async {
    try {
      final AccessibilityState savedState = await _preferencesService.load();
      state = savedState.copyWith(preferencesHydrated: true);
    } catch (_) {
      // Mantém o estado padrão em caso de falha na leitura local,
      // mas libera a interface para seguir o fluxo normal.
      state = state.copyWith(preferencesHydrated: true);
    }
  }

  /// Persiste no armazenamento local o estado atual do app.
  ///
  /// Essa centralização evita repetição de código em cada setter.
  Future<void> _persistState() async {
    try {
      await _preferencesService.save(state);
    } catch (_) {
      // Em caso de falha na gravação, o app continua funcionando com o estado
      // atual em memória.
    }
  }

  /// Marca o onboarding inicial de acessibilidade como concluído.
  ///
  /// Esse método deve ser chamado quando o usuário:
  /// - salva as preferências escolhidas na etapa inicial; ou
  /// - decide continuar com a configuração padrão.
  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingCompleted: true);
    await _persistState();
  }

  /// Restaura as preferências de acessibilidade para o padrão do projeto.
  ///
  /// Observação de manutenção:
  /// este método é útil no botão "Usar configuração padrão" do onboarding.
  Future<void> resetToDefaults() async {
    state = state.copyWith(
      autoAnnounceQueuePosition: false,
      speechRate: const AccessibilityState.initial().speechRate,
      highContrastEnabled: false,
      colorBlindAssistEnabled: false,
      textScaleFactor: 1.0,
    );
    await _persistState();
  }

  /// Ativa ou desativa a leitura automática da posição da fila.
  Future<void> setAutoAnnounceQueuePosition(bool value) async {
    state = state.copyWith(autoAnnounceQueuePosition: value);
    await _persistState();
  }

  /// Define a velocidade da fala do recurso TTS.
  ///
  /// Faixa atual:
  /// - mínimo: 0.45
  /// - máximo: 1.65
  ///
  /// Observação:
  /// o comportamento pode variar entre Android, iOS e desktop.
  Future<void> setSpeechRate(double value) async {
    state = state.copyWith(speechRate: value.clamp(0.45, 1.65));
    await _persistState();
  }

  /// Ativa ou desativa o modo de alto contraste.
  Future<void> setHighContrastEnabled(bool value) async {
    state = state.copyWith(highContrastEnabled: value);
    await _persistState();
  }

  /// Ativa ou desativa o modo de assistência para daltonismo.
  Future<void> setColorBlindAssistEnabled(bool value) async {
    state = state.copyWith(colorBlindAssistEnabled: value);
    await _persistState();
  }

  /// Ajusta a escala global da fonte do app.
  ///
  /// Faixa atual:
  /// - mínimo: 1.0
  /// - máximo: 1.6
  Future<void> setTextScaleFactor(double value) async {
    state = state.copyWith(textScaleFactor: value.clamp(1.0, 1.6));
    await _persistState();
  }
}
