import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/core/widgets/empty_state_card.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/history_entry_card.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(dashboardControllerProvider).currentSnapshot;

    if (snapshot == null) {
      return const SafeArea(
        child: AppResponsiveBody(
          child: EmptyStateCard(
            icon: Icons.history_rounded,
            title: 'Sem histórico disponível',
            message:
                'Carregue a fila para visualizar movimentações anteriores.',
          ),
        ),
      );
    }

    return SafeArea(
      child: AppResponsiveBody(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionTitle(
              title: 'Histórico completo',
              subtitle: 'Acompanhe as mudanças registradas na sua solicitação.',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return HistoryEntryCard(entry: snapshot.history[index]);
                },
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemCount: snapshot.history.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
