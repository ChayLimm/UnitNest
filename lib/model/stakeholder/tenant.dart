import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tenant.g.dart';

@JsonSerializable()
class Tenant {
  final String id = Uuid().v4();
  final DateTime registeredOn = DateTime.now();
  String identifyID;
  String userName;
  String contact;
  double deposit;

  Tenant({
    required this.identifyID,
    required this.userName,
    required this.contact,
    required this.deposit,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
  Map<String, dynamic> toJson() => _$TenantToJson(this);
 
}