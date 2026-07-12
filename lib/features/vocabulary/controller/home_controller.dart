import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/link_service.dart';
import 'package:vocly/core/services/platform_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class HomeController extends GetxController {
  late LinkService _linkService;
  late PlatformService _platformService;

  late WordRepository _wordRepository;
  late BookRepository _bookRepository;
  late BackupRepository _backupRepository;

  late ValueListenable<Box<WordModel>> _wordListenable;
  late ValueListenable<Box<BookModel>> _bookListenable;

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

  void _updateFileName({required String name}) {
    _fileName.value = name;
  }

  void clearBackupSession() {
    _fileName.value = AppStrings.emptyChar;
    _selectedFileContent = null;
  }

  void _initWordsCount() {
    final box = _wordListenable.value;
    _wordsCount.value = box.values.length.toString();
  }

  void _initBooksCount() {
    final box = _bookListenable.value;
    _booksCount.value = box.values.length.toString();
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
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
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
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
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
      }
      await _backupRepository.importHiveContent(content: _selectedFileContent!);
      return right(AppSuccess(successMessage: 'Data Imported From File!'));
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    } finally {
      _importLoading.value = false;
    }
  }

  Future<Either<AppError, AppSuccess>> _importFromClipBoard() async {
    try {
      final content = inputController.text.trim();
      await _backupRepository.importHiveContent(content: content);
      return right(AppSuccess(successMessage: 'Data Imported From Clipboard!'));
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
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
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  Future<Either<AppError, AppSuccess>> handleImport() async {
    if (inputController.text.isEmpty) {
      return await _importFromFile();
    } else {
      return await _importFromClipBoard();
    }
  }

  // ================ Navigations ==============================================

  void goToManageBooksScreen() {
    Get.toNamed(Routes.manageBooksScreen);
  }

  void goToManageWordsScreen() {
    Get.toNamed(
      Routes.manageWordsScreen,
      arguments: {'type': ManageWordsScreenType.manageWords},
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

  void goToBack() {
    Get.back();
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    _backupRepository = Get.find();
    _wordRepository = Get.find();
    _bookRepository = Get.find();

    _platformService = Get.find();
    _linkService = Get.find();

    _wordListenable = _wordRepository.wordValueListenable;
    _bookListenable = _bookRepository.bookValueListenable;

    _wordListenable.addListener(_initWordsCount);
    _bookListenable.addListener(_initBooksCount);

    _initWordsCount();
    _initBooksCount();

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    inputController.dispose();
    _wordListenable.removeListener(_initWordsCount);
    _bookListenable.removeListener(_initBooksCount);
  }
}
