// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landlord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Landlord _$LandlordFromJson(Map<String, dynamic> json) => Landlord(
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String,
      settings: json['settings'] == null
          ? null
          : LandlordSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LandlordToJson(Landlord instance) => <String, dynamic>{
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'settings': instance.settings?.toJson(),
    };

LandlordSettings _$LandlordSettingsFromJson(Map<String, dynamic> json) =>
    LandlordSettings(
      bakongAccount:
          BakongAccount.fromJson(json['bakongAccount'] as Map<String, dynamic>),
      priceChargeList: (json['priceChargeList'] as List<dynamic>)
          .map((e) => PriceCharge.fromJson(e as Map<String, dynamic>))
          .toList(),
      rule: json['rule'] as String? ?? " ",
    );

Map<String, dynamic> _$LandlordSettingsToJson(LandlordSettings instance) =>
    <String, dynamic>{
      'bakongAccount': instance.bakongAccount.toJson(),
      'priceChargeList':
          instance.priceChargeList.map((e) => e.toJson()).toList(),
      'rule': instance.rule,
    };

BakongAccount _$BakongAccountFromJson(Map<String, dynamic> json) =>
    BakongAccount(
      bakongID: json['bakongID'] as String,
      username: json['username'] as String,
      location: json['location'] as String,
    );

Map<String, dynamic> _$BakongAccountToJson(BakongAccount instance) =>
    <String, dynamic>{
      'bakongID': instance.bakongID,
      'username': instance.username,
      'location': instance.location,
    };
