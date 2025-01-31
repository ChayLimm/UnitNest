
import 'package:emonitor/screen/authentication/authenPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures Firebase is initialized before the app starts
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBvgGhEXQnt-ERUqs-iyyV8kmLuVmXAg5E",
      authDomain: "unitnest-f12cc.firebaseapp.com",
      projectId: "unitnest-f12cc",
      storageBucket: "unitnest-f12cc.appspot.com", // ✅ Fixed this line
      messagingSenderId: "143712922998",
      appId: "1:143712922998:web:49174d57789c20300f1e57",
      measurementId: "G-WZX6BRVPWJ",
    ),
  ); // Initialize Firebase

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
