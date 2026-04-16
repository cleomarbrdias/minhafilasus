import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/core/widgets/empty_state_card.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_request.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:minhafilasaude/features/home/presentation/screens/status_screen.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/active_queue_card.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/dashboard_header.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/history_entry_card.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/procedure_confirmation_sheet.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/validation_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DashboardState state = ref.watch(dashboardControllerProvider);
    final DashboardController controller = ref.read(
      dashboardControllerProvider.notifier,
    );

    if (state.isLoading && state.currentSnapshot == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final snapshot = state.currentSnapshot;

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
                ActiveQueueCard(
                  request: snapshot.activeRequest,
                  onPressed: () => _onQueuePressed(
                    context: context,
                    ref: ref,
                    request: snapshot.activeRequest,
                  ),
                ),
                const SizedBox(height: 24),
                SectionTitle(title: 'Históricos', subtitle: state.errorMessage),
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
          .confirmStillWaiting();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você continua na fila. Status mantido com sucesso.'),
          ),
        );
      }
      return;
    }

    final bool? submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const ValidationSheet(),
    );

    if (submitted == true && context.mounted) {
      context.push('/status', extra: StatusScreenArgs.validationReceived());
    }
  }
}
