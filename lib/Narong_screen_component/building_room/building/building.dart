import 'package:emonitor/presentation/view/building_room/building/buildingScreen.dart';
import 'package:emonitor/presentation/view/dashboard/requestScreen.dart';
import 'package:flutter/material.dart';
class building extends StatelessWidget {
  const building({super.key});
  // this file is the main file for building and room which i used for layouting the building screen
  // building = buidling screen(80) + request screen from dashbaord(28)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 80,
              child: BuildingScreen()
              ),
            Expanded(
              flex: 28,
              child: RequestScreen()
              ),
          ],
        ),
      ),
    );
  }
}