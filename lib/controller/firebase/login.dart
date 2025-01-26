import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/model/system/system.g.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UnitNestAuth{

  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;



  Future<bool> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //create system for the user
      final User? user = _auth.currentUser;
      final userID = user!.uid;

      System system = System(
        id: userID, 
        listBuilding: [], 
        priceChargeList: []
      );

      storeSystemData(system);    

      return true;
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }
      return false;
    }
  }
   Future<void> storeSystemData(System systemData) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Store the data in the 'system' collection
    // await firestore.collection('system').doc(systemData.id).set(systemData.toMap());

    print("System data stored successfully!");
  } catch (e) {
    print("Error storing system data: $e");
  }
}

}