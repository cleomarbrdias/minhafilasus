import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/core/widgets/empty_state_card.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/notification_card.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(dashboardControllerProvider).currentSnapshot;

    if (snapshot == null) {
      return const SafeArea(
        child: AppResponsiveBody(
          child: EmptyStateCard(
            icon: Icons.notifications_none_rounded,
            title: 'Sem notificações',
            message: 'As comunicações da SES aparecerão aqui.',
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
              title: 'Notificações',
              subtitle:
                  'Mensagens sobre validação, atualização de fila e alertas.',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: snapshot.notifications.isEmpty
                  ? const EmptyStateCard(
                      icon: Icons.notifications_off_outlined,
                      title: 'Nenhuma notificação no momento',
                      message:
                          'Quando houver atualizações, elas aparecerão aqui.',
                    )
                  : ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return NotificationCard(
                          notification: snapshot.notifications[index],
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemCount: snapshot.notifications.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
