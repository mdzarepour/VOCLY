import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/link_service.dart';
import 'package:vocly/core/services/platform_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class HomeController extends GetxController {
  late final LinkService _linkService;
  late final PlatformService _platformService;

  late final BackupRepository _backupRepository;
  late final BookRepository _bookRepository;
  late final WordRepository _wordRepository;

  // ================ Reactive Variables =======================================

  final Rx<ExportStatus> _exportLoading = ExportStatus.none.obs;
  ExportStatus get exportLoading => _exportLoading.value;

  final RxBool _importLoading = false.obs;
  bool get importLoading => _importLoading.value;

  final RxString _fileName = AppStrings.emptyChar.obs;
  String get fileName => _fileName.value;

  final RxString _wordsCount = '0'.obs;
  String get wordsCount => _wordsCount.value;

  final RxString _booksCount = '0'.obs;
  String get booksCount => _booksCount.value;

  // ================ Text Editing Controller ==================================

  final inputController = TextEditingController();

  // ================ Ui Functions =============================================

  void updateBooksCount() {
    _booksCount.value = _bookRepository.getBooksCount.toString();
  }

  void updateWordsCount() {
    _wordsCount.value = _wordRepository.getWordsCount.toString();
  }

  void _updateFileName({required String name}) {
    _fileName.value = name;
  }

  void clearBackupSession() {
    _fileName.value = AppStrings.emptyChar;
  }

  // ================ Url Luncher Function =====================================

  Future<void> openBookLibrary() async {
    try {
      await _linkService.openBookLibraryPage();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // ================ Export Functions =========================================

  Future<Either<AppError, AppSuccess>> exportToFile() async {
    try {
      _exportLoading.value = ExportStatus.file;
      final content = await _backupRepository.exportHiveContent();
      final Uint8List bytes = await Isolate.run(() {
        return utf8.encode(content);
      });
      final path = await _platformService.saveSelectFile(bytes: bytes);
      if (path == null) {
        return left(AppError(errorMessage: 'File Not Save!'));
      } else {
        return right(
          AppSuccess(successMessage: 'Backup Exported Successfully!'),
        );
      }
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    } finally {
      _exportLoading.value = ExportStatus.none;
    }
  }

  Future<Either<AppError, AppSuccess>> exportToClipboard() async {
    try {
      _exportLoading.value = ExportStatus.clipboard;
      final content = await _backupRepository.exportHiveContent();
      if (content.isEmpty) {
        return left(AppError(errorMessage: 'There Is Nothing To Export!'));
      } else {
        await _platformService.setContentToClipBoard(content: content);
        return right(AppSuccess(successMessage: 'Backup Copied To Clipboard!'));
      }
    } catch (error) {
      return left(AppError(errorMessage: 'Content Is Too Large For ClipBoard'));
    } finally {
      _exportLoading.value = ExportStatus.none;
    }
  }

  // ================ Import Functions =========================================

  Future<Either<AppError, AppSuccess>> _importFromFile() async {
    try {
      _importLoading.value = true;
      if (_selectedFileContent == null) {
        return left(AppError(errorMessage: 'Please Select File First'));
      } else {
        await _backupRepository.importHiveContent(
          content: _selectedFileContent!,
        );
        return right(AppSuccess(successMessage: 'Data Imported From File!'));
      }
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    } finally {
      _importLoading.value = false;
    }
  }

  Future<Either<AppError, AppSuccess>> _importFromClipBoard() async {
    try {
      final content = inputController.text.trim();
      await _backupRepository.importHiveContent(content: content);
      return right(AppSuccess(successMessage: 'Data Imported From Clipboard!'));
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    } finally {
      inputController.clear();
    }
  }

  // ================ Helpers ==================================================

  String? _selectedFileContent;
  Future<Either<AppError, AppSuccess>> selectFile() async {
    try {
      final selectedFile = await _platformService.selectFile();
      _updateFileName(name: selectedFile.fileName);
      _selectedFileContent = selectedFile.fileContent;
      return right(AppSuccess(successMessage: '$_fileName Selected'));
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    }
  }

  Future<Either<AppError, AppSuccess>> handleImport() async {
    if (inputController.text.isEmpty) {
      return await _importFromFile();
    } else {
      return _importFromClipBoard();
    }
  }

  // ================ Navigations ==============================================

  void goToManageBooksScreen() {
    Get.toNamed(Routes.manageBooksScreen);
  }

  void goToManageWordsScreen() {
    Get.toNamed(
      Routes.manageWordsScreen,
      arguments: [ManageWordsScreenType.manageWords, null],
    );
  }

  void goToAddEditBookScreen() {
    Get.toNamed(
      Routes.addEditBookScreen,
      arguments: [BookScreenType.addBook, null],
    );
  }

  void goToAddEditWordScreen() {
    Get.toNamed(
      Routes.addEditWordScreen,
      arguments: {'type': WordScreenType.addWord},
    );
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    _backupRepository = Get.find();
    _wordRepository = Get.find();
    _bookRepository = Get.find();
    _platformService = Get.find();
    _linkService = Get.find();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    inputController.dispose();
  }
}
