import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/vocabulary/controller/base/hive_controller.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

class WordController extends HiveController<WordModel> {
  WordController() : super(box: Hive.box<WordModel>('WordBox'));

  @override
  bool isItemExist({required final String name}) {
    return items.any(
      (element) => element.name!.toLowerCase().contains(name.toLowerCase()),
    );
  }
}
