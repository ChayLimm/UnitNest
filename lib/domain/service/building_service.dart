import 'package:emonitor/data/model/building/building.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/material.dart';

class BuildingService extends ChangeNotifier {
  // this is the root data that we will perform operation on 
  RootDataService repository;
  BuildingService(this.repository);

  ///
  /// Render data
  /// 


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
    repository.synceToCloud;
    notifyListeners();
    print("Added new building");
  }
  

  Future<void> removeBuilding(Building building) async {
    repository.rootData!.listBuilding.remove(building);
    //synce to cloud
    repository.synceToCloud;
    notifyListeners();
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







