import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:minhafilasaude/core/widgets/app_responsive_body.dart';

class StatusScreenArgs {
  const StatusScreenArgs({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.icon,
    required this.color,
  });

  factory StatusScreenArgs.validationReceived() {
    return const StatusScreenArgs(
      title: 'Informação Recebida',
      message:
          'Sua solicitação está sendo validada pelo sistema da SES. '
          'Você receberá uma notificação quando o processo for concluído.',
      buttonLabel: 'Voltar para o Início',
      icon: Icons.check_circle_outline_rounded,
      color: Color(0xFF3E9B52),
    );
  }

  final String title;
  final String message;
  final String buttonLabel;
  final IconData icon;
  final Color color;
}

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key, required this.args});

  final StatusScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: AppResponsiveBody(
          maxWidth: 520,
          child: Center(
            child: Column(
              children: <Widget>[
                const Spacer(flex: 2),
                Icon(args.icon, size: 110, color: args.color),
                const SizedBox(height: 18),
                Text(
                  args.title,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text(
                  args.message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF202A36),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                OutlinedButton(
                  onPressed: () => context.go('/app'),
                  child: Text(args.buttonLabel),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
