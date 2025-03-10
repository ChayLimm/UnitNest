// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      roomStatus: json['roomStatus'] == null
          ? Availibility.available
          : const AvailibilityConverter()
              .fromJson(json['roomStatus'] as Map<String, dynamic>),
      tenant: json['tenant'] == null
          ? null
          : Tenant.fromJson(json['tenant'] as Map<String, dynamic>),
      id: json['id'] as String?,
    )
      ..paymentList = (json['paymentList'] as List<dynamic>)
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList()
      ..consumptionList = (json['consumptionList'] as List<dynamic>)
          .map((e) => Consumption.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'tenant': instance.tenant?.toJson(),
      'roomStatus': const AvailibilityConverter().toJson(instance.roomStatus),
      'paymentList': instance.paymentList.map((e) => e.toJson()).toList(),
      'consumptionList':
          instance.consumptionList.map((e) => e.toJson()).toList(),
    };

Consumption _$ConsumptionFromJson(Map<String, dynamic> json) => Consumption(
      waterMeter: (json['waterMeter'] as num).toDouble(),
      electricityMeter: (json['electricityMeter'] as num).toDouble(),
    );

Map<String, dynamic> _$ConsumptionToJson(Consumption instance) =>
    <String, dynamic>{
      'waterMeter': instance.waterMeter,
      'electricityMeter': instance.electricityMeter,
    };
