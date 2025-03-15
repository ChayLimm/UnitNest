import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/service/root_data.dart';

class BuildingService  {
  static BuildingService? _instance;
  // this is the root data that we will perform operation on 
  RootDataService repository;
  BuildingService.internal(this.repository);

  ///
  /// init
  ///
  static void initialize(RootDataService repository){
    if(_instance == null){
      _instance = BuildingService.internal(repository);
    }else{
      throw "Building service is already init";
    }
  } 

  //single ton
  static BuildingService get instance{
    if(_instance == null){
      throw "BuildingService must init first";
    }else{
      return _instance!;
    }
  }


  ///
  /// CRUD Buidlings
  ///

  Future<void> updateOrAdd(Building newBuilding) async {
    final buildings = repository.rootData?.listBuilding;
    final index = buildings?.indexWhere((b) => b.id == newBuilding.id);
    if (index != null && index != -1) {
      buildings?[index] = newBuilding;
    }else{
    repository.rootData!.listBuilding.add(newBuilding);
    }
    //synce to cloud
    await repository.synceToCloud();
    print("Added new building");
  }
  

  Future<void> removeBuilding(Building building) async {
    repository.rootData!.listBuilding.remove(building);
    //synce to cloud
    await repository.synceToCloud();
    
  }

  

  // void updatePaymentStatus(Room newRoom, Payment newPayment) async {
  //   if (await checkTransStatus(newPayment)) {
  //     for (var building in listBuilding) {
  //       for (var room in building.roomList) {
  //         if (room.id == newRoom.id) {
  //           for (var payment in room.paymentList) {
  //             if (payment.timeStamp == newPayment.timeStamp) {
  //               payment.paymentStatus = PaymentStatus.paid;
  //               await SystemService().syncCloud();
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } else {
  //     print("Is not paid");
  //   }
  }
