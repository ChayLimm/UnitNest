
import 'package:emonitor/data/model/building/room.dart';
import 'package:emonitor/data/model/payment/payment.dart';
import 'package:emonitor/data/model/payment/transaction.dart';
import 'package:emonitor/data/model/stakeholder/tenant.dart';
import 'package:emonitor/presentation/view/authentication/authenPage.dart';
import 'package:emonitor/presentation/view/receipt/receipt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod





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

  runApp(const ProviderScope(child: MainApp()));
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

    return 
    
    
    MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
          fontFamily: 'Poppins',
        ),
      home:  AuthenPage(),
    );
  }
}
