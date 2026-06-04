import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'word_model.g.dart';

@HiveType(typeId: 0)
class WordModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  String id;

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

  WordModel({
    required this.id,
    required this.name,
    required this.meaning,
    required this.example,
    required this.icon,
    required this.type,
    required this.color,
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: Uuid().v4(),
      name: map['name'],
      meaning: map['meaning'],
      example: map['example'],
      icon: map['icon'],
      type: map['type'],
      color: map['color'],
    );
  }

  void updateWordModel({required final Map<String, dynamic> map}) {
    name = map['name'];
    meaning = map['meaning'];
    example = map['example'];
    icon = map['icon'];
    type = map['type'];
    color = map['color'];
  }

  @override
  List<Object?> get props => [id];
}
