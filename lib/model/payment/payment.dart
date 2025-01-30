
import 'package:emonitor/model/building/room.dart';
import 'package:emonitor/model/payment/transaction.dart';
import 'package:emonitor/model/stakeholder/landlord.dart';
import 'package:emonitor/model/stakeholder/tenant.dart';
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



@JsonSerializable(explicitToJson: true)
class Payment {
  final DateTime timeStamp = DateTime.now();
  final Tenant tenant;
  final Landlord landlord;
  final Room room;
  final double deposit;
  final Transaction transaction;
  PaymentStatus paymentStatus = PaymentStatus.unpaid;
  PaymentApproval paymentApproval = PaymentApproval.pending;
  double fine;
  Payment({required this.tenant, required this.landlord, required this.room, required this.deposit,required this.transaction,this.fine = 0});

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);


  void setFine(DateTime){

  }
  void getPaymentStatus(){

  }
}