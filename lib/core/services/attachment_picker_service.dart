import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:minhafilasaude/features/home/domain/models/validation_attachment.dart';

class AttachmentPickerService {
  AttachmentPickerService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  Future<ValidationAttachment?> captureMedicalReportPhoto() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 86,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (file == null) {
      return null;
    }

    return ValidationAttachment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: ValidationAttachmentType.photo,
      fileName: file.name,
      path: file.path,
      selectedAt: DateTime.now(),
    );
  }

  Future<ValidationAttachment?> pickPdf() async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const <String>['pdf'],
      allowMultiple: false,
      withData: false,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final PlatformFile file = result.files.single;

    return ValidationAttachment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: ValidationAttachmentType.pdf,
      fileName: file.name,
      path: file.path ?? file.name,
      selectedAt: DateTime.now(),
    );
  }
}
