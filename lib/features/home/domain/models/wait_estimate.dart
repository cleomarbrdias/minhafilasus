class WaitEstimate {
  const WaitEstimate({
    required this.minMonths,
    required this.maxMonths,
  });

  final int minMonths;
  final int maxMonths;

  String get label {
    if (minMonths == maxMonths) {
      return '$minMonths mês${minMonths > 1 ? 'es' : ''}';
    }

    return '$minMonths a $maxMonths meses';
  }
}
