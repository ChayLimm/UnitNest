import 'package:emonitor/domain/model/system/system.dart';
import 'package:emonitor/domain/repository/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';


///
/// i will not use singleton on this due to iniffecient of accesing and storing data
class RootDataService  {
  final DatabaseRepository databaseRepository;
  RootDataService(this.databaseRepository);

  // This is the root data source that we will perform CRUD and sync to the cloud
  System? _rootData;

  // Getter for rootData
  System? get rootData => _rootData;

  /// Fetches the root data from the database.
  /// This means that the user has to log in first and pass the User through the parameter.
  Future<System?> fetchRootData(User user) async {
    try {
      _rootData = await databaseRepository.fetchSystem(user.uid); // Notify listeners after fetching data
      return _rootData;
    } catch (e) {
      print("Error fetching root data: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  /// Initializes the root data for a new user and syncs it to the cloud.
  Future<void> initializeRootData(System system) async {
    try {
      if (system == null) {
        throw "System data cannot be null";
      }
      _rootData = system;
      await databaseRepository.synceToCloud(_rootData!); // Notify listeners after initializing data
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
      await databaseRepository.synceToCloud(_rootData!); // Notify listeners after syncing data
    } catch (e) {
      print("Error syncing to cloud: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }
}