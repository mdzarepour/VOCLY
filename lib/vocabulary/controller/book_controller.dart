import 'package:hive/hive.dart';
import 'package:vocly/vocabulary/controller/usecase/hive_controller.dart';
import 'package:vocly/vocabulary/model/book_model.dart';

class BookController extends HiveController<BookModel> {
  BookController() : super(box: Hive.box<BookModel>('BookBox'));

  @override
  bool isItemExist({required String name}) {
    return items.any(
      (element) => element.name.toLowerCase().contains(name.toLowerCase()),
    );
  }
}
