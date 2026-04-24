import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:minhafilasaude/core/services/attachment_picker_service.dart';
import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';
import 'package:minhafilasaude/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minhafilasaude/features/home/data/mock_queue_repository.dart';
import 'package:minhafilasaude/features/home/domain/models/dashboard_snapshot.dart';
import 'package:minhafilasaude/features/home/domain/models/validation_attachment.dart';
import 'package:minhafilasaude/features/home/domain/repositories/queue_repository.dart';

class DashboardState {
  const DashboardState({
    required this.isLoading,
    required this.isSubmitting,
    required this.snapshot,
    required this.errorMessage,
    required this.draftAttachments,
  });

  const DashboardState.initial()
    : isLoading = true,
      isSubmitting = false,
      snapshot = null,
      errorMessage = null,
      draftAttachments = const <ValidationAttachment>[];

  final bool isLoading;
  final bool isSubmitting;
  final DashboardSnapshot? snapshot;
  final String? errorMessage;
  final List<ValidationAttachment> draftAttachments;

  DashboardSnapshot? get currentSnapshot => snapshot;

  static const Object _sentinel = Object();

  DashboardState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    DashboardSnapshot? snapshot,
    Object? errorMessage = _sentinel,
    List<ValidationAttachment>? draftAttachments,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      snapshot: snapshot ?? this.snapshot,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      draftAttachments: draftAttachments ?? this.draftAttachments,
    );
  }
}

final queueRepositoryProvider = Provider<QueueRepository>((Ref ref) {
  return MockQueueRepository();
});

final attachmentPickerServiceProvider = Provider<AttachmentPickerService>((
  Ref ref,
) {
  return AttachmentPickerService();
});

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((Ref ref) {
      final AppUser? user = ref.watch(authControllerProvider).user;

      return DashboardController(
        queueRepository: ref.watch(queueRepositoryProvider),
        currentUser: user,
      )..load();
    });

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController({
    required QueueRepository queueRepository,
    required AppUser? currentUser,
  }) : _queueRepository = queueRepository,
       _currentUser = currentUser,
       super(const DashboardState.initial());

  final QueueRepository _queueRepository;
  final AppUser? _currentUser;

  Future<void> load() async {
    if (_currentUser == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Nenhum usuário autenticado.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final DashboardSnapshot snapshot = await _queueRepository.fetchDashboard(
        user: _currentUser,
      );

      state = state.copyWith(
        isLoading: false,
        snapshot: snapshot,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void addAttachment(ValidationAttachment attachment) {
    final bool alreadySelected = state.draftAttachments.any(
      (ValidationAttachment item) =>
          item.fileName == attachment.fileName && item.path == attachment.path,
    );

    if (alreadySelected) {
      return;
    }

    state = state.copyWith(
      draftAttachments: <ValidationAttachment>[
        ...state.draftAttachments,
        attachment,
      ],
      errorMessage: null,
    );
  }

  void removeAttachment(String attachmentId) {
    state = state.copyWith(
      draftAttachments: state.draftAttachments
          .where(
            (ValidationAttachment attachment) => attachment.id != attachmentId,
          )
          .toList(),
    );
  }

  void clearDraftAttachments() {
    state = state.copyWith(
      draftAttachments: const <ValidationAttachment>[],
      errorMessage: null,
    );
  }

  Future<void> confirmStillWaiting(String requestId) async {
    final DashboardSnapshot? snapshot = state.currentSnapshot;

    if (_currentUser == null || snapshot == null) {
      return;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final DashboardSnapshot updatedSnapshot = await _queueRepository
          .confirmStillWaiting(user: _currentUser, requestId: requestId);

      state = state.copyWith(
        isSubmitting: false,
        snapshot: updatedSnapshot,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> submitProcedureAlreadyDone(String requestId) async {
    final DashboardSnapshot? snapshot = state.currentSnapshot;

    if (_currentUser == null || snapshot == null) {
      return false;
    }

    if (state.draftAttachments.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Anexe pelo menos um comprovante antes de enviar.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final DashboardSnapshot updatedSnapshot = await _queueRepository
          .submitProcedureAlreadyDone(
            user: _currentUser,
            requestId: requestId,
            attachments: state.draftAttachments,
          );

      state = state.copyWith(
        isSubmitting: false,
        snapshot: updatedSnapshot,
        draftAttachments: const <ValidationAttachment>[],
        errorMessage: null,
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}
