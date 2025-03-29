import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tenant.g.dart';

@JsonSerializable()
class Tenant {
  final String id = const Uuid().v4();
  final DateTime registeredOn = DateTime.now();

  final String chatID;

  String identifyID;
  String userName;
  String contact;
  double deposit;
  int rentParking ;

  Tenant({
    required this.chatID,
    required this.identifyID,
    required this.userName,
    required this.contact,
    required this.deposit,
    this.rentParking = 0,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
  Map<String, dynamic> toJson() => _$TenantToJson(this);
 
}