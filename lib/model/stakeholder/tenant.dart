import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';


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
}