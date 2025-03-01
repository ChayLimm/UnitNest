import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/data/model/building/building.dart';
import 'package:emonitor/data/model/building/room.dart';
import 'package:emonitor/data/model/payment/payment.dart';
import 'package:emonitor/data/model/payment/transaction.dart';
import 'package:emonitor/data/model/stakeholder/landlord.dart';
import 'package:emonitor/data/model/stakeholder/tenant.dart';
import 'package:emonitor/data/model/system/priceCharge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

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

  Future<void> updateLandlord([String? userName, String? phoneNumber]) async{
    landlord = Landlord(
      username: userName !=null ? userName : landlord.username,
       phoneNumber: phoneNumber != null ? phoneNumber : landlord.phoneNumber,
       settings: landlord.settings
       );
       
    await syncCloud();
  }

  Future<void> updateBakongAccount(BakongAccount newBakongAccount) async{
    landlord.settings!.bakongAccount = newBakongAccount;
    await syncCloud();
  }


 
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

  Future<void> addPriceCharge(PriceCharge pricecharge) async {
    landlord.settings!.priceChargeList.last.endDate = DateTime.now();
    landlord.settings!.priceChargeList.add(pricecharge);
    notifyListeners();
    await syncCloud();
  }

  Future<bool> checkTransStatus(Payment payment) async {
    String md5 = payment.transaction.md5;
    final url = Uri.parse('http://localhost:4040/khqrkhqrstatus');
    try {
      var body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'md5': md5}
            ]
          }
        ]
      });

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      return true;
      // check (reposone ?= null) true;
    } catch (e) {
      print(e);
      return false;
    }
  }

 
 
  //#############
  //clone from old system
  //####
  Payment? getPaymentThisMonth(Room room, [DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return room.paymentList.isNotEmpty &&
            room.paymentList.last.timeStamp.month == dateTime.month &&
            room.paymentList.last.timeStamp.year == dateTime.year
        ? room.paymentList.last
        : null;
  }

  double getDepositPrice(Room room) {
    return room.tenant!.deposit < room.price
        ? room.price - room.tenant!.deposit
        : 0;
  }

  bool roomIsLeaving() {
    /// need to implement
    return true;
  }
}
