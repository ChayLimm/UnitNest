import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/stakeholder/landlord.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'system.g.dart';

@JsonSerializable(explicitToJson: true)
class System extends ChangeNotifier {
  final String id;
  static int num = 0;
  Landlord landlord;

  ////Convert this into JSON
  List<Building> listBuilding = [];
  // List<PriceCharge> priceChargeList = [];
  System({required this.landlord, required this.id});

  factory System.fromJson(Map<String, dynamic> json) => _$SystemFromJson(json);

  Map<String, dynamic> toJson() => _$SystemToJson(this);

  
 
  void sendMessageViaTelegramBot(String message, Tenant chatID) {
    // reqeuest API in nodejss
  }
  void generateReceipt(Payment payment) {
    // retrieve newConumption which newConumption's timestamp == payment.timestamp and the previoseConsumption is after newConumption timestamp
    DateTime timestamp = payment.timeStamp;
    List<Consumption> consumptionList = payment.room.consumptionList;
    late Consumption newConsumption;
    late Consumption preConsumption;
    for (var item in consumptionList) {
      if (item.timestamp == timestamp) {
        newConsumption = item;
        break;
      }
    }
    for (var item in consumptionList) {
      if (item.timestamp.isBefore(newConsumption.timestamp)) {
        preConsumption = item;
        break;
      }
    }

    // find package to generate reciept as png
  }

  
 
  //#############
  //clone from old system
  //####
 
 

}
