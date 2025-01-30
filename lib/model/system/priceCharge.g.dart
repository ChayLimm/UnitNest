// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priceCharge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceCharge _$PriceChargeFromJson(Map<String, dynamic> json) => PriceCharge(
      electricityPrice: (json['electricityPrice'] as num).toDouble(),
      waterPrice: (json['waterPrice'] as num).toDouble(),
      hygieneFee: (json['hygieneFee'] as num).toDouble(),
      finePerDay: (json['finePerDay'] as num).toDouble(),
      fineStartOn: (json['fineStartOn'] as num).toDouble(),
      rentParkingPrice: (json['rentParkingPrice'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
    )..endDate = DateTime.parse(json['endDate'] as String);

Map<String, dynamic> _$PriceChargeToJson(PriceCharge instance) =>
    <String, dynamic>{
      'electricityPrice': instance.electricityPrice,
      'waterPrice': instance.waterPrice,
      'hygieneFee': instance.hygieneFee,
      'finePerDay': instance.finePerDay,
      'fineStartOn': instance.fineStartOn,
      'rentParkingPrice': instance.rentParkingPrice,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
