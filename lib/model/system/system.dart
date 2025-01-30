import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/model/building/building.dart';
import 'package:emonitor/model/building/room.dart';
import 'package:emonitor/model/payment/payment.dart';
import 'package:emonitor/model/payment/transaction.dart';
import 'package:emonitor/model/stakeholder/landlord.dart';
import 'package:emonitor/model/stakeholder/tenant.dart';
import 'package:emonitor/model/system/priceCharge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;


part 'system.g.dart';

@JsonSerializable(explicitToJson: true)
class System extends ChangeNotifier {
  final String id;
  List<Building> listBuilding = [];
  List<PriceCharge> priceChargeList = [];
  System({required this.id});

  factory System.fromJson(Map<String, dynamic> json) => _$SystemFromJson(json);

  Map<String, dynamic> toJson() => _$SystemToJson(this);

  Future<TransactionKHQR> requestKHQR(double amount) async {
    final url = Uri.parse('http://localhost:4040/khqr');
    try {
      var body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'amount': amount}
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

 
      var jsonData = jsonDecode(response.body); 

      String md5 = jsonData['md5'] ?? '';  
      String qr = jsonData['qr'] ?? '';   

      return TransactionKHQR(md5: md5, qr: qr);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> syncCloud () async{
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser; 
    await firestore
        .collection('system')
        .doc(user!.uid)
        .set({
          'listBuilding': listBuilding,
          'priceChargeList': priceChargeList,
        }, SetOptions(merge: true));
  }
  void registrationTenant(Tenant tenant, double deposit,Room room) {
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
    late Consumption newConsumption ;
    late Consumption preConsumption;
    for(var item in consumptionList){
      if(item.timestamp == timestamp){
        newConsumption = item;
        break;
      }
    }
    for(var item in consumptionList){
      if(item.timestamp.isBefore(newConsumption.timestamp)){
        preConsumption = item;
        break;
      }
    }

    // find package to generate reciept as png
  }
  Future<void> proccessPayment(String tenantID,[ Consumption? consumption,bool lastpayment = false]) async {
    
    final DateTime timestamp = consumption == null?  DateTime.now() : consumption.timestamp;
    late PriceCharge priceCharge;
    final Landlord landlord = Landlord(contact: "1324", userName: "ChayLim"); //will figure out later
    late Building building;
    late Room room;
    late Tenant tenant;
    late double deposit;
    double totalPrice;

    //get valid pricecharge
    for (var item in priceChargeList) {
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
        landlord: landlord,
        room: room,
        deposit: deposit,
        transaction: transaction,
        );
    payment.paymentStatus = PaymentStatus.pending;
    
    room.paymentList.add(payment);
    //sync with cloud
    notifyListeners();
    syncCloud();
  }
  void addPriceCharge(PriceCharge pricecharge) {
    priceChargeList.last.endDate = DateTime.now();
    priceChargeList.add(pricecharge);
    notifyListeners();
    syncCloud();
  }
  Future<bool> checkTransStatus(Payment payment)async {
    String md5 =  payment.transaction.md5;
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
    if(response != null){
      return true;
    }else {
      return false;
    }
    // check (reposone ?= null) true;
  }catch (e){
   print(e);
   return false;
  }

 
}
  //CRUD Buidlings
  void addOrUpdateBuilding(Building building){
    for(var item in listBuilding){
      if(item.id == building.id){
        item = building;
        notifyListeners();
        syncCloud();
        return;
      }
    }
    //else just add the room
    listBuilding.add(building);
    notifyListeners();
    syncCloud();
  }
  void removeBuilding(Building building){
    listBuilding.remove(building);
    notifyListeners();
    syncCloud();
  }
  //CRUD Rooms
 void addOrUpdateRoom(Building? building, Room newRoom) {
  if (building == null) {
    for (var b in listBuilding) {
      for (var i = 0; i < b.roomList.length; i++) {
        if (b.roomList[i].id == newRoom.id) {
          b.roomList[i] = newRoom; // Update the room in the list directly
          notifyListeners();
           syncCloud();
          return;
        }
      }
    }
  } else {
    if (building.roomList.any((item) => item.name == newRoom.name)) {
      print("Room name must be unique");
      notifyListeners();
    syncCloud();
      return;
    }else{
    building.roomList.add(newRoom);
    notifyListeners();
    syncCloud();
    }
  }
}

  void updatePaymentStatus(Room newRoom,Payment newPayment) async{
    if(await checkTransStatus(newPayment)){
      for(var building in listBuilding){
        for(var room in building.roomList){
          if(room.id == newRoom.id){
            for(var payment in room.paymentList){
              if(payment.timeStamp == newPayment.timeStamp){
                payment.paymentStatus = PaymentStatus.paid;
                notifyListeners();
                syncCloud();
              }
            }
          }
        }
      }
    }else{
      print("Is not paid");
    }
  }

  void removeRoom(Room roomToRemove){
    for(var building in listBuilding){
      for(var room in building.roomList){
        if(room.id == roomToRemove.id){
          building.roomList.remove(room);
          notifyListeners();
          syncCloud();
        }
      }
    }
  }
  //CRUD Tenants please use ID for all for of these
  updateTenant(Tenant tenant){
    for(var building in listBuilding){
      for(var room in building.roomList){
        if(room.tenant?.id == tenant.id){
          room.tenant = tenant;
          notifyListeners();
          syncCloud();
        }
      }
    }
  }
   removeTenant(Tenant tenant){
    for(var building in listBuilding){
      for(var room in building.roomList){
        if(room.tenant?.id == tenant.id){
          room.tenant = null;
          notifyListeners();
    syncCloud();
        }
      }
    }
  }
  //#############
  //clone from old system
  //####
  Payment? getPaymentThisMonth(Room room, [DateTime? dateTime] ){
    dateTime ??= DateTime.now();
    return  room.paymentList.isNotEmpty &&
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
  
  bool roomIsLeaving(){
    return true;
  }







}
