import 'package:get/state_manager.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/vacabulary_model.dart';
import 'package:vocly/core/services/filter_service.dart';

class FilterController<T extends VacabularyModel> extends GetxController {
  final FilterService filterService;
  FilterController({required this.filterService});

  final Rx<SortType> _sortType = SortType.newest.obs;
  final RxMap<FilterType, Set> _activeFilters = <FilterType, Set>{}.obs;

  List<T> getFilteredItems({required List<T> items}) {
    return filterService.applyFilters<T>(
      items: items,
      sortType: _sortType.value,
      activeFilters: _activeFilters,
    );
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
