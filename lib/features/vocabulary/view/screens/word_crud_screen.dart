import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/controller/word_crud_controller.dart';
import 'package:vocly/shared/widgets/action_button.dart';
import 'package:vocly/shared/widgets/property_selector.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/input_text_field.dart';
import 'package:vocly/core/types/enums.dart';

class WordCrudScreen extends GetView<WordCrudController> {
  const WordCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: appBarWidget(),
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
                    // title
                    Text(UIStrings.details, style: AppTextTheme.titleMedium),
                    const SizedBox(height: 10),
                    // word name text field
                    InputTextField(
                      icon: Icons.language,
                      controller: controller.nameController,
                      hint: UIStrings.name,
                    ),
                    const SizedBox(height: 15),
                    // word meaning text field
                    InputTextField(
                      icon: Icons.lightbulb_outline,
                      controller: controller.meaningController,
                      hint: UIStrings.meaning,
                    ),
                    const SizedBox(height: 15),
                    // word example text field
                    InputTextField(
                      icon: Icons.newspaper_outlined,
                      controller: controller.exampleController,
                      hint: UIStrings.example,
                    ),
                    const SizedBox(height: 15),
                    // expantion widget for type
                    _typeSelection(),
                    const SizedBox(height: 15),
                    // expantion widget for level
                    _levelSelection(),
                    const SizedBox(height: 30),
                    // title
                    Text(UIStrings.visual, style: AppTextTheme.titleMedium),
                    const SizedBox(height: 10),
                    // expantion widget for icon
                    _iconSelection(),
                    const SizedBox(height: 15),
                    // expantion widget for color
                    _colorSelection(),
                    const SizedBox(height: 30),
                    // action buttons row
                    _actionButtons(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBarWidget() {
    return AppBar(
      centerTitle: false,
      title: Text(
        controller.type == WordScreenType.editWord
            ? 'Edit word'
            : 'Add new word',
        style: AppTextTheme.titleMedium,
      ),
    );
  }

  Widget _iconSelection() {
    return Obx(() {
      return PropertySelector(
        title: UIStrings.icon,
        onChildTap: (i) => controller.updateSelectedIcon(value: i),
        selectedChildIndex: controller.selectedIconIndex,
        type: ExpantionWidgetType.entityIcon,
        children: EntityIcon.children,
      );
    });
  }

  Widget _typeSelection() {
    return Obx(() {
      return PropertySelector(
        title: UIStrings.type,
        onChildTap: (i) => controller.updateSelectedType(value: i),
        selectedChildIndex: controller.selectedTypeIndex,
        type: ExpantionWidgetType.entityType,
        children: WordTypes.children,
      );
    });
  }

  Widget _levelSelection() {
    return Obx(() {
      return PropertySelector(
        title: UIStrings.difficulty,
        onChildTap: (i) => controller.updateSelectedLevel(value: i),
        selectedChildIndex: controller.selectedLevelIndex,
        type: ExpantionWidgetType.entityLevel,
        children: EntityLevel.children,
      );
    });
  }

  Widget _colorSelection() {
    return Obx(() {
      return PropertySelector(
        title: UIStrings.color,
        onChildTap: (i) => controller.updateSelectedColor(value: i),
        selectedChildIndex: controller.selectedColorIndex,
        type: ExpantionWidgetType.entityColor,
        children: EntityColor.children,
      );
    });
  }

  Widget _actionButtons() {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // add - edit button
        Expanded(
          child: ActionButton(
            borderColor: ConstUiColors.positiveColor,
            onTap: () => _action(),
            children: [
              Icon(
                controller.type == WordScreenType.editWord
                    ? Icons.edit_outlined
                    : Icons.done,
              ),
              Text(UIStrings.done, style: AppTextTheme.titleMedium),
            ],
          ),
        ),
        // cancel button
        Expanded(
          child: ActionButton(
            borderColor: ConstUiColors.errorColor,
            onTap: () => controller.goToBack(),
            children: [
              const Icon(Icons.cancel_outlined),
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
        Get.snackbar('Oops!', appError.errorMessage);
      },
      (appSuccess) {
        controller.goToBack();
        Get.snackbar('Success', appSuccess.successMessage!);
      },
    );
  }
}
