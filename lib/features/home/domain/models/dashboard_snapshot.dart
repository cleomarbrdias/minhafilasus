import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';
import 'package:minhafilasaude/features/home/domain/models/app_notification_item.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_history_entry.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_request.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.user,
    required this.activeRequests,
    required this.history,
    required this.notifications,
  });

  final AppUser user;
  final List<QueueRequest> activeRequests;
  final List<QueueHistoryEntry> history;
  final List<AppNotificationItem> notifications;

  QueueRequest? get activeRequest =>
      activeRequests.isNotEmpty ? activeRequests.first : null;

  DashboardSnapshot copyWith({
    AppUser? user,
    List<QueueRequest>? activeRequests,
    List<QueueHistoryEntry>? history,
    List<AppNotificationItem>? notifications,
  }) {
    return DashboardSnapshot(
      user: user ?? this.user,
      activeRequests: activeRequests ?? this.activeRequests,
      history: history ?? this.history,
      notifications: notifications ?? this.notifications,
    );
  }
}
