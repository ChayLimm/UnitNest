import 'package:emonitor/data/model/building/building.dart';
import 'package:emonitor/data/model/building/room.dart';
import 'package:emonitor/data/model/payment/payment.dart';
import 'package:emonitor/presentation/service/system_service.dart';
import 'package:flutter/material.dart';

class BuildingService extends ChangeNotifier {

  late Building building;

  List<Room> get unPaid => building.roomList.where((item) => item.paymentList.last.timeStamp.year != DateTime.now().year && item.paymentList.last.timeStamp.month != DateTime.now().month).toList();
  List<Room> get pending => building.roomList.where((item) => item.paymentList.last.timeStamp.year == DateTime.now().year && item.paymentList.last.timeStamp.month == DateTime.now().month &&item.paymentList.last.paymentStatus == PaymentStatus.pending).toList();
  List<Room> get paid => building.roomList.where((item) => item.paymentList.last.timeStamp.year == DateTime.now().year && item.paymentList.last.timeStamp.month == DateTime.now().month &&item.paymentList.last.paymentStatus == PaymentStatus.paid).toList();


 //CRUD Buidlings
  Future<void> update(Building newBuilding) async {
      building = newBuilding;
      await SystemService().syncCloud();
      notifyListeners();
  }
  

  Future<void> removeBuilding(Building building) async {
    
    await SystemService().syncCloud();
  }

  //CRUD Rooms

    void addOrUpdateRoom(Building? building, Room newRoom) {
    if (building == null) {
      for (var b in listBuilding) {
        for (var i = 0; i < b.roomList.length; i++) {
          if (b.roomList[i].id == newRoom.id) {
            b.roomList[i] = newRoom; // Update the room in the list directly
            await SystemService().syncCloud();
            return;
          }
        }
      }
    } else {
      if (building.roomList.any((item) => item.name == newRoom.name)) {
        print("Room name must be unique");
        await SystemService().syncCloud();
        return;
      } else {
        building.roomList.add(newRoom);
        await SystemService().syncCloud();
      }
    }
  }

  void updatePaymentStatus(Room newRoom, Payment newPayment) async {
    if (await checkTransStatus(newPayment)) {
      for (var building in listBuilding) {
        for (var room in building.roomList) {
          if (room.id == newRoom.id) {
            for (var payment in room.paymentList) {
              if (payment.timeStamp == newPayment.timeStamp) {
                payment.paymentStatus = PaymentStatus.paid;
                await SystemService().syncCloud();
              }
            }
          }
        }
      }
    } else {
      print("Is not paid");
    }
  }

  void removeRoom(Room roomToRemove) {
    for (var building in listBuilding) {
      for (var room in building.roomList) {
        if (room.id == roomToRemove.id) {
          building.roomList.remove(room);
          await SystemService().syncCloud();
        }
      }
    }
  }


}