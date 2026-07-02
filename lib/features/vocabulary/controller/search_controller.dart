import 'package:get/get.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class WordSearchController extends GetxController {
  final WordRepository wordRepository;

  WordSearchController({required this.wordRepository});

  final RxString _query = AppStrings.emptyChar.obs;
  String get query => _query.value;

  final RxList<WordModel> _words = <WordModel>[].obs;

  void updateQuery({required String value}) {
    _query.value = value;
  }

  List<WordModel> get words {
    final currentWords = wordRepository.getAllWords();
    _words.assignAll(
      wordRepository.searchWords(words: currentWords, query: _query.value),
    );
    return _words;
  }

  @override
  void onClose() {
    super.onClose();
    _query.value = AppStrings.emptyChar;
  }
}
