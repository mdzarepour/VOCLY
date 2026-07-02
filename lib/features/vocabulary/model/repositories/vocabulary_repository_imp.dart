import 'dart:convert';
import 'dart:isolate';
import 'package:hive/hive.dart';
import 'package:vocly/core/error/app_exeption.dart';
import 'package:vocly/features/vocabulary/model/entities/book_model.dart';
import 'package:vocly/features/vocabulary/model/entities/word_model.dart';
import 'package:vocly/features/vocabulary/model/repositories/vocabulary_repository.dart';

class VocabularyRepository
    implements BackupRepository, WordRepository, BookRepository {
  final Box<WordModel> wordsBox;
  final Box<BookModel> booksBox;

  VocabularyRepository({required this.booksBox, required this.wordsBox});

  AppExeption _wrapException(Object error, {String? code}) {
    if (error is AppExeption) {
      return error;
    }
    return AppExeption(
      message: error.toString(),
      code: code,
      cause: error,
      stackTrace: StackTrace.current,
    );
  }

  @override
  Future<void> addBook({required BookModel book}) async {
    try {
      await booksBox.put(book.id, book);
    } on HiveError catch (error) {
      throw _wrapException(error, code: 'hive_error');
    }
  }

  @override
  Future<void> addWord({required WordModel word}) async {
    try {
      await wordsBox.put(word.id, word);
    } on HiveError catch (error) {
      throw _wrapException(error, code: 'hive_error');
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
      throw _wrapException(error, code: 'hive_error');
    }
  }

  @override
  Future<void> deleteWords({required List<WordModel> selectedWords}) async {
    try {
      final List<String> idsToMap = selectedWords.map((e) => e.id).toList();
      final List<String> keys = await Isolate.run(() => idsToMap.toList());
      await wordsBox.deleteAll(keys);
    } on HiveError catch (error) {
      throw _wrapException(error, code: 'hive_error');
    }
  }

  @override
  List<BookModel> getAllBooks() {
    try {
      final List<BookModel> books = booksBox.values.toList();
      return books;
    } catch (error) {
      throw _wrapException(error, code: 'read_error');
    }
  }

  @override
  List<WordModel> getAllWords() {
    try {
      final List<WordModel> words = wordsBox.values.toList();
      return words;
    } catch (error) {
      throw _wrapException(error, code: 'read_error');
    }
  }

  @override
  bool isBookExist({required String name}) {
    try {
      return booksBox.values.any(
        (element) => element.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (error) {
      throw _wrapException(error, code: 'read_error');
    }
  }

  @override
  bool isWordExist({required String name}) {
    try {
      return wordsBox.values.any(
        (element) => element.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (error) {
      throw _wrapException(error, code: 'read_error');
    }
  }

  @override
  List<WordModel> searchWords({
    required List<WordModel> words,
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return words;
    }
    return words.where((word) {
      final name = word.name.toLowerCase();
      final example = word.example.toLowerCase();
      return name.contains(normalizedQuery) ||
          example.contains(normalizedQuery);
    }).toList();
  }

  @override
  Future<void> updateBook({required BookModel book}) async {
    try {
      await booksBox.put(book.id, book);
    } on HiveError catch (error) {
      throw _wrapException(error, code: 'hive_error');
    }
  }

  @override
  Future<void> updateWord({required WordModel word}) async {
    try {
      await wordsBox.put(word.id, word);
    } on HiveError catch (error) {
      throw _wrapException(error, code: 'hive_error');
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
      throw _wrapException(error, code: 'hive_error');
    } catch (error) {
      throw _wrapException(error, code: 'read_error');
    }
  }

  @override
  Future<String> exportHiveContent() async {
    try {
      final List<Map<String, dynamic>> rawList = wordsBox.values
          .map<Map<String, dynamic>>((word) => word.toMap())
          .toList();

      final String encodedData = await Isolate.run(() {
        return jsonEncode(rawList);
      });
      return encodedData;
    } on HiveError catch (error) {
      throw _wrapException(error, code: 'hive_error');
    } catch (error) {
      throw _wrapException(error, code: 'export_error');
    }
  }

  @override
  Future<void> importHiveContent({required String content}) async {
    try {
      final Map<dynamic, WordModel> wordsMap = await Isolate.run(() {
        final decodedList = jsonDecode(content) as List<dynamic>;

        final Map<dynamic, WordModel> map = {};
        for (var item in decodedList) {
          final word = WordModel.fromMap(item);
          map[word.id] = word;
        }
        return map;
      });
      if (wordsBox.values.length + wordsMap.length > 50000) {
        final remainCapacity = 50000 - wordsBox.values.length;
        throw _wrapException(
          'Remains word capacity is $remainCapacity ',
          code: 'capacity_error',
        );
      }
      await wordsBox.putAll(wordsMap);
    } on HiveError catch (error) {
      throw _wrapException(error, code: 'hive_error');
    } catch (error) {
      if (error is AppExeption) {
        rethrow;
      }
      throw _wrapException(error, code: 'import_error');
    }
  }
}
