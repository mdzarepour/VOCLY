import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';

class WordManageController extends GetxController {
  // ================ Dependencies =============================================

  late final WordRepository _wordRepository;

  late final WordSelectionController _selectionController;
  late final FilterController _filterController;

  late final DialogService _dialogService;

  late final ValueListenable<Box<WordModel>> _hiveListenable;
  late final ManageWordsScreenType type;

  // ================ Reactive Variables =======================================

  final RxList<WordModel> _words = <WordModel>[].obs;
  List<WordModel> get words => _words;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isGridLayout = false.obs;
  bool get isGridLayout => _isGridLayout.value;

  // ================ Ui Functions =============================================

  void _updateLoadingState({required bool value}) {
    _isLoading.value = value;
  }

  void changeScreenLayout() {
    _isGridLayout.value = !_isGridLayout.value;
  }

  // ================ Main Functions ===========================================

  void _initWordsList() {
    final wordsBox = _hiveListenable.value;
    final List<WordModel> freshList = wordsBox.values.toList();
    _words.assignAll(freshList);
  }

  Future<Either<AppError, AppSuccess>> deleteWords() async {
    try {
      final bool? permission = await _dialogService.showDialog(
        title: AppStrings.dialogConfirmDeleteTitle,
        content: AppStrings.dialogConfirmDeleteWordsContent,
        confirmTitle: AppStrings.dialogConfirmDeleteAction,
      );
      if (permission == null || permission == false) {
        return left(AppError(errorMessage: 'Permision Denied'));
      }
      _updateLoadingState(value: true);
      await _wordRepository.deleteWords(selectedWords: getSelectedWords());
      return right(AppSuccess(successMessage: 'Words Deleted!'));
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    } finally {
      _updateSelectionMode(mode: false);
      _updateLoadingState(value: false);
    }
  }

  // ================ Selection Controller Functions ===========================

  IconData get selectionButtonIcon {
    return _selectionController.selectButtonIcon;
  }

  bool get isSelectionMode {
    return _selectionController.isSelectionMode;
  }

  List<WordModel> getSelectedWords() {
    return _selectionController.selectedItems.cast<WordModel>();
  }

  bool isWordSelected({required WordModel word}) {
    return _selectionController.isSelected(item: word);
  }

  void startSelection({required WordModel word}) {
    _selectionController.changeSelectionMode(item: word);
  }

  void selectWord({required WordModel word}) {
    _selectionController.selectItem(item: word);
  }

  void selectAllWords() {
    _selectionController.selectAllItems(currentSelectedItems: _words);
  }

  void _updateSelectionMode({required bool mode}) {
    _selectionController.updateSelectionMode(mode: mode);
  }

  // ================ Filter Controller Functions ==============================

  void selectFilter({required FilterType type, required int filterItem}) {
    _filterController.selectFilter(type: type, filterItem: filterItem);
  }

  bool isFilterSelected({required FilterType type, required int filterItem}) {
    return _filterController.isFilterSelected(
      type: type,
      filterItem: filterItem,
    );
  }

  // ================ Navigation ===============================================

  void goToBackWithResult() => Get.back(result: getSelectedWords());

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments;
    _wordRepository = Get.find();
    _dialogService = Get.find();
    _filterController = Get.find();
    _selectionController = Get.find();

    _hiveListenable = _wordRepository.wordValueListenable;
    _hiveListenable.addListener(_initWordsList);
    _initWordsList();
  }

  @override
  void onClose() {
    super.onClose();
    _hiveListenable.removeListener(_initWordsList);
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