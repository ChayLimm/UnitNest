import 'package:emonitor/model/building/building.dart';
import 'package:emonitor/model/building/room.dart';
import 'package:emonitor/model/system/priceCharge.dart';
import 'package:emonitor/model/system/system.dart';
import 'package:emonitor/screen/authentication/authenPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

   var building1 =
  Building(
    name: "B1", 
    address: "Phnom Penh",
  )
;

building1.roomList.add(Room(name: "A001", price: 120));

var pricecharge =
  PriceCharge(
    electricityPrice: 1, 
    waterPrice: 1, 
    hygieneFee: 1, 
    finePerDay: 1, 
    fineStartOn: 5, 
    rentParkingPrice: 10, 
    startDate: DateTime.now());


System system1 = System(
  id: "testing1",
);
system1.priceChargeList.add(pricecharge);
system1.listBuilding.add(building1);

print(system1.toJson());
    WidgetsFlutterBinding.ensureInitialized();  // Ensures that Firebase is initialized before the app starts
    await Firebase.initializeApp();  // Initialize Firebase
      runApp(const MainApp());

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    
    
    MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
          fontFamily: 'Poppins',
        ),
      home:  Register()
    );
  }
}
