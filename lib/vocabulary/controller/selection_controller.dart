import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vocly/vocabulary/controller/book_controller.dart';
import 'package:vocly/vocabulary/controller/word_controller.dart';

class SelectionController extends GetxController {
  final WordController wordController;
  final BookController bookController;

  SelectionController({
    required this.wordController,
    required this.bookController,
  });

  final List<dynamic> selectedItems = [];

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
    final words = wordController.items;
    if (selectedItems.isEmpty || selectedItems.length < words.length) {
      updateSelectionMode(mode: true);
      selectedItems.clear();
      selectedItems.addAll(words);
    } else {
      updateSelectionMode(mode: false);
      selectedItems.clear();
    }
    _updateSelectionTitle();
    update();
  }

  void _updateSelectionTitle() {
    if (selectedItems.length >= wordController.items.length) {
      selectButtonTitle = 'Unselect all';
    } else {
      selectButtonTitle = 'Select all';
    }
  }
}
