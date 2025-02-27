// Main screen of the application
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/MonthlyReport/report.dart';
import 'package:emonitor/presentation/view/Notification/notification.dart';
import 'package:emonitor/presentation/view/building_room/buildingNavigator.dart';
import 'package:emonitor/presentation/view/dashboard/dashbaord.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: UniColor.white,
        child: Row(
          children: [
            // Drawer part
            Expanded(
              flex: 22,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                color: UniColor.white,
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.rectangle_outlined, color: Colors.blue, size: 30),
                          SizedBox(width: 10),
                          Text(
                            "UnitNest",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    // Dashboard
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentPage == 0 ? UniColor.primary : UniColor.white,
                      ),
                      child: buildListTile("Dashboard", Icons.dashboard, () {
                        setState(() {
                          currentPage = 0;
                        });
                      }, currentPage == 0),
                    ),
                    // Building
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentPage == 1 ? UniColor.primary : UniColor.white,
                      ),
                      child: buildListTile("Building", Icons.home, () {
                        setState(() {
                          currentPage = 1;
                        });
                      }, currentPage == 1),
                    ),
                    // Notification
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentPage == 2 ? UniColor.primary : UniColor.white,
                      ),
                      child: buildListTile("Notification", Icons.notifications, () {
                        setState(() {
                          currentPage = 2;
                        });
                      }, currentPage == 2),
                    ),
                    // Monthly Report
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentPage == 3 ? UniColor.primary : UniColor.white,
                      ),
                      child: buildListTile("Monthly Report", Icons.data_exploration, () {
                        setState(() {
                          currentPage = 3;
                        });
                      }, currentPage == 3),
                    ),
                    // Settings at the Bottom
                    const Spacer(),
                    buildListTile("Setting", Icons.settings, () {
                      setState(() {});
                    }, false),
                  ],
                ),
              )
            ),
            // screen content : dashboard,building,notification,monthly report
            Expanded(
              flex: 107,
              child: Container(
                color: UniColor.neutralLight,
                child: IndexedStack(
                  index: currentPage,
                  children: [
                    dashboard(),         // dashboard (dashboard screen + request screen)
                    BuidlingNavigator(), // building& room (building: buidling screen + request screen)+(room: room screen +  room details screen)
                    notification(),      // notification (notification screen+notification details screen)
                    report()             // monthly report (monthly report screen+ request screen)
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
// i used chaylim's code but just not using traiking 
Widget buildListTile(String title, IconData icon, VoidCallback trigger, bool isSelected) {
  return ListTile(
    onTap: trigger,
    hoverColor: UniColor.backGroundColor,
    leading: Icon(icon, size: 18, color: isSelected ? UniColor.white: UniColor.neutralDark),
    title: Text(
      title,
      style: UniTextStyles.body.copyWith(color: isSelected ? UniColor.white : UniColor.neutralDark,),
    ),
  );
}