// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      merchantType: json['merchantType'] as String,
      bakongAccountID: json['bakongAccountID'] as String?,
      accountInformation: json['accountInformation'] as String?,
      merchantID: json['merchantID'] as String?,
      acquiringBank: json['acquiringBank'] as String?,
      billNumber: json['billNumber'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      storeLabel: json['storeLabel'] as String?,
      terminalLabel: json['terminalLabel'] as String?,
      payloadFormatIndicator: json['payloadFormatIndicator'] as String,
      pointofInitiationMethod: json['pointofInitiationMethod'] as String,
      merchantCategoryCode: json['merchantCategoryCode'] as String,
      transactionCurrency: json['transactionCurrency'] as String,
      transactionAmount: json['transactionAmount'] as String,
      countryCode: json['countryCode'] as String,
      merchantName: json['merchantName'] as String,
      merchantCity: json['merchantCity'] as String,
      timestamp: json['timestamp'] as String,
      crc: json['crc'] as String,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'merchantType': instance.merchantType,
      'bakongAccountID': instance.bakongAccountID,
      'accountInformation': instance.accountInformation,
      'merchantID': instance.merchantID,
      'acquiringBank': instance.acquiringBank,
      'billNumber': instance.billNumber,
      'mobileNumber': instance.mobileNumber,
      'storeLabel': instance.storeLabel,
      'terminalLabel': instance.terminalLabel,
      'payloadFormatIndicator': instance.payloadFormatIndicator,
      'pointofInitiationMethod': instance.pointofInitiationMethod,
      'merchantCategoryCode': instance.merchantCategoryCode,
      'transactionCurrency': instance.transactionCurrency,
      'transactionAmount': instance.transactionAmount,
      'countryCode': instance.countryCode,
      'merchantName': instance.merchantName,
      'merchantCity': instance.merchantCity,
      'timestamp': instance.timestamp,
      'crc': instance.crc,
    };
