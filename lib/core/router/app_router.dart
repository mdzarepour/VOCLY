import 'package:get/get_navigation/get_navigation.dart';
import 'package:vocly/vocabulary/binding/vocabulary_binding.dart';
import 'package:vocly/vocabulary/view/screens/add_edit_book_screen.dart';
import 'package:vocly/vocabulary/view/screens/home_screen.dart';
import 'package:vocly/vocabulary/view/screens/add_edit_word_screen.dart';
import 'package:vocly/vocabulary/view/screens/manage_books_screen.dart';
import 'package:vocly/vocabulary/view/screens/read_book_screen.dart';
import 'package:vocly/vocabulary/view/screens/read_word_screen.dart';
import 'package:vocly/vocabulary/view/screens/search_screen.dart';
import 'package:vocly/vocabulary/view/screens/manage_words_screen.dart';
import 'package:vocly/common/widgets/wrapper_screen.dart';

class AppRouter {
  AppRouter._();
  static final routes = [
    GetPage(
      showCupertinoParallax: false,
      name: Routes.initial,
      page: () => WarpperScreen(),
      binding: AppCoreBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.addEditWordScreen,
      page: () => AddEditWordScreen(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.addEditBookScreen,
      page: () => AddEditBookScreen(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.searchScreen,
      page: () => SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.manageWordsScreen,
      page: () => ManageWordsScreen(),
      binding: ManageWordsBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.manageBooksScreen,
      page: () => ManageBooksScreen(),
      binding: ManageBooksBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.readWordScreen,
      page: () => ReadWordScreen(),
      binding: WordDetailsBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.readBookScreen,
      page: () => ReadBookScreen(),
      binding: WordDetailsBinding(),
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
