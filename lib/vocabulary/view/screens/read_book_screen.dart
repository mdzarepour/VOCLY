import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/widgets/card_widget.dart';
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
        title: Text('Book review', style: AppTextTheme.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GetBuilder<BookController>(
              builder: (controller) {
                final BookModel? currentBook = controller.currentItem;
                if (currentBook == null) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      SizedBox(height: 20, width: double.infinity),
                      _bannerImage(currentBook),
                      SizedBox(height: 20),
                      _editButton(),
                      SizedBox(height: 20),
                      _wordsList(currentBook),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _wordsList(BookModel currentBook) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        mainAxisExtent: 70,
      ),
      itemCount: currentBook.words.length,
      itemBuilder: (context, index) {
        final WordModel currentWord = currentBook.words[index];
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

  Widget _editButton() {
    return InkWell(
      child: CardWidget(
        height: 50,
        child: Center(child: Text(style: AppTextTheme.titleMedium, 'Edit')),
      ),
    );
  }

  Widget _bannerImage(BookModel currentBook) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
      child: Image.asset(
        fit: BoxFit.cover,
        width: double.infinity,
        height: 150,
        'assets/${currentBook.banner}.jpg',
      ),
    );
  }
}
