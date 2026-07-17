import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/services/speech_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/controllers/spelling_controller.dart';

class WordDetailsController extends GetxController {
  final WordRepository wordRepository;
  final SpellingController spellingController;
  final SpeechService speechService;
  final DialogService dialogService;

  WordDetailsController({
    required this.dialogService,
    required this.speechService,
    required this.spellingController,
    required this.wordRepository,
  });

  late ValueListenable<Box<WordModel>> _wordListenable;

  // ================ Reactive Variables =======================================

  final Rxn<WordModel> _word = Rxn<WordModel>();
  WordModel? get word => _word.value;

  // ================ Speech Service Functions =================================

  void listenToWord() {
    speechService.speak(text: _word.value!.name.toLowerCase());
  }

  // ================ Main Functions ===========================================

  Future<Either<AppError, AppSuccess>> deleteWord() async {
    try {
      final bool? permission = await dialogService.showDialog(
        title: AppStrings.dialogConfirmDeleteTitle,
        content: AppStrings.dialogConfirmDeleteWordsContent,
        confirmTitle: AppStrings.dialogConfirmDeleteAction,
      );
      if (permission == null || permission == false) {
        return left(const AppError(errorMessage: 'Permision Denied'));
      }
      await wordRepository.deleteWords(selectedWords: [_word.value!]);
      return right(AppSuccess(successMessage: '${_word.value!.name} deleted'));
    } on HiveError catch (error) {
      return left(AppError(errorMessage: error.message));
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    }
  }

  void _initWord() {
    final key = Get.arguments['word_key'];
    final box = _wordListenable.value;
    final updatedData = box.get(key);

    if (updatedData != null) {
      _word.value = updatedData;
      spellingController.loadCurrentWord(word: updatedData);
    }
  }

  // ================ Navigation ===============================================

  void goToAddEditWordScreen() {
    Get.toNamed(
      Routes.wordCrudScreen,
      arguments: {
        'type': WordScreenType.editWord,
        'word_key': Get.arguments['word_key'],
      },
    );
  }

  void goToBack() {
    Get.back();
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();

    _wordListenable = wordRepository.wordListenable;
    _wordListenable.addListener(_initWord);
    _initWord();
  }

  @override
  void onClose() {
    super.onClose();
    _wordListenable.removeListener(_initWord);
    _word.value = null;
  }
}
