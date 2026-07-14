import 'package:get/get_navigation/get_navigation.dart';
import 'package:vocly/features/vocabulary/binding/vocabulary_binding.dart';
import 'package:vocly/features/vocabulary/view/screens/book_crud_screen.dart';
import 'package:vocly/features/vocabulary/view/screens/word_crud_screen.dart';
import 'package:vocly/features/vocabulary/view/screens/home_screen.dart';
import 'package:vocly/features/vocabulary/view/screens/book_manager_screen.dart';
import 'package:vocly/features/vocabulary/view/screens/word_manager_screen.dart';
import 'package:vocly/features/vocabulary/view/screens/book_details_screen.dart';
import 'package:vocly/features/vocabulary/view/screens/word_details_screen.dart';
import 'package:vocly/features/vocabulary/view/screens/search_screen.dart';
import 'package:vocly/shared/widgets/wrapper_screen.dart';

class AppRouter {
  AppRouter._();
  static final routes = [
    GetPage(
      showCupertinoParallax: false,
      name: Routes.initial,
      page: () => const WrapperScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.homeScreen,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.wordCrudScreen,
      page: () => const WordCrudScreen(),
      binding: WordCrudBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.bookCrudScreen,
      page: () => const BookCrudScreen(),
      binding: BookCrudBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.searchScreen,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.wordManagerScreen,
      page: () => const WordManagerScreen(),
      binding: WordManageBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.bookManagerScreen,
      page: () => const ManageBooksScreen(),
      binding: BookManageBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.wordDetailsScreen,
      page: () => const WordDetailsScreen(),
      binding: ReadWordBinding(),
    ),
    GetPage(
      showCupertinoParallax: false,
      name: Routes.bookDetailsScreen,
      page: () => const BookDetailsScreen(),
      binding: ReadBookBinding(),
    ),
  ];
}

class Routes {
  Routes._();
  static const String initial = '/';
  static const String homeScreen = '/homeScreen';
  static const String wordCrudScreen = '/addEditWordScreen';
  static const String bookCrudScreen = '/addEditBookScreen';
  static const String searchScreen = '/searchScreen';
  static const String wordManagerScreen = '/manageWordsScreen';
  static const String bookManagerScreen = '/manageBooksScreen';
  static const String wordDetailsScreen = '/readWordScreen';
  static const String bookDetailsScreen = '/readBookScreen';
}
