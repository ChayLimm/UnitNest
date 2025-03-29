import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/service/root_data.dart';

class FinderService {
  RootDataService rootDataService;
  static FinderService? _instance;
  FinderService.internal(this.rootDataService); 


  static initialize(RootDataService rootDataService){
    if(_instance == null){
      _instance = FinderService.internal(rootDataService);
    }else{
      throw "Finder service is already init";
    }
  }

  ///
  ///singleton
  ///

 static FinderService get instance{
  if(_instance == null){
    throw "Must init roomservice";
  }else{
    return _instance!;
  }
 }
 Building? findBuildingByRoomID(String roomID){
    bool isFound =false;
    for(var building in rootDataService.rootData!.listBuilding){
      if(!isFound){
      for(var room in building.roomList){
        if(room.id == roomID){
          isFound= true;
          return building;
        }
      }}
    }
    return null;
  }

  Room? findRoomByID(String roomID){
    bool isFound =false;
    for(var building in rootDataService.rootData!.listBuilding){
      if(!isFound){
      for(var room in building.roomList){
        if(room.id == roomID){
          isFound= true;
          return room;
        }
      }}
    }
    return null;
  }
  Room? getRoomWithChatID(String chatID){
    for(var building in rootDataService.rootData!.listBuilding){
      for(var room in building.roomList){
        if(room.tenant != null && room.tenant!.chatID == chatID){
          return room;
        }
      }
    }
  }
  Tenant? findTenantByID(String tenantChatID){
     bool isFound =false;
    for(var building in rootDataService.rootData!.listBuilding){
      if(!isFound){
      for(var room in building.roomList){
        if(room.tenant != null &&room.tenant!.chatID == tenantChatID){
          isFound = true;
          return room.tenant;
        }
      }}
    }
    return null;
  }

}