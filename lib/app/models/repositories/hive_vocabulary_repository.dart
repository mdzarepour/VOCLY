import 'package:hive/hive.dart';
import 'package:vocly/app/models/entities/book_model.dart';
import 'package:vocly/app/models/entities/word_model.dart';
import 'package:vocly/app/models/repositories/vocabulary_repository.dart';

class HiveVocabularyRepository implements WordRepository, BookRepository {
  final Box<WordModel> wordsBox;
  final Box<BookModel> booksBox;

  HiveVocabularyRepository({required this.booksBox, required this.wordsBox});

  @override
  Future<void> addBook({required BookModel book}) async {
    try {
      await booksBox.put(book.id, book);
    } on HiveError catch (error) {
      throw error.message;
    }
  }

  @override
  Future<void> addWord({required WordModel word}) async {
    try {
      await wordsBox.put(word.id, word);
    } on HiveError catch (error) {
      throw error.message;
    }
  }

  @override
  Future<void> deleteBooks({required List<BookModel> selectedItems}) async {
    try {
      for (var item in selectedItems) {
        if (item.isInBox) {
          await booksBox.delete(item.id);
        }
      }
    } on HiveError catch (error) {
      throw error.message;
    }
  }

  @override
  Future<void> deleteWords({required List<WordModel> selectedWords}) async {
    try {
      for (var item in selectedWords) {
        if (item.isInBox) {
          await wordsBox.delete(item.id);
        }
      }
    } on HiveError catch (error) {
      throw error.message;
    }
  }

  @override
  List<BookModel> getAllBooks() {
    try {
      final List<BookModel> books = booksBox.values.toList();
      return books;
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  List<WordModel> getAllWords() {
    try {
      final List<WordModel> words = wordsBox.values.toList();
      return words;
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  bool isBookExist({required String name}) {
    try {
      return booksBox.values.any(
        (element) => element.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  bool isWordExist({required String name}) {
    try {
      return wordsBox.values.any(
        (element) => element.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  Future<void> updateBook({required BookModel book}) async {
    try {
      await booksBox.put(book.id, book);
    } on HiveError catch (error) {
      throw error.message;
    }
  }

  @override
  Future<void> updateWord({required WordModel word}) async {
    try {
      await wordsBox.put(word.id, word);
    } on HiveError catch (error) {
      throw error.message;
    }
  }

  @override
  List<WordModel> getBookWords({required BookModel book}) {
    return book.words
        .map((id) => wordsBox.get(id))
        .whereType<WordModel>()
        .toList();
  }
}
