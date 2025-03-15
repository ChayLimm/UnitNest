import 'package:emonitor/domain/model/system/system.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime todayDate = DateTime.now();
    String formattedDate = DateFormat('MMMM dd, yyyy').format(todayDate);
    String dayOfWeek = DateFormat('EEEE').format(todayDate);
    // list of color for the pie chart
    final List<Color> colorList = [
      UniColor.primary,
      UniColor.neutralLight,
    ];
    // dummy data for testing only
    final Map<String, double> dataMap = {
      "Total paid": 5,
      "Total Unpaid": 2,
    };
    return Scaffold(
        backgroundColor: UniColor.backGroundColor,
        floatingActionButton: customFloatingButton(
          onPressed: () {}, // place your function here
        ),
        body: Consumer<System>(
          builder: (context, system, child) {
            String username = system.landlord.username;
            String phoneNumber = system.landlord.phoneNumber;
            return Container(
              color: UniColor.neutralLight,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  // top section
                  _buildHeader(username, phoneNumber, formattedDate, dayOfWeek),
                  // Dashbaord content
                  Container(
                    child: Column(
                      children: [
                        // income graph and its break down
                        // its height 180 or 30%
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: UniColor.primary),
                                  color: UniColor.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            PieChart(
                                              dataMap: dataMap,
                                              initialAngleInDegree: 0,
                                              ringStrokeWidth: 10,
                                              chartRadius: 75,
                                              chartType: ChartType.ring,
                                              colorList: colorList,
                                              legendOptions: LegendOptions(
                                                showLegends: false,
                                              ),
                                              chartValuesOptions:
                                                  ChartValuesOptions(
                                                showChartValues: false,
                                                showChartValuesInPercentage:
                                                    false,
                                                showChartValuesOutside: false,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("22/30",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text("Paid",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Income",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: UniColor.neutralDark,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "\$" + "2,262.50",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Divider(),
                                    Flexible(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: 6,
                                        itemBuilder: (context, index) {
                                          return buildBuildingPaymentSummary();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: UniColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Breakdown",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // SizedBox(height: 10,),
                                      GridView.builder(
                                        shrinkWrap:
                                            true, // Prevents unnecessary scrolling inside a column
                                        physics:
                                            NeverScrollableScrollPhysics(), // Disables GridView scrolling inside another scrollable widget
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              2, // Adjust based on your layout
                                          crossAxisSpacing:
                                              5, // Space between columns
                                          mainAxisSpacing:
                                              15, // Space between rows
                                          childAspectRatio:
                                              3.515, // Adjust this to fit the content properly
                                        ),
                                        itemCount: 4, // Number of items
                                        itemBuilder: (context, index) {
                                          return buildBreakdownCard();
                                        },
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                        // the income breakdown 4:Available , unpaid,pending,paid
                        // its height 15%
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: GridView.count(
                            // physics: NeverScrollableScrollPhysics(),
                            // shrinkWrap: true, // Prevents unbounded height issue
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2.2,
                            children: [
                              buildPaymentStatusCard(),
                              buildPaymentStatusCard(),
                              buildPaymentStatusCard(),
                              buildPaymentStatusCard(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // the list of invoice and unpaid
                        // its height 180 or 35%
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: UniColor.white,
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: 250,
                                child: invoice(),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: UniColor.white,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  child: listUnpaid(),
                                ))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}

// in this screen i have used the following widgets
// 1. buildHeader (in this file)
// 2. customFloatingButton (from component.dart)
// 3. buildBuildingPaymentSummary[line 18] (from dashboardwidget.dart)
// 4. buildBreakdownCard [line 48](from dashboardwidget.dart)
// 5. buildPaymentStatusCard [line 97](from dashboardwidget.dart)
// 6. invoice[line 152] (from dashboardwidget.dart)
// 7. listUnpaid[line 217] (from dashboardwidget.dart)


// the header of the dashboard
Widget _buildHeader(String Username, String PhoneNumber, String formattedDate,
    String dayOfWeek) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile Information
        Row(
          children: [
            CircleAvatar(radius: 15, backgroundColor: UniColor.neutral),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Username,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(PhoneNumber,
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),

        // Date Information
        Column(
          children: [
            Text(formattedDate,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(dayOfWeek,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),

        // Search Bar
        Column(
          children: [
            Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius:
                    BorderRadius.circular(8), // Adjust for rounded corners
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search rooms",
                  border: InputBorder.none, // Remove default border
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  prefixIcon: Icon(Icons.search), // Add search icon
                ),
                onChanged: (value) {
                  // Handle search input change
                },
                onSubmitted: (value) {
                  // Handle search submission
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
