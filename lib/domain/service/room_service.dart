import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/root_data.dart';

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

  List<Room> availableRoom({required Building building, required DateTime dateTime}) => building.roomList.where((item) => item.roomStatus == Availibility.available || item.tenant == null).toList();
  List<Room> unPaid({required Building building, required DateTime dateTime})=>building.roomList.where((item) => item.paymentList.last.timeStamp.year != dateTime.year && item.paymentList.last.timeStamp.month != dateTime.month).toList();
  List<Room> pending({required Building building, required DateTime dateTime}) => building.roomList.where((item) => item.paymentList.last.timeStamp.year == dateTime.year && item.paymentList.last.timeStamp.month == dateTime.month &&item.paymentList.last.paymentStatus == PaymentStatus.pending).toList();
  List<Room> paid({required Building building, required DateTime dateTime}) => building.roomList.where((item) => item.paymentList.last.timeStamp.year == dateTime.year && item.paymentList.last.timeStamp.month == dateTime.month &&item.paymentList.last.paymentStatus == PaymentStatus.paid).toList();

  Consumption? getConsumptionUsageFor(Room room, DateTime timeStamp){
    for(var newConsumption in room.consumptionList){
      if(newConsumption.timestamp.year == timeStamp.year && newConsumption.timestamp.month == timeStamp.month){
        late Consumption preConsumption;
        for(var consumption in room.consumptionList){
          if(consumption.timestamp.isBefore(timeStamp)){
            preConsumption = consumption;
            return Consumption(
              waterMeter: newConsumption.waterMeter - preConsumption.waterMeter, 
              electricityMeter: newConsumption.electricityMeter - preConsumption.electricityMeter
            );
          }
        }
      }
    }
    return null;
  }

  Payment? getPaymentFor(Room room,DateTime timeStamp){
      for(var payment in room.paymentList ){
        if(payment.timeStamp.year == timeStamp.year && payment.timeStamp.month == timeStamp.month){
          print("found payment ${payment.timeStamp}");
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
    final roomIndex = buildings[buildingIndex].roomList.indexWhere((room) => room.id == newRoom.id);

    if (roomIndex == -1) {
      // Check for duplicate room name
      final hasDuplicateName = buildings[buildingIndex].roomList.any((room) => room.name == newRoom.name);
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

  Future<void> refreshRoomsPayment(Building building) async{
    for(var room in building.roomList){
      Payment? thisMonthPayment = RoomService.instance.getPaymentFor(room, DateTime.now());
      // reduce api call by checking only pending payment
      if(thisMonthPayment != null && thisMonthPayment.paymentStatus == PaymentStatus.pending){
        bool isPaid = await PaymentService.instance.checkTransStatus(thisMonthPayment);      
        if(isPaid){
         PaymentService.instance.updatePaymentStatus(room,thisMonthPayment,PaymentStatus.paid);
        }
      }
    }
  }

}