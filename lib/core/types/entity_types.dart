import 'package:flutter/material.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/shared/constants/const_strings.dart';

// ================ Entity Types As Property ===================================

class WordTypes {
  static const children = [
    'Article',
    'Pronoun',
    'Conjunction',
    'Adjective',
    'Preposition',
    'Adverb',
    'Verb',
    'Noun',
  ];
}

class BookTypes {
  static const children = [
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
}

// ================ Entity Color As Property ===================================

class EntityColor {
  static const children = [
    Color(0xFFFF727A),
    Color(0xFFFF9F54),
    Color(0xFFF7D358),
    Color(0xFFFFD700),
    Color(0xFF9ACD32),
    Color(0xFF4ADE80),
    Color(0xFF48D1CC),
    Color(0xFF40E0D0),
    Color(0xFF40C4FF),
    Color(0xFF4FA8FF),
    Color(0xFF6495ED),
    Color(0xFF7B68EE),
    Color(0xFFA57CF0),
    Color(0xFFB983FF),
    Color(0xFFE066FF),
    Color(0xFFFF85C1),
    Color(0xFFFF6B81),
    Color(0xFF94AABF),
  ];
}

// ================ Entity Level As Property ===================================

class EntityLevel {
  static const children = ['Easy', 'Medium', 'Hard', 'Very hard'];
}

// ================ Entity Icon As Property ====================================

class EntityIcon {
  static const children = [
    Icons.library_books_outlined,
    Icons.menu_book_outlined,
    Icons.bookmark_border_outlined,
    Icons.school_outlined,
    Icons.assignment_outlined,
    Icons.text_fields_outlined,
    Icons.spellcheck_outlined,
    Icons.translate_outlined,
    Icons.mic_outlined,
    Icons.headphones_outlined,
    Icons.search_outlined,
    Icons.folder_outlined,
    Icons.edit_outlined,
    Icons.delete_outline,
    Icons.close_outlined,
    Icons.check_circle_outlined,
    Icons.favorite_border_outlined,
    Icons.star_border_outlined,
    Icons.lightbulb_outline,
    Icons.info_outline,
    Icons.help_outlined,
    Icons.notifications_outlined,
    Icons.access_time_outlined,
    Icons.person_outline,
  ];
}

// ================ Entity Filtering Items For Books ===========================

class BookFilteringItems {
  static const List<Map> bookFilteringItems = [
    {
      AppStrings.keyName: 'Color',
      AppStrings.keyType: FilterType.color,
      AppStrings.keyFilterItems: EntityColor.children,
    },
    {
      AppStrings.keyName: 'Icon',
      AppStrings.keyType: FilterType.icon,
      AppStrings.keyFilterItems: EntityIcon.children,
    },
    {
      AppStrings.keyName: 'Type',
      AppStrings.keyType: FilterType.type,
      AppStrings.keyFilterItems: BookTypes.children,
    },
    {
      AppStrings.keyName: 'Level',
      AppStrings.keyType: FilterType.level,
      AppStrings.keyFilterItems: EntityLevel.children,
    },
  ];
}

// ================ Entity Filtering Items For Words ===========================

class WordFilteringItems {
  static const List<Map> wordFilteringItems = [
    {
      AppStrings.keyName: 'Color',
      AppStrings.keyType: FilterType.color,
      AppStrings.keyFilterItems: EntityColor.children,
    },
    {
      AppStrings.keyName: 'Icon',
      AppStrings.keyType: FilterType.icon,
      AppStrings.keyFilterItems: EntityIcon.children,
    },
    {
      AppStrings.keyName: 'Type',
      AppStrings.keyType: FilterType.type,
      AppStrings.keyFilterItems: WordTypes.children,
    },
    {
      AppStrings.keyName: 'Level',
      AppStrings.keyType: FilterType.level,
      AppStrings.keyFilterItems: EntityLevel.children,
    },
  ];
}
