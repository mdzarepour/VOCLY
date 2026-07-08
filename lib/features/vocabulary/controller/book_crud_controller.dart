import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class BookCrudController extends GetxController {
  late final BookRepository _bookRepository;
  late final DialogService _dialogService;
  late final BookScreenType bookScreenType;

  // ================ Form Key =================================================

  final formKey = GlobalKey<FormState>();

  // ================ Text Editing Controllers =================================

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // ================ Reactive Variables =======================================

  final Rxn<BookModel> _currentBook = Rxn<BookModel>();
  BookModel? get currentBook => _currentBook.value;

  final RxList<String> _selectedWords = <String>[].obs;
  List<String> get selectedWords => _selectedWords;

  final RxInt _selectedIconIndex = 0.obs;
  int get selectedIconIndex => _selectedIconIndex.value;

  final RxInt _selectedTypeIndex = 0.obs;
  int get selectedTypeIndex => _selectedTypeIndex.value;

  final RxInt _selectedColorIndex = 0.obs;
  int get selectedColorIndex => _selectedColorIndex.value;

  final RxInt _selectedLevelIndex = 0.obs;
  int get selectedLevelIndex => _selectedLevelIndex.value;

  // ================ Ui Functions ===========================================

  void updateSelectedIcon({required int value}) {
    _selectedIconIndex.value = value;
  }

  void updateSelectedType({required int value}) {
    _selectedTypeIndex.value = value;
  }

  void updateSelectedColor({required int value}) {
    _selectedColorIndex.value = value;
  }

  void updateSelectedLevel({required int value}) {
    _selectedLevelIndex.value = value;
  }

  void updateSelectedWords({required List<String> words}) {
    _selectedWords.value = words;
  }

  // ================ Crud Functions ===========================================

  Future<Either<AppError, AppSuccess>> _addBook() async {
    try {
      final map = _createMap();
      final BookModel book = BookModel.fromMap(map: map);
      final isWordExist = _isBookExist(name: book.name);

      if (!isWordExist) {
        await _bookRepository.addBook(book: book);
      }
      final bool? permission = await _dialogService.showDialog(
        title: AppStrings.dialogDuplicatedBookTitle,
        content: AppStrings.dialogDuplicatedBookContent,
        confirmTitle: AppStrings.dialogDuplicatedBookConfirm,
      );
      if (permission!) {
        await _bookRepository.addBook(book: book);
      } else {
        return left(AppError(errorMessage: 'Permision Denied'));
      }
      return right(AppSuccess(successMessage: '${book.name} added'));
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    }
  }

  bool _isBookExist({required final String name}) {
    try {
      return _bookRepository.isBookExist(name: name);
    } catch (error) {
      return false;
    }
  }

  Future<Either<AppError, AppSuccess>> _updateBook() async {
    try {
      final Map<String, dynamic> map = _createMap();
      _currentBook.value!.updateBook(map: map);
      await _bookRepository.updateBook(book: _currentBook.value!);
      return right(
        AppSuccess(successMessage: '${_currentBook.value!.name} updated'),
      );
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    }
  }

  List<WordModel> getBookWords(BookModel book) {
    try {
      final List<WordModel> bookWords = _bookRepository.getBookWords(
        book: book,
      );
      return bookWords;
    } catch (error) {
      //   Get.snackbar('Oops!', _errorMessage(error));
      return [];
    }
  }

  // ================ Helper Functions =========================================

  Map<String, dynamic> _createMap() {
    Map<String, dynamic> map = {};
    if (formKey.currentState!.validate()) {
      map = {
        AppStrings.keyName: nameController.text,
        AppStrings.keyIcon: _selectedIconIndex,
        AppStrings.keyType: _selectedTypeIndex,
        AppStrings.keyColor: _selectedColorIndex,
        AppStrings.keyLevel: _selectedLevelIndex,
        AppStrings.keyWords: _selectedWords,
      };
    }
    return map;
  }

  Future<Either<AppError, AppSuccess>> handleAction() async {
    if (bookScreenType == BookScreenType.addBook) {
      return await _addBook();
    } else {
      return await _updateBook();
    }
  }

  // ================ Navigation ===============================================

  void goToBack() => Get.back();

  void goToMnageWordsScreen() => Get.toNamed(Routes.manageWordsScreen);

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    bookScreenType = Get.arguments;
    _bookRepository = Get.find();
    _dialogService = Get.find();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    descriptionController.dispose();
  }
}
