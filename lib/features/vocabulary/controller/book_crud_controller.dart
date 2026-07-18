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
  final BookScreenType type;
  final int? bookKey;

  BookCrudController({
    this.bookKey,
    required this.type,
    required this.bookRepository,
    required this.dialogService,
  });

  BookModel? editingBook;

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

  // ================ Setter Functions =============================================

  void updateProperty({required String key, required int value}) {
    _properties[key] = value;
  }

  void updateSelectedWords({required List<int> words}) {
    _selectedWords.value = words;
  }

  // ================ Main Functions ===========================================

  Future<Either<AppError, AppSuccess>> addBook() async {
    try {
      final book = BookModel.fromMap(map: _createMap());
      await bookRepository.addBook(book: book);
      return right(
        AppSuccess(successMessage: '${book.name.capitalizeFirst} added'),
      );
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  Future<Either<AppError, AppSuccess>> updateBook() async {
    try {
      final Map<String, dynamic> map = _createMap();
      final updatedBook = editingBook!.copyWith(
        name: map[AppStrings.keyName],
        description: map[AppStrings.keyDescription],
        words: map[AppStrings.keyWords],
        icon: map[AppStrings.keyIcon],
        type: map[AppStrings.keyType],
        color: map[AppStrings.keyColor],
        level: map[AppStrings.keyLevel],
      );
      await bookRepository.updateBook(key: editingBook!.key, book: updatedBook);
      return right(AppSuccess(successMessage: '${editingBook!.name} updated'));
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  void _initControllerEssentials() {
    if (type == BookScreenType.addBook) return;

    final int key = bookKey!;
    final box = bookRepository.bookListenable.value;
    editingBook = box.get(key);

    if (editingBook != null) {
      nameController.text = editingBook!.name;
      descriptionController.text = editingBook!.description;
      _selectedWords.value = editingBook!.words;

      _properties[AppStrings.keyIcon] = editingBook!.icon;
      _properties[AppStrings.keyType] = editingBook!.type;
      _properties[AppStrings.keyColor] = editingBook!.color;
      _properties[AppStrings.keyLevel] = editingBook!.level;
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

  // ================ Navigation ===============================================

  void goToBack() => Get.back();

  void goToWordManagerScreen() async {
    final words = await Get.toNamed(
      Routes.wordManagerScreen,
      arguments: {
        'type': WordManagerScreenType.addWordToBook,
        'words': _selectedWords,
      },
    );
    updateSelectedWords(words: words);
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
