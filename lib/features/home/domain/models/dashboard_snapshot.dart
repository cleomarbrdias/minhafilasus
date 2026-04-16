import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';
import 'package:minhafilasaude/features/home/domain/models/app_notification_item.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_history_entry.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_request.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.user,
    required this.activeRequest,
    required this.history,
    required this.notifications,
  });

  final AppUser user;
  final QueueRequest activeRequest;
  final List<QueueHistoryEntry> history;
  final List<AppNotificationItem> notifications;

  DashboardSnapshot copyWith({
    AppUser? user,
    QueueRequest? activeRequest,
    List<QueueHistoryEntry>? history,
    List<AppNotificationItem>? notifications,
  }) {
    return DashboardSnapshot(
      user: user ?? this.user,
      activeRequest: activeRequest ?? this.activeRequest,
      history: history ?? this.history,
      notifications: notifications ?? this.notifications,
    );
  }
}
