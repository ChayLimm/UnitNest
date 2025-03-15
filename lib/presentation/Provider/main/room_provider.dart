import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
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

  // i just added for avoiding null problem when first run 
  void setDefaultRoom() {
      currentSelectedRoom =  currentSelectedBuilding!.roomList.isNotEmpty ? currentSelectedBuilding!.roomList.first : null;
      notifyListeners();
  }

  Future<void> addOrUpdateRoom(Room newRoom) async{
    RoomService.instance.updateOrAdd(currentSelectedBuilding!, newRoom);
    notifyListeners();
  }

  //function should be call on start roomlist screen and refresh;
  Future<void> refreshRoomsPayment() async{
    toggleLoading();
    await RoomService.instance.refreshRoomsPayment(currentSelectedBuilding!);
    toggleLoading();
  }
} 