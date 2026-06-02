import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/core/enums/enums.dart';
import 'package:vocly/core/router/app_router.dart';

class HomeScreen extends StatelessWidget {
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
          Text(UIStrings.yourVocabulary, style: AppTextTheme.titleMedium),
          const SizedBox(height: 15),
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 70,
            ),
            children: [
              _HomeButton(
                icon: Icons.chrome_reader_mode_outlined,
                title: UIStrings.books,
                data: '50 Books',
                onTap: () => Get.toNamed(Routes.manageBooksScreen),
              ),
              _HomeButton(
                icon: Icons.language_outlined,
                title: UIStrings.words,
                data: '30 Words',
                onTap: () => Get.toNamed(
                  Routes.manageWordsScreen,
                  arguments: [
                    ManageWordsScreenType.manageWords ,
                    null
                  ],
                ),
              ),
              _HomeButton(
                icon: Icons.add_outlined,
                title: UIStrings.newBook,
                onTap: () => Get.toNamed(Routes.addEditBookScreen ,
                arguments: [
                  BookScreenType.addBook ,
                  null
                ]
                ),
              ),
              _HomeButton(
                icon: Icons.add_outlined,
                title: UIStrings.newWord,
                onTap: () => Get.toNamed(
                  Routes.addEditWordScreen,
                  arguments: [WordScreenType.addWord, null],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(UIStrings.yourData, style: AppTextTheme.titleMedium),
          const SizedBox(height: 15),
          _HomeButton(
            icon: Icons.folder_outlined,
            title: UIStrings.exportYour,
            data: UIStrings.exportYourDataDescription,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _HomeButton(
            icon: Icons.import_export,
            title: UIStrings.importYourData,
            data: UIStrings.importPreviouslySavedVocabulary,
            onTap: () {},
          ),
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
          border: Border.all(color: ConstUiColors.backgroundColor2, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: ConstUiColors.forthColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onTap,
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
    return GestureDetector(
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
