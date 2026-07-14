import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/speech_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/controllers/spelling_controller.dart';

class WordDetailsController extends GetxController {
  late WordRepository _wordRepository;

  late SpeechService _speechService;
  late SpellingController spellingController;

  late ValueListenable<Box<WordModel>> _wordListenable;

  // ================ Reactive Variables =======================================

  final Rxn<WordModel> _word = Rxn<WordModel>();
  WordModel? get word => _word.value;

  // ================ Speech Service Functions =================================

  void listenToWord() {
    _speechService.speak(text: _word.value!.name.toLowerCase());
  }

  // ================ Main Functions ===========================================

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

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    _wordRepository = Get.find();
    _speechService = Get.find();
    spellingController = Get.find();

    _wordListenable = _wordRepository.wordValueListenable;
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
