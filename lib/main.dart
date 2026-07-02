import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/features/vocabulary/binding/initial_binding.dart';
import 'package:vocly/core/router/app_router.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/theme/app_ui_theme.dart';

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
