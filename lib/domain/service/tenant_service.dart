import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/domain/service/telegram_service.dart';

class TenantService {
  static TenantService? _instance;

  // Dependency
  final RootDataService repository;

  TenantService._internal(this.repository);

  ///
  /// Initialization
  ///
  static void initialize(RootDataService repository) {
    if (_instance == null) {
      _instance = TenantService._internal(repository);
    } else {
      throw "TenantService is already initialized";
    }
  }

  // Singleton getter
  static TenantService get instance {
    if (_instance == null) {
      throw "TenantService must be initialized first";
    } else {
      return _instance!;
    }
  }

  Tenant? getTenantByChatID(String chatID){
    for(var building in repository.rootData!.listBuilding){
      for(var room in building.roomList){
        if(room.tenant != null && room.tenant!.chatID ==chatID){
          return room.tenant;
        }
      }
  }
  }

  /// Helper method to find a room by tenant ID
  Room? _findRoomByTenantId(String tenantId) {
    for (var building in repository.rootData!.listBuilding) {
      for (var room in building.roomList) {
        if (room.tenant?.id == tenantId) {
          return room;
        }
      }
    }
    return null;
  }

  /// Helper method to find a room by room ID
  Room? _findRoomById(String roomId) {
    for (var building in repository.rootData!.listBuilding) {
      for (var room in building.roomList) {
        if (room.id == roomId) {
          return room;
        }
      }
    }
    return null;
  }

  /// Register a tenant to a room
  Future<Payment?> registrationTenant(Tenant tenant, Room roomToSearch) async {
    for (int i = 0; i < repository.rootData!.listBuilding.length; i++) {
      for (int j = 0; j < repository.rootData!.listBuilding[i].roomList.length; j++) {
        
        if (repository.rootData!.listBuilding[i].roomList[j].id == roomToSearch.id) {

          repository.rootData!.listBuilding[i].roomList[j].tenant = tenant;
          repository.rootData!.listBuilding[i].roomList[j].roomStatus = Availibility.taken;
          
           if (repository.rootData!.listBuilding[i].roomList[j].tenant != null) {
                try {    
                    Payment payment = await PaymentService.instance.proccessPayment(tenant.chatID);
                    // TelegramService.instance.sendReceipt(tenant.chatID, payment.receipt!, "Payment for your room include deposit");
                    // repository.synceToCloud();
                    return payment;
                } catch (e){
                throw "error register tenant : $e";
                }
              
              } else {
                print('Room not found');
              }
        }
      }
    }

   
  }

  /// Update tenant details
  void updateTenant(Tenant tenant) {
    final targetRoom = _findRoomByTenantId(tenant.id);
    if (targetRoom != null) {
      targetRoom.tenant = tenant;
      repository.synceToCloud();
    } else {
      print('Tenant not found');
    }
  }

  /// Remove a tenant from a room
  void removeTenant(Tenant tenant) {
    final targetRoom = _findRoomByTenantId(tenant.id);
    if (targetRoom != null) {
      targetRoom.tenant = null;
      repository.synceToCloud();
    } else {
      print('Tenant not found');
    }
  }
}