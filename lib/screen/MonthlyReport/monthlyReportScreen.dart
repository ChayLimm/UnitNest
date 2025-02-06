import 'package:emonitor/utils/component.dart';
import 'package:flutter/material.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      floatingActionButton: customFloatingButton(
        onPressed: (){},// place your function here
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),        width: MediaQuery.of(context).size.width * 0.65,
        child: Center(
          child: Text("Thih is the monthly report screen"),
        ),
      ),
    );
  }
}
