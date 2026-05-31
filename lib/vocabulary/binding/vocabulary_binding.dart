import 'package:get/get.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/vocabulary/controller/book_controller.dart';
import 'package:vocly/vocabulary/controller/selection_controller.dart';
import 'package:vocly/vocabulary/controller/spelling_controller.dart';
import 'package:vocly/vocabulary/controller/word_controller.dart';

class AppCoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DialogService>(DialogService(), permanent: true);
  }
}

class WordControllerBindig extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordController>(() => WordController());
  }
}

class ManagingScreenBindig extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookController>(() => BookController());
    Get.lazyPut<WordController>(() => WordController());
    Get.lazyPut<SelectionController>(
      () => SelectionController(
        bookController: Get.find<BookController>(),
        wordController: Get.find<WordController>(),
      ),
    );
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
