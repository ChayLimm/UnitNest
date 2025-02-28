import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/data/model/building/building.dart';
import 'package:emonitor/data/model/system/system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SystemService extends ChangeNotifier {
   
   late System system;

   Future<void> syncCloud() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("user is null");
        return;
      } else {
        await firestore.collection('system').doc(user.uid).set({
          'listBuilding': listBuidlingToJson(system.listBuilding),
          'landlord': system.landlord.toJson(),
        }, SetOptions(merge: true));
        notifyListeners();
        print("synce to cloud succesfully");
      }
    } catch (e) {
      print(e);
    }
  }

  //json convertor

  List<Map<String, dynamic>> listBuidlingToJson(List<Building> listBuildings) {
    return listBuildings.map((building) => building.toJson()).toList();
  }
}