import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minhafilasaude/core/providers/audio_announcement_provider.dart';
import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';
import 'package:minhafilasaude/core/widgets/empty_state_card.dart';
import 'package:minhafilasaude/features/home/domain/models/app_notification_item.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/accessibility_controller.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/dashboard_header.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/notification_card.dart';
import 'package:minhafilasaude/features/home/presentation/widgets/section_title.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

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
            icon: Icons.notifications_off_rounded,
            title: 'Nenhuma notificação disponível',
            message: 'Não foi possível carregar as notificações no momento.',
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
                  title: 'Notificações',
                  subtitle: state.errorMessage,
                ),
                const SizedBox(height: 14),
                if (snapshot.notifications.isEmpty)
                  const EmptyStateCard(
                    icon: Icons.notifications_off_rounded,
                    title: 'Sem notificações',
                    message:
                        'Ainda não existem avisos registrados para exibição.',
                  )
                else
                  ...snapshot.notifications.map(
                    (AppNotificationItem item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NotificationCard(
                        notification: item,
                        onPlayPressed: () => _announceNotification(ref, item),
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

  Future<void> _announceNotification(
    WidgetRef ref,
    AppNotificationItem item,
  ) async {
    final audioService = ref.read(audioAnnouncementServiceProvider);
    final accessibilityState = ref.read(accessibilityControllerProvider);

    await audioService.speakNotification(
      title: item.title,
      description: item.description,
      speechRate: accessibilityState.speechRate,
    );
  }
}
