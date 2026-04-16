import 'package:flutter/material.dart';

enum ProcedureConfirmationAction {
  alreadyDone,
  stillWaiting,
}

class ProcedureConfirmationSheet extends StatelessWidget {
  const ProcedureConfirmationSheet({
    super.key,
    required this.procedureLabel,
  });

  final String procedureLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
            Text(
              'Confirmar Procedimento',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Você já realizou este procedimento por outro canal?\n$procedureLabel',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF202A36),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(
                  ProcedureConfirmationAction.alreadyDone,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF3E9B52),
              ),
              child: const Text('Sim, já realizei'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(
                  ProcedureConfirmationAction.stillWaiting,
                );
              },
              child: const Text('Não, continuo na fila'),
            ),
          ],
        ),
      ),
    );
  }
}
