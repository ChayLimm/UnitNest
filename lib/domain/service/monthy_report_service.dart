import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/root_data.dart';

class MonthyReportService {
  static MonthyReportService? _instance;

  // Dependencies
  final RootDataService rootDataService;
  final RoomService roomService;
  final PaymentService paymentService;

  MonthyReportService._internal({
    required this.roomService,
    required this.rootDataService,
    required this.paymentService,
  });

  ///
  /// Initialization
  ///
  static void initialize({
    required RootDataService rootDataService,
    required RoomService roomService,
    required PaymentService paymentService,
  }) {
    if (_instance == null) {
      _instance = MonthyReportService._internal(
        rootDataService: rootDataService,
        roomService: roomService,
        paymentService: paymentService,
      );
    } else {
      throw "MonthyReportService is already initialized";
    }
  }

  // Singleton getter
  static MonthyReportService get instance {
    if (_instance == null) {
      throw "MonthyReportService must be initialized first";
    } else {
      return _instance!;
    }
  }

  IncomeBreakDown totalForMonth(Building building,DateTime datetime){

    late double electricity;
    late double electricityAmount;

    late double water;
    late double waterAmount;

    late double parking;
    late double parkingAmount;

    late double hygiene;
    late double hygieneAmount;

    late double fine;
    late double fineAmount;

    late double deposit;
    late double depositAmount;

    late double total;

      final paidRooms = roomService.paid(building: building, dateTime: datetime);
      late PriceCharge priceCharge;
      //get valid pricecharge
      for (var item in rootDataService.rootData!.landlord.settings!.priceChargeList) {
        if (item.isValidDate(datetime)) {
          priceCharge = item;
        }
      }
      // get total
      for(var room in paidRooms){
        //init room data;
        final payment = roomService.getPaymentFor(room,datetime);

        // Consumption Usage
        Consumption? consumptionUsage = roomService.getConsumptionUsageFor(room, datetime);
        // init breakdown value
        total = total + payment!.totalPrice;
        // electicity 
        electricity = electricity + (consumptionUsage!.electricityMeter * priceCharge.electricityPrice);
        electricityAmount += consumptionUsage.electricityMeter;
        // water
        water = water + (consumptionUsage.waterMeter * priceCharge.waterPrice);
        waterAmount += consumptionUsage.waterMeter;
        // parking
        parking = parking + payment.parkingFee;
        parkingAmount = parkingAmount + payment.parkingAmount;
        // hygiene
        hygiene = hygiene + payment.hygiene;
        hygieneAmount = double.parse(paidRooms.length.toString());
        //fine
        fine = fine + payment.fine;
        if(payment.fine != 0){
          fineAmount++;
        }
        //deposit
        deposit = deposit + payment.deposit;
        if(payment.deposit != 0){
          depositAmount++;
        }
      }
      
      return IncomeBreakDown(electricity: electricity, electricityAmount: electricityAmount, water: water, waterAmount: waterAmount, parking: parking, parkingAmount: parkingAmount, hygiene: hygiene, hygieneAmount: hygieneAmount, fine: fine, fineAmount: fineAmount, deposit: deposit, depositAmount: depositAmount, total: total);
  }
}

class IncomeBreakDown{
  late double electricity;
  late double electricityAmount;

  late double water;
  late double waterAmount;

  late double parking;
  late double parkingAmount;

  late double hygiene;
  late double hygieneAmount;

  late double fine;
  late double fineAmount;

  late double deposit;
  late double depositAmount;

  late double total;
  IncomeBreakDown({
    required this.electricity,
    required this.electricityAmount,
    required this.water,
    required this.waterAmount,
    required this.parking,
    required this.parkingAmount,
    required this.hygiene,
    required this.hygieneAmount,
    required this.fine,
    required this.fineAmount,
    required this.deposit,
    required this.depositAmount,
    required this.total,
  });
}