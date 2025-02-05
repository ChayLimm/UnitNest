
import 'package:emonitor/screen/authentication/authenPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';



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
