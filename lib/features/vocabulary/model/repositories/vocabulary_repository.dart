import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';

abstract class WordRepository {
  List<WordModel> getAllWords();
  Future<void> addWord({required WordModel word});
  Future<void> updateWord({required WordModel word});
  Future<void> deleteWords({required List<WordModel> selectedWords});
  bool isWordExist({required String name});
  List<WordModel> searchWords({required String query});
  ValueListenable<Box<WordModel>> get wordValueListenable;
  int get getWordsCount;
}

abstract class BookRepository {
  List<BookModel> getAllBooks();
  List<WordModel> getBookWords({required BookModel book});
  Future<void> addBook({required BookModel book});
  Future<void> updateBook({required BookModel book});
  Future<void> deleteBooks({required List<BookModel> selectedBooks});
  bool isBookExist({required String name});
  ValueListenable<Box<BookModel>> get bookValueListenable;
  int get getBooksCount;
}

abstract class BackupRepository {
  Future<String> exportHiveContent();
  Future<void> importHiveContent({required String content});
}
