import 'package:get/get.dart';
import 'package:vocly/features/vocabulary/controller/home_controller.dart';
import 'package:vocly/features/vocabulary/controller/book_manage_controller.dart';
import 'package:vocly/features/vocabulary/controller/word_crud_controller.dart';
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/features/vocabulary/controller/search_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';
import 'package:vocly/shared/controllers/spelling_controller.dart';
import 'package:vocly/features/vocabulary/controller/word_manage_controller.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

class VocabularyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordManageController>(() => WordManageController());
    Get.lazyPut<WordCrudController>(() => WordCrudController());

    Get.lazyPut<BookManageController>(() => BookManageController());
    Get.lazyPut<WordSelectionController>(
      () => WordSelectionController(wordRepository: Get.find<WordRepository>()),
    );
    Get.lazyPut<BookSelectionController>(
      () => BookSelectionController(bookRepository: Get.find<BookRepository>()),
    );
    Get.lazyPut<WordSearchController>(() => WordSearchController());
    Get.lazyPut<SpellingController>(
      () => SpellingController(
        currentWord: Get.find<WordCrudController>().currentWord!,
      ),
    );
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FilterController<WordModel>>(() => FilterController());
    Get.lazyPut<FilterController<BookModel>>(() => FilterController());
  }
}
