// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String?,
      username: fields[1] as String?,
      fullname: fields[2] as String?,
      img: fields[3] as String?,
      email: fields[4] as String?,
      cityToSearch: fields[11] as String?,
      rating: fields[5] as int?,
      numberOfRatings: fields[6] as int?,
      reviews: (fields[10] as List?)?.cast<String?>(),
      phoneNumber: fields[7] as String?,
      joinedOn: fields[8] as String?,
      superuser: fields[9] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.fullname)
      ..writeByte(3)
      ..write(obj.img)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.numberOfRatings)
      ..writeByte(7)
      ..write(obj.phoneNumber)
      ..writeByte(8)
      ..write(obj.joinedOn)
      ..writeByte(9)
      ..write(obj.superuser)
      ..writeByte(10)
      ..write(obj.reviews)
      ..writeByte(11)
      ..write(obj.cityToSearch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
