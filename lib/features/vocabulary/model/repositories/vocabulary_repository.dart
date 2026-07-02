import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

abstract class WordRepository {
  List<WordModel> getAllWords();
  Future<void> addWord({required WordModel word});
  Future<void> updateWord({required WordModel word});
  Future<void> deleteWords({required List<WordModel> selectedWords});
  bool isWordExist({required String name});
  List<WordModel> searchWords({
    required List<WordModel> words,
    required String query,
  });
}

abstract class BookRepository {
  List<BookModel> getAllBooks();
  List<WordModel> getBookWords({required BookModel book});
  Future<void> addBook({required BookModel book});
  Future<void> updateBook({required BookModel book});
  Future<void> deleteBooks({required List<BookModel> selectedItems});
  bool isBookExist({required String name});
}

abstract class BackupRepository {
  Future<String> exportHiveContent();
  Future<void> importHiveContent({required String content});
}
