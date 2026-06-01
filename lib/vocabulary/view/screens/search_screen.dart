import 'package:flutter/material.dart';
import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/widgets/filter_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstUiColors.forthColor,
      appBar: _searchWidget(),
      body: Column(
        children: [
          SizedBox(height: 15),
          SizedBox(
            height: 35,
            child: ListView(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                FilterWidget(onTap: () {}, title: UIStrings.sortWords),
                FilterWidget(onTap: () {}, title: UIStrings.color),
                FilterWidget(onTap: () {}, title: UIStrings.type),
                FilterWidget(onTap: () {}, title: UIStrings.book),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: 50,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(UIStrings.data),
                  //child: WordTile(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _searchWidget() {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(
          height: 0.8,
          width: double.infinity,
          color: ConstUiColors.firsColor,
        ),
      ),
      title: TextField(
        autofocus: true,
        cursorColor: ConstUiColors.thirdColor,
        controller: _searchController,
        style: AppTextTheme.titleMedium,
        decoration: InputDecoration(hintText: UIStrings.search),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}







