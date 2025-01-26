import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class PriceCharge {
  final double electricityPrice;
  final double waterPrice;
  final double hygieneFee;
  final double finePerDay;
  final double fineStartOn;
  final double rentParkingPrice;
  final DateTime startDate;
  final DateTime? endDate; // Nullable to represent ongoing validity

  PriceCharge({
    required this.electricityPrice,
    required this.waterPrice,
    required this.hygieneFee,
    required this.finePerDay,
    required this.fineStartOn,
    required this.rentParkingPrice,
    required this.startDate,
    this.endDate,
  });

  
}