import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';

class BookManageController extends GetxController {
  late final BookRepository _bookRepository;

  late final BookSelectionController _selectionController;
  late final FilterController _filterController;

  late final DialogService _dialogService;

  late final ValueListenable<Box<BookModel>> _hiveListenable;

  // ================ Reactive Variables =======================================

  final RxList<BookModel> _books = <BookModel>[].obs;
  List<BookModel> get books => _books;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // ================ Ui Functions =============================================

  void _updateLoadingState({required bool value}) {
    _isLoading.value = value;
  }

  // ================ Ui Functions =============================================

  void _initBooksList() {
    final booksBox = _hiveListenable.value;
    final List<BookModel> freshList = booksBox.values.toList();
    _books.assignAll(freshList);
  }

  Future<Either<AppError, AppSuccess>> deleteBooks() async {
    try {
      final bool? permission = await _dialogService.showDialog(
        title: AppStrings.dialogConfirmDeleteTitle,
        content: AppStrings.dialogConfirmDeleteBooksContent,
        confirmTitle: AppStrings.dialogConfirmDeleteAction,
      );
      if (permission == null || permission == false) {
        return left(AppError(errorMessage: 'Permision Denied'));
      }
      _updateLoadingState(value: true);
      await _bookRepository.deleteBooks(selectedBooks: getSelectedBooks());
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

  List<BookModel> getSelectedBooks() {
    return _selectionController.selectedItems.cast<BookModel>();
  }

  bool isBookSelected({required BookModel book}) {
    return _selectionController.isSelected(item: book);
  }

  void startSelection({required BookModel book}) {
    _selectionController.startSelecting(item: book);
  }

  void selectBook({required BookModel book}) {
    _selectionController.selectItem(item: book);
  }

  void selectAllBooks() {
    _selectionController.selectAllItems(currentSelectedItems: _books);
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

  void goToReakBookScreen({required BookModel book}) {
    Get.toNamed(Routes.readBookScreen, arguments: book);
  }

  // ================ Life Cycle ===============================================

  @override
  void onInit() {
    super.onInit();
    _bookRepository = Get.find();
    _dialogService = Get.find();
    _filterController = Get.find();
    _selectionController = Get.find();

    _hiveListenable = _bookRepository.bookValueListenable;
    _hiveListenable.addListener(_initBooksList);
    _initBooksList();
  }
}
