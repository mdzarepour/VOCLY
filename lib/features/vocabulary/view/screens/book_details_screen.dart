import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/controller/book_details_controller.dart';
import 'package:vocly/features/vocabulary/view/widgets/word_tile.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

class BookDetailsScreen extends GetView<BookDetailsController> {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        centerTitle: false,
        title: Text(UIStrings.bookReview, style: AppTextTheme.titleMedium),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Obx(() {
            final currentBook = controller.book;
            final currentBookWords = controller.bookWords;
            return CustomScrollView(
              slivers: [
                // flip card widget
                SliverToBoxAdapter(
                  child: _cardWidget(currentBook: currentBook!),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                // edit button
                SliverToBoxAdapter(
                  child: _editButton(currentBook: currentBook),
                ),
                // main widget as listview or empty state
                _getMainWidget(currentBookWords: currentBookWords),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _cardWidget({required final BookModel currentBook}) {
    // book card widget
    return FlipCard(
      direction: FlipDirection.VERTICAL,
      speed: 250,
      // card front
      front: Stack(
        children: [
          CardWidget(
            height: 130,
            selectedBorderColor: EntityColor.children[currentBook.color],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                // book name
                Text(currentBook.name, style: AppTextTheme.titleMedium),
              ],
            ),
          ),
          // right hand word icon
          Positioned(
            top: 20,
            right: 20,
            child: Icon(EntityIcon.children[currentBook.icon]),
          ),
        ],
      ),
      // card back
      back: Stack(
        children: [
          CardWidget(
            height: 130,
            selectedBorderColor: EntityColor.children[currentBook.color],
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                // book name
                Text(currentBook.description, style: AppTextTheme.bodyLarge),
                // count of words
                Text(
                  style: AppTextTheme.bodyMedium,
                  '${currentBook.words.length.toString()} words in the book',
                ),
              ],
            ),
          ),
          // right hand book icon
          Positioned(
            bottom: 20,
            right: 20,
            child: Icon(EntityIcon.children[currentBook.icon]),
          ),
        ],
      ),
    );
  }

  Widget _getMainWidget({required List<WordModel> currentBookWords}) {
    if (currentBookWords.isEmpty) {
      return _emptyStateWidget();
    } else {
      return _wordsList(currentBookWords: currentBookWords);
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
          const Icon(Icons.search_off_outlined),
          Text(style: AppTextTheme.titleMedium, 'You dont added words yet!'),
        ],
      ),
    );
  }

  Widget _wordsList({required final List<WordModel> currentBookWords}) {
    return SliverPadding(
      padding: const EdgeInsetsGeometry.only(top: 20),
      // sliver gridview
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          mainAxisExtent: 70,
        ),
        itemCount: currentBookWords.length,
        itemBuilder: (context, index) {
          // word tile
          final currentWord = currentBookWords[index];
          return InkWell(
            onTap: () => controller.goToWordDetailsScreen(key: currentWord.key),
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
      onTap: () => controller.goToAddEditBookScreen(),
      child: CardWidget(
        height: 50,
        child: Center(
          child: Text(style: AppTextTheme.titleMedium, UIStrings.edit),
        ),
      ),
    );
  }
}
