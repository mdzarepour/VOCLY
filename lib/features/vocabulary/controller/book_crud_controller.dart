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
  final BookRepository bookRepository;
  final DialogService dialogService;

  BookCrudController({
    required this.bookRepository,
    required this.dialogService,
  });

  late BookModel? _editingBook;
  late BookScreenType type;

  // ================ Form Key =================================================

  final formKey = GlobalKey<FormState>();

  // ================ Text Editing Controllers =================================

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // ================ Reactive Variables =======================================

  final RxMap<String, int> _properties = <String, int>{}.obs;
  Map<String, int> get properties => _properties;

  final RxList<int> _selectedWords = <int>[].obs;
  List<int> get selectedWords => _selectedWords;

  // ================ Ui Functions =============================================

  void updateProperty({required String key, required int value}) {
    _properties[key] = value;
  }

  // ================ Main Functions ===========================================

  Future<Either<AppError, AppSuccess>> _addBook() async {
    try {
      final book = BookModel.fromMap(map: _createMap());
      final isExist = _isBookExist(name: book.name);

      if (isExist) {
        final bool? permission = await dialogService.showDialog(
          title: AppStrings.dialogDuplicatedBookTitle,
          content: AppStrings.dialogDuplicatedBookContent,
          confirmTitle: AppStrings.dialogDuplicatedBookConfirm,
        );
        if (permission == null || !permission) {
          return left(const AppError(errorMessage: 'Permission Denied'));
        }
      }
      await bookRepository.addBook(book: book);
      return right(
        AppSuccess(successMessage: '${book.name.capitalizeFirst} Added'),
      );
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  bool _isBookExist({required final String name}) {
    try {
      return bookRepository.isBookExist(name: name);
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
      await bookRepository.updateBook(
        key: _editingBook!.key,
        book: updatedBook,
      );
      return right(AppSuccess(successMessage: '${_editingBook!.name} updated'));
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  void _initControllerEssentials() {
    type = Get.arguments['type'];
    if (type == BookScreenType.addBook) return;

    final int bookKey = Get.arguments['book_key'];
    final box = bookRepository.bookListenable.value;
    _editingBook = box.get(bookKey);

    if (_editingBook != null) {
      nameController.text = _editingBook!.name;
      descriptionController.text = _editingBook!.description;
      _selectedWords.value = _editingBook!.words;

      _properties[AppStrings.keyIcon] = _editingBook!.icon;
      _properties[AppStrings.keyType] = _editingBook!.type;
      _properties[AppStrings.keyColor] = _editingBook!.color;
      _properties[AppStrings.keyLevel] = _editingBook!.level;
    }
  }

  // ================ Helper Functions =========================================

  Map<String, dynamic> _createMap() {
    return {
      AppStrings.keyName: nameController.text,
      AppStrings.keyDescription: descriptionController.text,
      AppStrings.keyWords: _selectedWords,
      AppStrings.keyIcon: _properties[AppStrings.keyIcon] ?? 0,
      AppStrings.keyType: _properties[AppStrings.keyType] ?? 0,
      AppStrings.keyColor: _properties[AppStrings.keyColor] ?? 0,
      AppStrings.keyLevel: _properties[AppStrings.keyLevel] ?? 0,
    };
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
        'words': _selectedWords,
      },
    );
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    _initControllerEssentials();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    descriptionController.dispose();
  }
}
