import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:vocly/core/error/app_exception.dart';

class SelectedFile {
  String fileContent;
  String fileName;
  SelectedFile({required this.fileContent, required this.fileName});
}

class PlatformService {
  // ================ File Picker Functions ====================================

  Future<String?> saveSelectFile({required Uint8List? bytes}) async {
    return await FilePicker.saveFile(
      bytes: bytes,
      fileName: 'vocly_backup.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
  }

  Future<SelectedFile> selectFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowedExtensions: ['json'],
      type: FileType.custom,
    );
    if (result == null) throw AppError(errorMessage: 'File Not Selected');
    String fileContent;
    String fileName;

    final file = File(result.files.first.path!);
    fileContent = await file.readAsString();
    fileName = result.files.first.name;

    return SelectedFile(fileContent: fileContent, fileName: fileName);
  }

  // ================ ClipBoard Functions ======================================

  Future<void> setContentToClipBoard({required String content}) async {
    await Clipboard.setData(ClipboardData(text: content.toString().trim()));
  }
}
