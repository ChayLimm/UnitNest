// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      tenant: Tenant.fromJson(json['tenant'] as Map<String, dynamic>),
      landlord: Landlord.fromJson(json['landlord'] as Map<String, dynamic>),
      room: Room.fromJson(json['room'] as Map<String, dynamic>),
      deposit: (json['deposit'] as num).toDouble(),
      transaction:
          Transaction.fromJson(json['transaction'] as Map<String, dynamic>),
      fine: (json['fine'] as num?)?.toDouble() ?? 0,
    )
      ..paymentStatus =
          $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus'])
      ..paymentApproval =
          $enumDecode(_$PaymentApprovalEnumMap, json['paymentApproval']);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'tenant': instance.tenant.toJson(),
      'landlord': instance.landlord.toJson(),
      'room': instance.room.toJson(),
      'deposit': instance.deposit,
      'transaction': instance.transaction.toJson(),
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'paymentApproval': _$PaymentApprovalEnumMap[instance.paymentApproval]!,
      'fine': instance.fine,
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
