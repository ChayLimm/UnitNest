import 'package:emonitor/presentation/view/MonthlyReport/monthlyReportScreen.dart';
import 'package:emonitor/presentation/view/dashboard/requestScreen.dart';
import 'package:flutter/material.dart';
class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
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
    );
  }
}