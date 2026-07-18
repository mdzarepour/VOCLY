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
  final WordRepository wordRepository;
  final DialogService dialogService;
  final WordScreenType type;
  final int? wordKey;

  WordCrudController({
    this.wordKey,
    required this.type,
    required this.dialogService,
    required this.wordRepository,
  });

  WordModel? editingWord;

  // ================ Form Key =================================================

  final formKey = GlobalKey<FormState>();

  // ================ Text Editing Controllers =================================

  final nameController = TextEditingController();
  final meaningController = TextEditingController();
  final exampleController = TextEditingController();

  // ================ Reactive Variables =======================================

  final RxMap<String, int> _properties = <String, int>{}.obs;
  Map<String, int> get properties => _properties;

  // ================ Ui Functions =============================================

  void updateProperty({required String key, required int value}) {
    _properties[key] = value;
  }

  // ================ Main Functions ===========================================

  Future<Either<AppError, AppSuccess>> addWord() async {
    try {
      final word = WordModel.fromMap(map: _createMap());
      final isExist = _isWordExist(name: word.name);

      if (isExist) {
        final bool permission = await dialogService.showDialog(
          title: AppStrings.dialogDuplicatedWordTitle,
          content: AppStrings.dialogDuplicatedWordContent,
          confirmTitle: AppStrings.dialogDuplicatedWordConfirm,
        );
        if (!permission) {
          return left(const AppError(errorMessage: 'Permission Denied'));
        }
      }
      await wordRepository.addWord(word: word);
      return right(
        AppSuccess(successMessage: '${word.name.capitalizeFirst} Added'),
      );
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    }
  }

  bool _isWordExist({required final String name}) {
    try {
      return wordRepository.isWordExist(name: name);
    } catch (error) {
      return false;
    }
  }

  Future<Either<AppError, AppSuccess>> updateWord() async {
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
      await wordRepository.updateWord(
        key: editingWord!.key as int,
        word: updatedWord,
      );
      return right(const AppSuccess(successMessage: 'updated')); 
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage)); 
    }
  }

  void _initControllerEssentials() {
    if (type == WordScreenType.addWord) return;

    final box = wordRepository.wordListenable.value;
    editingWord = box.get(wordKey);

    if (editingWord != null) {
      nameController.text = editingWord!.name;
      meaningController.text = editingWord!.meaning;
      exampleController.text = editingWord!.example;

      _properties[AppStrings.keyIcon] = editingWord!.icon;
      _properties[AppStrings.keyType] = editingWord!.type;
      _properties[AppStrings.keyColor] = editingWord!.color;
      _properties[AppStrings.keyLevel] = editingWord!.level;
    }
  }

  // ================ Helper Functions =========================================

  Map<String, dynamic> _createMap() {
    return {
      AppStrings.keyName: nameController.text,
      AppStrings.keyMeaning: meaningController.text,
      AppStrings.keyExample: exampleController.text,
      AppStrings.keyIcon: _properties[AppStrings.keyIcon] ?? 0,
      AppStrings.keyType: _properties[AppStrings.keyType] ?? 0,
      AppStrings.keyColor: _properties[AppStrings.keyColor] ?? 0,
      AppStrings.keyLevel: _properties[AppStrings.keyLevel] ?? 0,
    };
  }

  // ================ Navigation ===============================================

  void goToBack() => Get.back();

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
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
