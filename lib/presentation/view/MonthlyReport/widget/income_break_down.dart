import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/service/monthy_report_service.dart';
import 'package:emonitor/presentation/Provider/main/monthly_report_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class IncomeCard extends StatelessWidget {
  IncomeBreakDown data;
  IncomeCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.read<MonthlyReportProvider>();
    final List<Color> colorList = [
      UniColor.primary,
      UniColor.neutralLight,
    ];
    final Map<String, double> dataMap = {
      "paid": data.paidRoom.toDouble(),
      "Unpaid": (data.unpaidRoom.toDouble() + data.pendingRoom.toDouble()),
    };

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // First Column: Building Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        boxShadow: [shadow()],
                        color: UniColor.white,
                        borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<Building>(
                        value: reportProvider.selectedBuilding,
                        underline: Container(),
                        dropdownColor: Colors.white,
                        onChanged: (value) {
                          reportProvider.setSelectedBuilding(value);
                        },
                        items: [
                          DropdownMenuItem<Building>(
                            value: null,
                            child: Text("All", style: UniTextStyles.body),
                          ),
                          ...reportProvider.rootDataService.rootData!.listBuilding
                              .map((item) => DropdownMenuItem<Building>(
                                    value: item,
                                    child: Text(item.name, style: UniTextStyles.body),
                                  ))
                              .toList(),
                        ],
                        hint: Text(
                          "Select a building",
                          style: UniTextStyles.body,
                        ),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Second Column: Date
                  Expanded(
                    child:GestureDetector(
                      onTap:  () async {
                        DateTime? selectedDate = await selectDate(context);
                        if (selectedDate != null) {
                          reportProvider.setSelectedDate(selectedDate);
                        }
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          boxShadow: [shadow()],
                          color: UniColor.white,
                          borderRadius: BorderRadius.circular(10)),
                        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(DateFormat('MMMM yyy').format(reportProvider.selectedDate)),
                          const Icon(Icons.arrow_drop_down)
                          ])
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: UniColor.primary,width: 1),
                  color: UniColor.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              dataMap: dataMap,
                              initialAngleInDegree: -90,
                              ringStrokeWidth: 10,
                              chartRadius: 75,
                              chartType: ChartType.ring,
                              colorList: colorList,
                              legendOptions: const LegendOptions(showLegends: false),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValues: false,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${data.paidRoom}/${data.unpaidRoom + data.paidRoom + data.pendingRoom }", style: UniTextStyles.label),
                                Text("Paid", style: UniTextStyles.body.copyWith(color: UniColor.neutral, fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Income", style: UniTextStyles.body),
                            Text("\$ ${data.total.toStringAsFixed(2)}", style: UniTextStyles.heading),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Updated Breakdown Section
        Expanded(
          flex: 2,
          child: Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: UniColor.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text("Breakdown", style: UniTextStyles.label),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: BreakdownCard(
                            title: "Water total",
                            totalPrice: data.water,
                            itemCount: "${data.waterAmount.toStringAsFixed(2)} m³",
                            totalTargetAmount: data.total,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: BreakdownCard(
                            title: "Electricity total",
                            totalPrice: data.electricity,
                            itemCount: "${data.electricity.toStringAsFixed(2)} KWH",
                            totalTargetAmount: data.total,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: BreakdownCard(
                            title: "Room total",
                            totalPrice: data.roomTotal,
                            itemCount: "${data.paidRoom} rooms",
                            totalTargetAmount: data.total,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: BreakdownCard(
                            title: "Other total",
                            totalPrice: (data.parking + data.fine + data.deposit),
                            itemCount: "3 items",
                            totalTargetAmount: data.total,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class BreakdownCard extends StatelessWidget {
  final String title;
  final double totalPrice; 
  late double percent;
  final String itemCount; 
  final double totalTargetAmount;

  BreakdownCard({
    super.key,
    required this.title,
    required this.totalPrice,
    required this.itemCount,
    required this.totalTargetAmount,
  }){
    percent = (totalPrice / totalTargetAmount)*100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: UniColor.neutralLight, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: UniTextStyles.body,
          ),
          Text( "\$ ${totalPrice.toStringAsFixed(2)}",
            style: UniTextStyles.label,
          ),
          LinearPercentIndicator(
            width: 200.0,
            lineHeight: 5.0,
            percent: percent/100,
            barRadius: const Radius.circular(3),
            progressColor: UniColor.primary,
            backgroundColor: UniColor.neutralLight,
            padding: EdgeInsets.zero,
          ),
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemCount,
                  style: TextStyle(
                    color: UniColor.neutral,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("${percent.toStringAsFixed(2)} %",
                  style:  UniTextStyles.body.copyWith(color: UniColor.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}