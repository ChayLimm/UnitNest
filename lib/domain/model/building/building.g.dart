// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Building _$BuildingFromJson(Map<String, dynamic> json) => Building(
      name: json['name'] as String,
      address: json['address'] as String,
      floorCount: (json['floorCount'] as num?)?.toInt() ?? 0,
      parkingSpace: (json['parkingSpace'] as num?)?.toInt() ?? 0,
      id: json['id'] as String?,
    )..roomList = (json['roomList'] as List<dynamic>)
        .map((e) => Room.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$BuildingToJson(Building instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'floorCount': instance.floorCount,
      'parkingSpace': instance.parkingSpace,
      'roomList': instance.roomList.map((e) => e.toJson()).toList(),
    };
