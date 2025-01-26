import 'package:emonitor/screen/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();  // Ensures that Firebase is initialized before the app starts
    await Firebase.initializeApp();  // Initialize Firebase
      runApp(const MainApp());

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
          fontFamily: 'Poppins',
        ),
      home:  RegisterScreen()
    );
  }
}
