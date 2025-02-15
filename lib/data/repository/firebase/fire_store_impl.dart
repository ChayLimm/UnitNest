import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:emonitor/domain/usecases/system.dart';
import 'package:emonitor/domain/repository/repo.dart';

class DatabaseRepoImpl implements DatabaseRepository{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<System> fetchSystem(String systemID) async {
    // TODO: implement fetchSystem
    try{
       DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('system')
            .doc(systemID)
            .get();
        if (doc.exists) {
          Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
          return System.fromJson(docData);       
        }
    }catch (e){
      rethrow;
    }
    throw UnimplementedError();
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
    throw UnimplementedError();
  }

}

//  await firestore.collection('system').doc(user!.uid).set({
//           'listBuilding': listBuidlingToJson(listBuilding),
//           'landlord': landlord.toJson(),
//         },SetOptions(merge: true)
//      );