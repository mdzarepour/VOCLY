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
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';
import 'package:vocly/shared/controllers/spelling_controller.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class WordManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WordManagerController());
    Get.lazyPut(() => WordSelectionController(wordRepository: Get.find()));
    Get.lazyPut(() => FilterController<WordModel>());
  }
}

class BookManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookManagerController());
    Get.lazyPut(() => BookSelectionController(bookRepository: Get.find()));
    Get.lazyPut(() => FilterController<BookModel>());
  }
}

class WordCrudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WordCrudController());
  }
}

class BookCrudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookCrudController());
  }
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WordSearchController());
  }
}

class ReadWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpellingController());
    Get.lazyPut(() => WordDetailsController());
  }
}

class ReadBookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookDetailsController());
  }
}
