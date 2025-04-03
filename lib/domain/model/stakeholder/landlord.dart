import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
part 'landlord.g.dart';


@JsonSerializable(explicitToJson: true)
class Landlord{
    final String id = const Uuid().v4();
    String username;
    String phoneNumber;
    final DateTime createdAt = DateTime.now();
    LandlordSettings? settings;

    Landlord({
      required this.username,
      required this.phoneNumber,
      this.settings,
    });

  factory Landlord.fromJson(Map<String, dynamic> json) => _$LandlordFromJson(json);
  Map<String, dynamic> toJson() => _$LandlordToJson(this);
 
}

@JsonSerializable(explicitToJson: true)
class LandlordSettings {
   BakongAccount bakongAccount;
   List<PriceCharge> priceChargeList = [];
   String rule;
 LandlordSettings({
    required this.bakongAccount,
    required this.priceChargeList,
    this.rule = " ",
  });

  factory LandlordSettings.fromJson(Map<String, dynamic> json) => _$LandlordSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$LandlordSettingsToJson(this);

  PriceCharge getPriceCharge(DateTime datetime){
    for( var priceCharge in priceChargeList){
      if(priceCharge.isValidDate(datetime)){
        return priceCharge;
      }
    }
    return PriceCharge(electricityPrice: 0, waterPrice: 0, hygieneFee: 0, finePerDay: 0, fineStartOn: 0, rentParkingPrice: 0, startDate: DateTime.now());
  }
}

@JsonSerializable()
class BakongAccount{
  String bakongID;
  String username;
  String location;

  BakongAccount({
    required this.bakongID,
    required this.username,
    required this.location
    
  });

  factory BakongAccount.fromJson(Map<String, dynamic> json) => _$BakongAccountFromJson(json);
  Map<String, dynamic> toJson() => _$BakongAccountToJson(this);
}