// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      lastPayment: json['lastPayment'] as bool? ?? false,
      roomPrice: (json['roomPrice'] as num).toDouble(),
      receipt: json['receipt'] as String?,
      parkingAmount: (json['parkingAmount'] as num).toInt(),
      parkingFee: (json['parkingFee'] as num).toDouble(),
      hygiene: (json['hygiene'] as num).toDouble(),
      tenantChatID: json['tenantChatID'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      roomID: json['roomID'] as String,
      deposit: (json['deposit'] as num).toDouble(),
      transaction:
          TransactionKHQR.fromJson(json['transaction'] as Map<String, dynamic>),
      fine: (json['fine'] as num?)?.toDouble() ?? 0,
      timeStamp: DateTime.parse(json['timeStamp'] as String),
    )
      ..paymentStatus =
          $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus'])
      ..paymentApproval =
          $enumDecode(_$PaymentApprovalEnumMap, json['paymentApproval']);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'timeStamp': _dateTimeToJson(instance.timeStamp),
      'tenantChatID': instance.tenantChatID,
      'roomID': instance.roomID,
      'transaction': instance.transaction.toJson(),
      'roomPrice': instance.roomPrice,
      'hygiene': instance.hygiene,
      'parkingFee': instance.parkingFee,
      'deposit': instance.deposit,
      'lastPayment': instance.lastPayment,
      'receipt': instance.receipt,
      'fine': instance.fine,
      'parkingAmount': instance.parkingAmount,
      'totalPrice': instance.totalPrice,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'paymentApproval': _$PaymentApprovalEnumMap[instance.paymentApproval]!,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.unpaid: 'unpaid',
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
};

const _$PaymentApprovalEnumMap = {
  PaymentApproval.reject: 'reject',
  PaymentApproval.pending: 'pending',
  PaymentApproval.approve: 'approve',
};
