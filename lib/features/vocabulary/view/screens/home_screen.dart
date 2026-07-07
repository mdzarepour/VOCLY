import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/shared/widgets/input_widget.dart';
import 'package:vocly/features/vocabulary/controller/home_controller.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/router/app_router.dart';

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
          SizedBox(height: 20),
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
                    onTap: () => controller.goToManageBooksScreen(),
                  ),
                );
              }),
              // add words button
              Obx(() {
                final wordsLength = controller.wordsCount;
                return Expanded(
                  child: _HomeButton(
                    icon: Icons.language_outlined,
                    title: UIStrings.words,
                    data: '$wordsLength Words',
                    onTap: () => controller.goToManageWordsScreen(),
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              // add book button
              Expanded(
                child: _HomeButton(
                  icon: Icons.add_outlined,
                  title: UIStrings.newBook,
                  onTap: () => controller.goToAddEditBookScreen(),
                ),
              ),
              // add word button
              Expanded(
                child: _HomeButton(
                  icon: Icons.add_outlined,
                  title: UIStrings.newWord,
                  onTap: () => controller.goToAddEditWordScreen(),
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
            onTap: () {
              controller.openBookLibrary();
            },
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
                _exportWidget(),
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
            SizedBox(width: double.infinity, height: 15),
            // drag effect widget
            Container(
              width: 50,
              height: 3,
              decoration: BoxDecoration(color: ConstUiColors.thirdColor),
            ),
            SizedBox(height: 15),
            // title
            Text(style: AppTextTheme.titleMedium, 'Import data'),
            SizedBox(height: 15),
            // content text field
            InputWidget(
              hint: 'Data',
              controller: controller.inputController,
              icon: Icons.import_export_outlined,
            ),
            SizedBox(height: 20),
            // select file button
            InkWell(
              onTap: () async {
                final either = await controller.selectFile();
                either.fold(
                  (appError) {
                    Get.snackbar('Oops!', appError.errorMessage);
                  },
                  (appSuccess) {
                    Get.snackbar('Success', appSuccess.successMessage!);
                  },
                );
              },
              child: CardWidget(
                height: 70,
                child: Center(
                  child: Obx(() {
                    final fileName = controller.fileName;
                    return Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_drive_file_outlined),
                        Text(
                          style: AppTextTheme.titleMedium,
                          fileName.isEmpty ? 'Choose json file' : fileName,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 15),
            // action buttons
            Row(
              spacing: 10,
              children: [
                // confirm button
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final either = await controller.handleImport();
                      either.fold(
                        (appError) {
                          Get.snackbar('Oops!', appError.errorMessage);
                        },
                        (appSuccess) {
                          Get.back();
                          Get.snackbar('Success', appSuccess.successMessage!);
                        },
                      );
                    },
                    child: Obx(() {
                      final isLoading = controller.importLoading;
                      return CardWidget(
                        selectedBorderColor: ConstUiColors.positiveColor,
                        height: 70,
                        child: Center(
                          child: isLoading
                              ? SpinKitThreeInOut(
                                  size: 15,
                                  color: ConstUiColors.thirdColor,
                                )
                              : Text(
                                  style: AppTextTheme.titleMedium,
                                  'Confirm',
                                ),
                        ),
                      );
                    }),
                  ),
                ),
                // cancel button
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.clearBackupSession();
                    },
                    child: CardWidget(
                      selectedBorderColor: ConstUiColors.errorColor,
                      height: 70,
                      child: Center(
                        child: Text(style: AppTextTheme.titleMedium, 'Cancel'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exportWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final isLoading = controller.exportLoading;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: double.infinity, height: 15),
            // drag effect widget
            Container(
              width: 50,
              height: 3,
              decoration: BoxDecoration(color: ConstUiColors.thirdColor),
            ),
            SizedBox(height: 15),
            // title
            Text(style: AppTextTheme.titleMedium, 'Export data'),
            SizedBox(height: 20),
            // export to file button
            InkWell(
              onTap: () async {
                final either = await controller.exportToFile();
                either.fold(
                  (appError) {
                    Get.snackbar('Oops!', appError.errorMessage);
                  },
                  (appSuccess) {
                    Get.back();
                    Get.snackbar('Success', appSuccess.successMessage!);
                  },
                );
              },
              child: CardWidget(
                height: 70,
                child: Center(
                  child: isLoading == ExportStatus.file
                      ? SpinKitThreeInOut(
                          size: 15,
                          color: ConstUiColors.thirdColor,
                        )
                      : Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.insert_drive_file_outlined),
                            Text(
                              style: AppTextTheme.titleMedium,
                              'Export as file',
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // export to clip board button
            InkWell(
              onTap: () async {
                final either = await controller.exportToClipboard();
                either.fold(
                  (appError) {
                    Get.snackbar('Oops!', appError.errorMessage);
                  },
                  (appSuccess) {
                    Get.back();
                    Get.snackbar('Success!', appSuccess.successMessage!);
                  },
                );
              },
              child: CardWidget(
                height: 70,
                child: isLoading == ExportStatus.clipboard
                    ? SpinKitThreeInOut(
                        size: 15,
                        color: ConstUiColors.thirdColor,
                      )
                    : Center(
                        child: Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.paste),
                            Text(
                              style: AppTextTheme.titleMedium,
                              'Export to clipboard',
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            SizedBox(height: 15),
            // cancel button
            InkWell(
              onTap: () => Get.back(),
              child: CardWidget(
                selectedBorderColor: ConstUiColors.errorColor,
                height: 70,
                child: Center(
                  child: Text(style: AppTextTheme.titleMedium, 'Cancel'),
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        );
      }),
    );
  }

  Widget _searchWidget() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.searchScreen),
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
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
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
