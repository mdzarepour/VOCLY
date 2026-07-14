import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';

class BookManagerController extends GetxController {
  late BookRepository _bookRepository;

  late BookSelectionController selectionController;
  late FilterController<BookModel> filterController;

  late DialogService _dialogService;

  late ValueListenable<Box<BookModel>> _bookListenable;

  // ================ Reactive Variables =======================================

  final RxList<BookModel> _rawBooks = <BookModel>[].obs;

  final RxList<BookModel> _displayedBooks = <BookModel>[].obs;
  List<BookModel> get displayedBooks => _displayedBooks;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // ================ Ui Functions =============================================

  void _updateLoadingState({required bool value}) {
    _isLoading.value = value;
  }

  // ================ Main Functions ===========================================

  void _initBooksList() {
    final booksBox = _bookListenable.value;
    _rawBooks.assignAll(booksBox.values.toList());
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<BookModel> result = filterController.applyFilter(items: _rawBooks);
    result.sort((a, b) => filterController.applySort(a, b));
    _displayedBooks.assignAll(result);
  }

  Future<Either<AppError, AppSuccess>> deleteBooks() async {
    try {
      final bool? permission = await _dialogService.showDialog(
        title: AppStrings.dialogConfirmDeleteTitle,
        content: AppStrings.dialogConfirmDeleteBooksContent,
        confirmTitle: AppStrings.dialogConfirmDeleteAction,
      );
      if (permission == null || permission == false) {
        return left(const AppError(errorMessage: 'Permision Denied'));
      }
      _updateLoadingState(value: true);
      await _bookRepository.deleteBooks(selectedBooks: _getSelectedBooks());
      return right(const AppSuccess(successMessage: 'Words Deleted!'));
    } catch (error) {
      return left(AppError(errorMessage: error.toString()));
    } finally {
      _updateLoadingState(value: false);
      selectionController.updateSelectionMode(mode: false);
    }
  }

  // ================ Helper Functions =========================================

  List<BookModel> _getSelectedBooks() {
    return selectionController.selectedItems.cast<BookModel>();
  }

  // ================ Navigation ===============================================

  void goToReadBookScreen({required int key}) {
    Get.toNamed(Routes.bookDetailsScreen, arguments: {'book_key': key});
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    super.onInit();

    _bookRepository = Get.find();
    _dialogService = Get.find();
    filterController = Get.find();
    selectionController = Get.find();

    _bookListenable = _bookRepository.bookValueListenable;
    _bookListenable.addListener(_initBooksList);
    _initBooksList();

    ever(filterController.activeFilters, (_) => _applyFiltersAndSort());
    ever(filterController.sortType, (_) => _applyFiltersAndSort());
  }
}
