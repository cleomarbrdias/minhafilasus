import 'dart:async';

import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';
import 'package:minhafilasaude/features/home/domain/models/app_notification_item.dart';
import 'package:minhafilasaude/features/home/domain/models/dashboard_snapshot.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_history_entry.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_request.dart';
import 'package:minhafilasaude/features/home/domain/models/validation_attachment.dart';
import 'package:minhafilasaude/features/home/domain/models/wait_estimate.dart';
import 'package:minhafilasaude/features/home/domain/repositories/queue_repository.dart';

class MockQueueRepository implements QueueRepository {
  DashboardSnapshot? _snapshot;

  @override
  Future<DashboardSnapshot> fetchDashboard({required AppUser user}) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    _snapshot ??= _buildInitialSnapshot(user);

    return _snapshot!;
  }

  @override
  Future<DashboardSnapshot> confirmStillWaiting({
    required AppUser user,
    required String requestId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));

    final DashboardSnapshot current = _snapshot ?? _buildInitialSnapshot(user);

    final QueueHistoryEntry entry = QueueHistoryEntry(
      id: 'history-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Você confirmou permanência na fila',
      description:
          'A solicitação continua ativa para ${current.activeRequest.fullProcedureLabel}.',
      type: QueueHistoryEntryType.info,
      occurredAt: DateTime.now(),
    );

    final AppNotificationItem notification = AppNotificationItem(
      id: 'notification-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Fila mantida',
      description:
          'Sua posição continua registrada para atendimento pela rede.',
      sentAt: DateTime.now(),
      importance: NotificationImportance.info,
      isRead: false,
    );

    _snapshot = current.copyWith(
      activeRequest: current.activeRequest.copyWith(
        status: QueueStatus.active,
        lastUpdated: DateTime.now(),
      ),
      history: <QueueHistoryEntry>[entry, ...current.history],
      notifications: <AppNotificationItem>[
        notification,
        ...current.notifications,
      ],
    );

    return _snapshot!;
  }

  @override
  Future<DashboardSnapshot> submitProcedureAlreadyDone({
    required AppUser user,
    required String requestId,
    required List<ValidationAttachment> attachments,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1300));

    final DashboardSnapshot current = _snapshot ?? _buildInitialSnapshot(user);

    final QueueHistoryEntry entry = QueueHistoryEntry(
      id: 'history-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Informação enviada para validação',
      description:
          '${attachments.length} anexo(s) recebido(s) para análise da SES.',
      type: QueueHistoryEntryType.success,
      occurredAt: DateTime.now(),
    );

    final AppNotificationItem notification = AppNotificationItem(
      id: 'notification-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Validação iniciada',
      description: 'Seu comprovante foi enviado e será verificado pela SES.',
      sentAt: DateTime.now(),
      importance: NotificationImportance.success,
      isRead: false,
    );

    _snapshot = current.copyWith(
      activeRequest: current.activeRequest.copyWith(
        status: QueueStatus.awaitingValidation,
        progress: 0.92,
        lastUpdated: DateTime.now(),
      ),
      history: <QueueHistoryEntry>[entry, ...current.history],
      notifications: <AppNotificationItem>[
        notification,
        ...current.notifications,
      ],
    );

    return _snapshot!;
  }

  DashboardSnapshot _buildInitialSnapshot(AppUser user) {
    return DashboardSnapshot(
      user: user,
      activeRequest: QueueRequest(
        id: 'REQ-2026-0001',
        procedureName: 'Consulta em Cardiologia',
        locationName: 'Hospital Regional',
        position: 54,
        waitEstimate: const WaitEstimate(minMonths: 2, maxMonths: 3),
        progress: 0.74,
        status: QueueStatus.active,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      history: <QueueHistoryEntry>[
        QueueHistoryEntry(
          id: 'history-001',
          title: '54º no mês anterior',
          description: 'Consulta em Cardiologia - Hospital Regional',
          type: QueueHistoryEntryType.progress,
          occurredAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        QueueHistoryEntry(
          id: 'history-002',
          title: 'Atualização de estimativa',
          description: 'Previsão ajustada para 2 a 3 meses.',
          type: QueueHistoryEntryType.warning,
          occurredAt: DateTime.now().subtract(const Duration(days: 14)),
        ),
        QueueHistoryEntry(
          id: 'history-003',
          title: 'Solicitação registrada',
          description: 'Pedido encaminhado para fila regulada da SES.',
          type: QueueHistoryEntryType.info,
          occurredAt: DateTime.now().subtract(const Duration(days: 55)),
        ),
      ],
      notifications: <AppNotificationItem>[
        AppNotificationItem(
          id: 'notification-001',
          title: 'Fila atualizada',
          description:
              'Sua posição foi recalculada com base no histórico recente.',
          sentAt: DateTime.now().subtract(const Duration(hours: 5)),
          importance: NotificationImportance.info,
          isRead: false,
        ),
        AppNotificationItem(
          id: 'notification-002',
          title: 'Confirme se já realizou o procedimento',
          description:
              'Se já foi atendida por outro canal, você pode liberar a vaga.',
          sentAt: DateTime.now().subtract(const Duration(days: 1)),
          importance: NotificationImportance.attention,
          isRead: false,
        ),
      ],
    );
  }
}
