// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      receipt: json['receipt'] as String?,
      parkingAmount: (json['parkingAmount'] as num).toInt(),
      parkingFee: (json['parkingFee'] as num).toDouble(),
      hygiene: (json['hygiene'] as num).toDouble(),
      tenant: Tenant.fromJson(json['tenant'] as Map<String, dynamic>),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      room: Room.fromJson(json['room'] as Map<String, dynamic>),
      deposit: (json['deposit'] as num).toDouble(),
      transaction:
          TransactionKHQR.fromJson(json['transaction'] as Map<String, dynamic>),
      fine: (json['fine'] as num?)?.toDouble() ?? 0,
    )
      ..paymentStatus =
          $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus'])
      ..paymentApproval =
          $enumDecode(_$PaymentApprovalEnumMap, json['paymentApproval']);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'tenant': instance.tenant.toJson(),
      'room': instance.room.toJson(),
      'transaction': instance.transaction.toJson(),
      'hygiene': instance.hygiene,
      'parkingFee': instance.parkingFee,
      'deposit': instance.deposit,
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
