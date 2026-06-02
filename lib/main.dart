import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/theme/app_ui_theme.dart';
import 'package:vocly/vocabulary/model/book_model.dart';
import 'package:vocly/vocabulary/model/word_model.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(WordModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(BookModelAdapter());
  }

  await Hive.openBox<WordModel>(AppStrings.wordBox);
  await Hive.openBox<BookModel>(AppStrings.bookBox);
  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initial,
      getPages: AppRouter.routes,
      theme: AppUiTheme.theme,
    );
  }
}

// add animation to screens
// revise vertical spacing in widgets
// make selection widgets reusable
// make screens customscrollable



