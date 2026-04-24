import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:minhafilasaude/core/services/audio_announcement_service.dart';

import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/core/widgets/empty_state_card.dart';
import 'package:minhafilasaude/features/home/domain/models/dashboard_snapshot.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_request.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:minhafilasaude/features/home/presentation/screens/status_screen.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/active_queue_card.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/dashboard_header.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/history_entry_card.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/procedure_confirmation_sheet.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/validation_sheet.dart';

final audioAnnouncementServiceProvider = Provider<AudioAnnouncementService>((
  Ref ref,
) {
  return AudioAnnouncementService();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _lastAutoAnnouncementKey;

  @override
  Widget build(BuildContext context) {
    final DashboardState state = ref.watch(dashboardControllerProvider);
    final DashboardController controller = ref.read(
      dashboardControllerProvider.notifier,
    );

    if (state.isLoading && state.currentSnapshot == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final DashboardSnapshot? snapshot = state.currentSnapshot;

    if (snapshot == null) {
      return const Center(
        child: AppResponsiveBody(
          child: EmptyStateCard(
            icon: Icons.error_outline_rounded,
            title: 'Não foi possível carregar a fila',
            message: 'Faça login novamente ou tente atualizar os dados.',
          ),
        ),
      );
    }

    _maybeAutoAnnounce(snapshot);

    final List<QueueRequest> activeRequests = snapshot.activeRequests;

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DashboardHeader(user: snapshot.user),
          AppResponsiveBody(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionTitle(
                  title: 'Minhas solicitações em andamento',
                  subtitle: state.errorMessage,
                ),
                const SizedBox(height: 14),
                if (activeRequests.isEmpty)
                  const EmptyStateCard(
                    icon: Icons.assignment_outlined,
                    title: 'Nenhuma solicitação em andamento',
                    message:
                        'No momento você não possui procedimentos ativos para acompanhamento.',
                  )
                else
                  ...activeRequests.map(
                    (QueueRequest request) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ActiveQueueCard(
                        request: request,
                        onPressed: () => _onQueuePressed(
                          context: context,
                          ref: ref,
                          request: request,
                        ),
                        onListenPressed: () => _announceQueuePosition(
                          userName: snapshot.user.fullName,
                          request: request,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                SectionTitle(title: 'Históricos', subtitle: null),
                const SizedBox(height: 14),
                ...snapshot.history
                    .take(3)
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HistoryEntryCard(entry: entry),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _maybeAutoAnnounce(DashboardSnapshot snapshot) {
    final accessibilityState = ref.read(accessibilityControllerProvider);

    if (!accessibilityState.autoAnnounceQueuePosition) {
      _lastAutoAnnouncementKey = null;
      return;
    }

    final List<QueueRequest> activeRequests = snapshot.activeRequests;

    if (activeRequests.isEmpty) {
      _lastAutoAnnouncementKey = null;
      return;
    }

    final String announcementKey = activeRequests
        .map(
          (QueueRequest request) =>
              '${request.id}-${request.position}-${request.status.name}-${request.lastUpdated.microsecondsSinceEpoch}',
        )
        .join('|');

    if (_lastAutoAnnouncementKey == announcementKey) {
      return;
    }

    _lastAutoAnnouncementKey = announcementKey;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      if (activeRequests.length == 1) {
        await _announceQueuePosition(
          userName: snapshot.user.fullName,
          request: activeRequests.first,
        );
        return;
      }

      await _announceQueueSummary(
        userName: snapshot.user.fullName,
        requests: activeRequests,
      );
    });
  }

  Future<void> _announceQueueSummary({
    required String userName,
    required List<QueueRequest> requests,
  }) async {
    final AudioAnnouncementService audioService = ref.read(
      audioAnnouncementServiceProvider,
    );
    final accessibilityState = ref.read(accessibilityControllerProvider);

    final StringBuffer message = StringBuffer(
      'Olá, $userName. Você possui ${requests.length} solicitações em andamento. ',
    );

    for (final QueueRequest request in requests) {
      message.write(
        '${request.procedureName} em ${request.locationName}, '
        'posição ${request.position} na fila. ',
      );
    }

    await audioService.speakText(
      message.toString(),
      speechRate: accessibilityState.speechRate,
    );
  }

  Future<void> _announceQueuePosition({
    required String userName,
    required QueueRequest request,
  }) async {
    final AudioAnnouncementService audioService = ref.read(
      audioAnnouncementServiceProvider,
    );
    final accessibilityState = ref.read(accessibilityControllerProvider);

    await audioService.speakQueuePosition(
      userName: userName,
      procedure: request.procedureName,
      hospital: request.locationName,
      position: request.position,
      estimatedWait: request.waitEstimate.label,
      speechRate: accessibilityState.speechRate,
    );
  }

  Future<void> _onQueuePressed({
    required BuildContext context,
    required WidgetRef ref,
    required QueueRequest request,
  }) async {
    if (request.status == QueueStatus.awaitingValidation) {
      context.push('/status', extra: StatusScreenArgs.validationReceived());
      return;
    }

    final ProcedureConfirmationAction? action =
        await showModalBottomSheet<ProcedureConfirmationAction>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) => ProcedureConfirmationSheet(
            procedureLabel: request.fullProcedureLabel,
          ),
        );

    if (!context.mounted || action == null) {
      return;
    }

    if (action == ProcedureConfirmationAction.stillWaiting) {
      await ref
          .read(dashboardControllerProvider.notifier)
          .confirmStillWaiting(request.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Você continua na fila de ${request.procedureName}. Status mantido com sucesso.',
            ),
          ),
        );
      }
      return;
    }

    final bool? submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => ValidationSheet(requestId: request.id),
    );

    if (submitted == true && context.mounted) {
      context.push('/status', extra: StatusScreenArgs.validationReceived());
    }
  }
}
