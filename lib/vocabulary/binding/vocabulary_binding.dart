import 'package:get/get.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/services/speech_service.dart';
import 'package:vocly/vocabulary/controller/book_controller.dart';
import 'package:vocly/vocabulary/controller/book_selection_controller.dart';
import 'package:vocly/vocabulary/controller/word_search_controller.dart';
import 'package:vocly/vocabulary/controller/word_selection_controller.dart';
import 'package:vocly/vocabulary/controller/spelling_controller.dart';
import 'package:vocly/vocabulary/controller/word_controller.dart';

class AppCoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DialogService>(DialogService(), permanent: true);
    Get.put<WordController>(WordController(), permanent: true);
    Get.put<BookController>(BookController(), permanent: true);
    Get.put<SpeechService>(SpeechService(), permanent: true).initEssentials();
  }
}

class ManageWordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordSelectionController>(
      () => WordSelectionController(
        currentController: Get.find<WordController>(),
      ),
    );
  }
}

class ManageBooksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookSelectionController>(
      () => BookSelectionController(
        currentController: Get.find<BookController>(),
      ),
    );
  }
}

class WordDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpellingController>(
      () => SpellingController(wordController: Get.find<WordController>()),
    );
  }
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordSearchController>(
      () => WordSearchController(wordController: Get.find<WordController>()),
    );
  }
}
