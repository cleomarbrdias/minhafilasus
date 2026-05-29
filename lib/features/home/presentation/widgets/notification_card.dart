import 'package:flutter/material.dart';

import 'package:minhafilasaude/app/theme/app_theme.dart';
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
    final _NotificationVisual visual = _resolveVisual(
      context,
      notification.importance,
    );
    final ThemeData theme = Theme.of(context);

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
          style: theme.textTheme.titleSmall?.copyWith(
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
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            tooltip: 'Ouvir notificação',
            onPressed: onPlayPressed,
            icon: Icon(
              Icons.volume_up_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  _NotificationVisual _resolveVisual(
    BuildContext context,
    NotificationImportance importance,
  ) {
    switch (importance) {
      case NotificationImportance.info:
        return _NotificationVisual(
          icon: Icons.notifications_none_rounded,
          color: AppTheme.infoColorOf(context),
        );
      case NotificationImportance.attention:
        return _NotificationVisual(
          icon: Icons.notification_important_rounded,
          color: AppTheme.warningColorOf(context),
        );
      case NotificationImportance.success:
        return _NotificationVisual(
          icon: Icons.check_circle_outline_rounded,
          color: AppTheme.successColorOf(context),
        );
    }
  }
}

class _NotificationVisual {
  const _NotificationVisual({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;
}
