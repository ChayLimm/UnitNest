
import 'package:emonitor/data/model/building/room.dart';
import 'package:emonitor/data/model/payment/payment.dart';
import 'package:emonitor/data/model/payment/transaction.dart';
import 'package:emonitor/data/model/stakeholder/landlord.dart';
import 'package:emonitor/data/model/stakeholder/tenant.dart';
import 'package:emonitor/data/model/system/priceCharge.dart';
import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/authentication/authenPage.dart';
import 'package:emonitor/presentation/view/receipt/receipt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  if(kIsWeb){
    await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBvgGhEXQnt-ERUqs-iyyV8kmLuVmXAg5E",
      authDomain: "unitnest-f12cc.firebaseapp.com",
      projectId: "unitnest-f12cc",
      storageBucket: "unitnest-f12cc.appspot.com", 
      messagingSenderId: "143712922998",
      appId: "1:143712922998:web:49174d57789c20300f1e57",
      measurementId: "G-WZX6BRVPWJ",
    ),
  ); 
  }else{
    await Firebase.initializeApp();
  }
  System.num += 1;
  runApp(MainApp());
}




class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    //dummy data
    Tenant tenant = Tenant(identifyID: "11111", userName: "ChayLim", contact: "012345", deposit: 100);
    Room room = Room(name: "A001", price: 100);
    TransactionKHQR transaction = TransactionKHQR(qr: "QR13413241234", md5: "MD51341324123");
    Payment dummyData = Payment(tenant: tenant, room: room, deposit: 0, transaction: transaction);

 
   List<PriceCharge> priceChargeList =  [PriceCharge(electricityPrice: 1, waterPrice: 1, hygieneFee: 1, finePerDay: 1, fineStartOn: 1, rentParkingPrice: 1,startDate: DateTime.now())];
    LandlordSettings landlordSettings = LandlordSettings(
      bakongAccount: BakongAccount(bakongID: "chayd@acld.com", username: "Cheng ChayLim", location:"Phnom Penh"), 
      priceChargeList: priceChargeList,
      );
    Landlord landlord = Landlord(username: "ChayLim", phoneNumber: "012341234",settings: landlordSettings);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: appTheme,
      home: AuthenPage(),
    );
  }
}
