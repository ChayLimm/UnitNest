// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
      identifyID: json['identifyID'] as String,
      userName: json['userName'] as String,
      contact: json['contact'] as String,
      deposit: (json['deposit'] as num).toDouble(),
      rentParking: (json['rentParking'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
      'identifyID': instance.identifyID,
      'userName': instance.userName,
      'contact': instance.contact,
      'deposit': instance.deposit,
      'rentParking': instance.rentParking,
    };
