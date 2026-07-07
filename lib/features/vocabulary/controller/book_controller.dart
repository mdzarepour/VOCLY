import 'package:get/get.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

class BookController extends GetxController {
  final BookRepository bookRepository;
  BookController({required this.bookRepository});

  final Rxn<BookModel> _currentBook = Rxn<BookModel>();
  BookModel? get currentBook => _currentBook.value;

  final List<BookModel> _books = <BookModel>[].obs;
  List<BookModel> get books => _books;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  void _updateLoadingState({required bool value}) {
    _isLoading.value = value;
  }

  void loadBooks() {
    try {
      final freshWords = bookRepository.getAllBooks();
      _books.assignAll(freshWords);
    } catch (error) {
   //   Get.snackbar('Failed!', _errorMessage(error));
    }
  }

  Future<void> deleteBooks({required List<BookModel> selectedBooks}) async {
    try {
      _updateLoadingState(value: true);
      await bookRepository.deleteBooks(selectedBooks: selectedBooks);
    } catch (error) {
    //  Get.snackbar('Oops!', _errorMessage(error));
    } finally {
      loadBooks();
      _updateLoadingState(value: false);
    }
  }

  Future<void> updateCurrentBook({required BookModel newBook}) async {
    try {
      await bookRepository.updateBook(book: newBook);
      _currentBook.value = newBook;
      _currentBook.refresh();
    } catch (error) {
     // Get.snackbar('Oops!', _errorMessage(error));
    } finally {
      loadBooks();
    }
  }

  Future<void> addBook({required Map<String, dynamic> map}) async {
    try {
      final BookModel book = BookModel.fromMap(map: map);
      await bookRepository.addBook(book: book);
    } catch (error) {
    //  Get.snackbar('Oops!', _errorMessage(error));
    } finally {
      Get.back();
      loadBooks();
    }
  }

  bool isBookExist({required final String name}) {
    try {
      return bookRepository.isBookExist(name: name);
    } catch (error) {
   //   Get.snackbar('Oops!', _errorMessage(error));
      return false;
    }
  }

  List<WordModel> getBookWords(BookModel book) {
    try {
      final List<WordModel> bookWords = bookRepository.getBookWords(book: book);
      return bookWords;
    } catch (error) {
   //   Get.snackbar('Oops!', _errorMessage(error));
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }
}
