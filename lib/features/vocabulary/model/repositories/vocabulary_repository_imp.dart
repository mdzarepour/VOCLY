import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  ValueListenable<Box<WordModel>> get wordListenable {
    return wordsBox.listenable();
  }

  @override
  ValueListenable<Box<BookModel>> get bookListenable {
    return booksBox.listenable();
  }

  @override
  Future<void> addBook({required BookModel book}) async {
    try {
      await booksBox.add(book);
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message, cause: error);
    }
  }

  @override
  Future<void> addWord({required WordModel word}) async {
    try {
      await wordsBox.add(word);
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message, cause: error);
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
      throw AppError(errorMessage: error.message, cause: error);
    }
  }

  @override
  Future<void> deleteWords({required List<WordModel> selectedWords}) async {
    try {
      final keysToDelete = selectedWords.map((word) => word.key).toList();
      await wordsBox.deleteAll(keysToDelete);
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message, cause: error);
    }
  }

  @override
  bool isBookExist({required String name}) {
    try {
      return booksBox.values.any(
        (element) => element.name.toLowerCase().contains(name.toLowerCase()),
      );
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message, cause: error);
    }
  }

  @override
  bool isWordExist({required String name}) {
    try {
      return wordsBox.values.any(
        (element) => element.name.toLowerCase().contains(name.toLowerCase()),
      );
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message, cause: error);
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
  Future<void> updateBook({required int key, required BookModel book}) async {
    try {
      await booksBox.put(key, book);
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message, cause: error);
    }
  }

  @override
  Future<void> updateWord({required int key, required WordModel word}) async {
    try {
      await wordsBox.put(key, word);
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message, cause: error);
    }
  }

  @override
  List<WordModel> getBookWords({required BookModel book}) {
    try {
      return book.words
          .map((key) => wordsBox.get(key))
          .whereType<WordModel>()
          .toList();
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message, cause: error);
    } catch (error) {
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
      throw AppError(errorMessage: error.message, cause: error);
    } catch (error) {
      throw AppError(errorMessage: error.toString(), cause: error);
    }
  }

  @override
  Future<void> importHiveContent({required String content}) async {
    try {
      final decoded = jsonDecode(content) as List<dynamic>;
      if (wordsBox.length + decoded.length > 30000) {
        throw const AppError(errorMessage: 'Capacity exceeded');
      }
      final items = decoded.map((e) {
        return WordModel.fromMap(map: Map<String, dynamic>.from(e));
      }).toList();

      for (int i = 0; i < items.length; i++) {
        await wordsBox.add(items[i]);
      }
    } on HiveError catch (error) {
      throw AppError(errorMessage: error.message);
    } catch (error) {
      throw AppError(errorMessage: error.toString());
    }
  }
}
