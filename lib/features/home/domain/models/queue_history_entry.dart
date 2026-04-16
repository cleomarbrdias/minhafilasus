enum QueueHistoryEntryType {
  progress,
  warning,
  success,
  info,
}

class QueueHistoryEntry {
  const QueueHistoryEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.occurredAt,
  });

  final String id;
  final String title;
  final String description;
  final QueueHistoryEntryType type;
  final DateTime occurredAt;
}
