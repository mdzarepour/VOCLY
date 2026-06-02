import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'word_model.g.dart';

@HiveType(typeId: 0)
class WordModel extends HiveObject with EquatableMixin{
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? meaning;

  @HiveField(2)
  String? example;

  @HiveField(3)
  int? icon;

  @HiveField(4)
  int? type;

  @HiveField(5)
  int? color;

  WordModel({
    this.name,
    this.meaning,
    this.example,
    this.icon,
    this.type,
    this.color,
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
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
  List<Object?> get props => [
    name,
    meaning,
    example,
    icon,
    type,
    color
  ];
}

