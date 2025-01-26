import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class Transaction {
  final String merchantType;
  final String? bakongAccountID;
  final String? accountInformation;
  final String? merchantID;
  final String? acquiringBank;
  final String? billNumber;
  final String? mobileNumber;
  final String? storeLabel;
  final String? terminalLabel;
  final String payloadFormatIndicator;
  final String pointofInitiationMethod;
  final String merchantCategoryCode;
  final String transactionCurrency;
  final String transactionAmount;
  final String countryCode;
  final String merchantName;
  final String merchantCity;
  final String timestamp;
  final String crc;

  Transaction({
    required this.merchantType,
    this.bakongAccountID,
    this.accountInformation,
    this.merchantID,
    this.acquiringBank,
    this.billNumber,
    this.mobileNumber,
    this.storeLabel,
    this.terminalLabel,
    required this.payloadFormatIndicator,
    required this.pointofInitiationMethod,
    required this.merchantCategoryCode,
    required this.transactionCurrency,
    required this.transactionAmount,
    required this.countryCode,
    required this.merchantName,
    required this.merchantCity,
    required this.timestamp,
    required this.crc,
  });

 
}
