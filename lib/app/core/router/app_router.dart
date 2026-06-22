import 'package:get/get_navigation/get_navigation.dart';
import 'package:vocly/app/core/bindings/vocabulary_binding.dart';
import 'package:vocly/app/views/vocabulary/screens/add_edit_book_screen.dart';
import 'package:vocly/app/views/vocabulary/screens/home_screen.dart';
import 'package:vocly/app/views/vocabulary/screens/add_edit_word_screen.dart';
import 'package:vocly/app/views/vocabulary/screens/manage_books_screen.dart';
import 'package:vocly/app/views/vocabulary/screens/read_book_screen.dart';
import 'package:vocly/app/views/vocabulary/screens/read_word_screen.dart';
import 'package:vocly/app/views/vocabulary/screens/search_screen.dart';
import 'package:vocly/app/views/vocabulary/screens/manage_words_screen.dart';
import 'package:vocly/app/common/widgets/wrapper_screen.dart';

class AppRouter {
  AppRouter._();
  static final routes = [
    GetPage(
      showCupertinoParallax: false,
      name: Routes.initial,
      page: () => WarpperScreen(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.homeScreen,
      page: () => HomeScreen(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.addEditWordScreen,
      page: () => AddEditWordScreen(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.addEditBookScreen,
      page: () => AddEditBookScreen(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.searchScreen,
      page: () => SearchScreen(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.manageWordsScreen,
      page: () => ManageWordsScreen(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.manageBooksScreen,
      page: () => ManageBooksScreen(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.readWordScreen,
      page: () => ReadWordScreen(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.readBookScreen,
      page: () => ReadBookScreen(),
      binding: VocabularyBinding(),
    ),
  ];
}

class Routes {
  Routes._();
  static const String initial = '/';
  static const String addEditWordScreen = '/addEditWordScreen';
  static const String addEditBookScreen = '/addEditBookScreen';
  static const String searchScreen = '/searchScreen';
  static const String homeScreen = '/homeScreen';
  static const String manageWordsScreen = '/manageWordsScreen';
  static const String manageBooksScreen = '/manageBooksScreen';
  static const String readWordScreen = '/readWordScreen';
  static const String readBookScreen = '/readBookScreen';
}
