import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/domain/service/telegram_service.dart';

class RoomService {
  static RoomService? _instance;

  // Dependency
  final RootDataService repository;

  RoomService._internal(this.repository);

  ///
  /// Initialization
  ///
  static void initialize(RootDataService repository) {
    if (_instance == null) {
      _instance = RoomService._internal(repository);
    } else {
      throw "RoomService is already initialized";
    }
  }

  // Singleton getter
  static RoomService get instance {
    if (_instance == null) {
      throw "RoomService must be initialized first";
    } else {
      return _instance!;
    }
  }

  ///
  ///render data
  ///

  List<Room>? availableRoom(
          {required Building building, required DateTime dateTime}) =>
      building.roomList
          .where((item) =>
              item.roomStatus == Availibility.available || item.tenant == null)
          .toList();
  List<Room> unPaid({required Building building, required DateTime dateTime}) {
    List<Room> unPaid = [];
    // Iterate through each room in the building
    for (Room room in building.roomList) {
      // Check if the room has at least one payment that matches the criteria
      bool hasPaidPayment = room.paymentList.any((payment) =>
          payment.timeStamp.year == dateTime.year &&
          payment.timeStamp.month == dateTime.month);

      // If the room has a matching payment, add it to the paidRoom list
      if (hasPaidPayment == false && room.roomStatus != Availibility.available) {
        unPaid.add(room);
      }
    }

    // Return the list of rooms with paid payments
    return unPaid;
  }

  List<Room> pending({required Building building, required DateTime dateTime}) {
    List<Room> pending = [];
    // Iterate through each room in the building
    for (Room room in building.roomList) {
      // Check if the room has at least one payment that matches the criteria
      bool hasPaidPayment = room.paymentList.any((payment) =>
          payment.timeStamp.year == dateTime.year &&
          payment.timeStamp.month == dateTime.month &&
          payment.paymentStatus == PaymentStatus.pending);

      // If the room has a matching payment, add it to the pending list
      if (hasPaidPayment) {
        pending.add(room);
      }
    }

    // Return the list of rooms with paid payments
    return pending;
  }

  List<Room> paid({required Building building, required DateTime dateTime}) {
    List<Room> paidRoom = [];
    // Iterate through each room in the building
    for (Room room in building.roomList) {
      // Check if the room has at least one payment that matches the criteria
      bool hasPaidPayment = room.paymentList.any((payment) =>
          payment.timeStamp.year == dateTime.year &&
          payment.timeStamp.month == dateTime.month &&
          payment.paymentStatus == PaymentStatus.paid);

      // If the room has a matching payment, add it to the paidRoom list
      if (hasPaidPayment) {
        paidRoom.add(room);
      }
    }

    // Return the list of rooms with paid payments
    return paidRoom;
  }

  Consumption getConsumptionUsageFor(Room room, DateTime timeStamp) {
    ///if there is only one consumption in the list
    ///its mean user have 0 usage
    for (var newConsumption in room.consumptionList) {
      if (newConsumption.timestamp.year == timeStamp.year &&
          newConsumption.timestamp.month == timeStamp.month) {
        late Consumption preConsumption;
        for (var consumption in room.consumptionList) {
          if (consumption.timestamp.isBefore(newConsumption.timestamp)) {
            preConsumption = consumption;
            return Consumption(
              waterMeter:newConsumption.waterMeter - preConsumption.waterMeter,
                electricityMeter: newConsumption.electricityMeter -preConsumption.electricityMeter);
          }
        }
      }
    }
    return Consumption(waterMeter: 0, electricityMeter: 0);
  }

  Payment? getPaymentFor(Room room, DateTime timeStamp) {
    for (var i = room.paymentList.length - 1; i >= 0; i--) { // Start from the last element
      var payment = room.paymentList[i];
      if (payment.timeStamp.year == timeStamp.year &&
          payment.timeStamp.month == timeStamp.month) {
        print("found latest payment ${payment.timeStamp}");
        return payment;
      }
    }
    print("not found payment");
    return null;
  }


