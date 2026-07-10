import 'package:get/state_manager.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/types/vocabulary_model.dart';

class FilterController<T extends VocabularyModel> extends GetxController {
  final RxMap<FilterType, Set> _activeFilters = <FilterType, Set>{}.obs;

  final Rx<SortType> _sortType = SortType.newest.obs;

  void selectFilter({required FilterType type, required int filterItem}) {
    if (!_activeFilters.containsKey(type)) {
      _activeFilters[type] = {};
    }
    final currentFilter = _activeFilters[type]!;
    if (currentFilter.contains(filterItem)) {
      currentFilter.remove(filterItem);

      if (currentFilter.isEmpty) {
        _activeFilters.remove(type);
      }
    } else {
      currentFilter.add(filterItem);
    }
    _activeFilters.refresh();
  }

  bool isFilterSelected({required FilterType type, required int filterItem}) {
    return _activeFilters[type]?.contains(filterItem) ?? false;
  }

  void deleteFilters() {
    _activeFilters.clear();
  }

  List<T> applyFilter({required List<T> items}) {
    if (_activeFilters.isEmpty) {
      return items;
    }
    List<T> result = List<T>.from(items);
    for (var entry in _activeFilters.entries) {
      final type = entry.key;
      final selectedFilterItems = entry.value;

      result = result.where((element) {
        switch (type) {
          case FilterType.icon:
            return selectedFilterItems.contains(element.icon);
          case FilterType.color:
            return selectedFilterItems.contains(element.color);
          case FilterType.level:
            return selectedFilterItems.contains(element.level);
          case FilterType.type:
            return selectedFilterItems.contains(element.type);
        }
      }).toList();
    }
    return result;
  }

  void selectSort({required SortType sortType}) {
    _sortType.value = sortType;
  }

  bool isSortSelected({required SortType sortType}) {
    return _sortType.value == sortType;
  }

  int applySort(T a, T b) {
    final aTime = a.createAt;
    final bTime = b.createAt;

    return switch (_sortType.value) {
      SortType.oldest => aTime.compareTo(bTime),
      SortType.newest => bTime.compareTo(aTime),
      SortType.aToZ => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      SortType.zToA => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
    };
  }
}
