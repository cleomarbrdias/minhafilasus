import 'package:minhafilasaude/features/auth/domain/models/app_user.dart';
import 'package:minhafilasaude/features/home/domain/models/dashboard_snapshot.dart';
import 'package:minhafilasaude/features/home/domain/models/validation_attachment.dart';

abstract class QueueRepository {
  Future<DashboardSnapshot> fetchDashboard({required AppUser user});

  Future<DashboardSnapshot> confirmStillWaiting({
    required AppUser user,
    required String requestId,
  });

  Future<DashboardSnapshot> submitProcedureAlreadyDone({
    required AppUser user,
    required String requestId,
    required List<ValidationAttachment> attachments,
  });
}
