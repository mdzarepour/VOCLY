import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/view/widgets/word_tile.dart';
import 'package:vocly/features/vocabulary/controller/word_manager_controller.dart';
import 'package:vocly/shared/widgets/filter_button.dart';
import 'package:vocly/shared/widgets/filter_bottom_sheet.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/shared/widgets/sort_bottom_sheet.dart';

class WordManagerScreen extends GetView<WordManagerController> {
  const WordManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: Obx(() {
        final words = controller.displayedWords;
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // horizontal listview of filter widgets
            SliverToBoxAdapter(child: _filterWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // main widget as listview or empty state
            _getMainWidget(words: words),
          ],
        );
      }),
      bottomNavigationBar: _getAddWordsButton(),
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Obx(() {
        final mode = controller.selectionController.isSelectionMode;
        final type = controller.type == WordManagerScreenType.manageWords;
        return Row(
          children: [
            // title
            Text(UIStrings.manageWords, style: AppTextTheme.titleMedium),
            const Spacer(),
            if (mode && type)
              // delete icon
              InkWell(
                onTap: () {
                  controller.deleteWords();
                },
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.delete_outline),
                ),
              ),
            const SizedBox(width: 10),
            // layout icon
            InkWell(
              onTap: () => controller.changeScreenLayout(),
              child: Icon(
                controller.isGridLayout
                    ? Icons.grid_view_outlined
                    : Icons.view_agenda_outlined,
              ),
            ),
            const SizedBox(width: 10),
            // select all icon
            InkWell(
              onTap: () {
                controller.selectionController.selectAllItems(
                  allDisplayedItems: controller.displayedWords,
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
    const wordFilteringItems = WordFilteringItems.children;
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
          for (int index = 0; index < wordFilteringItems.length; index++)
            // filter buttons
            FilterButton(
              onTap: () {
                Get.bottomSheet(
                  backgroundColor: ConstUiColors.backgroundColor,
                  FilterBottomSheet(
                    onChanged: (indexOfSelectedFilterItem) {
                      controller.filterController.selectFilter(
                        type: wordFilteringItems[index][AppStrings.keyType],
                        filterItem: indexOfSelectedFilterItem,
                      );
                    },
                    isSelected: (indexOfSelectedFilterItem) {
                      return controller.filterController.isFilterSelected(
                        type: wordFilteringItems[index][AppStrings.keyType],
                        filterItem: indexOfSelectedFilterItem,
                      );
                    },
                    filterItems:
                        wordFilteringItems[index][AppStrings.keyFilterItems],
                    type: wordFilteringItems[index][AppStrings.keyType],
                  ),
                );
              },
              title: wordFilteringItems[index][AppStrings.keyName],
            ),
        ],
      ),
    );
  }

  Widget _wordsListWidget({required List<WordModel> words}) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      // sliver gridview
      sliver: SliverGrid.builder(
        itemCount: words.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 70,
          crossAxisCount: controller.isGridLayout ? 2 : 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          // word tile
          final currentWord = words[index];
          return Obx(() {
            final isSelected = controller.selectionController.isSelected(
              item: currentWord,
            );
            return WordTile(
              selectedBorderColor: isSelected
                  ? ConstUiColors.thirdColor
                  : ConstUiColors.backgroundColor2,
              isSmallTile: controller.isGridLayout,
              name: currentWord.name,
              meaning: currentWord.meaning,
              icon: currentWord.icon,
              type: currentWord.type,
              color: currentWord.color,
              onLongPress: () {
                controller.selectionController.startSelecting(
                  item: currentWord,
                );
              },
              onTap: () {
                if (controller.selectionController.isSelectionMode) {
                  controller.selectionController.selectItem(item: currentWord);
                } else {
                  controller.goToWordDetailsScreen(key: currentWord.key);
                }
              },
            );
          });
        },
      ),
    );
  }

  Widget _wordSelectingButton() {
    return Obx(() {
      return InkWell(
        onTap: () => controller.goToBackWithResult(),
        child: Container(
          decoration: const BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(color: ConstUiColors.backgroundColor2),
            ),
          ),
          height: 70,
          child: Text(
            style: AppTextTheme.titleMedium,
            'Add ${controller.selectionController.selectedItems.length} words',
          ),
        ),
      );
    });
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

  Widget? _getAddWordsButton() {
    if (controller.type == WordManagerScreenType.addWordToBook) {
      return _wordSelectingButton();
    } else {
      return null;
    }
  }

  Widget _getMainWidget({required List<WordModel> words}) {
    if (words.isEmpty) {
      return _emptyStateWidget();
    } else {
      return _wordsListWidget(words: words);
    }
  }
}
