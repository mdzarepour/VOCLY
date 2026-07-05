import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class WordSearchController extends GetxController {
  late final WordRepository wordRepository;

  // ================ Reactive Variables =======================================

  final RxString _query = AppStrings.emptyChar.obs;
  String get query => _query.value;

  final RxList<WordModel> _words = <WordModel>[].obs;
  List<WordModel> get words => _words;

  // ================ Text Editing Controller ==================================

  final queryController = TextEditingController();

  // ================ Handle Query Chenges =====================================

  void updateQuery({required String value}) {
    _query.value = value;
    _words.assignAll(wordRepository.searchWords(query: _query.value));
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    wordRepository = Get.find();
    _words.value = wordRepository.getAllWords();
  }

  @override
  void onClose() {
    super.onClose();
    queryController.dispose();
    _query.value = AppStrings.emptyChar;
  }
}
