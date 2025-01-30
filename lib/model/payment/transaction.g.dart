// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionKHQR _$TransactionKHQRFromJson(Map<String, dynamic> json) =>
    TransactionKHQR(
      qr: json['qr'] as String,
      md5: json['md5'] as String,
    );

Map<String, dynamic> _$TransactionKHQRToJson(TransactionKHQR instance) =>
    <String, dynamic>{
      'md5': instance.md5,
      'qr': instance.qr,
    };
