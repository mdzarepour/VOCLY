import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class WordCrudController extends GetxController {
  late WordRepository _wordRepository;
  late DialogService _dialogService;

  late WordScreenType? type;
  late WordModel? editingWord;

  // ================ Form Key =================================================

  final formKey = GlobalKey<FormState>();

  // ================ Text Editing Controllers =================================

  final nameController = TextEditingController();
  final meaningController = TextEditingController();
  final exampleController = TextEditingController();

  // ================ Reactive Variables =======================================

  final RxInt _selectedIconIndex = 0.obs;
  int get selectedIconIndex => _selectedIconIndex.value;

  final RxInt _selectedTypeIndex = 0.obs;
  int get selectedTypeIndex => _selectedTypeIndex.value;

  final RxInt _selectedColorIndex = 0.obs;
  int get selectedColorIndex => _selectedColorIndex.value;

  final RxInt _selectedLevelIndex = 0.obs;
  int get selectedLevelIndex => _selectedLevelIndex.value;

  // ================ Ui Functions ===========================================

  void updateSelectedIcon({required int value}) {
    _selectedIconIndex.value = value;
  }

  void updateSelectedType({required int value}) {
    _selectedTypeIndex.value = value;
  }

  void updateSelectedColor({required int value}) {
    _selectedColorIndex.value = value;
  }

  void updateSelectedLevel({required int value}) {
    _selectedLevelIndex.value = value;
  }

  // ================ Crud Functions ===========================================

  Future<Either<AppError, AppSuccess>> _addWord() async {
    try {
      final word = WordModel.fromMap(map: _createMap());
      final isExist = _isWordExist(name: word.name);

      if (isExist) {
        final bool? permission = await _dialogService.showDialog(
          title: AppStrings.dialogDuplicatedWordTitle,
          content: AppStrings.dialogDuplicatedWordContent,
          confirmTitle: AppStrings.dialogDuplicatedWordConfirm,
        );
        if (permission == null || !permission) {
          return left(const AppError(errorMessage: 'Permission Denied'));
        }
      }
      await _wordRepository.addWord(word: word);
      return right(
        AppSuccess(successMessage: '${word.name.capitalizeFirst} Added'),
      );
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  bool _isWordExist({required final String name}) {
    try {
      return _wordRepository.isWordExist(name: name);
    } catch (error) {
      return false;
    }
  }

  Future<Either<AppError, AppSuccess>> _updateWord() async {
    try {
      final Map<String, dynamic> map = _createMap();
      final updatedWord = editingWord!.copyWith(
        name: map[AppStrings.keyName],
        meaning: map[AppStrings.keyMeaning],
        example: map[AppStrings.keyExample],
        icon: map[AppStrings.keyIcon],
        type: map[AppStrings.keyType],
        color: map[AppStrings.keyColor],
        level: map[AppStrings.keyLevel],
      );
      await _wordRepository.updateWord(
        key: editingWord!.key as int,
        word: updatedWord,
      );
      return right(AppSuccess(successMessage: '${editingWord!.name} updated'));
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  // ================ Helper Functions =========================================

  Map<String, dynamic> _createMap() {
    return {
      AppStrings.keyName: nameController.text,
      AppStrings.keyMeaning: meaningController.text,
      AppStrings.keyExample: exampleController.text,
      AppStrings.keyIcon: _selectedIconIndex.value,
      AppStrings.keyType: _selectedTypeIndex.value,
      AppStrings.keyColor: _selectedColorIndex.value,
      AppStrings.keyLevel: _selectedLevelIndex.value,
    };
  }

  void _initControllerEssentials() {
    type = Get.arguments['type'];
    if (type == WordScreenType.addWord) return;

    final int wordKey = Get.arguments['word_key'];
    final box = _wordRepository.wordValueListenable.value;
    editingWord = box.get(wordKey);

    if (editingWord != null) {
      nameController.text = editingWord!.name;
      meaningController.text = editingWord!.meaning;
      exampleController.text = editingWord!.example;

      _selectedIconIndex.value = editingWord!.icon;
      _selectedTypeIndex.value = editingWord!.type;
      _selectedColorIndex.value = editingWord!.color;
      _selectedLevelIndex.value = editingWord!.level;
    }
  }

  Future<Either<AppError, AppSuccess>> handleAction() async {
    if (formKey.currentState!.validate()) {
      if (type == WordScreenType.addWord) {
        return await _addWord();
      } else {
        return await _updateWord();
      }
    }
    return left(const AppError(errorMessage: 'Please Fill Inputs First'));
  }

  // ================ Navigation ===============================================

  void goToBack() => Get.back();

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    _wordRepository = Get.find();
    _dialogService = Get.find();
    _initControllerEssentials();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    exampleController.dispose();
    meaningController.dispose();
  }
}
