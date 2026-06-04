import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

abstract class HiveController<T extends HiveObject> extends GetxController {
  HiveController({required Box<T> box}) : this.box = box;

  late final Box<T> box;

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
      final List<T> freshItems = box.values.toList();
      _items.value = freshItems;
    } catch (error) {
      Get.snackbar('Failed!', error.toString());
    }
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

  Future<void> updateCurrentItem({required final T freshModel}) async {
    try {
      await freshModel.save();
      _currentItem.value = freshModel;
      _currentItem.refresh();
      loadItems();
    } on HiveError catch (error) {
      Get.snackbar('Oopps!', error.message);
    }
  }

  Future<void> addItem({required final T model});

  bool isItemExist({required final String name});
}
