import 'package:uuid/uuid.dart';

class Landlord{
  final String id = Uuid().v4();
  String contact;
  String userName;

  Landlord({
    required this.contact, 
    required this.userName,
    });
}