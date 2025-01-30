// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

System _$SystemFromJson(Map<String, dynamic> json) => System(
      id: json['id'] as String,
    )
      ..listBuilding = (json['listBuilding'] as List<dynamic>)
          .map((e) => Building.fromJson(e as Map<String, dynamic>))
          .toList()
      ..priceChargeList = (json['priceChargeList'] as List<dynamic>)
          .map((e) => PriceCharge.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SystemToJson(System instance) => <String, dynamic>{
      'id': instance.id,
      'listBuilding': instance.listBuilding.map((e) => e.toJson()).toList(),
      'priceChargeList':
          instance.priceChargeList.map((e) => e.toJson()).toList(),
    };
