import 'package:get/get.dart';
import 'package:vocly/app/controllers/vocabulary/backup_controller.dart';
import 'package:vocly/app/controllers/vocabulary/book_controller.dart';
import 'package:vocly/app/common/controllers/filter_controller.dart';
import 'package:vocly/app/controllers/vocabulary/search_controller.dart';
import 'package:vocly/app/common/controllers/selection_controller.dart';
import 'package:vocly/app/common/controllers/spelling_controller.dart';
import 'package:vocly/app/controllers/vocabulary/word_controller.dart';
import 'package:vocly/app/models/entities/book_model.dart';
import 'package:vocly/app/models/entities/word_model.dart';
import 'package:vocly/app/models/repositories/vocabulary_repository.dart';

class VocabularyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordController>(
      () => WordController(wordRepository: Get.find<WordRepository>()),
    );
    Get.lazyPut<BookController>(
      () => BookController(bookRepository: Get.find<BookRepository>()),
    );
    Get.lazyPut<WordSelectionController>(
      () => WordSelectionController(
        providedItems: () => Get.find<WordController>().words,
      ),
    );
    Get.lazyPut<BookSelectionController>(
      () => BookSelectionController(
        providedItems: () => Get.find<BookController>().books,
      ),
    );
    Get.lazyPut<WordSearchController>(
      () => WordSearchController(
        providedWords: () => Get.find<WordController>().words,
      ),
    );
    Get.lazyPut<SpellingController>(
      () => SpellingController(
        currentWord: Get.find<WordController>().currentWordRx,
      ),
    );
    Get.lazyPut<BackupController>(
      () => BackupController(backupRepository: Get.find<BackupRepository>()),
    );
    Get.lazyPut<FilterController<WordModel>>(() => FilterController());
    Get.lazyPut<FilterController<BookModel>>(() => FilterController());
  }
}
