import 'package:emonitor/domain/model/stakeholder/landlord.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/root_data.dart';

class SettingService{

  static SettingService? _instance;

  RootDataService repository;

  SettingService.internal(this.repository);

  static void initialize(RootDataService repository){
    if(_instance==null){
      _instance = SettingService.internal(repository);
    }else{
      throw "Setting service is already init";
    }
  }

  ///
  /// Singleton for service accesssing
  /// 
  static SettingService get instance {
    if(_instance == null){
      throw "Setting service must be init first";
    }else{
      return _instance!;
    }
  }
  

  Future<void> updateLandlord(String userName, String phoneNumber) async{
    print("Setting service : ");
    print(userName);
    print(phoneNumber);
    repository.rootData!.landlord = Landlord(
       username: userName ,
       phoneNumber: phoneNumber,
       settings: repository.rootData!.landlord.settings
    );
       
    await repository.synceToCloud();
    return;
  }

  Future<void> updateBakongAccount(BakongAccount newBakongAccount) async{
    repository.rootData!.landlord.settings!.bakongAccount = newBakongAccount;
    await repository.synceToCloud();
    return;
     }


  Future<void> addPriceCharge(PriceCharge priceCharge) async {
    try {
      // Set endDate for the last price charge
      if (repository.rootData!.landlord.settings!.priceChargeList.isNotEmpty) {
        repository.rootData!.landlord.settings!.priceChargeList.last.endDate = DateTime.now();
      }
      // Add the new price charge
      repository.rootData!.landlord.settings!.priceChargeList.add(priceCharge);
      await repository.synceToCloud(); // Ensure this does not throw UnimplementedError
      } catch (e) {
      print("Error in addPriceCharge: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  Future<void> updateRules(String newRule)async{
    repository.rootData!.landlord.settings!.rule = newRule;
    await repository.synceToCloud();
    
    return;
  }

}