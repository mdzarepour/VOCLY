import 'package:get/get.dart';
import 'package:vocly/app/common/constants/const_strings.dart';
import 'package:vocly/app/models/entities/word_model.dart';

class WordSearchController extends GetxController {
  final List<WordModel> Function() providedWords;
  WordSearchController({required this.providedWords});

  final RxString _query = AppStrings.emptyChar.obs;
  String get query => _query.value;

  final RxList<WordModel> _words = <WordModel>[].obs;

  void updateQuery({required String value}) {
    _query.value = value;
  }

  List<WordModel> get words {
    _words.value = providedWords();
    if (_query.value == AppStrings.emptyChar) return _words;

    _words.value = _words.where((currentWord) {
      final query = _query.value.toLowerCase();
      final name = currentWord.name.toLowerCase();
      final example = currentWord.example.toLowerCase();

      return name.contains(query) || example.contains(query);
    }).toList();
    return _words;
  }

  @override
  void onClose() {
    super.onClose();
    _query.value = AppStrings.emptyChar;
  }
}
