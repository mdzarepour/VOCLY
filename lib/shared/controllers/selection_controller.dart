import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

abstract class SelectionController<T> extends GetxController {
  List<T> get items;

  // ================ Reactive Variables =======================================

  final RxList<T> _selectedItems = <T>[].obs;
  List<T> get selectedItems => _selectedItems;

  final RxBool _isSelectionMode = false.obs;
  bool get isSelectionMode => _isSelectionMode.value;

  /// [UI - AppBar] Dynamic action icon based on selection count
  IconData get selectButtonIcon {
    if (_selectedItems.isEmpty) {
      return Icons.done_all_outlined;
    }
    if (_selectedItems.length >= items.length) {
      return Icons.do_not_disturb_alt_outlined;
    }
    return Icons.done_all_outlined;
  }

  // ================ Main Functions ===========================================

  /// [UI - Item LongPress] Entry point to activate selection mode
  void startSelecting({required T item}) {
    if (_selectedItems.isEmpty) {
      updateSelectionMode(mode: true);
      _selectedItems.add(item);
    } else {
      selectItem(item: item);
    }
  }

  /// [UI - Delete Button Visibility] Toggles global selection state
  void updateSelectionMode({required bool mode}) {
    _isSelectionMode.value = mode;
  }

  /// [UI - Item Border/Background] Checks if an item is selected
  bool isSelected({required T item}) => _selectedItems.contains(item);

  /// [UI - Item Tap] Toggles item inside selection list
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

  /// [UI - AppBar Checkbox] Selects or clears all visible items
  void selectAllItems({required List<T> currentSelectedItems}) {
    if (items.isEmpty) {
      Get.snackbar("Can't select", "There is no items to select.");
      return;
    }
    if (_selectedItems.isEmpty ||
        _selectedItems.length < currentSelectedItems.length) {
      updateSelectionMode(mode: true);
      _selectedItems
        ..clear()
        ..addAll(currentSelectedItems);
    } else {
      _clearSelection();
    }
  }

  void _clearSelection() {
    updateSelectionMode(mode: false);
    _selectedItems.clear();
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    // [Internal Logic] Auto-clears list when selection mode turns off
    ever(_isSelectionMode, (bool mode) {
      if (!mode) {
        _selectedItems.clear();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    _clearSelection();
  }
}

class WordSelectionController extends SelectionController<WordModel> {
  final WordRepository wordRepository;
  WordSelectionController({required this.wordRepository});

  @override
  List<WordModel> get items => wordRepository.getAllWords();

  /// [Feature - Book Sync] Pre-fills selected words for a specific book
  void initPreviouslySelectedWords({required List<String> selectedWordIds}) {
    _selectedItems.clear();
    final previouslySelectedWords = items
        .where((word) => selectedWordIds.contains(word.id))
        .toList();
    _selectedItems.addAll(previouslySelectedWords);
    if (_selectedItems.isNotEmpty) updateSelectionMode(mode: true);
  }
}

class BookSelectionController extends SelectionController<BookModel> {
  final BookRepository bookRepository;
  BookSelectionController({required this.bookRepository});

  @override
  List<BookModel> get items => bookRepository.getAllBooks();
}
