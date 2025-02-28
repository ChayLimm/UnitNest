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


  void registrationTenant(Tenant tenant, double deposit, Room room) {
    for (var building1 in listBuilding) {
      for (var room1 in building1.roomList) {
        if (room1.id == room.id) {
          room1.tenant = tenant;
        }
      }
    }
    proccessPayment(tenant.id);
    notifyListeners();
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

  Future<void> proccessPayment(String tenantID,
      [Consumption? consumption, bool lastpayment = false]) async {
    final DateTime timestamp =
        consumption == null ? DateTime.now() : consumption.timestamp;
    late PriceCharge priceCharge;
    late Building building;
    late Room room;
    late Tenant tenant;
    late double deposit;
    double totalPrice;

    //get valid pricecharge
    for (var item in landlord.settings!.priceChargeList) {
      if (item.isValidDate(timestamp)) {
        priceCharge = item;
      }
    }
    //find who is paying for which room
    for (var building1 in listBuilding) {
      for (var room1 in building1.roomList) {
        if (room.tenant!.id == tenantID) {
          building = building1;
          room = room1;
          tenant = room.tenant!;
        }
      }
    }
    //find deposit
    if (tenant.deposit < room.price) {
      deposit = room.price - tenant.deposit;
    } else {
      deposit = 0;
    }

    //calculate roomprice & rent parking if have
    if (consumption == null) {
      //first payment
      totalPrice = room.price +
          deposit +
          (tenant.rentParking.toDouble() * priceCharge.rentParkingPrice);
    } else {
      Consumption lastCons = room.consumptionList.last;
      final double elecTotalPrice =
          (consumption.electricityMeter - lastCons.electricityMeter) *
              priceCharge.electricityPrice;
      final double waterPrice = (consumption.waterMeter - lastCons.waterMeter) *
              priceCharge.waterPrice +
          priceCharge.hygieneFee;
      if (lastpayment) {
        //last payment
        totalPrice =
            deposit + elecTotalPrice + waterPrice + priceCharge.hygieneFee;
      } else {
        //normal payment
        totalPrice = room.price +
            deposit +
            (tenant.rentParking.toDouble() * priceCharge.rentParkingPrice) +
            elecTotalPrice +
            waterPrice +
            priceCharge.hygieneFee;
      }

      room.consumptionList.add(consumption);
    }

    TransactionKHQR transaction = await requestKHQR(totalPrice);

    Payment payment = Payment(
      tenant: tenant,
      room: room,
      deposit: deposit,
      transaction: transaction,
    );
    payment.paymentStatus = PaymentStatus.pending;

    room.paymentList.add(payment);
    //sync with cloud
    syncCloud();
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

 
  //CRUD Tenants please use ID for all for of these
  void updateTenant(Tenant tenant) {
    for (var building in listBuilding) {
      for (var room in building.roomList) {
        if (room.tenant?.id == tenant.id) {
          room.tenant = tenant;
          syncCloud();
        }
      }
    }
  }

  void removeTenant(Tenant tenant) {
    for (var building in listBuilding) {
      for (var room in building.roomList) {
        if (room.tenant?.id == tenant.id) {
          room.tenant = null;
          syncCloud();
        }
      }
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
