import 'package:emonitor/data/repository/api/http_api.dart';
import 'package:emonitor/data/repository/firebase/fire_auth_impl.dart';
import 'package:emonitor/data/repository/firebase/fire_store_impl.dart';
import 'package:emonitor/data/repository/khqr/bakong_KHQR.dart';
import 'package:emonitor/domain/service/authentication_service.dart';
import 'package:emonitor/domain/service/building_service.dart';
import 'package:emonitor/domain/service/finder_service.dart';
import 'package:emonitor/domain/service/khqr_service.dart';
import 'package:emonitor/domain/service/monthy_report_service.dart';
import 'package:emonitor/domain/service/notification_Service.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/domain/service/setting_service.dart';
import 'package:emonitor/domain/service/telegram_service.dart';
import 'package:emonitor/domain/service/tenant_service.dart';
import 'package:emonitor/presentation/Provider/Setting/setting_provider.dart';
import 'package:emonitor/presentation/Provider/main/building_provider.dart';
import 'package:emonitor/presentation/Provider/main/monthly_report_provider.dart';
import 'package:emonitor/presentation/Provider/main/notification_provider.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/authentication/authenPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
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
  } else {
    await Firebase.initializeApp();
     WidgetsFlutterBinding.ensureInitialized();
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hide status and nav bar
  }

  // Create RootDataService instance
  final rootDataService = RootDataService(DatabaseRepoImpl());

  /// 
  SettingService.initialize(rootDataService);
  AuthenticationService.initialize(AuthRepoImpl());
  KhqrService.initialize(bakongRepository: BakongKhqrImpl(), rootDataRepository: rootDataService);
  BuildingService.initialize(rootDataService);
  RoomService.initialize(rootDataService);
  TenantService.initialize(rootDataService);
  PaymentService.initialize(rootDataService);
  TelegramService.initialize(HttpApiCall());
  NotificationService.initialize(rootDataService);
  FinderService.initialize(rootDataService);
  MonthyReportService.initialize(rootDataService:rootDataService);

  runApp(
    MultiProvider(
      providers: [
        // Provide AuthenticationService
        ChangeNotifierProvider<SettingProvider>(create: (_) => SettingProvider(rootDataService),),
        ChangeNotifierProvider<BuildingProvider>(create: (_) => BuildingProvider(rootDataService),),
        ChangeNotifierProvider<RoomProvider>(create: (_) => RoomProvider(rootDataService),),
        ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider(rootDataService: rootDataService),),
        ChangeNotifierProvider<MonthlyReportProvider>(create: (_) => MonthlyReportProvider(rootDataService: rootDataService),),

      ],
      child: MainApp(rootDataService:rootDataService),
    ),
  );
}

class MainApp extends StatelessWidget {
  final RootDataService rootDataService;
  const MainApp({super.key,required this.rootDataService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: AuthenPage(rootDataService: rootDataService,),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();  
//   if(kIsWeb){
//     await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "AIzaSyBvgGhEXQnt-ERUqs-iyyV8kmLuVmXAg5E",
//       authDomain: "unitnest-f12cc.firebaseapp.com",
//       projectId: "unitnest-f12cc",
//       storageBucket: "unitnest-f12cc.appspot.com", 
//       messagingSenderId: "143712922998",
//       appId: "1:143712922998:web:49174d57789c20300f1e57",
//       measurementId: "G-WZX6BRVPWJ",
//     ),
//   ); 
//   }else{
//     await Firebase.initializeApp();
//   }
//   System.num += 1;
//   runApp(MainApp());
// }




// class MainApp extends StatelessWidget {
//   const MainApp({super.key});


//   @override
//   Widget build(BuildContext context) {
    
//     ///
//     /// Provider Inject of IMPL
//     ///
//     return MultiProvider(providers: [
//       // root data injection
//         ChangeNotifierProvider<RootDataService>(create: (_) => RootDataService(DatabaseRepoImpl())),
//       // authentication injection
//         ChangeNotifierProvider<AuthenticationService>(create: (_) => AuthenticationService(AuthRepoImpl())),
//       //khqr injection
//         ChangeNotifierProvider<KhqrService>(create: (_)=>KhqrService(rootDataRepository:  context.read<RootDataService>(), bakongRepository: BakongKhqrImpl())),
//       // building service injection
//         ChangeNotifierProvider<BuildingService>(create: (_)=>BuildingService(context.read<RootDataService>())),
//       // room injection
//         ChangeNotifierProvider<RoomService>(create: (_)=>RoomService(context.read<RootDataService>())),
//       // tenant injection
//         ChangeNotifierProvider<TenantService>(create: (_)=>TenantService(context.read<RootDataService>())),
//       // Settign service
//         ChangeNotifierProvider<SettingService>(create: (_)=>SettingService(context.read<RootDataService>())),
//       // Payment service but without the change notifire
//         ChangeNotifierProvider<PaymentService>(create: (_)=>PaymentService(context.read<RootDataService>())),
//     ],
//     child: MaterialApp(
//       debugShowCheckedModeBanner: false,
//        theme: appTheme,
//       home:  AuthenPage(),
//     ));
//   }
// }



 //dummy data
  //   Tenant tenant = Tenant(identifyID: "11111", userName: "ChayLim", contact: "012345", deposit: 100);
  //   Room room = Room(name: "A001", price: 100);
  //   TransactionKHQR transaction = TransactionKHQR(qr: "QR13413241234", md5: "MD51341324123");
  //   Payment dummyData = Payment(tenant: tenant, room: room, deposit: 0, transaction: transaction);

 
  //  List<PriceCharge> priceChargeList =  [PriceCharge(electricityPrice: 1, waterPrice: 1, hygieneFee: 1, finePerDay: 1, fineStartOn: 1, rentParkingPrice: 1,startDate: DateTime.now())];
  //   LandlordSettings landlordSettings = LandlordSettings(
  //     bakongAccount: BakongAccount(bakongID: "chayd@acld.com", username: "Cheng ChayLim", location:"Phnom Penh"), 
  //     priceChargeList: priceChargeList,
  //     );
  //   Landlord landlord = Landlord(username: "ChayLim", phoneNumber: "012341234",settings: landlordSettings);
