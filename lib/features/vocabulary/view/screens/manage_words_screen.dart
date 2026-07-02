import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/view/widgets/word_tile.dart';
import 'package:vocly/shared/controllers/filter_controller.dart';
import 'package:vocly/shared/controllers/selection_controller.dart';
import 'package:vocly/features/vocabulary/controller/word_controller.dart';
import 'package:vocly/shared/widgets/filter_button.dart';
import 'package:vocly/shared/widgets/filter_sheet_widget.dart';
import 'package:vocly/shared/widgets/sort_sheet_widget.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

class ManageWordsScreen extends StatefulWidget {
  const ManageWordsScreen({super.key});

  @override
  State<ManageWordsScreen> createState() => _ManageWordsScreenState();
}

class _ManageWordsScreenState extends State<ManageWordsScreen> {
  final _dialogService = Get.find<DialogService>();
  final _wordController = Get.find<WordController>();
  final _filterController = Get.find<FilterController<WordModel>>();
  final _selectionController = Get.find<WordSelectionController>();

  late final bool _isManagingMode;
  List<WordModel> _words = [];
  bool _isGridLayout = false;

  @override
  void initState() {
    super.initState();
    _determineScreenType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: Obx(() {
        final isLoading = _wordController.isLoading;
        _words = _filterController.getFilteredItems(
          items: _wordController.words,
        );
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _filterWidget()),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            _getMainWidget(isLoading: isLoading, isEmpty: _words.isEmpty),
          ],
        );
      }),
      bottomNavigationBar: !_isManagingMode ? _wordSelectingButton() : null,
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Obx(() {
        final selectedItem = _selectionController.selectedItems;
        final mode = _selectionController.isSelectionMode;
        return Row(
          children: [
            Text(UIStrings.manageWords, style: AppTextTheme.titleMedium),
            const Spacer(),
            if (mode)
              // delete icon -->
              InkWell(
                onTap: () {
                  _deleteWord(selectedWords: selectedItem.cast<WordModel>());
                },
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.delete_outline),
                ),
              ),
            SizedBox(width: 10),
            // layout icon-->
            InkWell(
              onTap: () => _changeLayout(),
              child: Icon(_getLayoutIcon()),
            ),
            SizedBox(width: 10),
            // select all icon -->
            InkWell(
              onTap: () {
                _selectionController.selectAllItems(
                  currentSelectedItems: _words,
                );
              },
              child: Icon(_selectionController.selectButtonIcon),
            ),
            SizedBox(width: 20),
          ],
        );
      }),
    );
  }

  Widget _filterWidget() {
    final wordFilteringItems = ConstWordTypes.wordFilteringItems;
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
                    _filterController.selectSort(sortType: selectedSortType);
                  },
                  isSelected: (selectedSortType) {
                    return _filterController.isSortSelected(
                      sortType: selectedSortType,
                    );
                  },
                ),
              );
            },
            title: 'Sort',
          ),
          for (int index = 0; index < wordFilteringItems.length; index++)
            // filter buttons -->
            FilterButton(
              onTap: () {
                Get.bottomSheet(
                  backgroundColor: ConstUiColors.backgroundColor,
                  FilterSheetWidget(
                    onChanged: (indexOfSelectedFilterItem) {
                      _filterController.selectFilters(
                        type: wordFilteringItems[index][AppStrings.keyType],
                        filterItem: indexOfSelectedFilterItem,
                      );
                    },
                    isSelected: (indexOfSelectedFilterItem) {
                      return _filterController.isFilterSelected(
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

  Widget _getMainWidget({required bool isLoading, required bool isEmpty}) {
    if (isLoading) {
      return _deletingLoading();
    } else {
      if (isEmpty) {
        return _emptyStateWidget();
      } else {
        return _wordsListWidget();
      }
    }
  }

  Widget _wordsListWidget() {
    return SliverPadding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      sliver: SliverGrid.builder(
        itemCount: _words.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 70,
          crossAxisCount: _isGridLayout ? 2 : 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final currentWord = _words[index];
          return Obx(() {
            final mode = _selectionController.isSelectionMode;
            final isSelected = _selectionController.isSelected(
              item: currentWord,
            );
            return WordTile(
              selectedBorderColor: isSelected
                  ? ConstUiColors.thirdColor
                  : ConstUiColors.backgroundColor2,
              isSmallTile: _isGridLayout,
              name: currentWord.name,
              meaning: currentWord.meaning,
              icon: currentWord.icon,
              type: currentWord.type,
              color: currentWord.color,
              onLongPress: () {
                _selectionController.changeSelectionMode(item: currentWord);
              },
              onTap: () {
                if (mode) {
                  _selectionController.selectItem(item: currentWord);
                } else {
                  Get.toNamed(Routes.readWordScreen, arguments: currentWord);
                }
              },
            );
          });
        },
      ),
    );
  }

  Widget _deletingLoading() {
    return SliverFillRemaining(
      fillOverscroll: false,
      hasScrollBody: false,
      child: SpinKitThreeInOut(size: 15, color: ConstUiColors.thirdColor),
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
          Icon(Icons.search_off_outlined, size: 25),
          Text('Empty', style: AppTextTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _wordSelectingButton() {
    return Obx(() {
      final selectedWords = _selectionController.selectedItems;
      return InkWell(
        onTap: () => Get.back(result: selectedWords),
        child: Container(
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(color: ConstUiColors.backgroundColor2),
            ),
          ),
          height: 70,
          child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(style: AppTextTheme.titleMedium, UIStrings.addBooks),
              Text(style: AppTextTheme.titleMedium, '${selectedWords.length}'),
            ],
          ),
        ),
      );
    });
  }

  void _determineScreenType() {
    final type = Get.arguments[0] as ManageWordsScreenType;
    _isManagingMode = type == ManageWordsScreenType.manageWords ? true : false;

    if (Get.arguments[1] == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedArg = Get.arguments[1] as List<String>;
      _selectionController.initPreviouslySelectedWords(
        selectedWordIds: selectedArg,
      );
    });
  }

  Future<void> _deleteWord({required List<WordModel> selectedWords}) async {
    final bool? permission = await _dialogService.showDialog(
      title: AppStrings.dialogConfirmDeleteTitle,
      content: AppStrings.dialogConfirmDeleteWordsContent,
      confirmTitle: AppStrings.dialogConfirmDeleteAction,
    );
    if (permission == null || permission == false) return;
    _wordController.deleteWords(selectedWords: selectedWords);
    _selectionController.updateSelectionMode(mode: false);
  }

  IconData _getLayoutIcon() {
    return _isGridLayout
        ? Icons.grid_view_outlined
        : Icons.view_agenda_outlined;
  }

  void _changeLayout() {
    setState(() {
      _isGridLayout = !_isGridLayout;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _selectionController.dispose();
    _filterController.deleteFilters();
  }
}
