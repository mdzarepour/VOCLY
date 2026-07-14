import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/view/widgets/book_tile.dart';
import 'package:vocly/shared/widgets/filter_button.dart';
import 'package:vocly/shared/widgets/filter_bottom_sheet.dart';
import 'package:vocly/features/vocabulary/controller/book_manager_controller.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/shared/widgets/sort_bottom_sheet.dart';

class ManageBooksScreen extends GetView<BookManagerController> {
  const ManageBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: Obx(() {
        final books = controller.displayedBooks;
        return CustomScrollView(
          slivers: [
            // horizontal listview of filter widgets
            SliverToBoxAdapter(child: _filterWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // main widget as listview or empty state
            _getMainWidget(books),
          ],
        );
      }),
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Obx(() {
        return Row(
          children: [
            // title
            Text(UIStrings.manageBooks, style: AppTextTheme.titleMedium),
            const Spacer(),
            if (controller.selectionController.isSelectionMode)
              // delete icon
              InkWell(
                onTap: () => controller.deleteBooks(),
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.delete_outline),
                ),
              ),
            const SizedBox(width: 10),
            // select all icon
            InkWell(
              onTap: () {
                controller.selectionController.selectAllItems(
                  allDisplayedItems: controller.displayedBooks,
                );
              },
              child: Icon(controller.selectionController.selectButtonIcon),
            ),
            const SizedBox(width: 20),
          ],
        );
      }),
    );
  }

  Widget _filterWidget() {
    const filteringItems = BookFilteringItems.children;
    return SizedBox(
      height: 35,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: [
          // sort button
          FilterButton(
            onTap: () {
              Get.bottomSheet(
                backgroundColor: ConstUiColors.backgroundColor,
                SortBottomSheet(
                  onChanged: (selectedSortType) {
                    controller.filterController.selectSort(
                      sortType: selectedSortType,
                    );
                  },
                  isSelected: (selectedSortType) {
                    return controller.filterController.isSortSelected(
                      sortType: selectedSortType,
                    );
                  },
                ),
              );
            },
            title: 'Sort',
          ),
          for (int index = 0; index < filteringItems.length; index++)
            // filter buttons
            FilterButton(
              onTap: () {
                Get.bottomSheet(
                  backgroundColor: ConstUiColors.backgroundColor,
                  FilterBottomSheet(
                    onChanged: (indexOfSelectedFilterItem) {
                      controller.filterController.selectFilter(
                        type: filteringItems[index][AppStrings.keyType],
                        filterItem: indexOfSelectedFilterItem,
                      );
                    },
                    isSelected: (indexOfSelectedFilterItem) {
                      return controller.filterController.isFilterSelected(
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // sliver gridview
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1 / 1,
        ),
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          // book tile
          final currentBook = books[index];
          return Obx(() {
            final isSelected = controller.selectionController.isSelected(
              item: currentBook,
            );
            return BookTile(
              color: isSelected
                  ? ConstUiColors.thirdColor
                  : EntityColor.children[currentBook.color],
              name: currentBook.name,
              icon: currentBook.icon,
              onLongPress: () {
                controller.selectionController.startSelecting(
                  item: currentBook,
                );
              },
              onTap: () {
                if (controller.selectionController.isSelectionMode) {
                  controller.selectionController.selectItem(item: currentBook);
                } else {
                  controller.goToReadBookScreen(key: currentBook.key);
                }
              },
            );
          });
        },
      ),
    );
  }

  Widget _emptyStateWidget() {
    return SliverFillRemaining(
      fillOverscroll: false,
      hasScrollBody: false,
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_outlined, size: 25),
          Text('Empty', style: AppTextTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _getMainWidget(List<BookModel> books) {
    if (books.isEmpty) {
      return _emptyStateWidget();
    } else {
      return _booksListView(books: books);
    }
  }

  Color getBookWidgetColor({required bool isSelected, required int color}) {
    return isSelected ? ConstUiColors.thirdColor : EntityColor.children[color];
  }
}
