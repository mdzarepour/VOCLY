import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/core/enums/enums.dart';
import 'package:vocly/vocabulary/controller/base/hive_controller.dart';
import 'package:vocly/vocabulary/model/book_model.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

class WordController extends HiveController<WordModel> {
  WordController() : super(box: Hive.box<WordModel>('WordBox'));

  final RxList<int> colorFilters = <int>[].obs;
  final RxList<int> iconFilters = <int>[].obs;
  final RxList<int> typeFilters = <int>[].obs;

  List<WordModel> get wordsList {
    if (colorFilters.isEmpty && iconFilters.isEmpty && typeFilters.isEmpty) {
      return items;
    }

    return items.where((word) {
      final matchesColor =
          colorFilters.isEmpty || colorFilters.contains(word.color);

      final matchesType =
          typeFilters.isEmpty || typeFilters.contains(word.type);

      final matchesIcon =
          iconFilters.isEmpty || iconFilters.contains(word.icon);

      return matchesColor && matchesType && matchesIcon;
    }).toList();
  }

  void selectFilters({required FilterType type, required int filterItem}) {
    switch (type) {
      case FilterType.color:
        {
          colorFilters.contains(filterItem)
              ? colorFilters.remove(filterItem)
              : colorFilters.add(filterItem);
        }
        break;
      case FilterType.icon:
        {
          iconFilters.contains(filterItem)
              ? iconFilters.remove(filterItem)
              : iconFilters.add(filterItem);
        }
        break;
      case FilterType.type:
        {
          typeFilters.contains(filterItem)
              ? typeFilters.remove(filterItem)
              : typeFilters.add(filterItem);
        }
        break;
    }
  }

  bool isFilterSelected({required FilterType type, required int filterItem}) {
    switch (type) {
      case FilterType.color:
        {
          return colorFilters.contains(filterItem);
        }
      case FilterType.icon:
        {
          return iconFilters.contains(filterItem);
        }
      case FilterType.type:
        {
          return typeFilters.contains(filterItem);
        }
    }
  }

  void deleteFilters() {
    colorFilters.clear();
    iconFilters.clear();
    typeFilters.clear();
  }

  @override
  Future<void> addItem({required WordModel model}) async {
    try {
      await box.put(model.id, model);
      loadItems();
    } on HiveError catch (error) {
      Get.snackbar('Oopps!', error.message);
    }
    Get.back();
  }

  @override
  bool isItemExist({required final String name}) {
    return items.any(
      (element) => element.name.toLowerCase().contains(name.toLowerCase()),
    );
  }
}
