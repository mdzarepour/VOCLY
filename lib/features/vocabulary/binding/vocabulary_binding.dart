import 'package:get/get.dart';
import 'package:vocly/core/services/filter_service.dart';
import 'package:vocly/features/vocabulary/controller/backup_controller.dart';
import 'package:vocly/features/vocabulary/controller/book_controller.dart';
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/features/vocabulary/controller/search_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';
import 'package:vocly/shared/controllers/spelling_controller.dart';
import 'package:vocly/features/vocabulary/controller/word_controller.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository_imp.dart';

class VocabularyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordController>(
      () => WordController(wordRepository: Get.find<VocabularyRepository>()),
    );
    Get.lazyPut<BookController>(
      () => BookController(bookRepository: Get.find<BookRepository>()),
    );
    Get.lazyPut<WordSelectionController>(
      () => WordSelectionController(wordRepository: Get.find<WordRepository>()),
    );
    Get.lazyPut<BookSelectionController>(
      () => BookSelectionController(bookRepository: Get.find<BookRepository>()),
    );
    Get.lazyPut<WordSearchController>(
      () => WordSearchController(wordRepository: Get.find<WordRepository>()),
    );
    Get.lazyPut<SpellingController>(
      () => SpellingController(
        currentWord: Get.find<WordController>().currentWordRx,
      ),
    );
    Get.lazyPut<BackupController>(
      () => BackupController(backupRepository: Get.find<BackupRepository>()),
    );
    Get.lazyPut<FilterController<WordModel>>(
      () => FilterController(filterService: Get.find<FilterService>()),
    );
    Get.lazyPut<FilterController<BookModel>>(
      () => FilterController(filterService: Get.find<FilterService>()),
    );
  }
}
