import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AccessibilityState {
  const AccessibilityState({
    required this.autoAnnounceQueuePosition,
    required this.speechRate,
    required this.highContrastEnabled,
    required this.textScaleFactor,
  });

  const AccessibilityState.initial()
    : autoAnnounceQueuePosition = false,
      speechRate = 0.45,
      highContrastEnabled = false,
      textScaleFactor = 1.0;

  final bool autoAnnounceQueuePosition;
  final double speechRate;
  final bool highContrastEnabled;
  final double textScaleFactor;

  AccessibilityState copyWith({
    bool? autoAnnounceQueuePosition,
    double? speechRate,
    bool? highContrastEnabled,
    double? textScaleFactor,
  }) {
    return AccessibilityState(
      autoAnnounceQueuePosition:
          autoAnnounceQueuePosition ?? this.autoAnnounceQueuePosition,
      speechRate: speechRate ?? this.speechRate,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
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

  void setHighContrastEnabled(bool value) {
    state = state.copyWith(highContrastEnabled: value);
  }

  void setTextScaleFactor(double value) {
    state = state.copyWith(textScaleFactor: value.clamp(1.0, 1.6));
  }
}
