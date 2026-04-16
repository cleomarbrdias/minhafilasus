import 'package:flutter/material.dart';

import 'package:minhafilasaude/core/extensions/date_extensions.dart';
import 'package:minhafilasaude/features/home/domain/models/queue_history_entry.dart';

class HistoryEntryCard extends StatelessWidget {
  const HistoryEntryCard({super.key, required this.entry});

  final QueueHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final _HistoryVisual visual = _resolveVisual(entry.type);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: visual.color.withOpacity(0.14),
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
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  _HistoryVisual _resolveVisual(QueueHistoryEntryType type) {
    switch (type) {
      case QueueHistoryEntryType.progress:
        return const _HistoryVisual(
          icon: Icons.favorite_rounded,
          color: Color(0xFF2B6CB0),
        );
      case QueueHistoryEntryType.warning:
        return const _HistoryVisual(
          icon: Icons.warning_amber_rounded,
          color: Color(0xFFD99025),
        );
      case QueueHistoryEntryType.success:
        return const _HistoryVisual(
          icon: Icons.check_circle_outline_rounded,
          color: Color(0xFF3E9B52),
        );
      case QueueHistoryEntryType.info:
        return const _HistoryVisual(
          icon: Icons.schedule_rounded,
          color: Color(0xFF6B7E90),
        );
    }
  }
}

class _HistoryVisual {
  const _HistoryVisual({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}
