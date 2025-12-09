import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AttachmentModel {
  final dynamic id;
  final File? file;
  final XFile? filePickerResult;

  AttachmentModel({this.id, this.file, this.filePickerResult});
}
