import 'package:get/get.dart';
import 'package:vocly/app/models/entities/word_model.dart';
import 'package:vocly/app/models/repositories/vocabulary_repository.dart';
import 'package:vocly/app/core/enums/enums.dart';

class WordController extends GetxController {
  final WordRepository wordRepository;

  WordController({required this.wordRepository});

  final Rx<SortType> _sortType = SortType.newest.obs;
  final RxList<int> _colorFilters = <int>[].obs;
  final RxList<int> _iconFilters = <int>[].obs;
  final RxList<int> _typeFilters = <int>[].obs;
  final RxList<int> _levelFilters = <int>[].obs;

  final Rxn<WordModel> _currentWord = Rxn<WordModel>();
  WordModel? get currentWord => _currentWord.value;
  Rxn<WordModel> get currentWordRx => _currentWord;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  void _updateLoadingState({required bool value}) {
    _isLoading.value = value;
  }

  final RxList<WordModel> _words = <WordModel>[].obs;
  List<WordModel> get words {
    final filteredWords = _words.where(_matchesFilters).toList();
    filteredWords.sort(_compareBySortType);
    return filteredWords;
  }

  // used by selection controller -->
  List<WordModel> get items => _words;

  // filtering operations -->
  bool _matchesFilters(WordModel word) {
    if (_colorFilters.isNotEmpty && !_colorFilters.contains(word.color)) {
      return false;
    }
    if (_iconFilters.isNotEmpty && !_iconFilters.contains(word.icon)) {
      return false;
    }
    if (_typeFilters.isNotEmpty && !_typeFilters.contains(word.type)) {
      return false;
    }
    if (_levelFilters.isNotEmpty && !_levelFilters.contains(word.level)) {
      return false;
    }

    return true;
  }

  int _compareBySortType(WordModel a, WordModel b) {
    switch (_sortType.value) {
      case SortType.oldest:
        return int.parse(a.createAt).compareTo(int.parse(b.createAt));
      case SortType.newest:
        return int.parse(b.createAt).compareTo(int.parse(a.createAt));
      case SortType.aToZ:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case SortType.zToA:
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
    }
  }

  void selectSort({required SortType sortType}) {
    _sortType.value = sortType;
  }

  bool isSortSelected({required SortType sortType}) {
    return _sortType.value == sortType;
  }

  void selectFilters({required FilterType type, required int filterItem}) {
    switch (type) {
      case FilterType.color:
        return _toggleFilterItem(_colorFilters, filterItem);
      case FilterType.icon:
        return _toggleFilterItem(_iconFilters, filterItem);
      case FilterType.type:
        return _toggleFilterItem(_typeFilters, filterItem);
      case FilterType.level:
        return _toggleFilterItem(_levelFilters, filterItem);
    }
  }

  bool isFilterSelected({required FilterType type, required int filterItem}) {
    switch (type) {
      case FilterType.color:
        return _colorFilters.contains(filterItem);
      case FilterType.icon:
        return _iconFilters.contains(filterItem);
      case FilterType.type:
        return _typeFilters.contains(filterItem);
      case FilterType.level:
        return _levelFilters.contains(filterItem);
    }
  }

  void _toggleFilterItem(RxList<int> filterList, int item) {
    if (filterList.contains(item)) {
      filterList.remove(item);
    } else {
      filterList.add(item);
    }
  }

  void deleteFilters() {
    _colorFilters.clear();
    _iconFilters.clear();
    _typeFilters.clear();
    _levelFilters.clear();
  }

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  // crud operations -->
   loadItems() {
    try {
      final freshWords = wordRepository.getAllWords();
      _words.assignAll(freshWords);
    } catch (error) {
      Get.snackbar('Failed!', error.toString());
    }
  }

  Future<void> deleteWords({required List<WordModel> selectedWords}) async {
    try {
      _updateLoadingState(value: true);
      await wordRepository.deleteWords(selectedWords: selectedWords);
      loadItems();
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
    } finally {
      _updateLoadingState(value: false);
    }
  }

  Future<void> updateCurrentWord({required WordModel newWord}) async {
    try {
      await wordRepository.updateWord(word: newWord);
      _currentWord.value = newWord;
      _currentWord.refresh();
      loadItems();
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
    }
  }

  Future<void> addWord({required WordModel word}) async {
    try {
      await wordRepository.addWord(word: word);
      loadItems();
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
    }
    Get.back();
  }

  Future<bool> isWordExist({required final String name}) async{
    try {
      return wordRepository.isWordExist(name: name);
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
      return false;
    }
  }
}
