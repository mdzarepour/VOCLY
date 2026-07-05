import 'package:get/get.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

class WordController extends GetxController {
  final WordRepository wordRepository;

  WordController({required this.wordRepository});

  final Rxn<WordModel> _currentWord = Rxn<WordModel>();
  WordModel? get currentWord => _currentWord.value;
  Rxn<WordModel> get currentWordRx => _currentWord;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  void _updateLoadingState({required bool value}) {
    _isLoading.value = value;
  }

  final RxList<WordModel> _words = <WordModel>[].obs;
  List<WordModel> get words => _words;

  void loadItems() {
    try {
      final freshWords = wordRepository.getAllWords();
      _words.assignAll(freshWords);
    } catch (error) {
    //  Get.snackbar('Failed!', _errorMessage(error));
    }
  }

  Future<void> deleteWords({required List<WordModel> selectedWords}) async {
    try {
      _updateLoadingState(value: true);
      await wordRepository.deleteWords(selectedWords: selectedWords);
    } catch (error) {
    //  Get.snackbar('Oops!', _errorMessage(error));
    } finally {
      loadItems();
      _updateLoadingState(value: false);
    }
  }

  Future<void> updateCurrentWord({required WordModel newWord}) async {
    try {
      await wordRepository.updateWord(word: newWord);
      _currentWord.value = newWord;
      _currentWord.refresh();
    } catch (error) {
    //  Get.snackbar('Oops!', _errorMessage(error));
    } finally {
      loadItems();
    }
  }

  Future<void> addWord({required Map<String, dynamic> map}) async {
    try {
      final WordModel word = WordModel.fromMap(map);
      await wordRepository.addWord(word: word);
    } catch (error) {
    //  Get.snackbar('Oops!', _errorMessage(error));
    } finally {
      loadItems();
      Get.back();
    }
  }

  Future<bool> isWordExist({required final String name}) async {
    try {
      return wordRepository.isWordExist(name: name);
    } catch (error) {
   //   Get.snackbar('Oops!', _errorMessage(error));
      return false;
    }
  }
  // ================ Life Cycle =====================
  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  @override
  void dispose() {
    super.dispose();
  }
}




































  // final filteredWords = _words.where(_matchesFilters).toList();
  // filteredWords.sort(_compareBySortType);

  // used by selection controller -->
  // filtering operations -->
  // bool _matchesFilters(WordModel word) {
  //   if (_colorFilters.isNotEmpty && !_colorFilters.contains(word.color)) {
  //     return false;
  //   }
  //   if (_iconFilters.isNotEmpty && !_iconFilters.contains(word.icon)) {
  //     return false;
  //   }
  //   if (_typeFilters.isNotEmpty && !_typeFilters.contains(word.type)) {
  //     return false;
  //   }
  //   if (_levelFilters.isNotEmpty && !_levelFilters.contains(word.level)) {
  //     return false;
  //   }

  //   return true;
  // }