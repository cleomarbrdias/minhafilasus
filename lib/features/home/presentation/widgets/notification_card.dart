import 'package:flutter/material.dart';

import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/features/home/domain/models/app_notification_item.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final AppNotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final _NotificationVisual visual = _resolveVisual(notification.importance);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: visual.color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(visual.icon, color: visual.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          notification.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0E5AA7),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(notification.description),
                  const SizedBox(height: 8),
                  Text(
                    notification.sentAt.toPtBrDateTime(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF627285),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _NotificationVisual _resolveVisual(NotificationImportance importance) {
    switch (importance) {
      case NotificationImportance.info:
        return const _NotificationVisual(
          icon: Icons.notifications_active_outlined,
          color: Color(0xFF2B6CB0),
        );
      case NotificationImportance.attention:
        return const _NotificationVisual(
          icon: Icons.priority_high_rounded,
          color: Color(0xFFD99025),
        );
      case NotificationImportance.success:
        return const _NotificationVisual(
          icon: Icons.verified_rounded,
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
