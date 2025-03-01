import 'package:emonitor/data/model/building/building.dart';
import 'package:emonitor/data/model/building/room.dart';
import 'package:emonitor/data/model/payment/payment.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/material.dart';

class RoomService extends ChangeNotifier {
  // this is the root data that we will perform operation on 
  RootDataService repository;
  RoomService(this.repository);

  ///
  ///render data
  ///

  Iterable<Room> availableRoom(Building building) => building.roomList.where((item) => item.roomStatus == Availibility.available);
  List<Room> unPaid(Building building)=>building.roomList.where((item) => item.paymentList.last.timeStamp.year != DateTime.now().year && item.paymentList.last.timeStamp.month != DateTime.now().month).toList();
  List<Room> pending(Building building) => building.roomList.where((item) => item.paymentList.last.timeStamp.year == DateTime.now().year && item.paymentList.last.timeStamp.month == DateTime.now().month &&item.paymentList.last.paymentStatus == PaymentStatus.pending).toList();
  List<Room> paid(Building building) => building.roomList.where((item) => item.paymentList.last.timeStamp.year == DateTime.now().year && item.paymentList.last.timeStamp.month == DateTime.now().month &&item.paymentList.last.paymentStatus == PaymentStatus.paid).toList();

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
    notifyListeners();
}
 void removeRoom(Room roomToRemove) {
    for (var building in repository.rootData!.listBuilding) {
        building.roomList.removeWhere((room) => room.id == roomToRemove.id);
    }
    repository.synceToCloud();
    notifyListeners();
}

}