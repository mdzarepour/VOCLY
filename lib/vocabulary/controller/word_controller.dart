import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/core/enums/enums.dart';
import 'package:vocly/vocabulary/controller/base/hive_controller.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

class WordController extends HiveController<WordModel> {
  WordController() : super(box: Hive.box<WordModel>('WordBox'));

  final RxList<int> _difficultyFilters = <int>[].obs;
  final RxList<int> _colorFilters = <int>[].obs;
  final RxList<int> _iconFilters = <int>[].obs;
  final RxList<int> _typeFilters = <int>[].obs;

  final Rx<SortType> _sortType = SortType.newest.obs;

  List<WordModel> get wordsList {
    List<WordModel> modifiedWordsList = [];

    if (_colorFilters.isEmpty &&
        _iconFilters.isEmpty &&
        _typeFilters.isEmpty &&
        _difficultyFilters.isEmpty) {
      modifiedWordsList.assignAll(items);
    } else {
      modifiedWordsList = items.where((word) {
        final matchesColor =
            _colorFilters.isEmpty || _colorFilters.contains(word.color);

        final matchesType =
            _typeFilters.isEmpty || _typeFilters.contains(word.type);

        final matchesIcon =
            _iconFilters.isEmpty || _iconFilters.contains(word.icon);

        final matchesDifficulty =
            _difficultyFilters.isEmpty ||
            _difficultyFilters.contains(word.difficulty);

        return matchesColor && matchesType && matchesIcon && matchesDifficulty;
      }).toList();
    }

    modifiedWordsList.sort((a, b) {
      switch (_sortType.value) {
        case SortType.oldest:
          {
            return int.parse(a.createAt).compareTo(int.parse(b.createAt));
          }
        case SortType.newest:
          {
            return int.parse(b.createAt).compareTo(int.parse(a.createAt));
          }
        case SortType.aToZ:
          {
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }
        case SortType.zToA:
          {
            return b.name.toLowerCase().compareTo(a.name.toLowerCase());
          }
      }
    });
    return modifiedWordsList;
  }

  void selectSort({required final SortType sortType}) {
    _sortType.value = sortType;
  }

  bool isSortSelected({required final SortType sortType}) {
    return _sortType.value == sortType;
  }

  void selectFilters({required FilterType type, required int filterItem}) {
    switch (type) {
      case FilterType.color:
        {
          _colorFilters.contains(filterItem)
              ? _colorFilters.remove(filterItem)
              : _colorFilters.add(filterItem);
        }
        break;
      case FilterType.icon:
        {
          _iconFilters.contains(filterItem)
              ? _iconFilters.remove(filterItem)
              : _iconFilters.add(filterItem);
        }
        break;
      case FilterType.type:
        {
          _typeFilters.contains(filterItem)
              ? _typeFilters.remove(filterItem)
              : _typeFilters.add(filterItem);
        }
        break;
      case FilterType.difficulty:
        {
          _difficultyFilters.contains(filterItem)
              ? _difficultyFilters.remove(filterItem)
              : _difficultyFilters.add(filterItem);
        }
        break;
    }
  }

  bool isFilterSelected({required FilterType type, required int filterItem}) {
    switch (type) {
      case FilterType.color:
        {
          return _colorFilters.contains(filterItem);
        }
      case FilterType.icon:
        {
          return _iconFilters.contains(filterItem);
        }
      case FilterType.type:
        {
          return _typeFilters.contains(filterItem);
        }
      case FilterType.difficulty:
        {
          return _difficultyFilters.contains(filterItem);
        }
    }
  }

  void deleteFilters() {
    _colorFilters.clear();
    _iconFilters.clear();
    _typeFilters.clear();
    _difficultyFilters.clear();
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
