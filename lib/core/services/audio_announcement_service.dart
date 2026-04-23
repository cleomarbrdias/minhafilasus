import 'package:flutter_tts/flutter_tts.dart';

class AudioAnnouncementService {
  AudioAnnouncementService() {
    _configure();
  }

  final FlutterTts _tts = FlutterTts();

  Future<void> _configure() async {
    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> speakQueuePosition({
    required String userName,
    required String procedure,
    required String hospital,
    required int position,
    required String estimatedWait,
    required double speechRate,
  }) async {
    final message =
        'Olá, $userName. Sua posição atual é $position na fila para $procedure, no $hospital. '
        'Tempo estimado de espera: $estimatedWait.';

    await _tts.stop();
    await _tts.speak(message);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
