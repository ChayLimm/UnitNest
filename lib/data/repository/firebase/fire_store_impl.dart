import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:emonitor/domain/model/system/system.dart';
import 'package:emonitor/domain/repository/repo.dart';

class DatabaseRepoImpl implements DatabaseRepository{

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

  @override
  Future<void> synceToCloud(System system) async {
    // TODO: implement synceToCloud
    try{
       await firestore.collection('system').doc(system.id).set(
         system.toJson(),SetOptions(merge: true)
        );
    } catch (e){
      rethrow;
    }
  }
}

//  await firestore.collection('system').doc(user!.uid).set({
//           'listBuilding': listBuidlingToJson(listBuilding),
//           'landlord': landlord.toJson(),
//         },SetOptions(merge: true)
//      );