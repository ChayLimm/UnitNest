import 'package:emonitor/presentation/view/building_room/building/building.dart';
import 'package:emonitor/presentation/view/building_room/building/buildingScreen.dart';
import 'package:emonitor/presentation/view/building_room/room/room.dart';
import 'package:emonitor/presentation/view/building_room/room/roomDetails.dart';
import 'package:flutter/material.dart';

class BuidlingNavigator extends StatelessWidget {
  const BuidlingNavigator({super.key});
  // your code .....
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        // Handle different named routes
        switch (settings.name) {
          case '/building/room':
            return MaterialPageRoute(builder: (context) => room());
          default:
            return MaterialPageRoute(builder: (context) => building());
        }
      },
    );
  }
}