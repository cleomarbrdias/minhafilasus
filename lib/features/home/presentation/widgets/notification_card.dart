import 'package:flutter/material.dart';

import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/features/home/domain/models/app_notification_item.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onPlayPressed,
  });

  final AppNotificationItem notification;
  final VoidCallback? onTap;
  final VoidCallback? onPlayPressed;

  @override
  Widget build(BuildContext context) {
    final _NotificationVisual visual = _resolveVisual(notification.importance);

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: visual.color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(visual.icon, color: visual.color),
        ),
        title: Text(
          notification.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${notification.description}\n${notification.sentAt.toShortLabel()}',
          ),
        ),
        trailing: Container(
          child: IconButton(
            tooltip: 'Ouvir notificação',
            onPressed: onPlayPressed,
            icon: Icon(
              Icons.volume_up_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  _NotificationVisual _resolveVisual(NotificationImportance importance) {
    switch (importance) {
      case NotificationImportance.info:
        return const _NotificationVisual(
          icon: Icons.notifications_none_rounded,
          color: Color(0xFF2B6CB0),
        );
      case NotificationImportance.attention:
        return const _NotificationVisual(
          icon: Icons.notification_important_rounded,
          color: Color(0xFFD99025),
        );
      case NotificationImportance.success:
        return const _NotificationVisual(
          icon: Icons.check_circle_outline_rounded,
          color: Color(0xFF3E9B52),
        );
    }
  }
}

class _NotificationVisual {
  const _NotificationVisual({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}
