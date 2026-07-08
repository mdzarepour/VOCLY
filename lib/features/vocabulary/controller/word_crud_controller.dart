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
  late final WordRepository _wordRepository;
  late final DialogService _dialogService;

  late WordScreenType? wordScreenType;
  late WordModel? currentWord;

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

      if (!isExist) {
        final bool? permission = await _dialogService.showDialog(
          title: AppStrings.dialogDuplicatedWordTitle,
          content: AppStrings.dialogDuplicatedWordContent,
          confirmTitle: AppStrings.dialogDuplicatedWordConfirm,
        );
        if (permission == null || !permission) {
          return left(AppError(errorMessage: 'Permission Denied'));
        }
      }
      await _wordRepository.addWord(word: word);
      return right(AppSuccess(successMessage: '${word.name} added'));
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
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
      currentWord!.updateWord(map: map);
      await _wordRepository.updateWord(word: currentWord!);
      return right(AppSuccess(successMessage: '${currentWord!.name} updated'));
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    }
  }

  // ================ Helper Functions =========================================

  Map<String, dynamic> _createMap() {
    Map<String, dynamic> map = {};
    map = {
      AppStrings.keyName: nameController.text,
      AppStrings.keyMeaning: meaningController.text,
      AppStrings.keyExample: exampleController.text,
      AppStrings.keyIcon: _selectedIconIndex.value,
      AppStrings.keyType: _selectedTypeIndex.value,
      AppStrings.keyColor: _selectedColorIndex.value,
      AppStrings.keyLevel: _selectedLevelIndex.value,
    };
    return map;
  }

  void _initControllerEssentials() {
    wordScreenType = Get.arguments['type'];
    if (wordScreenType == WordScreenType.addWord) {
      return;
    }
    currentWord = Get.arguments['word'];

    nameController.text = currentWord!.name;
    meaningController.text = currentWord!.meaning;
    exampleController.text = currentWord!.example;

    _selectedIconIndex.value = currentWord!.icon;
    _selectedTypeIndex.value = currentWord!.type;
    _selectedColorIndex.value = currentWord!.color;
    _selectedLevelIndex.value = currentWord!.level;
  }

  Future<Either<AppError, AppSuccess>> handleAction() async {
    if (formKey.currentState!.validate()) {
      if (wordScreenType == WordScreenType.addWord) {
        return await _addWord();
      } else {
        return await _updateWord();
      }
    }
    return left(AppError(errorMessage: 'Please Fill Inputs First'));
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
