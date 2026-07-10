import 'package:get/get.dart';
import 'package:vocly/features/vocabulary/model/entities/spell_char_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/shared/constants/const_strings.dart';

class SpellingController extends GetxController {
  // ================ Reactive Variables =======================================

  final RxString _wordName = AppStrings.emptyChar.obs;
  String get wordName => _wordName.value;

  final RxnBool _accuracy = RxnBool();
  bool? get accuracy => _accuracy.value;

  final RxBool _isPracticeMode = false.obs;
  bool get isPracticeMode => _isPracticeMode.value;

  final RxList<SpellCharModel> _chars = <SpellCharModel>[].obs;
  List<SpellCharModel> get chars => _chars;

  final RxList<SpellCharModel> _selectedChars = <SpellCharModel>[].obs;
  List<SpellCharModel> get selectedChars => _selectedChars;

  // ================ Main Functions ===========================================

  /// [Logic - Details Controller] Get the target word to be spelled
  void loadCurrentWord({required WordModel word}) {
    _wordName.value = word.name.trim();
  }

  /// [Internal Logic] Prepares, shuffles, and indexes characters for spelling
  void _startPractice() {
    _updatePracticeMode(value: true);
    final tempChars =
        _wordName.value
            .split('')
            .map((char) => SpellCharModel(char: char, originalIndex: 0))
            .toList()
          ..shuffle();
    for (int i = 0; i < tempChars.length; i++) {
      tempChars[i].originalIndex = i;
    }
    _chars.assignAll(tempChars);
  }

  /// [Internal Logic] Compares user's answer with the target word
  void _checkAccuracy() {
    _updatePracticeMode(value: false);
    final answer = _selectedChars.map((e) => e.char).join();
    _updateAccuracy(value: answer == _wordName.value);
  }

  /// [UI - Character Tap] Removes a character from pool and restores it
  void unselectChar({
    required SpellCharModel char,
    required int selectedIndex,
  }) {
    _selectedChars.removeAt(selectedIndex);
    _chars[char.originalIndex] = char;
    if (_selectedChars.length < _wordName.value.length) {
      _updatePracticeMode(value: true);
      _updateAccuracy(value: null);
    }
  }

  /// [UI - Character Tap] Moves a character from the pool to the input selections
  void selectChar({required SpellCharModel char}) {
    if (char.char.isEmpty) return;
    _selectedChars.add(char);
    _chars[char.originalIndex] = SpellCharModel(
      char: '',
      originalIndex: char.originalIndex,
    );
    if (_selectedChars.length == _wordName.value.length) _checkAccuracy();
  }

  /// [Internal Logic] Resets practice state and clears all selected chars
  void _endPractice() {
    _isPracticeMode.value = false;
    _updateAccuracy(value: null);
    _selectedChars.clear();
  }

  // ================ Helper Functions =========================================

  void _updatePracticeMode({required bool value}) {
    _isPracticeMode.value = value;
  }

  void _updateAccuracy({required bool? value}) {
    _accuracy.value = value;
  }

  /// [UI - Action Button] Toggles practice state based on active mode
  /// isPractice will be true if ExpansionTile is expanded
  void handleAction({required bool isPractice}) {
    if (isPractice) {
      _startPractice();
    } else {
      _endPractice();
    }
  }
}
