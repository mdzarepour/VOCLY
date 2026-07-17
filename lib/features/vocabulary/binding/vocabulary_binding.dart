import 'package:get/get.dart';
import 'package:vocly/features/vocabulary/controller/book_details_controller.dart';
import 'package:vocly/features/vocabulary/controller/home_controller.dart';
import 'package:vocly/features/vocabulary/controller/word_details_controller.dart';
import 'package:vocly/features/vocabulary/controller/word_manager_controller.dart';
import 'package:vocly/features/vocabulary/controller/book_manager_controller.dart';
import 'package:vocly/features/vocabulary/controller/word_crud_controller.dart';
import 'package:vocly/features/vocabulary/controller/book_crud_controller.dart';
import 'package:vocly/features/vocabulary/controller/search_controller.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';
import 'package:vocly/shared/controllers/spelling_controller.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        backupRepository: Get.find(),
        bookRepository: Get.find(),
        linkService: Get.find(),
        platformService: Get.find(),
        wordRepository: Get.find(),
      ),
    );
  }
}

class WordManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => WordManagerController(
        dialogService: Get.find(),
        filterController: Get.find(),
        selectionController: Get.find(),
        wordRepository: Get.find(),
      ),
    );
    Get.lazyPut(() {
      return SelectionController<WordModel>(
        items: Get.find<WordRepository>().wordListenable.value.values.toList(),
      );
    });
    Get.lazyPut(() => FilterController<WordModel>());
  }
}

class BookManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => BookManagerController(
        bookRepository: Get.find(),
        dialogService: Get.find(),
        filterController: Get.find(),
        selectionController: Get.find(),
      ),
    );
    Get.lazyPut(() {
      return SelectionController<BookModel>(
        items: Get.find<BookRepository>().bookListenable.value.values.toList(),
      );
    });
    Get.lazyPut(() => FilterController<BookModel>());
  }
}

class WordCrudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => WordCrudController(
        dialogService: Get.find(),
        wordRepository: Get.find(),
        type: Get.arguments?['type'],
        wordKey: Get.arguments['word_key'],
      ),
    );
  }
}

class BookCrudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => BookCrudController(
        bookRepository: Get.find(),
        dialogService: Get.find(),
      ),
    );
  }
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WordSearchController(wordRepository: Get.find()));
  }
}

class ReadWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpellingController());
    Get.lazyPut(
      () => WordDetailsController(
        dialogService: Get.find(),
        speechService: Get.find(),
        spellingController: Get.find(),
        wordRepository: Get.find(),
      ),
    );
  }
}

class ReadBookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookDetailsController(bookRepository: Get.find()));
  }
}
