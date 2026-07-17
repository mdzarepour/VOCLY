import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/action_button.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/widgets/property_selector.dart';
import 'package:vocly/shared/widgets/input_text_field.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/features/vocabulary/controller/book_crud_controller.dart';

class BookCrudScreen extends GetView<BookCrudController> {
  const BookCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        // appbar
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
                    // title
                    Text(UIStrings.details, style: AppTextTheme.titleMedium),
                    const SizedBox(height: 10),
                    // name text field
                    InputTextField(
                      icon: Icons.chrome_reader_mode_outlined,
                      controller: controller.nameController,
                      hint: UIStrings.name,
                    ),
                    const SizedBox(height: 10),
                    // description text field
                    InputTextField(
                      icon: Icons.description_outlined,
                      controller: controller.descriptionController,
                      hint: UIStrings.description,
                    ),
                    const SizedBox(height: 10),
                    // book type selector
                    _typeSelection(),
                    const SizedBox(height: 10),
                    // book level selector
                    _levelSelection(),
                    const SizedBox(height: 30),
                    // title
                    Text(UIStrings.visual, style: AppTextTheme.titleMedium),
                    const SizedBox(height: 10),
                    // book color selection
                    _colorSelection(),
                    const SizedBox(height: 10),
                    // book icon selection
                    _iconSelection(),
                    const SizedBox(height: 30),
                    // title
                    Text(UIStrings.words, style: AppTextTheme.titleMedium),
                    const SizedBox(height: 10),
                    // book words selection
                    _wordSelection(),
                    const SizedBox(height: 30),
                    // cancel - done buttons
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

  AppBar appbarWidget() {
    return AppBar(
      centerTitle: false,
      title: Text(
        controller.type == BookScreenType.editBook ? 'Edit book' : 'Add Book',
        style: AppTextTheme.titleMedium,
      ),
    );
  }

  Widget _typeSelection() {
    return Obx(() {
      return PropertySelector(
        title: UIStrings.type,
        onChildTap: (i) {
          controller.updateProperty(key: AppStrings.keyType, value: i);
        },
        selectedChildIndex: controller.properties[AppStrings.keyType],
        type: ExpantionWidgetType.entityType,
        children: WordTypes.children,
      );
    });
  }

  Widget _levelSelection() {
    return Obx(() {
      return PropertySelector(
        title: UIStrings.difficulty,
        onChildTap: (i) {
          controller.updateProperty(key: AppStrings.keyLevel, value: i);
        },
        selectedChildIndex: controller.properties[AppStrings.keyLevel],
        type: ExpantionWidgetType.entityLevel,
        children: EntityLevel.children,
      );
    });
  }

  Widget _colorSelection() {
    return Obx(() {
      return PropertySelector(
        title: UIStrings.color,
        onChildTap: (i) {
          controller.updateProperty(key: AppStrings.keyColor, value: i);
        },
        selectedChildIndex: controller.properties[AppStrings.keyColor],
        type: ExpantionWidgetType.entityColor,
        children: EntityColor.children,
      );
    });
  }

  Widget _iconSelection() {
    return Obx(() {
      return PropertySelector(
        title: UIStrings.icon,
        onChildTap: (i) {
          controller.updateProperty(key: AppStrings.keyIcon, value: i);
        },
        selectedChildIndex: controller.properties[AppStrings.keyIcon],
        type: ExpantionWidgetType.entityIcon,
        children: EntityIcon.children,
      );
    });
  }

  Widget _wordSelection() {
    return InkWell(
      onTap: () => controller.goToWordManagerScreen(),
      child: CardWidget(
        height: 50,
        child: Center(
          child: Text(style: AppTextTheme.titleMedium, 'Select words'),
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
        Expanded(
          child: ActionButton(
            borderColor: ConstUiColors.positiveColor,
            onTap: () => _action(),
            children: [
              Icon(
                controller.type == BookScreenType.editBook
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
        controller.goToBack();
        Get.snackbar('Oops!', appError.errorMessage);
      },
      (appSuccess) {
        controller.goToBack();
        Get.snackbar('Success', appSuccess.successMessage!);
      },
    );
  }
}
