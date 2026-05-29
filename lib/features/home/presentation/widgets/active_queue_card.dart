import 'package:flutter/material.dart';

import 'package:minhafilasaude/app/theme/app_theme.dart';
import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_request.dart';

class ActiveQueueCard extends StatelessWidget {
  const ActiveQueueCard({
    super.key,
    required this.request,
    required this.onPressed,
    required this.onListenPressed,
  });

  final QueueRequest request;
  final VoidCallback onPressed;
  final VoidCallback onListenPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool waitingValidation =
        request.status == QueueStatus.awaitingValidation;

    final Color activeQueueColor = AppTheme.infoColorOf(context);
    final String semanticsLabel =
        'Fila ativa. Procedimento ${request.procedureName}, na unidade '
        '${request.locationName}. Sua posição atual é ${request.position} '
        'na fila. Espera estimada de ${request.waitEstimate.label}. '
        'Status atual: ${request.statusLabel}.';

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: activeQueueColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Fila ativa',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right_rounded, color: activeQueueColor),
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
                      color: scheme.primary,
                      height: 0.9,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'na fila',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: activeQueueColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Estimativa aproximada: ${request.waitEstimate.label}',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: scheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A posição pode mudar conforme critérios de prioridade clínica e regulação do atendimento.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: request.progress,
                  minHeight: 10,
                  backgroundColor: scheme.primary.withValues(alpha: 0.12),
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
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
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
                  OutlinedButton.icon(
                    onPressed: onListenPressed,
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Ouvir posição'),
                  ),
                ],
              ),
            ],
          ),
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
        ? AppTheme.warningColorOf(context)
        : AppTheme.infoColorOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
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
