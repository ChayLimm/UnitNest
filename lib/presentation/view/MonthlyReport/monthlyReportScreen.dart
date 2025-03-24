import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/presentation/Provider/main/monthly_report_provider.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/MonthlyReport/widget/break_down_table.dart';
import 'package:emonitor/presentation/view/MonthlyReport/widget/icome_break_down.dart';
import 'package:emonitor/presentation/view/utils/date_formator.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    /// Render data
    ///
    return Consumer2<MonthlyReportProvider,RoomProvider>(
      builder: (context, reportProvider,roomProvider, child) {
        return Scaffold(
          backgroundColor: UniColor.backGroundColor,
          body: Container(
            width: 1000,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  const SizedBox(height: 10,),
                IncomeCard(data: reportProvider.getIncome()),
                const SizedBox(height: 10,),
                BreakDownTable(icomeBreakDown: reportProvider.getIncome(),),
              ],
            ),
          ),
        );
      },
    );
  }
}