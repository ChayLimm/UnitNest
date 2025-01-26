import 'package:emonitor/model/json/jsonconvertor.dart';
import 'package:emonitor/model/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

enum Availibility{
  taken("taken",Color(0xFF4FAC80)),
  book("book",Color(0xFFF8A849)),
  available("available",Color(0xFF757575));

  final String status;
  final Color color;

  const Availibility(this.status,this.color);
}

@JsonSerializable()
class Room{
  final String id = const Uuid().v4();
  String name;
  double price;

  @AvailibilityConverter()
  Availibility roomStatus ;

  List<Payment> paymentList = [];
  List<Consumption> consumptionList = [];
  Room({required this.name, required this.price,this.roomStatus= Availibility.available});

  // List<Consumption> getPeviousAndNewConsumption(DateTime dateTime){
  //   List<Consumption> date=[];
  //   // var newConumption = consumptionList.map(toElement.timeStamp) find the matching dateTime
  //   // var preConsumtion = consumptionList.map(toElement.timeStamp) conditon if(toElement.timestamp.isBefore(newConumption.timestamp)){return toELement}
  //   date.add(newConumption);
  //   date.add(preConumption);
  //   return data;
  // }

}

@JsonSerializable()
class Consumption{
  final DateTime timestamp = DateTime.now();
  final double waterMeter;
  final double electricityMeter;
  
  Consumption({required this.waterMeter, required this.electricityMeter});

}