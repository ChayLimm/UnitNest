
import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';



enum PaymentStatus{
  unpaid("Unpaid"),
  pending("Pending"),
  paid("Paid");

  final String status;
  const PaymentStatus(this.status);
}
enum PaymentApproval{
  reject("Rejected"),
  pending("Pending"),
  approve("Approved");

  final String status;
  const PaymentApproval(this.status);
}
String _dateTimeToJson(DateTime date) => date.toIso8601String();

@JsonSerializable(explicitToJson: true)
class Payment {
  @JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToJson)
  late DateTime timeStamp;
  final String tenantChatID;
  final String roomID;
  final TransactionKHQR transaction;

  final double roomPrice;
  final double hygiene; // uncomputable
  final double parkingFee; // uncomputable
  final double deposit; //uncomputatble

  late bool lastPayment;

  String? receipt;

  double fine; // uncomputable

  final int parkingAmount; // uncomputable

  double totalPrice;// uncomputable

  PaymentStatus paymentStatus = PaymentStatus.unpaid;
  PaymentApproval paymentApproval = PaymentApproval.pending;

  Payment({
    this.lastPayment = false, 
    required this.roomPrice,
    this.receipt,
    required this.parkingAmount,
    required this.parkingFee,
    required this.hygiene,
    required this.tenantChatID, 
    required this.totalPrice,
    required this.roomID, 
    required this.deposit,
    required this.transaction,
    this.fine = 0,
    DateTime? timeStamp,
  }) : timeStamp = timeStamp ?? DateTime.now();

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}