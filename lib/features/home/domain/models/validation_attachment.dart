enum ValidationAttachmentType {
  photo,
  pdf,
}

class ValidationAttachment {
  const ValidationAttachment({
    required this.id,
    required this.type,
    required this.fileName,
    required this.path,
    required this.selectedAt,
  });

  final String id;
  final ValidationAttachmentType type;
  final String fileName;
  final String path;
  final DateTime selectedAt;

  bool get isPdf => type == ValidationAttachmentType.pdf;

  ValidationAttachment copyWith({
    String? id,
    ValidationAttachmentType? type,
    String? fileName,
    String? path,
    DateTime? selectedAt,
  }) {
    return ValidationAttachment(
      id: id ?? this.id,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      path: path ?? this.path,
      selectedAt: selectedAt ?? this.selectedAt,
    );
  }
}
