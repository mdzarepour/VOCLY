import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/action_button.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/widgets/expansion_widget.dart';
import 'package:vocly/shared/widgets/input_widget.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/controller/book_crud_controller.dart';

class AddEditBookScreen extends GetView<BookCrudController> {
  const AddEditBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: appbarWidget(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(UIStrings.details, style: AppTextTheme.titleMedium),
                    SizedBox(height: 10),
                    InputWidget(
                      icon: Icons.chrome_reader_mode_outlined,
                      controller: controller.nameController,
                      hint: UIStrings.name,
                    ),
                    SizedBox(height: 10),
                    InputWidget(
                      icon: Icons.description_outlined,
                      controller: controller.descriptionController,
                      hint: UIStrings.description,
                    ),
                    SizedBox(height: 10),
                    _typeSelection(),
                    SizedBox(height: 10),
                    _levelSelection(),
                    const SizedBox(height: 30),
                    Text(UIStrings.visual, style: AppTextTheme.titleMedium),
                    SizedBox(height: 10),
                    _colorSelection(),
                    SizedBox(height: 10),
                    _iconSelection(),
                    SizedBox(height: 30),
                    Text(UIStrings.words, style: AppTextTheme.titleMedium),
                    SizedBox(height: 10),
                    _wordSelection(),
                    SizedBox(height: 30),
                    _actionButtons(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appbarWidget() {
    return AppBar(
      centerTitle: false,
      title: Text(
        controller.bookScreenType == BookScreenType.editBook
            ? 'Edit book'
            : 'Add Book',
        style: AppTextTheme.titleMedium,
      ),
    );
  }

  Widget _iconSelection() {
    return ExpansionWidget(
      title: UIStrings.icon,
      onChildTap: (i) => controller.updateSelectedIcon(value: i),
      selectedChildIndex: controller.selectedIconIndex,
      type: ExpantionWidgetType.entityIcon,
      children: EntityIcon.children,
    );
  }

  Widget _typeSelection() {
    return ExpansionWidget(
      title: UIStrings.type,
      onChildTap: (i) => controller.updateSelectedType(value: i),
      selectedChildIndex: controller.selectedTypeIndex,
      type: ExpantionWidgetType.entityType,
      children: WordTypes.children,
    );
  }

  Widget _levelSelection() {
    return ExpansionWidget(
      title: UIStrings.difficulty,
      onChildTap: (i) => controller.updateSelectedLevel(value: i),
      selectedChildIndex: controller.selectedLevelIndex,
      type: ExpantionWidgetType.entityLevel,
      children: EntityLevel.children,
    );
  }

  Widget _colorSelection() {
    return ExpansionWidget(
      title: UIStrings.color,
      onChildTap: (i) => controller.updateSelectedColor(value: i),
      selectedChildIndex: controller.selectedColorIndex,
      type: ExpantionWidgetType.entityColor,
      children: EntityColor.children,
    );
  }

  Widget _wordSelection() {
    return InkWell(
      onTap: () => controller.goToMnageWordsScreen(),
      child: CardWidget(
        height: 50,
        child: Center(
          child: Text(style: AppTextTheme.titleMedium, 'Selected words'),
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // add - edit button
        ActionButton(
          borderColor: ConstUiColors.positiveColor,
          onTap: () => _action(),
          child: Row(
            children: [
              Icon(
                controller.bookScreenType == BookScreenType.editBook
                    ? Icons.edit_outlined
                    : Icons.done,
              ),
              Text(UIStrings.done, style: AppTextTheme.titleMedium),
            ],
          ),
        ),
        // cancel button
        ActionButton(
          borderColor: ConstUiColors.errorColor,
          onTap: () => controller.goToBack(),
          child: Row(
            children: [
              Icon(Icons.cancel_outlined),
              Text(UIStrings.cancel, style: AppTextTheme.titleMedium),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _action() async {
    FocusManager.instance.primaryFocus!.unfocus();
    final either = await controller.handleAction();
    either.fold(
      (appError) {
        controller.goToBack();
        Get.snackbar('Oops!', appError.errorMessage);
      },
      (appSuccess) {
        controller.goToBack();
        Get.snackbar('Oops!', appSuccess.successMessage!);
      },
    );
  }
}
