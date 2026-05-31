import 'package:get/get.dart';
import 'package:vocly/vocabulary/controller/word_controller.dart';
import 'package:vocly/vocabulary/model/spell_char_model.dart';

class SpellingController extends GetxController {
  final WordController wordController;
  SpellingController({required this.wordController});

  String word = '';
  bool? accuracy;
  bool isPracticeMode = false;

  List<SpellCharModel> chars = [];
  List<SpellCharModel> selectedChars = [];

  void _initSpellingEssentials() {
    _updatePracticeMode(value: true);
    word = wordController.currentItem?.name ?? word;

    if (word.isNotEmpty) {
      final List<String> splitWord = word.split('');
      splitWord.shuffle();

      chars = List.generate(
        splitWord.length,
        (index) => SpellCharModel(char: splitWord[index], originalIndex: index),
      );
    }
    update();
  }

  void _endPractice() {
    _updatePracticeMode(value: false);
    _updateAccuracy(value: null);
    selectedChars.clear();
    update();
  }

  void _checkAccuracy() {
    _updatePracticeMode(value: false);
    String answer = '';
    for (var currentChar in selectedChars) {
      answer += currentChar.char;
    }

    if (answer == word) {
      _updateAccuracy(value: true);
    } else {
      _updateAccuracy(value: false);
    }
    update();
  }

  void _updatePracticeMode({required final bool value}) {
    isPracticeMode = value;
  }

  void _updateAccuracy({required final bool? value}) {
    accuracy = value;
  }

  void unselectChar({required SpellCharModel char}) {
    if (char.char.isEmpty) return;
    selectedChars.remove(char);
    chars.removeAt(char.originalIndex);
    chars.insert(char.originalIndex, char);

    if (selectedChars.length < word.length) {
      _updatePracticeMode(value: true);
      _updateAccuracy(value: null);
    }
    update();
  }

  void selectChar({required final SpellCharModel char}) {
    if (char.char.isEmpty) return;

    selectedChars.insert(selectedChars.length, char);
    chars.removeAt(char.originalIndex);
    chars.insert(
      char.originalIndex,
      SpellCharModel(char: '', originalIndex: char.originalIndex),
    );

    if (selectedChars.length == word.length) {
      _checkAccuracy();
    }
    update();
  }

  void startSpellingPractice({required final bool isClosed}) {
    if (!isClosed) {
      _endPractice();
    } else {
      _initSpellingEssentials();
    }
  }
}
