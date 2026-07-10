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
    final wordsBox = _wordListenable.value;
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
  }

  @override
  void onClose() {
    super.onClose();
    filterController.deleteFilters();
    _wordListenable.removeListener(_initWordsList);
  }
}
