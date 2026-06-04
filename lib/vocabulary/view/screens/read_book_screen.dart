import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/constants/const_icons.dart';
import 'package:vocly/core/enums/enums.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/vocabulary/controller/book_controller.dart';
import 'package:vocly/vocabulary/model/book_model.dart';
import 'package:vocly/vocabulary/model/word_model.dart';
import 'package:vocly/vocabulary/view/widgets/word_tile.dart';

class ReadBookScreen extends StatefulWidget {
  const ReadBookScreen({super.key});

  @override
  State<ReadBookScreen> createState() => _ReadBookScreenState();
}

class _ReadBookScreenState extends State<ReadBookScreen> {
  final _bookController = Get.find<BookController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentWord = Get.arguments;
      if (currentWord != null) {
        _bookController.updateCurrentItem(freshModel: currentWord);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(UIStrings.bookReview, style: AppTextTheme.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              final currentBook = _bookController.currentItem;
              if (currentBook == null) {
                return CircularProgressIndicator();
              } else {
                return Column(
                  children: [
                    _cardWidget(currentBook: currentBook),
                    SizedBox(height: 20),
                    _editButton(currentBook: currentBook),
                    SizedBox(height: 20),
                    _wordsList(
                      currentBookWords: _bookController.getBookWords(
                        currentBook,
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _cardWidget({required final BookModel currentBook}) {
    return FlipCard(
      direction: FlipDirection.VERTICAL,
      speed: 250,
      front: Stack(
        children: [
          CardWidget(
            height: 130,
            selectedBorderColor: ConstEntityColors.colors[currentBook.color],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: double.infinity),
                Text(currentBook.name, style: AppTextTheme.titleMedium),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Icon(ConstIcons.icons[currentBook.icon]),
          ),
        ],
      ),
      back: Stack(
        children: [
          CardWidget(
            height: 130,
            selectedBorderColor: ConstEntityColors.colors[currentBook.color],
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: double.infinity),
                Text(currentBook.description, style: AppTextTheme.bodyLarge),
                Text(
                  style: AppTextTheme.bodyMedium,
                  'You have ${currentBook.words.length.toString()} words in this book',
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Icon(ConstIcons.icons[currentBook.icon]),
          ),
        ],
      ),
    );
  }

  Widget _wordsList({required final List<WordModel> currentBookWords}) {
    return currentBookWords.isEmpty
        ? Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off),
              Text(
                'you don\'t added any words yet',
                style: AppTextTheme.titleMedium,
              ),
            ],
          )
        : GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              mainAxisExtent: 70,
            ),
            itemCount: currentBookWords.length,
            itemBuilder: (context, index) {
              final WordModel currentWord = currentBookWords[index];

              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.readWordScreen, arguments: currentWord);
                },
                child: WordTile(
                  name: currentWord.name,
                  meaning: currentWord.meaning,
                  icon: currentWord.icon,
                  type: currentWord.type,
                  isSmallTile: true,
                  color: currentWord.color,
                ),
              );
            },
          );
  }

  Widget _editButton({required final BookModel currentBook}) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.addEditBookScreen,
        arguments: [BookScreenType.editBook, currentBook],
      ),
      child: CardWidget(
        height: 50,
        child: Center(
          child: Text(style: AppTextTheme.titleMedium, UIStrings.edit),
        ),
      ),
    );
  }
}
