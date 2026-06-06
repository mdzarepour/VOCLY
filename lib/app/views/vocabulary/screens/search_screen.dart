import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:vocly/app/controllers/vocabulary/search_controller.dart';
import 'package:vocly/app/common/constants/const_colors.dart';
import 'package:vocly/app/common/constants/const_icons.dart';
import 'package:vocly/app/common/theme/app_text_theme.dart';
import 'package:vocly/app/common/constants/const_strings.dart';
import 'package:vocly/app/core/router/app_router.dart';
import 'package:vocly/app/models/entities/word_model.dart';

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

        if (words.isEmpty) {
          return Center(child: _emptyStateWidget());
        } else {
          return Column(
            children: [
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final currentWord = words[index];
                    final query = _searchController.query;
                    return InkWell(
                      onTap: () => Get.toNamed(
                        Routes.readWordScreen,
                        arguments: currentWord,
                      ),
                      child: _SearchWordTile(
                        currentWord: currentWord,
                        query: query,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
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
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(UIStrings.thereIsNoWordYet, style: AppTextTheme.titleMedium),
        Icon(Icons.search_off_outlined, size: 30),
      ],
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
