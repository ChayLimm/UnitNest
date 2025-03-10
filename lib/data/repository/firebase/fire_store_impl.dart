import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/domain/model/Notification/notification.dart';

import 'package:emonitor/domain/model/system/system.dart';
import 'package:emonitor/domain/repository/repo.dart';

class DatabaseRepoImpl implements DatabaseRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<System> fetchSystem(String systemID) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('system')
          .doc(systemID)
          .get();

      if (doc.exists) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        return System.fromJson(docData);
      } else {
        throw "System with ID $systemID does not exist";
      }
    } catch (e) {
      print("Error fetching system: $e");
      rethrow;
    }
  }

  Future<void> synceToCloud(NotificationList notificationList, System system) async {
    try {
      // Sync the main system document
      await firestore.collection('system').doc(system.id).set(
        system.toJson(), SetOptions(merge: true)
      );

      
      /// sync notification
      for(var notification in notificationList.listNotification){
        await firestore.collection('system').doc(system.id)
          .collection('notificationList').doc(notification!.id).set(
          notification.toJson(), SetOptions(merge: true));
      ///
      }
      

    } catch (e) {
      print("Error syncing to cloud: $e");
      rethrow;
    }
  }
  
  @override
  Future<NotificationList> fetchNotification(String systemId) async {
    // TODO: implement fetchNotification
    try{
      
      NotificationList notificationList = NotificationList([]);

      QuerySnapshot querySnapshot = await firestore
        .collection('system')
        .doc(systemId)
        .collection('notificationList')
        .get();

      /// 
      /// check doc null
      /// 
      if(querySnapshot.docs.isEmpty || querySnapshot.docs == 0 ){
        print("No notifications found for system ID: $systemId");
        return notificationList;
      }
      ///
      ///loop the docs
      ///
      print("Converting to json");
      for(var doc in querySnapshot.docs){
          final data = Notification.fromJson(doc.data() as Map<String, dynamic>);
          data.id = doc.id;
          notificationList.listNotification.add(data);
      }

      return notificationList;

    }catch (e){
      throw "Error in feching notification $e";
    }
  }



// @override
// Future<NotificationList> fetchNotification(String systemId) async {
//   try {
//     QuerySnapshot querySnapshot = await firestore
//         .collection('system')
//         .doc(systemId)
//         .collection('notificationList')
//         .get();

//     if (querySnapshot.docs.isEmpty) {
//       print("No notifications found for system ID: $systemId");

//       // Create empty list
//       NotificationList notificationList = NotificationList([]);

//       // Reference to the notification subcollection
//       CollectionReference notificationRef = firestore
//           .collection('system')
//           .doc(systemId)
//           .collection('notificationList');

//       // Sync each notification in the list to Firestore
//       await notificationRef.doc(notificationList.id).set(
//         notificationList.toJson(), SetOptions(merge: true),
//       );

//       return notificationList; // Return empty notification list
//     }

//     print("Starting data conversion...");

//     List<Notification> notifications = querySnapshot.docs
//         .map((doc) {
//           final data = doc.data(); // Get the document data
//           print("Checking data for doc ID: ${doc.id}");

//           if (data == null ) {
//             print("⚠️ Document ${doc.id} has empty or null data.");
//             return null; // Skip this document
//           }


//           if (data is Map<String, dynamic>) {
//             if (data.containsKey('listNotification') &&
//                 data['listNotification'] is List &&
//                 (data['listNotification'] as List).isEmpty) {
//               print("⚠️ Document ${doc.id} has an empty list for notifications.");
//               return null; // Skip empty lists
//             }

//             return Notification.fromJson(data);
//           } else {
//             print("⚠️ Document ${doc.id} does not contain valid notification data.");
//             return null;
//           }
//         })
//         .where((notification) => notification != null)
//         .cast<Notification>() // Cast the list to remove null values
//         .toList();

//     print("Finished data conversion");

//     return NotificationList(notifications);
//   } catch (e) {
//     print("Error fetching notifications: $e");
//     rethrow;
//   }
// }


  
  

  // @override
  // Future<void> syncNotificationToCloud(NotificationList notificationList, System system) async {
  //   try {
  //     // Reference to the notification subcollection under the system document
  //     CollectionReference notificationRef = firestore
  //         .collection('system')
  //         .doc(system.id)
  //         .collection('notificationList');

  //     // Sync each notification in the list to Firestore
  //     for (Notification notification in notificationList.listNotification) {
  //       await notificationRef.doc(notification.id).set(
  //         notification.toJson(), SetOptions(merge: true)
  //       );
  //     }
  //   } catch (e) {
  //     print("Error syncing notifications to cloud: $e");
  //     rethrow;
  //   }
  // }
  

}

//  await firestore.collection('system').doc(user!.uid).set({
//           'listBuilding': listBuidlingToJson(listBuilding),
//           'landlord': landlord.toJson(),
//         },SetOptions(merge: true)
//      );
