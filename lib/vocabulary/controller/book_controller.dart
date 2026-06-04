import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/vocabulary/controller/base/hive_controller.dart';
import 'package:vocly/vocabulary/model/book_model.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

class BookController extends HiveController<BookModel> {
  BookController() : super(box: Hive.box<BookModel>('BookBox'));
  final Box<WordModel> wordBox = Hive.box<WordModel>('WordBox');

  List<WordModel> getBookWords(BookModel book) {
    try {
      return book.words
          .map((id) => wordBox.get(id))
          .whereType<WordModel>()
          .toList();
    } catch (e) {
      Get.snackbar('Oopps!', e.toString());
      return [];
    }
  }

  @override
  Future<void> addItem({required BookModel model}) async {
    try {
      await box.put(model.id, model);
      loadItems();
    } on HiveError catch (error) {
      Get.snackbar('Oopps!', error.message);
    }
    Get.back();
  }

  @override
  bool isItemExist({required String name}) {
    return items.any(
      (element) => element.name.toLowerCase().contains(name.toLowerCase()),
    );
  }
}
