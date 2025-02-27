import 'package:emonitor/presentation/view/dashboard/dashboardScreen.dart';
import 'package:emonitor/presentation/view/dashboard/requestScreen.dart';
import 'package:flutter/material.dart';

class dashboard extends StatelessWidget {
  const dashboard({super.key});
  // this file is the main file for dashboard and request which i used for layouting the dashboard screen
  // dashboard = dashboard screen(80) + request screen from dashbaord(28)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 80,
              child: DashboardScreen()
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