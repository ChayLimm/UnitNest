import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/material.dart';

class RoomProvider extends ChangeNotifier {
  RootDataService repository;
  RoomProvider(this.repository);
  
  Building? currentSelectedBuilding;

  Room? currentSelectedRoom;

  bool isLoading = false;

  void toggleLoading(){
    isLoading = !isLoading;
    notifyListeners();
  }

  void setCurrentSelectedBuilding(Building building) async {
    currentSelectedBuilding = building;
    await refreshRoomsPayment();
  }

  void setCurrentSelectedRoom(Room room){
    currentSelectedRoom = room;
    notifyListeners();
  }

  // // i just added for avoiding null problem when first run 
  // void setDefaultRoom() {
  //     currentSelectedRoom =  currentSelectedBuilding!.roomList.isNotEmpty ? currentSelectedBuilding!.roomList.first : null;
  //     notifyListeners();
  // }

   Future<void> addOrUpdateRoom(Room newRoom) async{
      RoomService.instance.updateOrAdd(currentSelectedBuilding!, newRoom);
      notifyListeners();
    }

    //function should be call on start roomlist screen and refresh;
    Future<void> refreshRoomsPayment() async{
      toggleLoading();
      currentSelectedRoom = null;
      await RoomService.instance.refreshRoomsPayment();
      toggleLoading();
    }

    void removeRoom(Room room)  {
      toggleLoading();
      RoomService.instance.removeRoom(room);
      toggleLoading();
    }

    List<Room> sortRoomsByLastPaymentStatus(List<Room> rooms, PaymentStatus targetStatus) {
        // Create a copy of the list to avoid modifying the original list
        final sortedRooms = List<Room>.from(rooms);

        sortedRooms.sort((roomA, roomB) {
          // Get the last payment status for roomA
          final statusA = roomA.paymentList.isNotEmpty
              ? roomA.paymentList.last.paymentStatus
              : PaymentStatus.unpaid;

          // Get the last payment status for roomB
          final statusB = roomB.paymentList.isNotEmpty
              ? roomB.paymentList.last.paymentStatus
              : PaymentStatus.unpaid;

          // Check if the status matches the targetStatus
          final isStatusA = statusA == targetStatus;
          final isStatusB = statusB == targetStatus;

          // Sort rooms with the targetStatus first
          if (isStatusA && !isStatusB) {
            return -1; // roomA comes before roomB
          } else if (!isStatusA && isStatusB) {
            return 1; // roomB comes before roomA
          } else {
            // If both have the same status (both match or both don't match), maintain their original order
            return 0;
          }
        });

        return sortedRooms;
      }

} 