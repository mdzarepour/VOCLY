import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/vocabulary/controller/base/hive_controller.dart';

abstract class SelectionController<T extends HiveObject> extends GetxController{
  final HiveController currentController ;
  SelectionController({required this.currentController}) ;

  final List<T> selectedItems = [];
  bool isSelectionMode = false;
  String selectButtonTitle = 'Select all';

  void changeSelectionMode({required dynamic item}) {
    if (selectedItems.isEmpty) {
      selectedItems.add(item);
      updateSelectionMode(mode: true);
    } else {
      selectItem(item: item);
    }
    update();
  }
  void updateSelectionMode({required bool mode}) {
    isSelectionMode = mode;
    update();
  }

  bool isSelected({required dynamic item}) => selectedItems.contains(item);

  void selectItem({required dynamic item}) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
      if (selectedItems.isEmpty) {
        updateSelectionMode(mode: false);
      }
    } else {
      selectedItems.add(item);
    }
    _updateSelectionTitle();
    update();
  }

  void selectAllItems() {
    final words = currentController.items;
    if (selectedItems.isEmpty || selectedItems.length < words.length) {
      updateSelectionMode(mode: true);
      selectedItems.clear();
      selectedItems.addAll(words.cast<T>());
    } else {
      updateSelectionMode(mode: false);
      selectedItems.clear();
    }
    _updateSelectionTitle();
    update();
  }

  void _updateSelectionTitle() {
    if (selectedItems.length >= currentController.items.length) {
      selectButtonTitle = 'Unselect all';
    } else {
      selectButtonTitle = 'Select all';
    }
  }

}