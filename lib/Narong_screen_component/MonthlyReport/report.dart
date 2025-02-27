import 'package:emonitor/presentation/view/MonthlyReport/monthlyReportScreen.dart';
import 'package:emonitor/presentation/view/dashboard/requestScreen.dart';
import 'package:flutter/material.dart';
class report extends StatelessWidget {
  const report({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 80,
              child: MonthlyReportScreen()
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