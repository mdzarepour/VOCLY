import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/app/common/widgets/filter_button.dart';
import 'package:vocly/app/common/widgets/filter_sheet_widget.dart';
import 'package:vocly/app/common/widgets/sort_sheet_widget.dart';
import 'package:vocly/app/controllers/vocabulary/book_controller.dart';
import 'package:vocly/app/controllers/vocabulary/selection_controller.dart';
import 'package:vocly/app/common/theme/app_text_theme.dart';
import 'package:vocly/app/common/constants/const_strings.dart';
import 'package:vocly/app/common/widgets/card_widget.dart';
import 'package:vocly/app/common/constants/const_colors.dart';
import 'package:vocly/app/common/constants/const_icons.dart';
import 'package:vocly/app/controllers/vocabulary/word_controller.dart';
import 'package:vocly/app/core/router/app_router.dart';
import 'package:vocly/app/core/services/dialog_service.dart';
import 'package:vocly/app/models/entities/book_model.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({super.key});

  @override
  State<ManageBooksScreen> createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  final _dialogService = Get.find<DialogService>();
  final _bookController = Get.find<BookController>();
  //TODO delete word controller
  final _wordController = Get.find<WordController>();
  final _selectionController = Get.find<BookSelectionController>();

  List<BookModel> _books = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: Obx(() {
        final isLoading = _bookController.isLoading;
        _books = _bookController.books;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _filterWidget()),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            _getMainWidget(isLoading: isLoading, isEmpty: _books.isEmpty),
          ],
        );
      }),
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Obx(() {
        final mode = _selectionController.isSelectionMode;
        final selectedBooks = _selectionController.selectedItems;
        return Row(
          children: [
            // appbar title -->
            Text(UIStrings.manageBooks, style: AppTextTheme.titleMedium),
            const Spacer(),
            if (mode)
              // delete icon -->
              InkWell(
                onTap: () {
                  _deleteBook(selectedBooks: selectedBooks.cast<BookModel>());
                },
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.delete_outline),
                ),
              ),
            SizedBox(width: 10),
            // select all icon -->
            InkWell(
              onTap: () => _selectionController.selectAllItems(
                currentSelectedItems: _books,
              ),
              child: Icon(_selectionController.selectButtonIcon),
            ),
            SizedBox(width: 20),
          ],
        );
      }),
    );
  }

  Widget _filterWidget() {
    final filteringItems = AppStrings.wordFilteringItems;
    return SizedBox(
      height: 35,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          // sort buttons -->
          FilterButton(
            onTap: () {
              Get.bottomSheet(
                backgroundColor: ConstUiColors.backgroundColor,
                SortSheetWidget(
                  onChanged: (selectedSortType) {
                    _wordController.selectSort(sortType: selectedSortType);
                  },
                  isSelected: (selectedSortType) {
                    return _wordController.isSortSelected(
                      sortType: selectedSortType,
                    );
                  },
                ),
              );
            },
            title: 'Sort',
          ),
          for (int index = 0; index < filteringItems.length; index++)
            // filter buttons -->
            FilterButton(
              onTap: () {
                Get.bottomSheet(
                  backgroundColor: ConstUiColors.backgroundColor,
                  FilterSheetWidget(
                    onChanged: (indexOfSelectedFilterItem) {
                      _wordController.selectFilters(
                        type: filteringItems[index][AppStrings.keyType],
                        filterItem: indexOfSelectedFilterItem,
                      );
                    },
                    isSelected: (indexOfSelectedFilterItem) {
                      return _wordController.isFilterSelected(
                        type: filteringItems[index][AppStrings.keyType],
                        filterItem: indexOfSelectedFilterItem,
                      );
                    },
                    filterItems:
                        filteringItems[index][AppStrings.keyFilterItems],
                    type: filteringItems[index][AppStrings.keyType],
                  ),
                );
              },
              title: filteringItems[index][AppStrings.keyName],
            ),
        ],
      ),
    );
  }

  Widget _getMainWidget({required bool isLoading, required bool isEmpty}) {
    if (isLoading) {
      return _deletingLoading();
    } else {
      if (isEmpty) {
        return _emptyStateWidget();
      } else {
        return _booksListView();
      }
    }
  }

  Widget _booksListView() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1 / 1,
        ),
        itemCount: _books.length,
        itemBuilder: (BuildContext context, int index) {
          final book = _books[index];
          return _bookWidget(currentBook: book);
        },
      ),
    );
  }

  Widget _bookWidget({required final BookModel currentBook}) {
    return Obx(() {
      final mode = _selectionController.isSelectionMode;
      final isSelected = _selectionController.isSelected(item: currentBook);
      return InkWell(
        onLongPress: () {
          _selectionController.changeSelectionMode(item: currentBook);
        },
        onTap: () {
          if (mode) {
            _selectionController.selectItem(item: currentBook);
          } else {
            Get.toNamed(Routes.readBookScreen, arguments: currentBook);
          }
        },
        child: Stack(
          children: [
            CardWidget(
              selectedBorderColor: getBookWidgetColor(
                isSelected: isSelected,
                color: currentBook.color,
              ),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  style: AppTextTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  currentBook.name,
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Icon(ConstIcons.icons[currentBook.icon]),
            ),
          ],
        ),
      );
    });
  }

  Widget _emptyStateWidget() {
    return SliverFillRemaining(
      fillOverscroll: false,
      hasScrollBody: false,
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Icon(Icons.search_off_outlined),
          Text(style: AppTextTheme.titleMedium, UIStrings.thereIsNoBookYet),
        ],
      ),
    );
  }

  Widget _deletingLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        SpinKitThreeInOut(size: 15, color: ConstUiColors.thirdColor),
        Text(style: AppTextTheme.titleMedium, 'Deleting books please wait..'),
      ],
    );
  }

  Color getBookWidgetColor({required bool isSelected, required int color}) {
    return isSelected
        ? ConstUiColors.thirdColor
        : ConstEntityColors.colors[color];
  }

  Future<void> _deleteBook({required List<BookModel> selectedBooks}) async {
    final bool? permission = await _dialogService.showDialog(
      title: AppStrings.dialogConfirmDeleteTitle,
      content: 'Are you sure about deleting these books?',
      confirmTitle: AppStrings.dialogConfirmDeleteAction,
    );

    if (permission == null || permission == false) return;
    _bookController.deleteBooks(selectedBooks: selectedBooks);
  }
}
