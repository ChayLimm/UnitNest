
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/service/notification_Service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  RootDataService rootDataService;
  NotificationProvider({required this.rootDataService});

  get rootData => rootDataService.rootData;

  get notiList => rootDataService.notificationList?.listNotification ?? [];
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

  void setCurrentNotifyDetails(UniNotification? notification){
    currentNotifyDetails = notification;
    notifyListeners();
  }

  Future<bool> approve(BuildContext context,UniNotification notification, Room? room, double? deposit, ) async{
    toggleLoading();
    // approving the payment or registration and PROCESS payment
    final isApprove = await NotificationService.instance.approve(context: context ,notification: notification,room:  room,deposit: deposit?? 0);
    toggleLoading();
    setCurrentNotifyDetails(null);
    return isApprove;
  } 
  void reject (UniNotification notification){
    toggleLoading();
    // NotificationService.instance.
    NotificationService.instance.reject(notification);
    setCurrentNotifyDetails(null);
    toggleLoading();  
    } 

  Future<void> refreshNotification() async {
  final systemId = rootDataService.rootData!.id;
  print("Refreshing notification list");
  print(systemId);
  
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