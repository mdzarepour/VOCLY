import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

abstract class HiveController<T extends HiveObject> extends GetxController {
  HiveController({required Box<T> box}) : _box = box;

  late final Box<T> _box;

  final Rxn<T> _currentItem = Rxn<T>();
  T? get currentItem => _currentItem.value;

  final RxList<T> _items = <T>[].obs;
  List<T> get items => _items;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  void loadItems() {
    try {
      final List<T> freshItems = _box.values.toList();
      _items.value = freshItems;
    } catch (error) {
      Get.snackbar('Failed!', error.toString());
    }
  }

  Future<void> addItem({required final T model}) async {
    try {
      await _box.add(model);
      loadItems();
    } on HiveError catch (error) {
      Get.snackbar('Oopps!', error.message);
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
      Get.snackbar('Oopps!', error.message);
    }
  }

  void updateCurrentItem({required final T freshModel}) {
    _currentItem.value = freshModel;
    freshModel.save();
  }

  Future<void> saveCurrentItem() async {
    try {
      final item = _currentItem.value;
      if (item != null && item.isInBox) {
        await item.save();
        loadItems();
      }
    } on HiveError catch (error) {
      Get.snackbar('Oopps!', error.message);
    }
  }

  bool isItemExist({required final String name});
}
