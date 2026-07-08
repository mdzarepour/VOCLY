import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:vocly/core/types/entity_types.dart';
import 'package:vocly/features/vocabulary/controller/search_controller.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

class SearchScreen extends GetView<WordSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstUiColors.forthColor,
      // search widget as appbar
      appBar: _searchWidget(),
      body: Obx(() {
        final words = controller.words;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            // empty state - listview
            _getMaiWidget(words: words),
          ],
        );
      }),
    );
  }

  Widget _getMaiWidget({required List<WordModel> words}) {
    if (words.isEmpty) {
      return _emptyStateWidget();
    } else {
      return _wordsListView(words);
    }
  }

  Widget _wordsListView(List<WordModel> words) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final currentWord = words[index];
          final query = controller.query;
          // listview child
          return InkWell(
            onTap: () => controller.goToReadWordScreen(word: currentWord),
            child: _SearchWordTile(currentWord: currentWord, query: query),
          );
        },
      ),
    );
  }

  AppBar _searchWidget() {
    return AppBar(
      // bottom line effect widget
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 0.8,
          width: double.infinity,
          color: ConstUiColors.firsColor,
        ),
      ),
      // search text field
      title: TextField(
        autofocus: true,
        cursorColor: ConstUiColors.thirdColor,
        controller: controller.queryController,
        style: AppTextTheme.titleMedium,
        decoration: InputDecoration(hintText: UIStrings.search),
        onChanged: (value) => controller.updateQuery(value: value),
      ),
    );
  }

  Widget _emptyStateWidget() {
    return SliverFillRemaining(
      fillOverscroll: false,
      hasScrollBody: false,
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 30),
          Text('Empty', style: AppTextTheme.titleMedium),
        ],
      ),
    );
  }
}

class _SearchWordTile extends StatelessWidget {
  final WordModel currentWord;
  final String query;
  const _SearchWordTile({required this.query, required this.currentWord});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: ConstUiColors.backgroundColor2),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 2,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // word name text
                Expanded(
                  child: SubstringHighlight(
                    text: currentWord.name,
                    overflow: TextOverflow.ellipsis,
                    term: query,
                    textStyle: AppTextTheme.titleMedium,
                    textStyleHighlight: AppTextTheme.titleMedium.copyWith(
                      color: ConstUiColors.blueHighLightColor,
                    ),
                  ),
                ),
                // word example text
                Expanded(
                  child: SubstringHighlight(
                    text: currentWord.example,
                    overflow: TextOverflow.ellipsis,
                    term: query,
                    textStyle: AppTextTheme.titleMedium,
                    textStyleHighlight: AppTextTheme.titleMedium.copyWith(
                      color: ConstUiColors.blueHighLightColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // right hand icon
          Icon(EntityIcon.children[currentWord.icon]),
        ],
      ),
    );
  }
}
