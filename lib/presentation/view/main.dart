import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/presentation/view/Main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final System system;
  const MyApp({
    required this.system,
    super.key
    });
  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => system),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Poppins',
              ),
              home: MainScreen(system: system,), 
            ),
    );
  }
}