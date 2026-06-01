import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
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

  late final bool _isManagingMode;
  bool _isGridLayout = false;

  @override
  void initState() {
    super.initState();
    final type = Get.arguments;
    _isManagingMode = type == ManageWordsScreenType.manage ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: GetBuilder<WordController>(
        builder: (controller) {
          final words = controller.items;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Expanded(
                child: words.isEmpty
                    ? _emptyStateWidget()
                    : GridView.builder(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 30,
                        ),
                        itemCount: words.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 70,
                          crossAxisCount: _isGridLayout ? 2 : 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final currentWord = words[index];
                          return GetBuilder<WordSelectionController>(
                            builder: (controller) {
                              return WordTile(
                                selectedBorderColor: controller.isSelected(item: currentWord) ? ConstUiColors.thirdColor :  ConstUiColors.backgroundColor2,
                                isSmallTile: _isGridLayout,
                                name: currentWord.name,
                                meaning: currentWord.meaning,
                                icon: currentWord.icon,
                                type: currentWord.type,
                                color: currentWord.color,
                                onLongPress: () {
                                  controller.changeSelectionMode(
                                    item: currentWord,
                                  );
                                },
                                onTap: () {
                                  if (controller.isSelectionMode) {
                                    controller.selectItem(item: currentWord);
                                  } else {
                                    Get.toNamed(
                                      Routes.readWordScreen,
                                      arguments: currentWord,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
              if (!_isManagingMode) _addButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _addButton() {
    return GetBuilder<WordSelectionController>(
      builder: (controller) {
        final selectedWords = controller.selectedItems;
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
                Text(
                  style: AppTextTheme.titleMedium,
                  '${selectedWords.length}',
                ),
              ],
            ),
          ),
        );
      },
    );
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
      title: GetBuilder<WordSelectionController>(
        builder: (controller) {
          return Row(
            children: [
              Text(
                _isManagingMode ? 'Manage words' : 'Add words',
                style: AppTextTheme.titleMedium,
              ),
              const Spacer(),
              if (controller.isSelectionMode && _isManagingMode)
                InkWell(
                  onTap: () {
                    _deleteWord(
                      selectedWords: controller.selectedItems.cast<WordModel>(),
                    );
                  },
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Icon(Icons.delete_outline),
                  ),
                ),
              InkWell(
                onTap: () => _changeLayout(),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Icon(_getLayoutIcon()),
                ),
              ),
              SizedBox(width: 10),
              // TODO change to icon
              InkWell(
                onTap: () => controller.selectAllItems(),
                child: Text(
                  controller.selectButtonTitle,
                  style: AppTextTheme.titleMedium,
                ),
              ),
              SizedBox(width: 20),
            ],
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
    return _isGridLayout ? Icons.grid_view_outlined : Icons.view_list_sharp;
  }

  void _changeLayout() {
    setState(() {
      _isGridLayout = !_isGridLayout;
    });
  }
}







