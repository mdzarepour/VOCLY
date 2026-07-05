import 'dart:convert';
import 'dart:isolate';
import 'package:hive/hive.dart';
import 'package:vocly/core/error/app_exception.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

class VocabularyRepository
    implements BackupRepository, WordRepository, BookRepository {
  final Box<WordModel> wordsBox;
  final Box<BookModel> booksBox;

  VocabularyRepository({required this.booksBox, required this.wordsBox});

  @override
  int get getBooksCount => booksBox.values.length;

  @override
  int get getWordsCount => wordsBox.values.length;

  @override
  Future<void> addBook({required BookModel book}) async {
    try {
      await booksBox.add(book);
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  Future<void> addWord({required WordModel word}) async {
    try {
      await wordsBox.add(word);
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  Future<void> deleteBooks({required List<BookModel> selectedBooks}) async {
    try {
      for (var currentBook in selectedBooks) {
        if (currentBook.isInBox) {
          await currentBook.delete();
        }
      }
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  Future<void> deleteWords({required List<WordModel> selectedWords}) async {
    try {
      for (var currentWord in selectedWords) {
        if (currentWord.isInBox) {
          await currentWord.delete();
        }
      }
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  List<BookModel> getAllBooks() {
    try {
      final List<BookModel> books = booksBox.values.toList();
      return books;
    } catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  List<WordModel> getAllWords() {
    try {
      final List<WordModel> words = wordsBox.values.toList();
      return words.reversed.toList();
    } catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  bool isBookExist({required String name}) {
    try {
      return booksBox.values.any(
        (element) => element.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  bool isWordExist({required String name}) {
    try {
      return wordsBox.values.any(
        (element) => element.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  List<WordModel> searchWords({required String query}) {
    final allWords = wordsBox.values.toList();
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return allWords;
    }
    return allWords.where((word) {
      return word.name.toLowerCase().contains(normalizedQuery) ||
          word.example.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  @override
  Future<void> updateBook({required BookModel book}) async {
    try {
      await book.save();
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  Future<void> updateWord({required WordModel word}) async {
    try {
      await word.save();
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  List<WordModel> getBookWords({required BookModel book}) {
    try {
      return book.words
          .map((id) => wordsBox.get(id))
          .whereType<WordModel>()
          .toList();
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  Future<String> exportHiveContent() async {
    try {
      final rawList = wordsBox.values
          .map<Map<String, dynamic>>((word) => word.toMap())
          .toList();
      final String encodedData = await Isolate.run(() {
        return jsonEncode(rawList);
      });
      return encodedData;
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  Future<void> importHiveContent({required String content}) async {
    final decoded = await Isolate.run(
      () => jsonDecode(content) as List<dynamic>,
    );
    if (wordsBox.length + decoded.length > 50000) {
      throw AppError(errorMessage: 'Capacity exceeded');
    }
    final existing = wordsBox.values.map((e) => e.id).toSet();
    final items = decoded
        .map((e) => WordModel.fromMap(Map<String, dynamic>.from(e)))
        .where((w) => !existing.contains(w.id))
        .toList();
    await wordsBox.addAll(items);
  }
}
