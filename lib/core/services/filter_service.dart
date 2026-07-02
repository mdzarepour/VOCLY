import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/vacabulary_model.dart';

class FilterService {
  List<T> applyFilters<T extends VacabularyModel>({
    required List<T> items,
    required SortType sortType,
    required Map<FilterType, Set> activeFilters,
  }) {
    if (activeFilters.isEmpty && sortType == SortType.newest) {
      return items;
    }

    List<T> result = List<T>.from(items);
    if (activeFilters.isNotEmpty) {
      result = _filterItems(result: result, activeFilters: activeFilters);
    }

    result.sort((a, b) => _sortItems(a, b, sortType));
    return result;
  }

  List<T> _filterItems<T extends VacabularyModel>({
    required List<T> result,
    required Map<FilterType, Set> activeFilters,
  }) {
    return result.where((item) {
      for (final entry in activeFilters.entries) {
        final type = entry.key;
        final selectedItems = entry.value;
        if (selectedItems.isEmpty) continue;

        final bool matches = switch (type) {
          FilterType.color => selectedItems.contains(item.color),
          FilterType.type => selectedItems.contains(item.level),
          FilterType.icon => selectedItems.contains(item.icon),
          FilterType.level => selectedItems.contains(item.type),
        };
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  int _sortItems<T extends VacabularyModel>(T a, T b, SortType sortType) {
    final aTime = int.tryParse(a.createAt) ?? 0;
    final bTime = int.tryParse(b.createAt) ?? 0;

    return switch (sortType) {
      SortType.oldest => aTime.compareTo(bTime),
      SortType.newest => bTime.compareTo(aTime),
      SortType.aToZ => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      SortType.zToA => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
    };
  }
}
