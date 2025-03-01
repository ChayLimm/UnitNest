import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/domain/repository/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootDataService {
  final DatabaseRepository databaseRepository;
  RootDataService(this.databaseRepository);

  //this is the Root data source that we will perform crud and sync to cloud
  System? _rootData;

  Future<System?> fetchRootData(User user) async {
    /// fetch the data form the data base
    /// this mean that user have to login first and pass the User throught the param
    _rootData = await databaseRepository.fetchSystem(user.uid);

    return _rootData;
  }

  Future<void> synceToCloud() async {
    try {
      if (rootData != null) {
        await databaseRepository.synceToCloud(rootData!);
      } else {
        throw "Must fetch before synce";
      }
    } catch (e) {
      rethrow;
    }
  }

  System? get rootData => _rootData;
}
