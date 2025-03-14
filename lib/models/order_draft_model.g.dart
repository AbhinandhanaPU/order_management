// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_draft_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderDraftAdapter extends TypeAdapter<OrderDraft> {
  @override
  final int typeId = 3;

  @override
  OrderDraft read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderDraft(
      order: fields[0] as Order,
      createdAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OrderDraft obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.order)
      ..writeByte(1)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDraftAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
