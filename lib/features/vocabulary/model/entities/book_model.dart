import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vocly/features/vocabulary/model/entities/vacabulary_model.dart';
part 'book_model.g.dart';

@HiveType(typeId: 1)
class BookModel extends VacabularyModel with EquatableMixin, HiveObjectMixin {
  @override
  @HiveField(0)
  String id;

  @override
  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @override
  @HiveField(3)
  int color;

  @override
  @HiveField(4)
  int icon;

  @HiveField(5)
  List<String> words;

  @override
  @HiveField(6)
  int level;

  @override
  @HiveField(7)
  String createAt;

  @override
  @HiveField(8)
  int type;

  BookModel({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.words,
    required this.level,
    required this.createAt,
    required this.type,
  }) : super(
         id: id,
         name: name,
         color: color,
         icon: icon,
         level: level,
         createAt: createAt,
         type: type,
       );

  factory BookModel.fromMap({required final Map<String, dynamic> map}) {
    return BookModel(
      id: Uuid().v4(),
      createAt: DateTime.now().microsecond.toString(),
      name: map['name'],
      icon: map['banner'],
      color: map['color'],
      level: map['level'],
      words: map['words'],
      description: map['description'],
      type: map['type'],
    );
  }

  void updateBook({required final Map<String, dynamic> map}) {
    name = map['name'] ?? name;
    icon = map['banner'] ?? icon;
    color = map['color'] ?? color;
    words = map['words'] ?? words;
    level = map['level'] ?? level;
    type = map['type'] ?? type;
  }

  @override
  List<Object?> get props => [id];
}
