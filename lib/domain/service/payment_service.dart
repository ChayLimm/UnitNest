import 'dart:convert';
import 'dart:typed_data';

import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/khqr_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/presentation/view/receipt/receipt.dart';
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
  
  

  Future<void> proccessPayment(String tenantID,[Consumption? consumption, bool lastpayment = false]) async {
    print("in proccess apyment function assign payment ");

    // declare data
    final DateTime timestamp =consumption == null ? DateTime.now() : consumption.timestamp;
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
    for (var building1 in repository.rootData!.listBuilding) {
                  print("#########1");

      for (var room1 in building1.roomList) {
        print("########2");
        if (room.tenant!.id == tenantID) {
          print("#########3");
          building = building1;
          room = room1;
          tenant = room.tenant!;
        }
      }
    }
            print("in proccess apyment function assign payment 2");

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

    TransactionKHQR transaction = await KhqrService.instance.requestKHQR(totalPrice);

    print("assign payment");
    Payment payment = Payment(
      tenant: tenant,
      room: room,
      deposit: deposit,
      transaction: transaction,
      totalPrice: totalPrice,
      hygiene: priceCharge.hygieneFee,
      parkingFee: (tenant.rentParking.toDouble() * priceCharge.rentParkingPrice),
      parkingAmount : tenant.rentParking.toInt(),
    );
    print("assign payment Done");

    ////
    ///  get reciept
    ///
    
    late String recieptURL;
    Uint8List? receiptPNG = await Receipt(payment: payment).capturePNG();
    try{
      recieptURL = await repository.uploadImageToFirebaseStorage(receiptPNG!);
      print("upload image to cloud");
    }catch (e){
      throw "Payment error : $e";
    }
    // add reciept to the database
    payment.receipt = recieptURL;
    print(recieptURL);

    payment.paymentStatus = PaymentStatus.pending;
    room.paymentList.add(payment);
    //sync with cloud
    repository.synceToCloud();
    print("done processing payment!!!!!!!!!!!");
  }


  PaymentStatus getRoomPaymentStatus(Room room, DateTime dateTime){
    Payment? payment = getPaymentFor(room, dateTime);
    if(payment != null){
      return payment.paymentStatus;
    }
    return PaymentStatus.unpaid;
  }

  Payment? getPaymentFor(Room room, DateTime dateTime) {
    for(var payment in room.paymentList){
      if(payment.timeStamp.month == dateTime.month && payment.timeStamp.year == dateTime.year){
        return payment;
      }
      return null;
    }

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
}