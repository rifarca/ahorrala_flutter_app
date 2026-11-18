// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Items.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemsAdapter extends TypeAdapter<Items> {
  @override
  final int typeId = 1;

  @override
  Items read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Items(
      Sku: fields[3] as String,
      Titulo: fields[2] as String,
      Imagen: fields[4] as String,
      CategoriaID: fields[5] as int,
      CategoriaNombre: fields[6] as String,
      SubcategoriaNombre: fields[8] as String,
      SubcategoriaID: fields[7] as int,
      NegocioID: fields[13] as int,
      NegocioNombre: fields[1] as String,
      PrecioNuevo: fields[9] as int,
      PrecioViejo: fields[10] as int,
      PrecioOff: fields[11] as int,
      Link: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Items obj) {
    writer
      ..writeByte(13)
      ..writeByte(13)
      ..write(obj.NegocioID)
      ..writeByte(1)
      ..write(obj.NegocioNombre)
      ..writeByte(2)
      ..write(obj.Titulo)
      ..writeByte(3)
      ..write(obj.Sku)
      ..writeByte(4)
      ..write(obj.Imagen)
      ..writeByte(5)
      ..write(obj.CategoriaID)
      ..writeByte(6)
      ..write(obj.CategoriaNombre)
      ..writeByte(7)
      ..write(obj.SubcategoriaID)
      ..writeByte(8)
      ..write(obj.SubcategoriaNombre)
      ..writeByte(9)
      ..write(obj.PrecioNuevo)
      ..writeByte(10)
      ..write(obj.PrecioViejo)
      ..writeByte(11)
      ..write(obj.PrecioOff)
      ..writeByte(12)
      ..write(obj.Link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
