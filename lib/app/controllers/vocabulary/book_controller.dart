import 'package:get/get.dart';
import 'package:vocly/app/models/entities/book_model.dart';
import 'package:vocly/app/models/entities/word_model.dart';
import 'package:vocly/app/models/repositories/vocabulary_repository.dart';

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
      Get.snackbar('Failed!', error.toString());
    }
  }

  Future<void> deleteBooks({required List<BookModel> selectedBooks}) async {
    try {
      _updateLoadingState(value: true);
      await bookRepository.deleteBooks(selectedItems: selectedBooks);
      loadBooks();
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
    } finally {
      _updateLoadingState(value: false);
    }
  }

  Future<void> updateCurrentBook({required BookModel newBook}) async {
    try {
      await bookRepository.updateBook(book: newBook);
      _currentBook.value = newBook;
      _currentBook.refresh();
      loadBooks();
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
    }
  }

  Future<void> addBook({required BookModel book}) async {
    try {
      await bookRepository.addBook(book: book);
      loadBooks();
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
    }
    Get.back();
  }

  bool isBookExist({required final String name}) {
    try {
      return bookRepository.isBookExist(name: name);
    } catch (error) {
      Get.snackbar('Oops!', error.toString());
      return false;
    }
  }

  List<WordModel> getBookWords(BookModel book) {
    try {
      final List<WordModel> bookWords = bookRepository.getBookWords(book: book);
      return bookWords;
    } catch (e) {
      Get.snackbar('Oops!', e.toString());
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }
}
