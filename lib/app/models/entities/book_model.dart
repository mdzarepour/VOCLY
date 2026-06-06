import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'book_model.g.dart';

@HiveType(typeId: 1)
class BookModel extends HiveObject with EquatableMixin{

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  int color;

  @HiveField(4)
  int icon;

  @HiveField(5)
  List<String> words;

  BookModel({
    required this.id,
    required this.color,
    required this.icon,
    required this.name,
    required this.words,
    required this.description,
  });

  factory BookModel.fromMap({required final Map<String, dynamic> map}) {
    return BookModel(
      id: Uuid().v4(),
      name: map['name'],
      icon: map['banner'],
      color: map['color'],
      words: map['words'],
      description: map['description'],
    );
  }

  void updateBook({required final Map<String, dynamic> map}) {
    name = map['name'] ?? name;
    icon = map['banner'] ?? icon;
    color = map['color'] ?? color;
    words = map['words'] ?? words;
  }

  @override
  List<Object?> get props => [id];
}
