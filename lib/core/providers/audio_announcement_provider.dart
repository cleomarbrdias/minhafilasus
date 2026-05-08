import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minhafilasaude/core/services/audio_announcement_service.dart';

final audioAnnouncementServiceProvider = Provider<AudioAnnouncementService>((
  Ref ref,
) {
  return AudioAnnouncementService();
});
