import 'package:uuid/uuid.dart';

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