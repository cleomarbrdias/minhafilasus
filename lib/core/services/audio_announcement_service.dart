import 'package:flutter_tts/flutter_tts.dart';

/// Serviço central responsável pelas leituras em voz do aplicativo.
///
/// Observação de manutenção:
/// toda fala do app passa por este serviço para facilitar ajustes futuros
/// de idioma, velocidade, volume e estilo das mensagens.
class AudioAnnouncementService {
  AudioAnnouncementService() {
    _configure();
  }

  final FlutterTts _tts = FlutterTts();

  /// Configuração inicial do motor de voz.
  ///
  /// Mantida em um método separado para facilitar manutenção futura.
  Future<void> _configure() async {
    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  /// Lê um texto livre.
  ///
  /// Esse método é o mais genérico do serviço e serve de base para
  /// mensagens rápidas ou instruções específicas.
  Future<void> speakText(String text, {double speechRate = 0.45}) async {
    await _tts.setSpeechRate(speechRate);
    await _tts.stop();
    await _tts.speak(text);
  }

  /// Lê instruções gerais do onboarding de acessibilidade.
  ///
  /// Criado para centralizar a mensagem inicial da configuração guiada.
  Future<void> speakAccessibilityOnboarding({
    required double speechRate,
  }) async {
    final String message =
        'Configuração inicial de acessibilidade. '
        'Você pode escolher como prefere usar o aplicativo. '
        'As opções estão nesta ordem: alto contraste, modo daltônico, '
        'leitura automática da posição da fila e tamanho do texto. '
        'Ao lado de cada opção existe um botão de áudio para ouvir a explicação. '
        'No final da tela, você pode tocar em usar configuração padrão '
        'ou salvar preferências.';

    await speakText(message, speechRate: speechRate);
  }

  Future<void> speakNotification({
    required String title,
    required String description,
    double speechRate = 0.45,
  }) async {
    final String message = '$title. $description.';

    await _tts.setSpeechRate(speechRate);
    await _tts.stop();
    await _tts.speak(message);
  }

  Future<void> speakQueuePosition({
    required String userName,
    required String procedure,
    required String hospital,
    required int position,
    required String estimatedWait,
    double speechRate = 0.45,
  }) async {
    final String message =
        'Olá, $userName. Sua posição atual é $position na fila para '
        '$procedure, no $hospital. Tempo estimado de espera: $estimatedWait.';

    await _tts.setSpeechRate(speechRate);
    await _tts.stop();
    await _tts.speak(message);
  }

  /// Interrompe qualquer áudio em reprodução.
  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> speakHistoryEntry({
    required String title,
    required String description,
    required String dateLabel,
    double speechRate = 0.45,
  }) async {
    final String message =
        '$title. $description. Data do registro: $dateLabel.';

    await _tts.setSpeechRate(speechRate);
    await _tts.stop();
    await _tts.speak(message);
  }
}
