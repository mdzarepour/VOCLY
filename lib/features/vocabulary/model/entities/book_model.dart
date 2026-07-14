import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vocly/core/types/vocabulary_model.dart';
import 'package:vocly/shared/constants/const_strings.dart';
part 'book_model.g.dart';

@HiveType(typeId: 1)
class BookModel extends VocabularyModel with EquatableMixin, HiveObjectMixin {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @override
  @HiveField(3)
  final int color;

  @override
  @HiveField(4)
  final int icon;

  @HiveField(5)
  final List<int> words;

  @override
  @HiveField(6)
  final int level;

  @override
  @HiveField(7)
  final int createAt;

  @override
  @HiveField(8)
  final int type;

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
      id: const Uuid().v4(),
      createAt: DateTime.now().microsecondsSinceEpoch,
      name: map[AppStrings.keyName],
      icon: map[AppStrings.keyIcon],
      color: map[AppStrings.keyColor],
      level: map[AppStrings.keyLevel],
      words: map[AppStrings.keyWords],
      description: map[AppStrings.keyDescription],
      type: map[AppStrings.keyType],
    );
  }

  BookModel copyWith({
    String? name,
    String? description,
    List<int>? words,
    int? icon,
    int? type,
    int? color,
    int? level,
  }) {
    return BookModel(
      id: id,
      createAt: createAt,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      color: color ?? this.color,
      level: level ?? this.level,
      words: words ?? this.words,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createAt,
    name,
    icon,
    color,
    level,
    words,
    description,
    type,
  ];
}
