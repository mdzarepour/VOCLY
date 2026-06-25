import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/app/models/entities/book_model.dart';
import 'package:vocly/app/models/entities/word_model.dart';

abstract class _SelectionController<T> extends GetxController {
  final List<T> Function() providedItems;
  _SelectionController({required this.providedItems});

  final RxList<T> _selectedItems = <T>[].obs;
  List<T> get selectedItems => _selectedItems;

  final RxBool _isSelectionMode = false.obs;
  bool get isSelectionMode => _isSelectionMode.value;

  IconData get selectButtonIcon {
    final items = providedItems();
    if (_selectedItems.isEmpty) {
      return Icons.done_all_outlined;
    }
    if (_selectedItems.length >= items.length) {
      return Icons.do_not_disturb_alt_outlined;
    } else {
      return Icons.done_all_outlined;
    }
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
    final items = providedItems();
    if (items.isEmpty) {
      Get.snackbar('Cant select', 'there is no item for select');
      return;
    }
    
    if (_selectedItems.isEmpty ||
        _selectedItems.length < currentSelectedItems.length) {
      updateSelectionMode(mode: true);
      _selectedItems.clear();
      _selectedItems.addAll(currentSelectedItems);
    } else {
      updateSelectionMode(mode: false);
      _selectedItems.clear();
    }
  }

  void clearSelection() {
    _selectedItems.clear();
    updateSelectionMode(mode: false);
  }

  @override
  void onClose() {
    super.onClose();
    _selectedItems.clear();
    _isSelectionMode.value = false;
  }
}

class WordSelectionController extends _SelectionController<WordModel> {
  void initPreviouslySelectedWords({required List<String> selectedWords}) {
    final List<WordModel> allWords = providedItems();
    selectedItems.clear();
    final List<WordModel> previouslySelectedWords = allWords
        .where((word) => selectedWords.contains(word.id))
        .toList();
    selectedItems.addAll(previouslySelectedWords);
    updateSelectionMode(mode: true);
  }

  WordSelectionController({required super.providedItems});
}

class BookSelectionController extends _SelectionController<BookModel> {
  BookSelectionController({required super.providedItems});
}
