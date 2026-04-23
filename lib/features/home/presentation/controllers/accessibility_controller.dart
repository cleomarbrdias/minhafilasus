import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AccessibilityState {
  const AccessibilityState({
    required this.autoAnnounceQueuePosition,
    required this.speechRate,
  });

  const AccessibilityState.initial()
    : autoAnnounceQueuePosition = false,
      speechRate = 0.45;

  final bool autoAnnounceQueuePosition;
  final double speechRate;

  AccessibilityState copyWith({
    bool? autoAnnounceQueuePosition,
    double? speechRate,
  }) {
    return AccessibilityState(
      autoAnnounceQueuePosition:
          autoAnnounceQueuePosition ?? this.autoAnnounceQueuePosition,
      speechRate: speechRate ?? this.speechRate,
    );
  }
}

final accessibilityControllerProvider =
    StateNotifierProvider<AccessibilityController, AccessibilityState>((
      Ref ref,
    ) {
      return AccessibilityController();
    });

class AccessibilityController extends StateNotifier<AccessibilityState> {
  AccessibilityController() : super(const AccessibilityState.initial());

  void setAutoAnnounceQueuePosition(bool value) {
    state = state.copyWith(autoAnnounceQueuePosition: value);
  }

  void setSpeechRate(double value) {
    state = state.copyWith(speechRate: value.clamp(0.3, 0.65));
  }
}
