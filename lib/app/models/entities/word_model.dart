import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'word_model.g.dart';

@HiveType(typeId: 0)
class WordModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String meaning;

  @HiveField(3)
  String example;

  @HiveField(4)
  int icon;

  @HiveField(5)
  int type;

  @HiveField(6)
  int color;

  @HiveField(7)
  int level;

  @HiveField(8)
  String createAt;

  WordModel({
    required this.id,
    required this.name,
    required this.meaning,
    required this.example,
    required this.icon,
    required this.type,
    required this.color,
    required this.level,
    required this.createAt,
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] ?? Uuid().v4(),
      createAt: DateTime.now().microsecond.toString(),
      name: map['name'],
      meaning: map['meaning'],
      example: map['example'],
      icon: map['icon'],
      type: map['type'],
      color: map['color'],
      level: map['level'],
    );
  }

  void updateWordModel({required Map<String, dynamic> map}) {
    name = map['name'];
    meaning = map['meaning'];
    example = map['example'];
    icon = map['icon'];
    type = map['type'];
    color = map['color'];
    level = map['level'];
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
