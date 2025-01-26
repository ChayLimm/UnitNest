import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class Landlord{
  final String id = Uuid().v4();
  String contact;
  String userName;

  Landlord({
    required this.contact, 
    required this.userName,
    });
}