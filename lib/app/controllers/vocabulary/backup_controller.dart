import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:vocly/app/common/constants/const_strings.dart';
import 'package:vocly/app/models/repositories/vocabulary_repository.dart';

//TODO get filepciker from constructor
class BackupController extends GetxController {
  final BackupRepository backupRepository;

  BackupController({required this.backupRepository});

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _fileName = AppStrings.emptyChar.obs;
  String get fileName => _fileName.value;

  void _updateFileName({required String name}) {
    _fileName.value = name;
  }

  void _updateLoadingState({required bool value}) {
    _isLoading.value = value;
  }

  Future<void> exportToFile() async {
    try {
      _updateLoadingState(value: true);
      final content = await backupRepository.exportHiveContent();
      final Uint8List bytes = utf8.encode(content);

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
      Get.snackbar('Oops!', error.toString());
    } finally {
      _updateLoadingState(value: false);
    }
  }

  Future<void> exportToClipboard() async {
    try {
      final content = await backupRepository.exportHiveContent();
      if (content.isEmpty) return;
      await Clipboard.setData(ClipboardData(text: content.toString().trim()));
      Get.back();
      Get.snackbar('Success', 'Backup copied to clipboard!');
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
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
      Get.snackbar('Oops!', error.toString());
    }
  }

  Future<void> importFromFile() async {
    try {
      _updateLoadingState(value: true);
      if (_filePickerResult == null) {
        Get.snackbar('Oops!', 'Please select file first');
        return;
      }

      final file = File(_filePickerResult!.files.single.path!);
      final String rawContent = await file.readAsString();
      final List<dynamic> decodedContent = jsonDecode(rawContent);

      await backupRepository.importHiveContent(
        content: decodedContent.cast<Map<String, dynamic>>(),
      );

      Get.back();
      Get.snackbar('Success', 'Data imported from file!');
    } catch (error) {
      Get.snackbar('Oops!', 'Failed to import data: ${error.toString()}');
    } finally {
      _updateLoadingState(value: false);
    }
  }

  Future<void> importFromClipBoard({required String content}) async {
    try {
      _updateLoadingState(value: true);
      final List<dynamic> decodedContent = jsonDecode(content);
      
      await backupRepository.importHiveContent(
        content: decodedContent.cast<Map<String, dynamic>>(),
      );
      Get.back();
      Get.snackbar('Success', 'Data imported from clipboard!');
    } catch (error) {
      Get.snackbar(
        'Oops!',
        'Failed to import data please double check the input',
      );
    } finally {
      _updateLoadingState(value: false);
    }
  }

  void clearBackupSession() {
    _fileName.value = AppStrings.emptyChar;
  }
}
