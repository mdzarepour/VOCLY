import 'package:get/get.dart';
import 'package:vocly/app/common/constants/const_strings.dart';
import 'package:vocly/app/models/entities/spell_char_model.dart';
import 'package:vocly/app/models/entities/word_model.dart';

class SpellingController extends GetxController {
  final Rxn<WordModel> currentWord;
  SpellingController({required this.currentWord});

  final RxString _word = AppStrings.emptyChar.obs;
  String get word => _word.value;

  final RxnBool _accuracy = RxnBool();
  bool? get accuracy => _accuracy.value;

  final RxBool _isPracticeMode = false.obs;
  bool get isPracticeMode => _isPracticeMode.value;

  final RxList<SpellCharModel> _chars = <SpellCharModel>[].obs;
  List<SpellCharModel> get chars => _chars;

  final RxList<SpellCharModel> _selectedChars = <SpellCharModel>[].obs;
  List<SpellCharModel> get selectedChars => _selectedChars;

  void _prepareChars() {
    _updatePracticeMode(value: true);
    _word.value = currentWord.value?.name.trim() ?? AppStrings.emptyChar;

    final List<String> splitWord = _word.split(AppStrings.emptyChar);
    splitWord.shuffle();

    _chars.value = List.generate(splitWord.length, (index) {
      return SpellCharModel(char: splitWord[index], originalIndex: index);
    });
  }

  void _checkAccuracy() {
    _updatePracticeMode(value: false);
    String answer = AppStrings.emptyChar;
    for (var currentChar in _selectedChars) {
      answer += currentChar.char;
    }
    if (answer == _word.value) {
      _updateAccuracy(value: true);
    } else {
      _updateAccuracy(value: false);
    }
  }

  void _updatePracticeMode({required bool value}) {
    _isPracticeMode.value = value;
  }

  void _updateAccuracy({required bool? value}) {
    _accuracy.value = value;
  }

  void unselectChar({required SpellCharModel char}) {
    _selectedChars.remove(char);
    _chars.removeAt(char.originalIndex);
    _chars.insert(char.originalIndex, char);

    if (_selectedChars.length < _word.value.length) {
      _updatePracticeMode(value: true);
      _updateAccuracy(value: null);
    }
  }

  void selectChar({required SpellCharModel char}) {
    if (char.char.isEmpty) return;
    _selectedChars.insert(_selectedChars.length, char);

    _chars[char.originalIndex] = SpellCharModel(
      char: AppStrings.emptyChar,
      originalIndex: char.originalIndex,
    );
    if (_selectedChars.length == _word.value.length) _checkAccuracy();
  }

  void startPractice({required bool isClosed}) {
    if (!isClosed) {
      _endPractice();
    } else {
      _prepareChars();
    }
  }

  void _endPractice() {
    _updatePracticeMode(value: false);
    _updateAccuracy(value: null);
    _selectedChars.clear();
  }
}