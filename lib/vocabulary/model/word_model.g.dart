part of 'word_model.dart';

class WordModelAdapter extends TypeAdapter<WordModel> {
  @override
  final int typeId = 0;

  @override
  WordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordModel(
      id: fields[0] as String,
      name: fields[1] as String,
      meaning: fields[2] as String,
      example: fields[3] as String,
      icon: fields[4] as int,
      type: fields[5] as int,
      color: fields[6] as int,
      difficulty: fields[7] as int,
      createAt: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.meaning)
      ..writeByte(3)
      ..write(obj.example)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.color)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.createAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
