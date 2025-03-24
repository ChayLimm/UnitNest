import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/root_data.dart';

class MonthyReportService {
  static MonthyReportService? _instance;
  // Dependencies
  final RootDataService rootDataService;

  MonthyReportService._internal({
    required this.rootDataService,
  });

  ///
  /// Initialization
  ///
  static void initialize({
    required RootDataService rootDataService,
  }) {
    if (_instance == null) {
      _instance = MonthyReportService._internal(rootDataService: rootDataService,
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

     double electricity = 0;
     double electricityAmount = 0;

     double water = 0;
     double waterAmount = 0;

     double parking = 0;
     double parkingAmount = 0;

     double hygiene = 0;
     double hygieneAmount = 0;

     double fine = 0;
     double fineAmount = 0;

     double deposit = 0;
     double depositAmount = 0;

     double roomTotal = 0;
     double total  = 0;
     
    PriceCharge priceCharge = PriceCharge(electricityPrice: 0, waterPrice: 0, hygieneFee: 0, finePerDay: 0, fineStartOn: 0, rentParkingPrice: 0, startDate: datetime);


      final List<Room> paidRooms = RoomService.instance.paid(building: building, dateTime: datetime);
      final List<Room> unpaidRooms = RoomService.instance.unPaid(building: building, dateTime: datetime);
      final List<Room> pendingRooms = RoomService.instance.pending(building: building, dateTime: datetime);


      //get valid pricecharge
      for (var item in rootDataService.rootData!.landlord.settings!.priceChargeList) {
        if (item.isValidDate(datetime)) {
          priceCharge = item;
        }
      }

      // get total
      for(var room in paidRooms){
        //init room data;
        final payment = RoomService.instance.getPaymentFor(room,datetime);
        // room price
        roomTotal = roomTotal + payment!.roomPrice;
        // Consumption Usage
        Consumption consumptionUsage = RoomService.instance.getConsumptionUsageFor(room, datetime);
        // init breakdown value
        total = total + payment.totalPrice;
        // electicity 
        electricity = electricity + (consumptionUsage.electricityMeter * priceCharge.electricityPrice);
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

      return IncomeBreakDown(priceCharge: priceCharge,paidRoom: paidRooms.length,pendingRoom: pendingRooms.length,unpaidRoom: unpaidRooms.length,roomTotal: roomTotal,electricity: electricity, electricityAmount: electricityAmount, water: water, waterAmount: waterAmount, parking: parking, parkingAmount: parkingAmount, hygiene: hygiene, hygieneAmount: hygieneAmount, fine: fine, fineAmount: fineAmount, deposit: deposit, depositAmount: depositAmount, total: total);
  }
}
// class TargetTotal{
//   double roomTotalTarget;

// }
class IncomeBreakDown {
  PriceCharge priceCharge;
  int unpaidRoom;
  int paidRoom;
  int pendingRoom;
  double roomTotal;
  double electricity;
  double electricityAmount;
  double water;
  double waterAmount;
  double parking;
  double parkingAmount;
  double hygiene;
  double hygieneAmount;
  double fine;
  double fineAmount;
  double deposit;
  double depositAmount;
  double total;

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
    required this.roomTotal,
    required this.paidRoom,
    required this.pendingRoom,
    required this.unpaidRoom,
    required this.priceCharge
  });

  // Override the + operator
  IncomeBreakDown operator +(IncomeBreakDown other) {
    return IncomeBreakDown(
      priceCharge: priceCharge,
      electricity: electricity + other.electricity,
      electricityAmount: electricityAmount + other.electricityAmount,
      water: water + other.water,
      waterAmount: waterAmount + other.waterAmount,
      parking: parking + other.parking,
      parkingAmount: parkingAmount + other.parkingAmount,
      hygiene: hygiene + other.hygiene,
      hygieneAmount: hygieneAmount + other.hygieneAmount,
      fine: fine + other.fine,
      fineAmount: fineAmount + other.fineAmount,
      deposit: deposit + other.deposit,
      depositAmount: depositAmount + other.depositAmount,
      total: total + other.total,
      roomTotal: roomTotal + other.roomTotal,
      unpaidRoom: unpaidRoom + other.unpaidRoom,
      paidRoom: paidRoom + other.paidRoom,
      pendingRoom: pendingRoom + other.paidRoom,
    );
  }
}
