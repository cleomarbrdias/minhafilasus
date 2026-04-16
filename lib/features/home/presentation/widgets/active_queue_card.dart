import 'package:flutter/material.dart';

import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_request.dart';

class ActiveQueueCard extends StatelessWidget {
  const ActiveQueueCard({
    super.key,
    required this.request,
    required this.onPressed,
  });

  final QueueRequest request;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool waitingValidation =
        request.status == QueueStatus.awaitingValidation;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Fila Ativa',
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              request.fullProcedureLabel,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 18),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 8,
              children: <Widget>[
                Text(
                  request.positionLabel,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: 56,
                    color: theme.colorScheme.primary,
                    height: 0.9,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'na Fila',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF56A15D),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Espera estimada:',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF1F2937),
              ),
            ),
            Text(
              '${request.waitEstimate.label} (Baseado no histórico)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF202A36),
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: request.progress,
                minHeight: 10,
                backgroundColor: const Color(0xFFE7EDF4),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 12,
              children: <Widget>[
                _StatusBadge(
                  label: request.statusLabel,
                  waitingValidation: waitingValidation,
                ),
                Text(
                  'Atualizado em ${request.lastUpdated.toPtBrDateTime()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF607285),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            waitingValidation
                ? FilledButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.verified_outlined),
                    label: const Text('Acompanhar validação'),
                  )
                : FilledButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.task_alt_rounded),
                    label: const Text('Atualizar andamento'),
                  ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.waitingValidation});

  final String label;
  final bool waitingValidation;

  @override
  Widget build(BuildContext context) {
    final Color color = waitingValidation
        ? const Color(0xFFE7A741)
        : const Color(0xFF4D9C5C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
