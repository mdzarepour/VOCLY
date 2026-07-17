import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vocly/core/types/vocabulary_model.dart';
import 'package:vocly/shared/constants/const_strings.dart';
part 'word_model.g.dart';

@HiveType(typeId: 0)
class WordModel extends VocabularyModel with EquatableMixin, HiveObjectMixin {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String name;

  @HiveField(2)
  final String meaning;

  @HiveField(3)
  final String example;

  @override
  @HiveField(4)
  final int icon;

  @override
  @HiveField(5)
  final int type;

  @override
  @HiveField(6)
  final int color;

  @override
  @HiveField(7)
  final int level;

  @override
  @HiveField(8)
  final int createAt;

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

  WordModel copyWith({
    String? name,
    String? meaning,
    String? example,
    int? icon,
    int? type,
    int? color,
    int? level,
  }) {
    return WordModel(
      id: id,
      createAt: createAt,
      name: name ?? this.name,
      meaning: meaning ?? this.meaning,
      example: example ?? this.example,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      color: color ?? this.color,
      level: level ?? this.level,
    );
  }

  factory WordModel.fromMap({required Map<String, dynamic> map}) {
    return WordModel(
      id: const Uuid().v4(),
      createAt: DateTime.now().microsecondsSinceEpoch,
      name: map[AppStrings.keyName],
      meaning: map[AppStrings.keyMeaning],
      example: map[AppStrings.keyExample],
      icon: map[AppStrings.keyIcon],
      type: map[AppStrings.keyType],
      color: map[AppStrings.keyColor],
      level: map[AppStrings.keyLevel],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppStrings.keyId: id,
      AppStrings.keyName: name,
      AppStrings.keyMeaning: meaning,
      AppStrings.keyExample: example,
      AppStrings.keyIcon: icon,
      AppStrings.keyType: type,
      AppStrings.keyColor: color,
      AppStrings.keyLevel: level,
      AppStrings.keyCreateAt: createAt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    meaning,
    example,
    icon,
    type,
    color,
    level,
    createAt,
  ];
}
