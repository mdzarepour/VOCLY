import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:vocly/features/vocabulary/controller/book_controller.dart';
import 'package:vocly/features/vocabulary/view/widgets/word_tile.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/constants/const_icons.dart';
import 'package:vocly/core/types/enums.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

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
        _bookController.updateCurrentBook(newBook: currentWord);
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
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Obx(() {
            final currentBook = _bookController.currentBook;
            if (currentBook == null) {
              return SpinKitThreeInOut(
                size: 15,
                color: ConstUiColors.thirdColor,
              );
            } else {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _cardWidget(currentBook: currentBook),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: _editButton(currentBook: currentBook),
                  ),
                  _getWordsListView(currentBook: currentBook),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _getWordsListView({required BookModel currentBook}) {
    if (currentBook.words.isEmpty) {
      return _emptyStateWidget();
    } else {
      return _wordsList(
        currentBookWords: _bookController.getBookWords(currentBook),
      );
    }
  }

  SliverFillRemaining _emptyStateWidget() {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: false,
      child: Column(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined),
          Text(style: AppTextTheme.titleMedium, 'You dont added words yet!'),
        ],
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
    return SliverPadding(
      padding: EdgeInsetsGeometry.only(top: 20),
      sliver: SliverGrid.builder(
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
      ),
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
