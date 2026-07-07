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
  late final WordScreenType wordScreenType;

  // ================ Form Key =================================================

  final formKey = GlobalKey<FormState>();

  // ================ Text Editing Controllers =================================

  final nameController = TextEditingController();
  final meaningController = TextEditingController();
  final exampleController = TextEditingController();

  // ================ Reactive Variables =======================================

  final Rxn<WordModel> _currentWord = Rxn<WordModel>();
  WordModel? get currentWord => _currentWord.value;

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
      final map = _createMap();
      final WordModel word = WordModel.fromMap(map);
      final isWordExist = _isWordExist(name: word.name);

      if (!isWordExist) {
        await _wordRepository.addWord(word: word);
      }
      final bool? permission = await _dialogService.showDialog(
        title: AppStrings.dialogDuplicatedWordTitle,
        content: AppStrings.dialogDuplicatedWordContent,
        confirmTitle: AppStrings.dialogDuplicatedWordConfirm,
      );
      if (permission!) {
        await _wordRepository.addWord(word: word);
      } else {
        Get.back();
      }
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
      _currentWord.value!.updateWordModel(map: map);
      await _wordRepository.updateWord(word: _currentWord.value!);
      return right(
        AppSuccess(successMessage: '${_currentWord.value!.name} updated'),
      );
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    }
  }

  // ================ Helper Functions =========================================

  Map<String, dynamic> _createMap() {
    Map<String, dynamic> map = {};
    if (formKey.currentState!.validate()) {
      map = {
        AppStrings.keyName: nameController.text,
        AppStrings.keyMeaning: meaningController.text,
        AppStrings.keyExample: exampleController.text,
        AppStrings.keyIcon: _selectedIconIndex,
        AppStrings.keyType: _selectedTypeIndex,
        AppStrings.keyColor: _selectedColorIndex,
        AppStrings.level: _selectedLevelIndex,
      };
    }
    return map;
  }

  Future<Either<AppError, AppSuccess>> handleAction() async {
    if (wordScreenType == WordScreenType.addWord) {
      return await _addWord();
    } else {
      return await _updateWord();
    }
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    wordScreenType = Get.arguments;
    _wordRepository = Get.find();
    _dialogService = Get.find();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    exampleController.dispose();
    meaningController.dispose();
  }
}
