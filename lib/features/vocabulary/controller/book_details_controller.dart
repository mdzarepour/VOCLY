import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

class BookDetailsController extends GetxController {
  late BookRepository _bookRepository;
  late ValueListenable<Box<BookModel>> _bookListenable;

  // ================ Reactive Variables =======================================

  final Rxn<BookModel> _book = Rxn<BookModel>();
  BookModel? get book => _book.value;

  final RxList<WordModel> _bookWords = <WordModel>[].obs;
  List<WordModel> get bookWords => _bookWords;

  // ================ Main Functions ===========================================

  void _initBook() {
    final key = Get.arguments['book_key'];
    final box = _bookListenable.value;
    final updatedData = box.get(key);

    if (updatedData != null) {
      _book.value = updatedData;
      _bookWords.value = _bookRepository.getBookWords(book: _book.value!);
    }
  }

  // ================ Navigation ===============================================

  void goToAddEditBookScreen() {
    Get.toNamed(
      Routes.bookCrudScreen,
      arguments: {
        'type': BookScreenType.editBook,
        'book_key': Get.arguments['book_key'],
      },
    );
  }

  void goToWordDetailsScreen({required int key}) {
    Get.toNamed(Routes.wordDetailsScreen, arguments: {'word_key': key});
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    _bookRepository = Get.find();

    _bookListenable = _bookRepository.bookValueListenable;
    _bookListenable.addListener(_initBook);
    _initBook();
    //  _initBookWords();
  }

  @override
  void onClose() {
    super.onClose();
    _bookListenable.removeListener(_initBook);
    _book.value = null;
  }
}
