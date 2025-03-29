import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/monthy_report_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/material.dart';

class MonthlyReportProvider extends ChangeNotifier {
  RootDataService rootDataService;
  MonthlyReportProvider({required this.rootDataService});

  DateTime selectedDate = DateTime.now();
  Building? selectedBuilding;

  void refresh(){
    notifyListeners();
  }

  void setSelectedDate(DateTime datetime){
    selectedDate = datetime;
    notifyListeners();
  }
  void setSelectedBuilding(Building? building){
    selectedBuilding = building;
    notifyListeners();
  }

  IncomeBreakDown getIncome(){
    if(selectedBuilding == null){
      IncomeBreakDown? totalIncome;
      for(var building in rootDataService.rootData!.listBuilding){
        if(totalIncome == null){
          totalIncome = MonthyReportService.instance.totalForMonth(building, selectedDate);
        }else{
        totalIncome = totalIncome + MonthyReportService.instance.totalForMonth(building, selectedDate);
        }
      }
      return totalIncome?? IncomeBreakDown(electricity: 0, electricityAmount: 0, water: 0, waterAmount: 0, parking: 0, parkingAmount: 0, hygiene: 0, hygieneAmount: 0, fine: 0, fineAmount: 0, deposit: 0, depositAmount: 0, total: 0, roomTotal: 0, paidRoom: 0, pendingRoom: 0, unpaidRoom: 0, priceCharge: PriceCharge(electricityPrice: 0, waterPrice: 0, hygieneFee: 0, finePerDay: 0, fineStartOn: 0, rentParkingPrice: 0, startDate: DateTime.now()));
      }else{
      return  MonthyReportService.instance.totalForMonth(selectedBuilding!,selectedDate);
      }
  }
}
