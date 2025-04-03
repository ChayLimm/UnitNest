
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/service/notification_Service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  RootDataService rootDataService;
  NotificationProvider({required this.rootDataService});

  get rootData => rootDataService.rootData;

  List<UniNotification?> get notiList => sortNotificationsByMostRecent(rootDataService.notificationList!.listNotification);
  UniNotification? currentNotifyDetails;
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  void toggleLoading(){
    isLoading = !isLoading;
    notifyListeners();
  }


  NotificationList? get isUnRead => NotificationList(notiList.where((noti) => noti?.read == false).toList());
  NotificationList? get isRead => NotificationList(notiList.where((noti) => noti?.read == true).toList());

  List<Building> get buildingList => rootDataService.rootData!.listBuilding;

  // ignore: body_might_complete_normally_nullable
  Building? get building{
    for(var building in rootDataService.rootData!.listBuilding){
      for(var room in building.roomList){
        if(room.tenant != null && room.tenant!.chatID ==currentNotifyDetails!.chatID){
          return building;
        }
      }
    }
  }

  Room? get room{
    for(var building in rootDataService.rootData!.listBuilding){
      for(var room in building.roomList){
        if(room.tenant != null && room.tenant!.chatID ==currentNotifyDetails!.chatID){
          return room;
        }
      }
    }
  }

    List<UniNotification?> sortNotificationsByMostRecent(List<UniNotification?> notifications) {
     
  // Sort the list based on the date extracted from `notifyData`
  notifications.sort((a, b) {
    DateTime dateA;
    DateTime dateB;

    // Extract the date for notification A
    if (a!.dataType == NotificationType.registration) {
      dateA = (a.notifyData as NotifyRegistration).registerOnDate;
    } else {
      dateA = (a.notifyData as NotifyPaymentRequest).requestDateOn;
    }

    // Extract the date for notification B
    if (b!.dataType == NotificationType.registration) {
      dateB = (b.notifyData as NotifyRegistration).registerOnDate;
    } else {
      dateB = (b.notifyData as NotifyPaymentRequest).requestDateOn;
    }

    // Sort in descending order (most recent first)
    return dateB.compareTo(dateA);
  });

  return notifications;
}
  

  Future<void> removeNotification(UniNotification notification) async{
    try{
      toggleLoading();
            notiList.remove(notification);
      await firestore
        .collection('system')
        .doc(notification.systemID)
        .collection('notificationList')
        .doc(notification.id).delete();
      toggleLoading();

    }catch (e){
      throw"error in remove notification";
    }
  }

  void setCurrentNotifyDetails(UniNotification? notification){
    currentNotifyDetails = notification;
    notifyListeners();
  }

  Future<bool> approve(BuildContext context,UniNotification notification, Room? room, double? deposit, int? tenantRentParking ) async{
    toggleLoading();
    // approving the payment or registration and PROCESS payment
    final isApprove = await NotificationService.instance.approve(context: context ,notification: notification,room:  room,deposit: deposit?? 0, tenantRentParking: tenantRentParking??0);
    toggleLoading();
    print("set curretn notification to null");
    setCurrentNotifyDetails(null);
    RoomService.instance.refreshRoomsPayment();
    return isApprove;
  } 
  void reject (UniNotification notification){
    toggleLoading();
    // NotificationService.instance.
    NotificationService.instance.reject(notification);
    currentNotifyDetails = null;
    toggleLoading();  
    } 

  Future<void> refreshNotification() async {
  final systemId = rootDataService.rootData!.id;
  currentNotifyDetails = null;
  print("Refreshing notification list");
  print(systemId);
  RoomService.instance.refreshRoomsPayment();
  toggleLoading();
  
  try {
    final querySnapshot = await firestore
        .collection('system')
        .doc(systemId)
        .collection('notificationList')
        .get(); // Use get() to fetch the data once

    List<UniNotification> streamNotificationList = [];

    if (querySnapshot.docs.isEmpty) {
      print("No notifications found for system ID: $systemId");
      rootDataService.updateNotificationList(streamNotificationList);
    } else {
      for (var doc in querySnapshot.docs) {
        final data = UniNotification.fromJson(doc.data());
        data.id = doc.id;
        streamNotificationList.add(data);
        print("Loading data");
        print(data.chatID);
        print(streamNotificationList.length);
      }
      print("update");
      rootDataService.updateNotificationList(streamNotificationList);
    }
  } catch (e) {
    print("Error fetching notifications: $e");
  }

  toggleLoading();
}


}