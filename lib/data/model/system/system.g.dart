// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

System _$SystemFromJson(Map<String, dynamic> json) => System(
      landlord: Landlord.fromJson(json['landlord'] as Map<String, dynamic>),
      id: json['id'] as String,
    )..listBuilding = (json['listBuilding'] as List<dynamic>)
        .map((e) => Building.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$SystemToJson(System instance) => <String, dynamic>{
      'id': instance.id,
      'landlord': instance.landlord.toJson(),
      'listBuilding': instance.listBuilding.map((e) => e.toJson()).toList(),
    };
