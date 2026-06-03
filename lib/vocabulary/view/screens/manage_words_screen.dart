import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:vocly/common/constants/const_icons.dart';
import 'package:vocly/common/widgets/filter_button.dart';
import 'package:vocly/common/widgets/filter_sheet_widget.dart';
import 'package:vocly/core/enums/enums.dart';
import 'package:vocly/core/services/dialog_service.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/vocabulary/controller/word_selection_controller.dart';
import 'package:vocly/vocabulary/controller/word_controller.dart';
import 'package:vocly/vocabulary/model/word_model.dart';
import 'package:vocly/vocabulary/view/widgets/word_tile.dart';

class ManageWordsScreen extends StatefulWidget {
  const ManageWordsScreen({super.key});

  @override
  State<ManageWordsScreen> createState() => _ManageWordsScreenState();
}

class _ManageWordsScreenState extends State<ManageWordsScreen> {
  final _dialogService = Get.find<DialogService>();
  final _wordController = Get.find<WordController>();
  final _selectionController = Get.find<WordSelectionController>();

  late final bool _isManagingMode;
  bool _isGridLayout = false;

  @override
  void initState() {
    super.initState();
    final type = Get.arguments[0] as ManageWordsScreenType;
    _isManagingMode = type == ManageWordsScreenType.manageWords ? true : false;

    if (Get.arguments[1] == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectionController.selectedItems.clear();
      _selectionController.selectedItems.addAll(Get.arguments[1]);
      _selectionController.updateSelectionMode(mode: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: Obx(() {
        final words = _wordController.wordsList;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            _filterWidget(),
            SizedBox(height: 10),
            Expanded(
              child: words.isEmpty
                  ? _emptyStateWidget()
                  : _wordsListWidget(words),
            ),
            if (!_isManagingMode) _addButton(),
          ],
        );
      }),
    );
  }

  Widget _wordsListWidget(List<WordModel> words) {
    return GridView.builder(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      itemCount: words.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 70,
        crossAxisCount: _isGridLayout ? 2 : 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final currentWord = words[index];
        return Obx(() {
          final mode = _selectionController.isSelectionMode;
          final isSelected = _selectionController.isSelected(item: currentWord);

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
    );
  }

  Widget _addButton() {
    return Obx(() {
      final selectedWords = _selectionController.selectedItems;
      return InkWell(
        onTap: () => Get.back(result: selectedWords.cast<WordModel>()),
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

  Widget _emptyStateWidget() {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(UIStrings.thereIsNoWordYet, style: AppTextTheme.titleMedium),
        Icon(Icons.search_off_outlined, size: 30),
      ],
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
            Text(UIStrings.manageBooks, style: AppTextTheme.titleMedium),
            const Spacer(),
            if (mode)
              // DELETE ICON -->
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
            // LAYOUT ICON -->
            InkWell(
              onTap: () => _changeLayout(),
              child: Icon(_getLayoutIcon()),
            ),
            SizedBox(width: 10),
            // SELECT ALL ICON -->
            InkWell(
              onTap: () => _selectionController.selectAllItems(),
              child: Icon(_selectionController.selectButtonIcon),
            ),
            SizedBox(width: 20),
          ],
        );
      }),
    );
  }

  Widget _filterWidget() {
    final List<Map> filterMap = [
      {
        AppStrings.keyName: AppStrings.keyColor,
        AppStrings.keyType: FilterType.color,
        AppStrings.keyFilterItems: ConstEntityColors.colors,
      },
      {
        AppStrings.keyName: AppStrings.keyIcon,
        AppStrings.keyType: FilterType.icon,
        AppStrings.keyFilterItems: ConstIcons.icons,
      },
      {
        AppStrings.keyName: AppStrings.keyType,
        AppStrings.keyType: FilterType.type,
        AppStrings.keyFilterItems: ConstWordTypes.wordTypes,
      },
    ];
    return SizedBox(
      height: 35,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return FilterButton(
            onTap: () {
              Get.bottomSheet(
                backgroundColor: ConstUiColors.backgroundColor,
                FilterSheetWidget(
                  onChanged: (i) {
                    _wordController.selectFilters(
                      type: filterMap[index][AppStrings.keyType],
                      filterItem: i,
                    );
                  },
                  isSelected: (i) {
                    return _wordController.isFilterSelected(
                      type: filterMap[index][AppStrings.keyType],
                      filterItem: i,
                    );
                  },
                  filterItems: filterMap[index][AppStrings.keyFilterItems],
                  type: filterMap[index][AppStrings.keyType],
                ),
              );
            },
            title: filterMap[index][AppStrings.keyName],
          );
        },
      ),
    );
  }

  Future<void> _deleteWord({required List<WordModel> selectedWords}) async {
    final bool? permission = await _dialogService.showDialog(
      title: AppStrings.dialogConfirmDeleteTitle,
      content: AppStrings.dialogConfirmDeleteWordsContent,
      confirmTitle: AppStrings.dialogConfirmDeleteAction,
    );
    if (permission == null || permission == false) return;
    _wordController.deleteItems(selectedItems: selectedWords);
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
}
