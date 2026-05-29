import 'package:shared_preferences/shared_preferences.dart';

import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';

/// Serviço responsável por persistir localmente as preferências de acessibilidade.
///
/// A responsabilidade deste arquivo é centralizar:
/// - os nomes das chaves salvas no dispositivo;
/// - a leitura inicial das preferências;
/// - a gravação das alterações feitas pelo usuário;
/// - o controle de conclusão do onboarding inicial.
class AccessibilityPreferencesService {
  AccessibilityPreferencesService();

  /// Prefixo usado para manter as chaves organizadas no armazenamento local.
  static const String _prefix = 'accessibility';

  /// Chaves persistidas.
  ///
  /// Mantidas como constantes para evitar erro de digitação
  /// e facilitar futuras mudanças de nomenclatura.
  static const String _autoAnnounceQueuePositionKey =
      '$_prefix.autoAnnounceQueuePosition';
  static const String _speechRateKey = '$_prefix.speechRate';
  static const String _highContrastEnabledKey =
      '$_prefix.highContrastEnabled';
  static const String _colorBlindAssistEnabledKey =
      '$_prefix.colorBlindAssistEnabled';
  static const String _textScaleFactorKey = '$_prefix.textScaleFactor';
  static const String _onboardingCompletedKey = '$_prefix.onboardingCompleted';

  /// Carrega do armazenamento local as preferências salvas anteriormente.
  ///
  /// Quando não existir valor salvo, o método utiliza o estado inicial
  /// definido em [AccessibilityState.initial].
  Future<AccessibilityState> load() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    const AccessibilityState initialState = AccessibilityState.initial();

    return AccessibilityState(
      autoAnnounceQueuePosition:
          preferences.getBool(_autoAnnounceQueuePositionKey) ??
          initialState.autoAnnounceQueuePosition,
      speechRate:
          preferences.getDouble(_speechRateKey) ?? initialState.speechRate,
      highContrastEnabled:
          preferences.getBool(_highContrastEnabledKey) ??
          initialState.highContrastEnabled,
      colorBlindAssistEnabled:
          preferences.getBool(_colorBlindAssistEnabledKey) ??
          initialState.colorBlindAssistEnabled,
      textScaleFactor:
          preferences.getDouble(_textScaleFactorKey) ??
          initialState.textScaleFactor,
      onboardingCompleted:
          preferences.getBool(_onboardingCompletedKey) ??
          initialState.onboardingCompleted,
      // Quando o estado vem do serviço, a hidratação ainda será marcada pelo controller.
      preferencesHydrated: false,
    );
  }

  /// Salva o estado completo de acessibilidade.
  ///
  /// Optamos por persistir o estado inteiro a cada alteração para:
  /// - simplificar a lógica;
  /// - evitar inconsistência entre campos;
  /// - deixar a manutenção futura mais previsível.
  Future<void> save(AccessibilityState state) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      _autoAnnounceQueuePositionKey,
      state.autoAnnounceQueuePosition,
    );
    await preferences.setDouble(_speechRateKey, state.speechRate);
    await preferences.setBool(
      _highContrastEnabledKey,
      state.highContrastEnabled,
    );
    await preferences.setBool(
      _colorBlindAssistEnabledKey,
      state.colorBlindAssistEnabled,
    );
    await preferences.setDouble(_textScaleFactorKey, state.textScaleFactor);
    await preferences.setBool(
      _onboardingCompletedKey,
      state.onboardingCompleted,
    );
  }
}
