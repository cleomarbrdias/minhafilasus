class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.cpfMasked,
    required this.accessLevel,
  });

  final String id;
  final String fullName;
  final String cpfMasked;
  final String accessLevel;

  String get firstName => fullName.split(' ').first;

  String get initials {
    final List<String> parts = fullName
        .split(' ')
        .where((String part) => part.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  AppUser copyWith({
    String? id,
    String? fullName,
    String? cpfMasked,
    String? accessLevel,
  }) {
    return AppUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      cpfMasked: cpfMasked ?? this.cpfMasked,
      accessLevel: accessLevel ?? this.accessLevel,
    );
  }
}
