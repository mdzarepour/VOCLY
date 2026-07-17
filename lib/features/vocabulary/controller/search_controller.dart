import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class WordSearchController extends GetxController {
  final WordRepository wordRepository;

  WordSearchController({required this.wordRepository});

  late ValueListenable<Box<WordModel>> _wordListenable;

  // ================ Reactive Variables =======================================

  final RxString _query = AppStrings.emptyChar.obs;
  String get query => _query.value;

  final RxList<WordModel> _rawWords = <WordModel>[].obs;
  List<WordModel> get words => _rawWords;

  // ================ Text Editing Controller ==================================

  final queryController = TextEditingController();

  // ================ Main Functions ===========================================

  void _initWordsList() {
    final wordsBox = _wordListenable.value;
    _rawWords.assignAll(wordsBox.values.toList());
  }

  void updateQuery({required String value}) {
    _query.value = value;
  }

  void _updateWordsList() {
    _rawWords.assignAll(wordRepository.searchWords(query: _query.value));
  }

  // ================ Navigation ===============================================

  void goToReadWordScreen({required int key}) {
    Get.toNamed(Routes.wordDetailsScreen, arguments: {'word_key': key});
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    _wordListenable = wordRepository.wordListenable;
    _wordListenable.addListener(_initWordsList);
    _initWordsList();

    ever(_query, (_) => _updateWordsList());
  }

  @override
  void onClose() {
    super.onClose();
    _wordListenable.removeListener(_initWordsList);
    _query.value = AppStrings.emptyChar;

    queryController.dispose();
  }
}
