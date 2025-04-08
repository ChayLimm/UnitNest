import 'dart:convert';

import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/khqr_service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/global_url.dart';
import 'package:http/http.dart' as http;


class PaymentService {
  static PaymentService? _instance;

  // Dependency
  final RootDataService repository;

  PaymentService._internal(this.repository);

  ///
  /// Initialization
  ///
  static void initialize(RootDataService repository) {
    if (_instance == null) {
      _instance = PaymentService._internal(repository);
    } else {
      throw "PaymentService is already initialized";
    }
  }

  // Singleton getter
  static PaymentService get instance {
    if (_instance == null) {
      throw "PaymentService must be initialized first";
    } else {
      return _instance!;
    }
  }
  ///
  /// Proccess payment
  /// 
  
  

  Future<Payment> proccessPayment(String tenantID,[Consumption? consumption, bool lastpayment = false]) async {
    print("in proccess apyment function assign payment ");

    // declare data
    final DateTime timestamp = consumption == null ? DateTime.now() : consumption.timestamp;
    late PriceCharge priceCharge;
    late Building building;
    late Room room;
    late Tenant tenant;
    late double deposit;
    double totalPrice;

    //get valid pricecharge
    for (var item in repository.rootData!.landlord.settings!.priceChargeList) {
      if (item.isValidDate(timestamp)) {
        priceCharge = item;
      }
    }
    print("in proccess apyment function assign payment 1");

    //find who is paying for which room
    bool found = false;

    for (var building1 in repository.rootData!.listBuilding) {
    print("Checking Building: ${building1.name}");
    for (var room1 in building1.roomList) {
      print("Checking Room: ${room1.name}, Tenant: ${room1.tenant}");

      if (room1.tenant != null) {
        print("Tenant to find ! : $tenantID");
        print("Tenant chatID ! : ${room1.tenant!.chatID}");
      }
      if (room1.tenant != null && room1.tenant!.chatID == tenantID) {
        print("Tenant found in room ${room1.name}");
        building = building1;
        room = room1;
        tenant = room1.tenant!;
        found = true;
        break;
      }
    }
    if (found) break;
  }
   
    print("in proccess payment function assign payment 2");
    // print(room.consumptionList.last.electricityMeter);
    //find deposit
    if (tenant.deposit < room.price) {
      deposit = room.price - tenant.deposit;
    } else {
      deposit = 0;
    }
    print("done check deposit");
    //calculate roomprice & rent parking if have
    if (consumption == null) {
      //first payment
      totalPrice = room.price + priceCharge.hygieneFee + deposit +(tenant.rentParking.toDouble() * priceCharge.rentParkingPrice);
    } else {

      Consumption lastCons = room.consumptionList.last;
      print("last consumption checked");
      if (room.consumptionList.isNotEmpty) {
      print("process function");
      for (var item in room.consumptionList) {
        if (item.timestamp.isBefore(consumption.timestamp)) {
          lastCons = item;
          break;
        }
      }
    }
      
      final double elecTotalPrice =(consumption.electricityMeter - lastCons.electricityMeter) * priceCharge.electricityPrice;
      final double waterPrice = (consumption.waterMeter - lastCons.waterMeter) *priceCharge.waterPrice + priceCharge.hygieneFee;
    
      if (lastpayment) {
        //last payment
        totalPrice =deposit + elecTotalPrice + waterPrice + priceCharge.hygieneFee;
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
          //convert total price
    totalPrice = double.parse(totalPrice.toStringAsFixed(2));
    print("requestiing  transaction qr for ${totalPrice}");

    TransactionKHQR transaction = await KhqrService.instance.requestKHQR(totalPrice);
    
    print("assign payment");
    Payment payment = Payment(
      lastPayment: lastpayment,
      roomPrice: room.price,
      tenantChatID: tenant.chatID,
      roomID: room.id,
      deposit: deposit,
      transaction: transaction,
      totalPrice: totalPrice,
      hygiene: priceCharge.hygieneFee,
      parkingFee: (tenant.rentParking.toDouble() * priceCharge.rentParkingPrice),
      parkingAmount : tenant.rentParking.toInt(),
    );
    print("assign payment Done ${payment.totalPrice}");


    payment.paymentStatus = PaymentStatus.pending;
    // room.paymentList.add(payment);
    //sync with cloud
    // repository.synceToCloud();
    print("done processing payment!!!!!!!!!!!");
    return payment;
  }


  PaymentStatus? getRoomPaymentStatus(Room room, DateTime dateTime){
    Payment? payment = RoomService.instance.getPaymentFor(room, dateTime);
    if(payment != null){
      return payment.paymentStatus;
    }else
    if(room.tenant == null ){
      return null;
    }else {
      return PaymentStatus.unpaid;
    }
  }



  Future<bool> checkTransStatus(Payment payment) async {
    String md5 = payment.transaction.md5;
    final url = Uri.parse("${global_url}/khqrstatus");
    try {
      var body = jsonEncode({
        'md5': md5
      }
      );

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      ///
      ///check condition
      ///
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['data'] != null) {
          print("Data exists: ${jsonResponse['data']}");
          return true;
        } else {
          print("Data is null.");
          return false;
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
        return false;
      }
      // check (reposone ?= null) true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> setFine(Payment payment,double newfine) async{
    payment.fine = newfine;
    payment.totalPrice = payment.totalPrice + newfine;
    await repository.synceToCloud();

  }

  PriceCharge? getPriceChargeFor(DateTime dateTime){
    for (var item in repository.rootData!.landlord.settings!.priceChargeList) {
      if (item.isValidDate(dateTime)) {
        return item;
      }
    }
    return null;
  }

  void updatePaymentStatus(Room targetRoom, Payment targetPayment, PaymentStatus status) {
    for (var building in repository.rootData!.listBuilding) {
      for (var room in building.roomList) {
        if (room.id == targetRoom.id) {
          for (var payment in room.paymentList) {
            if (payment.timeStamp == targetPayment.timeStamp) {
              payment.paymentStatus = status;
              return; 
            }
          }
        }
      }
    }
  }  
  void paymentHistory(){
    
  }



}