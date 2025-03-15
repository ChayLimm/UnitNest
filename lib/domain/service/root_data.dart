import 'dart:typed_data';

import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/system/system.dart';
import 'package:emonitor/domain/repository/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


///
/// i will not use singleton on this due to iniffecient of accesing and storing data
class RootDataService  {
  final DatabaseRepository databaseRepository;
  RootDataService(this.databaseRepository);

  // This is the root data source that we will perform CRUD and sync to the cloud
  System? _rootData;
  NotificationList? _notificationList;

  // Getter for rootData
  System? get rootData => _rootData;
  NotificationList? get notificationList => _notificationList;

  void updateNotificationList(List<UniNotification?> newNoti) {
  if (newNoti == null) {
    print("Warning: _notificationList is null!");
    return;
  }
  _notificationList!.listNotification = newNoti;
  print(_notificationList!.listNotification.length);
}


  /// Fetches the root data from the database.
  /// This means that the user has to log in first and pass the User through the parameter.
  Future<void> fetchRootData(User user) async {
    try {
      _rootData = await databaseRepository.fetchSystem(user.uid); // Notify listeners after fetching data
      _notificationList = await databaseRepository.fetchNotification(_rootData!.id);
    } catch (e) {
      print("Error fetching root data: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  /// Initializes the root data for a new user and syncs it to the cloud.
  Future<void> initializeRootData(System system,NotificationList notificationList) async {
    try {
     
      _rootData = system;
      _notificationList = notificationList;

      await databaseRepository.synceToCloud(_notificationList!,_rootData!); // Notify listeners after initializing data


    } catch (e) {
      print("Error initializing root data: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  /// Syncs the root data to the cloud.
  Future<void> synceToCloud() async {
    try {
      if (_rootData == null) {
        throw "Root data is null. Fetch or initialize data before syncing.";
      }

      await databaseRepository.synceToCloud(_notificationList!,_rootData!); // Notify listeners after syncing data
      // await databaseRepository.syncNotificationToCloud(notificationList!,_rootData!);

    } catch (e) {
      print("Error syncing to cloud: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  Future<NotificationList> fetchNotification() async{
     try {
      if (_rootData == null) {
        throw "Root data is null. Fetch or initialize data before syncing.";
      }
        _notificationList = await databaseRepository.fetchNotification(_rootData!.id);
       return _notificationList!;
     } catch (e){
       rethrow;
     }
  }


    static Future<String?> uploadImageToFirebaseStorage(Uint8List imageBytes) async {
     try{
       // Create a reference to the location you want to upload to
      //  print(imageBytes);
       print("trigger starting uploading image");
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child("receipts/${DateTime.now().millisecondsSinceEpoch}.png");
       print("1");

      // Upload the file
      final uploadTask = imageRef.putData(imageBytes);
      print("2");

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() => null);
      print("3");
      // Get the download URL
      final String downloadURL = await snapshot.ref.getDownloadURL();
      // print(downloadURL);

      return downloadURL;
     }catch (e){
      print("Error uploading image to Firebase Storage: $e");
      throw e; // Rethrow the error after printing
    }
    }
}