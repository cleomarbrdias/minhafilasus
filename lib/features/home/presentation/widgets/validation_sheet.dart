import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/core/services/attachment_picker_service.dart';
import 'package:minhafilasaude/features/home/domain/models/validation_attachment.dart';
import 'package:minhafilasaude/features/home/presentation/controllers/dashboard_controller.dart';

class ValidationSheet extends ConsumerWidget {
  const ValidationSheet({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DashboardState state = ref.watch(dashboardControllerProvider);
    final DashboardController controller = ref.read(
      dashboardControllerProvider.notifier,
    );
    final ThemeData theme = Theme.of(context);
    final AttachmentPickerService picker = ref.read(
      attachmentPickerServiceProvider,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 52,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD7DEE8),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),
            Text('Validação', style: theme.textTheme.titleLarge),
            const SizedBox(height: 14),
            _ValidationActionButton(
              icon: Icons.camera_alt_rounded,
              label: 'Tirar Foto do Laudo',
              onTap: state.isSubmitting
                  ? null
                  : () async {
                      final ValidationAttachment? attachment = await picker
                          .captureMedicalReportPhoto();

                      if (attachment != null) {
                        controller.addAttachment(attachment);
                      }
                    },
            ),
            const SizedBox(height: 10),
            _ValidationActionButton(
              icon: Icons.attach_file_rounded,
              label: 'Anexar PDF',
              onTap: state.isSubmitting
                  ? null
                  : () async {
                      final ValidationAttachment? attachment = await picker
                          .pickPdf();

                      if (attachment != null) {
                        controller.addAttachment(attachment);
                      }
                    },
            ),
            const SizedBox(height: 16),
            if (state.draftAttachments.isNotEmpty)
              Column(
                children: state.draftAttachments
                    .map<Widget>(
                      (ValidationAttachment attachment) =>
                          _SelectedAttachmentTile(
                            attachment: attachment,
                            onRemove: state.isSubmitting
                                ? null
                                : () => controller.removeAttachment(
                                    attachment.id,
                                  ),
                          ),
                    )
                    .toList(),
              ),
            if (state.draftAttachments.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Adicione um comprovante para que a SES possa validar a baixa da fila.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Sua informação será verificada pela SES para liberar a vaga para o próximo da fila. Obrigado por ajudar!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF202A36),
              ),
              textAlign: TextAlign.center,
            ),
            if (state.errorMessage != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: state.isSubmitting
                  ? null
                  : () async {
                      final bool success = await controller
                          .submitProcedureAlreadyDone(requestId);

                      if (success && context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
              icon: state.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : const Icon(Icons.cloud_upload_rounded),
              label: Text(
                state.isSubmitting
                    ? 'Enviando para SES...'
                    : 'Enviar para validação',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValidationActionButton extends StatelessWidget {
  const _ValidationActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleSmall),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedAttachmentTile extends StatelessWidget {
  const _SelectedAttachmentTile({
    required this.attachment,
    required this.onRemove,
  });

  final ValidationAttachment attachment;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E7F0)),
      ),
      child: ListTile(
        leading: Icon(
          attachment.isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
          color: attachment.isPdf
              ? const Color(0xFFD44A3A)
              : Theme.of(context).colorScheme.primary,
        ),
        title: Text(attachment.fileName, overflow: TextOverflow.ellipsis),
        subtitle: Text(attachment.selectedAt.toPtBrDateTime()),
        trailing: IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.close_rounded),
        ),
      ),
    );
  }
}
