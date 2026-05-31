import 'package:get/get.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/vocabulary/controller/book_controller.dart';
import 'package:vocly/vocabulary/controller/book_selection_controller.dart';
import 'package:vocly/vocabulary/controller/word_selection_controller.dart';
import 'package:vocly/vocabulary/controller/spelling_controller.dart';
import 'package:vocly/vocabulary/controller/word_controller.dart';
import 'package:vocly/core/services/speech_service.dart';

class AppCoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DialogService>(DialogService(), permanent: true);
  }
}

class WordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordController>(() => WordController());
  }
}

class ManagingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookController>(() => BookController());
    Get.lazyPut<WordController>(() => WordController());
    Get.lazyPut<WordSelectionController>(() => WordSelectionController(currentController: Get.find<WordController>()));
    Get.lazyPut<BookSelectionController>(() => BookSelectionController(currentController: Get.find<BookController>()));
  }
}

class SpellingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpellingController>(
      () => SpellingController(wordController: Get.find<WordController>()),
    );
  }
}

class BookControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookController>(() => BookController());
  }
}

class SpeechServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpeechService>(() => SpeechService());
  }
}
