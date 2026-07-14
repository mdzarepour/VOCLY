import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class BookCrudController extends GetxController {
  late BookRepository _bookRepository;
  late DialogService _dialogService;

  late BookModel? _editingBook;
  late BookScreenType type;

  // ================ Form Key =================================================

  final formKey = GlobalKey<FormState>();

  // ================ Text Editing Controllers =================================

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // ================ Reactive Variables =======================================

  final Rxn<BookModel> _currentBook = Rxn<BookModel>();
  BookModel? get currentBook => _currentBook.value;

  final RxList<int> _selectedWords = <int>[].obs;
  List<int> get selectedWords => _selectedWords;

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

  void updateSelectedWords({required List<int> words}) {
    _selectedWords.value = words;
  }

  // ================ Crud Functions ===========================================

  Future<Either<AppError, AppSuccess>> _addBook() async {
    try {
      final book = BookModel.fromMap(map: _createMap());
      final isExist = _isBookExist(name: book.name);

      if (isExist) {
        final bool? permission = await _dialogService.showDialog(
          title: AppStrings.dialogDuplicatedBookTitle,
          content: AppStrings.dialogDuplicatedBookContent,
          confirmTitle: AppStrings.dialogDuplicatedBookConfirm,
        );
        if (permission == null || !permission) {
          return left(const AppError(errorMessage: 'Permission Denied'));
        }
      }
      await _bookRepository.addBook(book: book);
      return right(
        AppSuccess(successMessage: '${book.name.capitalizeFirst} Added'),
      );
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
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
      final updatedBook = _editingBook!.copyWith(
        name: map[AppStrings.keyName],
        description: map[AppStrings.keyDescription],
        words: map[AppStrings.keyWords],
        icon: map[AppStrings.keyIcon],
        type: map[AppStrings.keyType],
        color: map[AppStrings.keyColor],
        level: map[AppStrings.keyLevel],
      );
      await _bookRepository.updateBook(
        key: _editingBook!.key,
        book: updatedBook,
      );
      return right(AppSuccess(successMessage: '${_editingBook!.name} updated'));
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  // ================ Helper Functions =========================================

  Map<String, dynamic> _createMap() {
    return {
      AppStrings.keyName: nameController.text,
      AppStrings.keyDescription: descriptionController.text,
      AppStrings.keyIcon: _selectedIconIndex.value,
      AppStrings.keyType: _selectedTypeIndex.value,
      AppStrings.keyColor: _selectedColorIndex.value,
      AppStrings.keyLevel: _selectedLevelIndex.value,
      AppStrings.keyWords: _selectedWords,
    };
  }

  void _initControllerEssentials() {
    type = Get.arguments['type'];
    if (type == BookScreenType.addBook) return;

    final int bookKey = Get.arguments['book_key'];
    final box = _bookRepository.bookValueListenable.value;
    _editingBook = box.get(bookKey);

    if (_editingBook != null) {
      nameController.text = _editingBook!.name;
      descriptionController.text = _editingBook!.description;
      _selectedIconIndex.value = _editingBook!.icon;
      _selectedTypeIndex.value = _editingBook!.type;
      _selectedColorIndex.value = _editingBook!.color;
      _selectedLevelIndex.value = _editingBook!.level;
      _selectedWords.value = _editingBook!.words;
    }
  }

  Future<Either<AppError, AppSuccess>> handleAction() async {
    if (formKey.currentState!.validate()) {
      if (type == BookScreenType.addBook) {
        return await _addBook();
      } else {
        return await _updateBook();
      }
    }
    return left(const AppError(errorMessage: 'Please Fill Inputs First'));
  }

  // ================ Navigation ===============================================

  void goToBack() => Get.back();

  void goToWordManagerScreen() async {
    _selectedWords.value = await Get.toNamed(
      Routes.wordManagerScreen,
      arguments: {
        'type': WordManagerScreenType.addWordToBook,
        'words': selectedWords,
      },
    );
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    _bookRepository = Get.find();
    _dialogService = Get.find();
    _initControllerEssentials();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    descriptionController.dispose();
  }
}
