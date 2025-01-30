import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
part 'landlord.g.dart';


@JsonSerializable()
class Landlord{
  final String id = Uuid().v4();
  String contact;
  String userName;

  Landlord({
    required this.contact, 
    required this.userName,
    });

  factory Landlord.fromJson(Map<String, dynamic> json) => _$LandlordFromJson(json);
  Map<String, dynamic> toJson() => _$LandlordToJson(this);
 
}