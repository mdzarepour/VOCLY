import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/app/common/widgets/input_widget.dart';
import 'package:vocly/app/controllers/vocabulary/backup_controller.dart';
import 'package:vocly/app/controllers/vocabulary/book_controller.dart';
import 'package:vocly/app/controllers/vocabulary/word_controller.dart';
import 'package:vocly/app/common/theme/app_text_theme.dart';
import 'package:vocly/app/common/constants/const_strings.dart';
import 'package:vocly/app/common/widgets/card_widget.dart';
import 'package:vocly/app/common/constants/const_colors.dart';
import 'package:vocly/app/core/enums/enums.dart';
import 'package:vocly/app/core/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  final void Function()? onTap;
  const HomeScreen({super.key, this.onTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _backupInputController = TextEditingController();

  final _wordController = Get.find<WordController>();
  final _bookController = Get.find<BookController>();
  final _backupController = Get.find<BackupController>();

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
          Text(UIStrings.yourVocabulary, style: AppTextTheme.titleMedium),
          const SizedBox(height: 15),
          Row(
            spacing: 10,
            children: [
              // manage books button -->
              Obx(() {
                final booksLength = _bookController.books.length;
                return Expanded(
                  child: _HomeButton(
                    icon: Icons.chrome_reader_mode_outlined,
                    title: UIStrings.books,
                    data: '$booksLength Books',
                    onTap: () => Get.toNamed(Routes.manageBooksScreen),
                  ),
                );
              }),
              // add words button -->
              Obx(() {
                final wordsLength = _wordController.items.length;
                return Expanded(
                  child: _HomeButton(
                    icon: Icons.language_outlined,
                    title: UIStrings.words,
                    data: '$wordsLength Words',
                    onTap: () => Get.toNamed(
                      Routes.manageWordsScreen,
                      arguments: [ManageWordsScreenType.manageWords, null],
                    ),
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              // add book button -->
              Expanded(
                child: _HomeButton(
                  icon: Icons.add_outlined,
                  title: UIStrings.newBook,
                  onTap: () => Get.toNamed(
                    Routes.addEditBookScreen,
                    arguments: [BookScreenType.addBook, null],
                  ),
                ),
              ),
              // add word button -->
              Expanded(
                child: _HomeButton(
                  icon: Icons.add_outlined,
                  title: UIStrings.newWord,
                  onTap: () => Get.toNamed(
                    Routes.addEditWordScreen,
                    arguments: [WordScreenType.addWord, null],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text('Use Prepared Books', style: AppTextTheme.titleMedium),
          const SizedBox(height: 15),
          _HomeButton(
            icon: Icons.coffee_outlined,
            title: 'Use vocabulary',
            data: 'We are prepared some vocabulary for you',
            onTap: () {},
          ),
          const SizedBox(height: 30),
          Text(UIStrings.yourData, style: AppTextTheme.titleMedium),
          const SizedBox(height: 15),
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
          _HomeButton(
            icon: Icons.import_export,
            title: UIStrings.importYourData,
            data: UIStrings.importPreviouslySavedVocabulary,
            onTap: () {
              Get.bottomSheet(
                backgroundColor: ConstUiColors.backgroundColor,
                _importWidget(),
              );
              _backupInputController.clear();
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
            Container(
              width: 50,
              height: 3,
              decoration: BoxDecoration(color: ConstUiColors.thirdColor),
            ),
            SizedBox(height: 15),
            Text(style: AppTextTheme.titleMedium, 'Import data'),
            SizedBox(height: 15),
            InputWidget(
              hint: 'Data',
              controller: _backupInputController,
              icon: Icons.import_export_outlined,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => _backupController.selectFile(),
              child: CardWidget(
                height: 70,
                child: Center(
                  child: Obx(() {
                    final fileName = _backupController.fileName;
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
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (_backupInputController.text.isEmpty) {
                        await _backupController.importFromFile();
                      } else {
                        final content = _backupInputController.text;
                        await _backupController.importFromClipBoard(
                          content: content,
                        );
                      }
                      _wordController.loadItems();
                    },
                    child: Obx(() {
                      final isLoading = _backupController.isLoading;
                      return CardWidget(
                        selectedBorderColor: ConstUiColors.positiveColor,
                        height: 70,
                        child: Center(
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  style: AppTextTheme.titleMedium,
                                  'Confirm',
                                ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      _backupController.clearBackupSession();
                    },
                    child: CardWidget(
                      selectedBorderColor: ConstUiColors.errorColor,
                      height: 70,
                      child: Center(
                        child: Text(style: AppTextTheme.titleMedium, 'Cancle'),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: double.infinity, height: 15),
          Container(
            width: 50,
            height: 3,
            decoration: BoxDecoration(color: ConstUiColors.thirdColor),
          ),
          SizedBox(height: 15),
          Text(style: AppTextTheme.titleMedium, 'Export data'),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _backupController.exportToFile(),
            child: Obx(() {
              final isLoading = _backupController.isLoading;
              return CardWidget(
                height: 70,
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
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
              );
            }),
          ),
          SizedBox(height: 15),
          InkWell(
            onTap: () => _backupController.exportToClipboard(),
            child: CardWidget(
              height: 70,
              child: Center(
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
          InkWell(
            onTap: () => Get.back(),
            child: CardWidget(
              selectedBorderColor: ConstUiColors.errorColor,
              height: 70,
              child: Center(
                child: Text(style: AppTextTheme.titleMedium, 'Cancle'),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
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
            InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(Icons.menu, size: 25),
              ),
            ),
            const SizedBox(width: 10),
            Align(
              alignment: AlignmentGeometry.center,
              child: Text(UIStrings.search, style: AppTextTheme.titleMedium),
            ),
            const Spacer(),
            const Icon(Icons.search, size: 25),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _backupInputController.dispose();
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
            Expanded(flex: 1, child: Icon(icon)),
            Expanded(
              flex: 8,
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.titleMedium,
                    title,
                  ),
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
