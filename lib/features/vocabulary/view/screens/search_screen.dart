import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:vocly/features/vocabulary/controller/search_controller.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_icons.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = Get.find<WordSearchController>();

  final TextEditingController _queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstUiColors.forthColor,
      appBar: _searchWidget(),
      body: Obx(() {
        final words = _searchController.words;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 20)),
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
          final query = _searchController.query;
          return InkWell(
            onTap: () =>
                Get.toNamed(Routes.readWordScreen, arguments: currentWord),
            child: _SearchWordTile(currentWord: currentWord, query: query),
          );
        },
      ),
    );
  }

  AppBar _searchWidget() {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 0.8,
          width: double.infinity,
          color: ConstUiColors.firsColor,
        ),
      ),
      title: TextField(
        autofocus: true,
        cursorColor: ConstUiColors.thirdColor,
        controller: _queryController,
        style: AppTextTheme.titleMedium,
        decoration: InputDecoration(hintText: UIStrings.search),
        onChanged: (value) => _searchController.updateQuery(value: value),
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

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
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
          Icon(ConstIcons.icons[currentWord.icon]),
        ],
      ),
    );
  }
}
