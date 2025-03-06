import 'package:emonitor/domain/model/json/jsonconvertor.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';


enum Availibility{
  taken("taken",Color(0xFF4FAC80)),
  book("book",Color(0xFFF8A849)),
  available("available",Color(0xFF757575));

  final String status;
  final Color color;

  const Availibility(this.status,this.color);
}

@JsonSerializable(explicitToJson: true)
class Room{
  final String id = const Uuid().v4();
  String name;
  double price;
  Tenant? tenant;

  @AvailibilityConverter()
  Availibility roomStatus ;

  List<Payment> paymentList = [];
  List<Consumption> consumptionList = [];
  Room({required this.name, required this.price,this.roomStatus= Availibility.available, this.tenant});

   // Manually add fromJson and toJson
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
  
}

@JsonSerializable()
class Consumption{
  final DateTime timestamp = DateTime.now();
  final double waterMeter;
  final double electricityMeter;
  
  Consumption({required this.waterMeter, required this.electricityMeter});

  factory Consumption.fromJson(Map<String, dynamic> json) => _$ConsumptionFromJson(json);
  Map<String, dynamic> toJson() => _$ConsumptionToJson(this);
 

}