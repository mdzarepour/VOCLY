import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/error/app_exeption.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class BackupController extends GetxController {
  final BackupRepository backupRepository;

  BackupController({required this.backupRepository , 
  
  });

  final Rx<ExportStatus> _exportLoading = ExportStatus.none.obs;
  ExportStatus get exportLoading => _exportLoading.value;

  final RxBool _importLoading = false.obs;
  bool get importLoading => _importLoading.value;

  final RxString _fileName = AppStrings.emptyChar.obs;
  String get fileName => _fileName.value;

  void _updateFileName({required String name}) {
    _fileName.value = name;
  }

  String _errorMessage(Object? error) {
    if (error is AppExeption) {
      return error.message;
    }
    return error.toString();
  }

  Future<void> exportToFile() async {
    try {
      _exportLoading.value = ExportStatus.file;
      final content = await backupRepository.exportHiveContent();
      final Uint8List bytes = await Isolate.run(() {
        return utf8.encode(content);
      });
      final path = await FilePicker.saveFile(
        bytes: bytes,
        fileName: 'vocly_backup.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (path == null) return;
      Get.back();
      Get.snackbar('Success', 'Backup exported successfully!');
    } catch (error) {
      Get.snackbar('Oops!', _errorMessage(error));
    } finally {
      _exportLoading.value = ExportStatus.none;
    }
  }

  Future<void> exportToClipboard() async {
    try {
      _exportLoading.value = ExportStatus.clipboard;
      final content = await backupRepository.exportHiveContent();
      if (content.isEmpty) return;
      await Clipboard.setData(ClipboardData(text: content.toString().trim()));
      Get.back();
      Get.snackbar('Success', 'Backup copied to clipboard!');
    } catch (error) {
      final message = _errorMessage(error);
      if (message.contains('TooLarge')) {
        Get.snackbar('Oops!', 'too large for clipboard, try to export as file');
      } else {
        Get.snackbar('Oops!', message);
      }
    } finally {
      _exportLoading.value = ExportStatus.none;
    }
  }

  FilePickerResult? _filePickerResult;
  Future<void> selectFile() async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        allowedExtensions: ['json'],
        type: FileType.custom,
      );
      if (result == null) return;
      _filePickerResult = result;
      _updateFileName(name: _filePickerResult!.files.first.name);
    } catch (error) {
      Get.snackbar('Oops!', _errorMessage(error));
    }
  }

  Future<void> importFromFile() async {
    try {
      _importLoading.value = true;
      if (_filePickerResult == null) {
        Get.snackbar('Oops!', 'Please select file first');
        return;
      }
      final file = File(_filePickerResult!.files.single.path!);
      final String rawContent = await file.readAsString();
      await backupRepository.importHiveContent(content: rawContent);
      Get.back();
      Get.snackbar('Success', 'Data imported from file!');
    } catch (error) {
      Get.snackbar('Oops!', 'Failed: ${_errorMessage(error)}');
    } finally {
      _importLoading.value = false;
    }
  }

  Future<void> importFromClipBoard({required String content}) async {
    try {
      await backupRepository.importHiveContent(content: content);
      Get.back();
      Get.snackbar('Success', 'Data imported from clipboard!');
    } catch (error) {
      Get.snackbar('Oops!', _errorMessage(error));
    }
  }

  void clearBackupSession() {
    _fileName.value = AppStrings.emptyChar;
  }
}
