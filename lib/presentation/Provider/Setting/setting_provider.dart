import 'package:emonitor/domain/model/stakeholder/landlord.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/authentication_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/domain/service/setting_service.dart';
import 'package:flutter/material.dart';

class SettingProvider extends ChangeNotifier {
  RootDataService repository;
  SettingProvider(this.repository);
  
  //Profile
  Landlord get landlord => repository.rootData!.landlord;
  // get setting
  LandlordSettings get setting => repository.rootData!.landlord.settings!;

  //edit profile
  void updateProfile(String? newUsername, String? newPhoneNumber){    
    SettingService.instance.updateLandlord(
      newUsername?? landlord.username,
      newPhoneNumber?? landlord.phoneNumber
    );
    notifyListeners();
  }

  //update bakong
  Future<void> updateBakongAccount(BakongAccount newBakongAccount) async{
    await SettingService.instance.updateBakongAccount(newBakongAccount);
    notifyListeners();
  }

  //update price charge
  Future<void> addPriceCharge(PriceCharge newPriceCharge) async {
    await SettingService.instance.addPriceCharge(newPriceCharge);
    notifyListeners();
  }

  //update rules
  Future<void> updateRules(String newRule) async{
    await SettingService.instance.updateRules(newRule);
    notifyListeners();
  }

  void sendPasswordResetEmail(){
    AuthenticationService.instance.sendPasswordResetEmail();
  }

  
}