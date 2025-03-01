import 'package:emonitor/data/model/building/room.dart';
import 'package:emonitor/data/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/material.dart';

class TenantService extends ChangeNotifier {
  final RootDataService repository;
  TenantService(this.repository);

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
      notifyListeners();
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
      notifyListeners();
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
      notifyListeners();
    } else {
      print('Tenant not found');
    }
  }
}