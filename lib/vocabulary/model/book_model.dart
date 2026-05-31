import 'package:hive_flutter/hive_flutter.dart';
import 'package:vocly/vocabulary/model/word_model.dart';
part 'book_model.g.dart';

@HiveType(typeId: 1)
class BookModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  int color;

  @HiveField(3)
  int icon;

  @HiveField(4)
  List<WordModel> words;

  BookModel({
    required this.color,
    required this.icon,
    required this.name,
    required this.words,
    required this.description,
  });

  factory BookModel.fromMap({required final Map<String, dynamic> map}) {
    return BookModel(
      name: map['name'],
      description: map['description'],
      icon: map['banner'],
      color: map['color'],
      words: map['words'],
    );
  }

  void updateBook({required final Map<String, dynamic> map}) {
    name = map['name'] ?? name;
    icon = map['banner'] ?? icon;
    color = map['color'] ?? color;
    words = map['words'] ?? words;
  }
}
