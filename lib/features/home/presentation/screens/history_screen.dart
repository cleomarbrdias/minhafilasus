import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/core/providers/audio_announcement_provider.dart';
import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/core/widgets/empty_state_card.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_history_entry.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/dashboard_header.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/history_entry_card.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DashboardState state = ref.watch(dashboardControllerProvider);
    final snapshot = state.currentSnapshot;

    if (state.isLoading && snapshot == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot == null) {
      return const Center(
        child: AppResponsiveBody(
          child: EmptyStateCard(
            icon: Icons.history_rounded,
            title: 'Nenhum histórico disponível',
            message: 'Não foi possível carregar o histórico no momento.',
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardControllerProvider.notifier).load(),
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
                  title: 'Histórico completo',
                  subtitle: state.errorMessage,
                ),
                const SizedBox(height: 14),
                if (snapshot.history.isEmpty)
                  const EmptyStateCard(
                    icon: Icons.history_toggle_off_rounded,
                    title: 'Sem registros no histórico',
                    message:
                        'Ainda não existem movimentações registradas para exibição.',
                  )
                else
                  ...snapshot.history.map(
                    (QueueHistoryEntry entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HistoryEntryCard(
                        entry: entry,
                        onPlayPressed: () => _announceHistoryEntry(ref, entry),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _announceHistoryEntry(
    WidgetRef ref,
    QueueHistoryEntry entry,
  ) async {
    final audioService = ref.read(audioAnnouncementServiceProvider);
    final accessibilityState = ref.read(accessibilityControllerProvider);

    await audioService.speakHistoryEntry(
      title: entry.title,
      description: entry.description,
      dateLabel: entry.occurredAt.toShortLabel(),
      speechRate: accessibilityState.speechRate,
    );
  }
}
