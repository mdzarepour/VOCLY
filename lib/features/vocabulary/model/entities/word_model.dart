import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vocly/core/types/vocabulary_model.dart';
part 'word_model.g.dart';

@HiveType(typeId: 0)
class WordModel extends VocabularyModel with EquatableMixin, HiveObjectMixin {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  String name;

  @HiveField(2)
  String meaning;

  @HiveField(3)
  String example;

  @override
  @HiveField(4)
  int icon;

  @override
  @HiveField(5)
  int type;

  @override
  @HiveField(6)
  int color;

  @override
  @HiveField(7)
  int level;

  @override
  @HiveField(8)
  int createAt;

  WordModel({
    required this.id,
    required this.name,
    required this.meaning,
    required this.example,
    required this.icon,
    required this.type,
    required this.level,
    required this.color,
    required this.createAt,
  }) : super(
         id: id,
         name: name,
         color: color,
         icon: icon,
         level: level,
         createAt: createAt,
         type: type,
       );

  factory WordModel.fromMap({required Map<String, dynamic> map}) {
    return WordModel(
      id: Uuid().v4(),
      createAt: DateTime.now().microsecondsSinceEpoch,
      name: map['name'],
      meaning: map['meaning'],
      example: map['example'],
      icon: map['icon'],
      type: map['type'],
      color: map['color'],
      level: map['level'],
    );
  }

  void updateWord({required Map<String, dynamic> map}) {
    name = map['name'] ?? name;
    meaning = map['meaning'] ?? meaning;
    example = map['example'] ?? example;
    icon = map['icon'] ?? icon;
    type = map['type'] ?? type;
    color = map['color'] ?? color;
    level = map['level'] ?? level;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'meaning': meaning,
      'example': example,
      'icon': icon,
      'type': type,
      'color': color,
      'level': level,
      'createAt': createAt,
    };
  }

  @override
  List<Object?> get props => [id];
}
