import 'package:json_annotation/json_annotation.dart';

part 'priceCharge.g.dart';

@JsonSerializable()
class PriceCharge {
  final double electricityPrice;
  final double waterPrice;
  final double hygieneFee;
  final double finePerDay;
  final double fineStartOn;
  final double rentParkingPrice;
  final DateTime startDate;
  late DateTime endDate; // Nullable to represent ongoing validity

  PriceCharge({
    required this.electricityPrice,
    required this.waterPrice,
    required this.hygieneFee,
    required this.finePerDay,
    required this.fineStartOn,
    required this.rentParkingPrice,
    required this.startDate,
  });

  factory PriceCharge.fromJson(Map<String, dynamic> json) => _$PriceChargeFromJson(json);
  Map<String, dynamic> toJson() => _$PriceChargeToJson(this);
 
   bool isValidDate(DateTime datetime) {
    if (endDate == null) {
      // print('enddate null checked');
      return datetime.isAfter(startDate);
    }
    // print('enddate null NOT checked');
    return datetime.isAfter(startDate) && datetime.isBefore(endDate!);
   }
}