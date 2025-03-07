import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/service/building_service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BuildingProvider extends ChangeNotifier {
  RootDataService repository;
  BuildingProvider(this.repository);

  ///
  /// Attribute
  ///
  Building? currentSelectedBuilding;

  List<Building> get buildingList => repository.rootData!.listBuilding;

  BuildingInfo buildingInfo(Building building){
    final availableRoom = RoomService.instance.availableRoom(building: building).length;
    final totalRoom = building.roomList.length;
    final parkingSpace = building.parkingSpace;
    final floorCount = building.floorCount;
    return BuildingInfo(availableRoom: availableRoom, totalRoom: totalRoom, parkingSpace: parkingSpace, floorCount: floorCount);
  }

  ///
  /// Data processing
  ///
  
  void setCurrentBuilding(Building building){
    currentSelectedBuilding = building;
    notifyListeners();
  }
  
  void updateOrAddBuilding(Building newBuidling){
     BuildingService.instance.updateOrAdd(newBuidling);
     notifyListeners();
  }

  void removeBuilding(Building buildingToRemove){
    BuildingService.instance.removeBuilding(buildingToRemove);
    notifyListeners();
  }

}

class BuildingInfo{
  int availableRoom;
  int totalRoom;
  int parkingSpace;
  int floorCount;
  BuildingInfo({required this.availableRoom, required this.totalRoom,required this.parkingSpace, required this.floorCount});
}