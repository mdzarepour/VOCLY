import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/app/core/router/app_router.dart';
import 'package:vocly/app/common/theme/app_ui_theme.dart';
import 'package:vocly/app/models/entities/word_model.dart';
import 'package:vocly/app/models/entities/book_model.dart';
import 'package:vocly/app/core/bindings/initial_binding.dart';
import 'package:vocly/app/common/constants/const_strings.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
      initialBinding: InitialBinding(),
      getPages: AppRouter.routes,
      theme: AppUiTheme.theme,
    );
  }
}
//TODO fix date sorting by changing datetime format

//TODO fix empty state after deleting words in manage words screen [its about filtering]
//TODO make repo implementation dry
//TODO fix duplicated import problem

///[for smooth manage words screen]
//step one
//TODO separate sorting and filtering logic from word controller (will use in other controllers)
//step two
//TODO delete sorting and filtering from _words getter
//step three
//TODO add pagination to word controller
//step four
//TODO use two getter and avoid using loadWords() every time -- use add.new word or updated word to visible words list instead of entire list
