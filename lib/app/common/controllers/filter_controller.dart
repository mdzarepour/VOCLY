import 'package:get/state_manager.dart';
import 'package:vocly/app/core/enums/enums.dart';
import 'package:vocly/app/models/vacabulary_model.dart';

class FilterController<T extends VacabularyModel> extends GetxController {
  final Rx<SortType> _sortType = SortType.newest.obs;
  final RxMap<FilterType, Set> _activeFilters = <FilterType, Set>{}.obs;

  List<T> getFilteredItems({required List<T> items}) {
    if (_activeFilters.isEmpty && _sortType.value == SortType.newest) {
      return items;
    }
    List<T> result = List.from(items);

    if (_activeFilters.isNotEmpty) {
      result = _filterItems(result: result);
    }

    result.sort(_sortWords);
    return result;
  }

  List<T> _filterItems({required List<T> result}) {
    return result.where((item) {
      for (var entry in _activeFilters.entries) {
        final type = entry.key;
        final selectedItems = entry.value;

        if (selectedItems.isEmpty) continue;
        bool matchesCurrentFilter = false;

        switch (type) {
          case FilterType.color:
            matchesCurrentFilter = selectedItems.contains(item.color);
            break;
          case FilterType.type:
            matchesCurrentFilter = selectedItems.contains(item.level);
            break;
          case FilterType.icon:
            matchesCurrentFilter = selectedItems.contains(item.icon);
            break;
          case FilterType.level:
            matchesCurrentFilter = selectedItems.contains(item.type);
            break;
        }
        if (!matchesCurrentFilter) return false;
      }
      return true;
    }).toList();
  }

  int _sortWords(T a, T b) {
    final aTime = int.tryParse(a.createAt) ?? 0;
    final bTime = int.tryParse(b.createAt) ?? 0;

    switch (_sortType.value) {
      case SortType.oldest:
        return aTime.compareTo(bTime);
      case SortType.newest:
        return bTime.compareTo(aTime);
      case SortType.aToZ:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case SortType.zToA:
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
    }
  }

  void selectSort({required SortType sortType}) {
    _sortType.value = sortType;
  }

  bool isSortSelected({required SortType sortType}) {
    return _sortType.value == sortType;
  }

  void selectFilters({required FilterType type, required int filterItem}) {
    if (!_activeFilters.containsKey(type)) {
      _activeFilters[type] = {};
    }
    final currentSet = _activeFilters[type]!;
    if (currentSet.contains(filterItem)) {
      currentSet.remove(filterItem);
      if (currentSet.isEmpty) _activeFilters.remove(type);
    } else {
      currentSet.add(filterItem);
    }
    _activeFilters.refresh();
  }

  bool isFilterSelected({required FilterType type, required int filterItem}) {
    return _activeFilters[type]?.contains(filterItem) ?? false;
  }

  Set getFilterItems(FilterType type) {
    return _activeFilters[type] ?? {};
  }

  void deleteFilters() {
    _activeFilters.clear();
  }
}
