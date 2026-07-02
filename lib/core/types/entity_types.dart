import 'package:vocly/core/types/enums.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_icons.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class ConstWordTypes {
  ConstWordTypes._();
  static const wordTypes = [
    'Article',
    'Pronoun',
    'Conjunction',
    'Adjective',
    'Preposition',
    'Adverb',
    'Verb',
    'Noun',
  ];
  static const List<Map> wordFilteringItems = [
    {
      AppStrings.keyName: 'Color',
      AppStrings.keyType: FilterType.color,
      AppStrings.keyFilterItems: ConstEntityColors.colors,
    },
    {
      AppStrings.keyName: 'Icon',
      AppStrings.keyType: FilterType.icon,
      AppStrings.keyFilterItems: ConstIcons.icons,
    },
    {
      AppStrings.keyName: 'Type',
      AppStrings.keyType: FilterType.type,
      AppStrings.keyFilterItems: ConstWordTypes.wordTypes,
    },
    {
      AppStrings.keyName: 'Level',
      AppStrings.keyType: FilterType.level,
      AppStrings.keyFilterItems: ConstEntityLevel.levels,
    },
  ];
}

class ConstBookTypes {
  ConstBookTypes._();
  static const bookTypes = [
    'Educational',
    'Story',
    'Poem',
    'Vocabulary',
    'Movie',
    'Environment',
    'School',
    'Novel',
    'Songs',
    'Academic',
    'General',
  ];
  static const List<Map> bookFilteringItems = [
    {
      AppStrings.keyName: 'Color',
      AppStrings.keyType: FilterType.color,
      AppStrings.keyFilterItems: ConstEntityColors.colors,
    },
    {
      AppStrings.keyName: 'Icon',
      AppStrings.keyType: FilterType.icon,
      AppStrings.keyFilterItems: ConstIcons.icons,
    },
    {
      AppStrings.keyName: 'Type',
      AppStrings.keyType: FilterType.type,
      AppStrings.keyFilterItems: ConstBookTypes.bookTypes,
    },
    {
      AppStrings.keyName: 'Level',
      AppStrings.keyType: FilterType.level,
      AppStrings.keyFilterItems: ConstEntityLevel.levels,
    },
  ];
}

class ConstEntityLevel {
  ConstEntityLevel._();
  static const levels = ['Easy', 'Medium', 'Hard', 'Very hard'];
}

class ConstSortItems {
  ConstSortItems._();
  static const List<Map> sortItems = [
    {'name': 'Newest', 'type': SortType.newest},
    {'name': 'Oldest', 'type': SortType.oldest},
    {'name': 'From A to Z', 'type': SortType.aToZ},
    {'name': 'From Z to A', 'type': SortType.zToA},
  ];
}
