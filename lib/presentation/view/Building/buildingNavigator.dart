import 'package:emonitor/presentation/view/Building/building/buildingScreen.dart';
import 'package:emonitor/presentation/view/Building/room/room_main.dart';
import 'package:flutter/material.dart';

class BuidlingNavigator extends StatelessWidget {
  const BuidlingNavigator({super.key});
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        // Handle different named routes
        switch (settings.name) {
          case '/building/room':
            return MaterialPageRoute(builder: (context) => const RoomMain());
          default:
            return MaterialPageRoute(builder: (context) =>const BuildingScreen());
        }
      },
    );
  }
}