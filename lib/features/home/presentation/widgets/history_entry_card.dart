import 'package:flutter/material.dart';

import 'package:minhafilasaude/app/theme/app_theme.dart';
import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_history_entry.dart';

class HistoryEntryCard extends StatelessWidget {
  const HistoryEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onPlayPressed,
  });

  final QueueHistoryEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onPlayPressed;

  @override
  Widget build(BuildContext context) {
    final _HistoryVisual visual = _resolveVisual(context, entry.type);

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: visual.color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(visual.icon, color: visual.color),
        ),
        title: Text(
          entry.title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${entry.description}\n${entry.occurredAt.toShortLabel()}',
          ),
        ),
        trailing: IconButton(
          tooltip: 'Ouvir histórico',
          onPressed: onPlayPressed,
          icon: Icon(
            Icons.volume_up_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  _HistoryVisual _resolveVisual(
    BuildContext context,
    QueueHistoryEntryType type,
  ) {
    switch (type) {
      case QueueHistoryEntryType.progress:
        return _HistoryVisual(
          icon: Icons.favorite_rounded,
          color: AppTheme.infoColorOf(context),
        );
      case QueueHistoryEntryType.warning:
        return _HistoryVisual(
          icon: Icons.warning_amber_rounded,
          color: AppTheme.warningColorOf(context),
        );
      case QueueHistoryEntryType.success:
        return _HistoryVisual(
          icon: Icons.check_circle_outline_rounded,
          color: AppTheme.successColorOf(context),
        );
      case QueueHistoryEntryType.info:
        return _HistoryVisual(
          icon: Icons.schedule_rounded,
          color: AppTheme.neutralColorOf(context),
        );
    }
  }
}

class _HistoryVisual {
  const _HistoryVisual({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}
