import 'package:minhafilasaude/features/home/domain/models/wait_estimate.dart';

enum QueueStatus { active, awaitingValidation, completed }

class QueueRequest {
  const QueueRequest({
    required this.id,
    required this.procedureName,
    required this.locationName,
    required this.position,
    required this.waitEstimate,
    required this.progress,
    required this.status,
    required this.lastUpdated,
  });

  final String id;
  final String procedureName;
  final String locationName;
  final int position;
  final WaitEstimate waitEstimate;
  final double progress;
  final QueueStatus status;
  final DateTime lastUpdated;

  String get fullProcedureLabel => '$procedureName - $locationName';

  String get positionLabel => '$positionº';

  String get statusLabel {
    switch (status) {
      case QueueStatus.active:
        return 'Fila ativa';
      case QueueStatus.awaitingValidation:
        return 'Em validação pela SES';
      case QueueStatus.completed:
        return 'Concluída';
    }
  }

  QueueRequest copyWith({
    String? id,
    String? procedureName,
    String? locationName,
    int? position,
    WaitEstimate? waitEstimate,
    double? progress,
    QueueStatus? status,
    DateTime? lastUpdated,
  }) {
    return QueueRequest(
      id: id ?? this.id,
      procedureName: procedureName ?? this.procedureName,
      locationName: locationName ?? this.locationName,
      position: position ?? this.position,
      waitEstimate: waitEstimate ?? this.waitEstimate,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
