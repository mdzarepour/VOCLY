import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/shared/widgets/filter_button.dart';
import 'package:vocly/shared/widgets/filter_bottom_sheet.dart';
import 'package:vocly/features/vocabulary/controller/book_manage_controller.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';

class ManageBooksScreen extends GetView<BookManageController> {
  const ManageBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: Obx(() {
        final books = controller.books;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _filterWidget()),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            _booksListView(books: books),
          ],
        );
      }),
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Obx(() {
        final mode = controller.isSelectionMode;
        return Row(
          children: [
            // appbar title -->
            Text(UIStrings.manageBooks, style: AppTextTheme.titleMedium),
            const Spacer(),
            if (mode)
              // delete icon -->
              InkWell(
                onTap: () => controller.deleteBooks(),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.delete_outline),
                ),
              ),
            SizedBox(width: 10),
            // select all icon -->
            InkWell(
              onTap: () => controller.selectAllBooks(),
              child: Icon(controller.selectionButtonIcon),
            ),
            SizedBox(width: 20),
          ],
        );
      }),
    );
  }

  Widget _filterWidget() {
    final filteringItems = BookFilteringItems.children;
    return SizedBox(
      height: 35,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          // sort buttons -->
          // FilterButton(
          //   onTap: () {
          //     Get.bottomSheet(
          //       backgroundColor: ConstUiColors.backgroundColor,
          //       SortSheetWidget(
          //         onChanged: (selectedSortType) {
          //           _filterController.selectSort(sortType: selectedSortType);
          //         },
          //         isSelected: (selectedSortType) {
          //           return _filterController.isSortSelected(
          //             sortType: selectedSortType,
          //           );
          //         },
          //       ),
          //     );
          //   },
          //   title: 'Sort',
          // ),
          for (int index = 0; index < filteringItems.length; index++)
            // filter buttons -->
            FilterButton(
              onTap: () {
                Get.bottomSheet(
                  backgroundColor: ConstUiColors.backgroundColor,
                  FilterBottomSheet(
                    onChanged: (indexOfSelectedFilterItem) {
                      controller.selectFilter(
                        type: filteringItems[index][AppStrings.keyType],
                        filterItem: indexOfSelectedFilterItem,
                      );
                    },
                    isSelected: (indexOfSelectedFilterItem) {
                      return controller.isFilterSelected(
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

  Widget _booksListView({required List<BookModel> books}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1 / 1,
        ),
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          final book = books[index];
          return _bookWidget(currentBook: book);
        },
      ),
    );
  }

  Widget _bookWidget({required final BookModel currentBook}) {
    return Obx(() {
      final mode = controller.isSelectionMode;
      final isSelected = controller.isBookSelected(book: currentBook);
      return InkWell(
        onLongPress: () => controller.startSelection(book: currentBook),
        onTap: () {
          if (mode) {
            controller.selectBook(book: currentBook);
          } else {
            controller.goToReakBookScreen(book: currentBook);
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
              child: Icon(EntityIcon.children[currentBook.icon]),
            ),
          ],
        ),
      );
    });
  }

  Color getBookWidgetColor({required bool isSelected, required int color}) {
    return isSelected ? ConstUiColors.thirdColor : EntityColor.children[color];
  }
}


  // Widget _emptyStateWidget() {
  //   return SliverFillRemaining(
  //     fillOverscroll: false,
  //     hasScrollBody: false,
  //     child: Row(
  //       spacing: 5,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.search_off_outlined, size: 25),
  //         Text('Empty', style: AppTextTheme.titleMedium),
  //       ],
  //     ),
  //   );
  // }

  // Widget _deletingLoading() {
  //   return SliverFillRemaining(
  //     fillOverscroll: false,
  //     hasScrollBody: false,
  //     child: SpinKitThreeInOut(size: 15, color: ConstUiColors.thirdColor),
  //   );
  // }