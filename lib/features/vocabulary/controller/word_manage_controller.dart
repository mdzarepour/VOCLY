import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';

class WordManageController extends GetxController {
  late WordRepository _wordRepository;
  late WordSelectionController selectionController;
  late FilterController<WordModel> filterController;
  late DialogService _dialogService;

  late ManageWordsScreenType? type;
  late ValueListenable<Box<WordModel>> _wordListenable;

  final RxList<WordModel> _rawWords = <WordModel>[].obs;

  // ================ Reactive Variables =======================================

  final RxList<WordModel> _displayedWords = <WordModel>[].obs;
  List<WordModel> get displayedWords => _displayedWords;

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
    final wordsBox = _wordListenable.value;
    _rawWords.assignAll(wordsBox.values.toList());
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<WordModel> result = filterController.applyFilter(items: _rawWords);
    result.sort((a, b) => filterController.applySort(a, b));
    _displayedWords.assignAll(result);
  }

  Future<Either<AppError, AppSuccess>> deleteWords() async {
    try {
      final bool? permission = await _dialogService.showDialog(
        title: AppStrings.dialogConfirmDeleteTitle,
        content: AppStrings.dialogConfirmDeleteWordsContent,
        confirmTitle: AppStrings.dialogConfirmDeleteAction,
      );
      if (permission == null || permission == false) {
        return left(AppError(errorMessage: 'Permission Denied'));
      }
      _updateLoadingState(value: true);
      await _wordRepository.deleteWords(selectedWords: _getSelectedWords());
      return right(AppSuccess(successMessage: 'Words Deleted!'));
    } on AppError catch (error) {
      return left(AppError(errorMessage: error.errorMessage));
    } finally {
      _updateLoadingState(value: false);
      selectionController.updateSelectionMode(mode: false);
    }
  }

  // ================ Helper Functions =========================================

  void _initControllerEssentials() {
    type = Get.arguments['type'];
  }

  List<WordModel> _getSelectedWords() {
    return selectionController.selectedItems.cast<WordModel>();
  }

  // ================ Navigation ===============================================

  void goToBackWithResult() {
    Get.back(result: _getSelectedWords());
  }

  void goToReadWordScreen({required int key}) {
    Get.toNamed(Routes.readWordScreen, arguments: {'word_key': key});
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();

    _wordRepository = Get.find();
    _dialogService = Get.find();
    filterController = Get.find();
    selectionController = Get.find();

    _wordListenable = _wordRepository.wordValueListenable;
    _wordListenable.addListener(_initWordsList);
    _initWordsList();
    _initControllerEssentials();

    ever(filterController.activeFilters, (_) => _applyFiltersAndSort());
    ever(filterController.sortType, (_) => _applyFiltersAndSort());
  }

  @override
  void onClose() {
    _wordListenable.removeListener(_initWordsList);
    super.onClose();
  }
}