  ///
  ///CRUD Rooms
  ///

  void updateOrAdd(Building newBuilding, Room newRoom) {
    final buildings = repository.rootData!.listBuilding;

    // Find the index of the building
    final buildingIndex = buildings.indexWhere((building) => building == newBuilding);

    if (buildingIndex == -1) {
      print('Building not found');
      return;
    }

    // Find the index of the room
    final roomIndex = buildings[buildingIndex]
        .roomList
        .indexWhere((room) => room.id == newRoom.id);

    if (roomIndex == -1) {
      // Check for duplicate room name
      final hasDuplicateName = buildings[buildingIndex]
          .roomList
          .any((room) => room.name == newRoom.name);
      if (hasDuplicateName) {
        print('Room name must be unique');
        return;
      }

      // Add the new room
      buildings[buildingIndex].roomList.add(newRoom);
    } else {
      // Update the existing room
      buildings[buildingIndex].roomList[roomIndex] = newRoom;
    }

    // Sync to cloud and notify listeners
    repository.synceToCloud();
  }

  void removeRoom(Room roomToRemove) {
    for (var building in repository.rootData!.listBuilding) {
      building.roomList.removeWhere((room) => room.id == roomToRemove.id);
    }
    repository.synceToCloud();
  }

  bool roomIsLeaving() {
    /// need to implement
    return true;
  }

  double getDepositPrice(Room room) {
    return room.tenant!.deposit < room.price
        ? room.price - room.tenant!.deposit
        : 0;
  }

  void markAsPaid(Room room, Payment thisMonthPayment){

    final PriceCharge? priceCharge = PaymentService.instance.getPriceChargeFor(thisMonthPayment.timeStamp);

    PaymentService.instance.updatePaymentStatus(room, thisMonthPayment, PaymentStatus.paid);
    TelegramService.instance.sendMesage(int.parse(room.tenant!.chatID), "We have successfully received your payment of [${thisMonthPayment.totalPrice}] for [${room.name}]");
    // perform logic to calucate fine
    if(priceCharge !=null){
      ///find over due date
      int overDueDate = thisMonthPayment.timeStamp.day - priceCharge.fineStartOn.toInt();
      if(overDueDate > 0 ){
        double fine = overDueDate.toDouble() * priceCharge.finePerDay;
        thisMonthPayment.fine = fine;
        TelegramService.instance.sendMesage(int.parse(room.tenant!.chatID), ///below is the message
                '''
          ===========================
          Payment Overdue Notice
          ===========================

          Your payment for [${thisMonthPayment.timeStamp.month}/${thisMonthPayment.timeStamp.year}] is overdue by [$overDueDate] days.
          Penalty Fee: [${priceCharge.finePerDay} \$]
          Total Due: [$fine \$]

          Please contact your landlord as soon as possible to discuss or negotiate the payment.

          ===========================
          Landlord Contact Info:
          Name: [${repository.rootData!.landlord.username}]
          Phone: [${repository.rootData!.landlord.phoneNumber}]
          ===========================
          '''
        );
      }

    }else{
      throw "Error in markAsPaid price charge is not found";
    }
  }

  Future<void> refreshRoomsPayment() async {
   for(Building building in repository.rootData!.listBuilding){   
     for (var room in building.roomList) {
      Payment? thisMonthPayment = RoomService.instance.getPaymentFor(room, DateTime.now());
      // reduce api call by checking only pending payment
      if (thisMonthPayment != null && thisMonthPayment.paymentStatus == PaymentStatus.pending) {
        print("checking ${thisMonthPayment.totalPrice}");
        bool isPaid = await PaymentService.instance.checkTransStatus(thisMonthPayment);
        Future.delayed(const Duration(microseconds: 300));
        if (isPaid) {
          markAsPaid(room,thisMonthPayment);
        }
      }
    }
   }
   repository.synceToCloud();
  }
}
