import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

abstract class HiveController<T extends HiveObject> extends GetxController {
  HiveController({required this.box});

  late final Box<T> box;
  T? currentItem;
  List<T> items = [];

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  void loadItems() {
    try {
      final List<T> freshItems = box.values.toList();
      items = freshItems;
      update();
    } catch (error) {
      Get.snackbar('Failed!', error.toString());
    }
  }

  Future<void> addItem({required final T model}) async {
    try {
      await box.add(model);
      loadItems();
    } on HiveError catch (error) {
      Get.snackbar('Oops!', error.message);
    }
    Get.back();
  }

  Future<void> deleteItems({required final List<T> selectedItems}) async {
    try {
      for (var item in selectedItems) {
        if (item.isInBox) {
          await item.delete();
        }
      }
      loadItems();
    } on HiveError catch (error) {
      Get.snackbar('Oops!', error.message);
    }
  }

  void updateCurrentItem({required final T freshModel}) {
    currentItem = freshModel;
    update();
  }

  Future<void> saveCurrentItem() async {
    try {
      if (currentItem != null && currentItem!.isInBox) {
        await currentItem!.save();
        loadItems();
      }
    } on HiveError catch (error) {
      Get.snackbar('Oops!', error.message);
    }
  }

  bool isItemExist({required final String name});
}
