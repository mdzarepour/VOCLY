import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

abstract class SelectionController<T> extends GetxController {
  List<T> items = [];

  final RxList<T> _selectedItems = <T>[].obs;
  List<T> get selectedItems => _selectedItems;

  final RxBool _isSelectionMode = false.obs;
  bool get isSelectionMode => _isSelectionMode.value;

  IconData get selectButtonIcon {
    if (_selectedItems.isEmpty) {
      return Icons.done_all_outlined;
    }

    if (_selectedItems.length >= items.length) {
      return Icons.do_not_disturb_alt_outlined;
    }

    return Icons.done_all_outlined;
  }

  void changeSelectionMode({required T item}) {
    if (_selectedItems.isEmpty) {
      _selectedItems.add(item);
      updateSelectionMode(mode: true);
    } else {
      selectItem(item: item);
    }
  }

  void updateSelectionMode({required bool mode}) {
    _isSelectionMode.value = mode;
  }

  bool isSelected({required T item}) => _selectedItems.contains(item);

  void selectItem({required T item}) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);

      if (_selectedItems.isEmpty) {
        updateSelectionMode(mode: false);
      }
    } else {
      _selectedItems.add(item);
    }
  }

  void selectAllItems({required List<T> currentSelectedItems}) {
    if (items.isEmpty) {
      Get.snackbar(
        "Can't select",
        "There are no items to select.",
      );
      return;
    }

    if (_selectedItems.isEmpty ||
        _selectedItems.length < currentSelectedItems.length) {
      updateSelectionMode(mode: true);
      _selectedItems
        ..clear()
        ..addAll(currentSelectedItems);
    } else {
      clearSelection();
    }
  }

  void clearSelection() {
    _selectedItems.clear();
    updateSelectionMode(mode: false);
  }

  @override
  void onClose() {
    _selectedItems.clear();
    _isSelectionMode.value = false;
    super.onClose();
  }
}

class WordSelectionController extends SelectionController<WordModel> {
  final WordRepository wordRepository;

  WordSelectionController({
    required this.wordRepository,
  });

  @override
  void onInit() {
    super.onInit();
    items = wordRepository.getAllWords();
  }

  void initPreviouslySelectedWords({
    required List<String> selectedWordIds,
  }) {
    selectedItems.clear();

    final previouslySelectedWords = items
        .where((word) => selectedWordIds.contains(word.id))
        .toList();

    selectedItems.addAll(previouslySelectedWords);

    if (selectedItems.isNotEmpty) {
      updateSelectionMode(mode: true);
    }
  }
}

class BookSelectionController extends SelectionController<BookModel> {
  final BookRepository bookRepository;

  BookSelectionController({
    required this.bookRepository,
  });

  @override
  void onInit() {
    super.onInit();
    items = bookRepository.getAllBooks();
  }
}