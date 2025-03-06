import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/service/root_data.dart';

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
  void registrationTenant(Tenant tenant, double deposit, Room room) {
    final targetRoom = _findRoomById(room.id);
    if (targetRoom != null) {
      targetRoom.tenant = tenant;
      // Call payment processing service (ignored as per your request)
      // proccessPayment(tenant.id);
      repository.synceToCloud();
    } else {
      print('Room not found');
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