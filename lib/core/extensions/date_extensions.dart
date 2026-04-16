import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toPtBrDate() {
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(this);
  }

  String toPtBrDateTime() {
    return DateFormat('dd/MM/yyyy • HH:mm', 'pt_BR').format(this);
  }

  String toShortLabel() {
    return DateFormat("dd 'de' MMM", 'pt_BR').format(this);
  }
}
