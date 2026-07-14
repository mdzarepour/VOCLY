import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/shared/widgets/action_button.dart';
import 'package:vocly/shared/widgets/input_text_field.dart';
import 'package:vocly/features/vocabulary/controller/home_controller.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/core/types/enums.dart';

class HomeScreen extends GetView<HomeController> {
  final void Function()? onTap;
  const HomeScreen({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _searchWidget(),
          const SizedBox(height: 30),
          // title
          Text(UIStrings.yourVocabulary, style: AppTextTheme.titleMedium),
          const SizedBox(height: 15),
          Row(
            spacing: 10,
            children: [
              // manage books button
              Obx(() {
                final booksLength = controller.booksCount;
                return Expanded(
                  child: _HomeButton(
                    icon: Icons.chrome_reader_mode_outlined,
                    title: UIStrings.books,
                    data: '$booksLength Books',
                    onTap: () => controller.goToBookManagerScreen(),
                  ),
                );
              }),
              // manage words button
              Obx(() {
                final wordsLength = controller.wordsCount;
                return Expanded(
                  child: _HomeButton(
                    icon: Icons.language_outlined,
                    title: UIStrings.words,
                    data: '$wordsLength Words',
                    onTap: () => controller.goToWordManagerScreen(),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              // add book button
              Expanded(
                child: _HomeButton(
                  icon: Icons.add_outlined,
                  title: UIStrings.newBook,
                  onTap: () => controller.goToBookCrudScreen(),
                ),
              ),
              // add word button
              Expanded(
                child: _HomeButton(
                  icon: Icons.add_outlined,
                  title: UIStrings.newWord,
                  onTap: () => controller.goToWordCrudScreen(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // title
          Text('Use Prepared Books', style: AppTextTheme.titleMedium),
          const SizedBox(height: 15),
          // book library web link
          _HomeButton(
            icon: Icons.coffee_outlined,
            title: 'Use vocabulary',
            data: 'We are prepared some vocabulary for you',
            onTap: () => controller.openBookLibrary(),
          ),
          const SizedBox(height: 30),
          // title
          Text(UIStrings.yourData, style: AppTextTheme.titleMedium),
          const SizedBox(height: 15),
          // export bottom sheet
          _HomeButton(
            icon: Icons.folder_outlined,
            title: UIStrings.exportYour,
            data: UIStrings.exportYourDataDescription,
            onTap: () {
              Get.bottomSheet(
                backgroundColor: ConstUiColors.backgroundColor,
                _exportBottomSheet(),
              );
            },
          ),
          const SizedBox(height: 10),
          // import bottom sheet
          _HomeButton(
            icon: Icons.import_export,
            title: UIStrings.importYourData,
            data: UIStrings.importPreviouslySavedVocabulary,
            onTap: () {
              Get.bottomSheet(
                backgroundColor: ConstUiColors.backgroundColor,
                _importWidget(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _importWidget() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: double.infinity, height: 15),
            // drag effect widget
            Container(
              width: 50,
              height: 3,
              decoration: const BoxDecoration(color: ConstUiColors.thirdColor),
            ),
            const SizedBox(height: 15),
            // title
            Text(style: AppTextTheme.titleMedium, 'Import data'),
            const SizedBox(height: 15),
            // content text field
            InputTextField(
              hint: 'Data',
              controller: controller.inputController,
              icon: Icons.import_export_outlined,
            ),
            const SizedBox(height: 20),
            // select file button
            Obx(() {
              final fileName = controller.fileName;
              return ActionButton(
                onTap: () => _selectFile(),
                children: [
                  const Icon(Icons.insert_drive_file_outlined),
                  Text(
                    style: AppTextTheme.titleMedium,
                    fileName.isEmpty ? 'Choose json file' : fileName,
                  ),
                ],
              );
            }),
            const SizedBox(height: 15),
            Row(
              spacing: 10,
              children: [
                // confirm button
                Obx(() {
                  return Expanded(
                    child: ActionButton(
                      borderColor: ConstUiColors.positiveColor,
                      onTap: () => _handleOntap(controller.handleImport),
                      isLoading: controller.importLoading,
                      children: [
                        const Icon(Icons.done),
                        Text('Confirm', style: AppTextTheme.titleMedium),
                      ],
                    ),
                  );
                }),
                // cancel button
                Expanded(
                  child: ActionButton(
                    borderColor: ConstUiColors.errorColor,
                    onTap: () {
                      controller.goToBack();
                      controller.clearBackupSession();
                    },
                    children: [
                      const Icon(Icons.cancel_outlined),
                      Text(style: AppTextTheme.titleMedium, 'Cancel'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exportBottomSheet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final isLoading = controller.exportLoading;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: double.infinity, height: 15),
            // drag effect widget
            Container(
              width: 50,
              height: 3,
              decoration: const BoxDecoration(color: ConstUiColors.thirdColor),
            ),
            const SizedBox(height: 15),
            // title
            Text(style: AppTextTheme.titleMedium, 'Export data'),
            const SizedBox(height: 20),
            // export to file button
            ActionButton(
              onTap: () => _handleOntap(controller.exportToFile),
              isLoading: isLoading == ExportStatus.file,
              children: [
                const Icon(Icons.insert_drive_file_outlined),
                Text(style: AppTextTheme.titleMedium, 'Export as file'),
              ],
            ),
            const SizedBox(height: 15),
            // export to clip board button
            ActionButton(
              onTap: () => _handleOntap(controller.exportToClipboard),
              isLoading: isLoading == ExportStatus.clipboard,
              children: [
                const Icon(Icons.insert_drive_file_outlined),
                Text(style: AppTextTheme.titleMedium, 'Export to clipboard'),
              ],
            ),
            const SizedBox(height: 15),
            // cancel button
            ActionButton(
              borderColor: ConstUiColors.errorColor,
              onTap: () => controller.goToBack(),
              children: [
                const Icon(Icons.cancel_outlined),
                Text(style: AppTextTheme.titleMedium, 'Cancel'),
              ],
            ),
            const SizedBox(height: 15),
          ],
        );
      }),
    );
  }

  Widget _searchWidget() {
    return GestureDetector(
      onTap: () => controller.gotoSearchScreen(),
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          border: Border.all(color: ConstUiColors.blueHighLightColor, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: ConstUiColors.forthColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // drawer menu open button
            InkWell(
              onTap: onTap,
              child: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.menu, size: 25),
              ),
            ),
            const SizedBox(width: 10),
            // title
            Align(
              alignment: AlignmentGeometry.center,
              child: Text(UIStrings.search, style: AppTextTheme.titleMedium),
            ),
            const Spacer(),
            // right hand search icon
            const Icon(Icons.search, size: 25),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    final either = await controller.selectFile();
    either.fold(
      (appError) {
        Get.snackbar('Oops!', appError.errorMessage);
      },
      (appSuccess) {
        Get.snackbar('Success!', appSuccess.successMessage!);
      },
    );
  }

  Future<void> _handleOntap(Function() function) async {
    final either = await function();
    either.fold(
      (appError) {
        Get.snackbar('Oops!', appError.errorMessage);
      },
      (appSuccess) {
        Get.back();
        Get.snackbar('Success!', appSuccess.successMessage!);
      },
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? data;
  final void Function() onTap;

  const _HomeButton({
    this.data,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHighlightChanged: (value) {},
      onTap: onTap,
      child: CardWidget(
        height: 70,
        child: Row(
          spacing: 20,
          children: [
            // left hand single icon
            Expanded(flex: 1, child: Icon(icon)),
            Expanded(
              flex: 8,
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // title text
                  Text(
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.titleMedium,
                    title,
                  ),
                  // description text
                  if (data != null)
                    Text(
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.titleSmall,
                      data!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
