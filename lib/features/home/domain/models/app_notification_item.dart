enum NotificationImportance {
  info,
  attention,
  success,
}

class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.sentAt,
    required this.importance,
    required this.isRead,
  });

  final String id;
  final String title;
  final String description;
  final DateTime sentAt;
  final NotificationImportance importance;
  final bool isRead;

  AppNotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? sentAt,
    NotificationImportance? importance,
    bool? isRead,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      sentAt: sentAt ?? this.sentAt,
      importance: importance ?? this.importance,
      isRead: isRead ?? this.isRead,
    );
  }
}
