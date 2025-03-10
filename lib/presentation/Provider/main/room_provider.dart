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

  //function should be call on start roomlist screen and refresh;
  Future<void> refreshRoomsPayment() async{
    await RoomService.instance.refreshRoomsPayment(currentSelectedBuilding!);
    notifyListeners();
  }

  void setCurrentSelectedBuilding(Building building){
    currentSelectedBuilding = building;
    notifyListeners();
  }
  void setCurrentSelectedRoom(Room room){
    currentSelectedRoom = room;
    notifyListeners();
  }

  Future<void> addOrUpdateRoom(Room newRoom) async{
    RoomService.instance.updateOrAdd(currentSelectedBuilding!, newRoom);
    notifyListeners();
  }
} 