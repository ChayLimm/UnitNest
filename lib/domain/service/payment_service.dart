import 'package:emonitor/data/model/building/building.dart';
import 'package:emonitor/data/model/building/room.dart';
import 'package:emonitor/data/model/payment/payment.dart';
import 'package:emonitor/data/model/payment/transaction.dart';
import 'package:emonitor/data/model/stakeholder/tenant.dart';
import 'package:emonitor/data/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/khqr_service.dart';
import 'package:emonitor/domain/service/root_data.dart';

class PaymentService {
  final RootDataService repository;
  PaymentService(this.repository)

  ///
  /// Proccess payment
  /// 

  Future<void> proccessPayment(String tenantID,[Consumption? consumption, bool lastpayment = false]) async {
   
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
    //find who is paying for which room
    for (var building1 in repository.rootData!.listBuilding) {
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

    TransactionKHQR transaction = await KhqrService.requestKHQR(totalPrice);

    Payment payment = Payment(
      tenant: tenant,
      room: room,
      deposit: deposit,
      transaction: transaction,
    );
    payment.paymentStatus = PaymentStatus.pending;

    room.paymentList.add(payment);
    //sync with cloud
    repository.synceToCloud();
  }

}