class WaitEstimate {
  const WaitEstimate({
    required this.minMonths,
    required this.maxMonths,
    this.additionalDays = 0,
  });

  final int minMonths;
  final int maxMonths;
  final int additionalDays;

  String get label {
    if (additionalDays > 0 && minMonths == maxMonths) {
      return '${_monthLabel(minMonths)} e ${_dayLabel(additionalDays)}';
    }

    if (minMonths == maxMonths) {
      return _monthLabel(minMonths);
    }

    return '${_monthLabel(minMonths)} a ${_monthLabel(maxMonths)}';
  }

  String _monthLabel(int value) => '$value mês${value > 1 ? 'es' : ''}';

  String _dayLabel(int value) => '$value dia${value > 1 ? 's' : ''}';
}
