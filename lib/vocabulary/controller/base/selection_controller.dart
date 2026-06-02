import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/vocabulary/controller/base/hive_controller.dart';

abstract class SelectionController<T extends HiveObject>
    extends GetxController {
  final HiveController currentController;
  SelectionController({required this.currentController});

  final RxList<T> _selectedItems = <T>[].obs;
  List<T> get selectedItems => _selectedItems;

  final RxBool _isSelectionMode = false.obs;
  bool get isSelectionMode => _isSelectionMode.value;

  final _selectButtonIcon = Icons.done_all_outlined.obs;
  IconData get selectButtonIcon => _selectButtonIcon.value;

  void changeSelectionMode({required dynamic item}) {
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

  bool isSelected({required dynamic item}) => _selectedItems.contains(item);

  void selectItem({required dynamic item}) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
      if (_selectedItems.isEmpty) {
        updateSelectionMode(mode: false);
      }
    } else {
      _selectedItems.add(item);
    }
    _updateSelectionTitle();
  }

  void selectAllItems() {
    final words = currentController.items;
    if (_selectedItems.isEmpty || _selectedItems.length < words.length) {
      updateSelectionMode(mode: true);
      _selectedItems.clear();
      _selectedItems.addAll(words.cast<T>());
    } else {
      updateSelectionMode(mode: false);
      _selectedItems.clear();
    }
    _updateSelectionTitle();
  }

  void _updateSelectionTitle() {
    if (_selectedItems.length >= currentController.items.length) {
      _selectButtonIcon.value = Icons.do_not_disturb_alt_outlined;
    } else {
      _selectButtonIcon.value = Icons.done_all_outlined;
    }
  }
}
