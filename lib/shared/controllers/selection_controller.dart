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

  void startSelecting({required T item}) {
    if (_selectedItems.isEmpty) {
      updateSelectionMode(mode: true);
      _selectedItems.add(item);
    } else {
      selectItem(item: item);
    }
  }

  void updateSelectionMode({required bool mode}) {
    _isSelectionMode.value = mode;
  }

  bool isSelected({required T item}) {
    return _selectedItems.contains(item);
  }

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

  void selectAllItems({required List<T> allDisplayedItems}) {
    if (items.isEmpty) return;
    if (_selectedItems.isEmpty ||
        _selectedItems.length < allDisplayedItems.length) {
      updateSelectionMode(mode: true);
      _selectedItems
        ..clear()
        ..addAll(allDisplayedItems);
    } else {
      _clearSelection();
    }
  }

  // ================ Helper Functions =========================================

  void _clearSelection() {
    updateSelectionMode(mode: false);
    _selectedItems.clear();
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
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
}

class BookSelectionController extends SelectionController<BookModel> {
  final BookRepository bookRepository;
  BookSelectionController({required this.bookRepository});

  @override
  List<BookModel> get items => bookRepository.getAllBooks();
}
