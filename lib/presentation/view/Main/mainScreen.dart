// Main screen of the application
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/telegram_service.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/Building/buildingNavigator.dart';
import 'package:emonitor/presentation/view/MonthlyReport/monthlyReportScreen.dart';
import 'package:emonitor/presentation/view/Notification/notification_main.dart';
import 'package:emonitor/presentation/view/dashboard/dashboardScreen.dart';
import 'package:emonitor/presentation/view/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState(); 
}

class _MainscreenState extends State<Mainscreen> {
  int currentPage =0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final roomProvider = context.read<RoomProvider>();
    final PriceCharge? priceCharge = PaymentService.instance.getPriceChargeFor(DateTime.now());

    if(roomProvider.repository.rootData!.currentMonth != DateTime.now().month){
      for(var building in roomProvider.repository.rootData!.listBuilding){
        for(Room room in building.roomList){
          if(room.tenant != null){
            TelegramService.instance.sendReminder(int.parse(room.tenant!.chatID), 
            "Hello ${room.tenant!.userName}, your rent payment is due on ${priceCharge!.fineStartOn}/${DateTime.now().month}/${DateTime.now().year}. Please make the payment on time to avoid late fees.");
          }
        }
      }
     roomProvider.repository.rootData!.currentMonth = DateTime.now().month;
    }
  }

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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    const SizedBox(height: 10,),
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
                      setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Setting()));
                      });
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
                  children: const [
                     DashboardScreen(),         // dashboard (dashboard screen + request screen)
                     BuidlingNavigator(), // building& room (building: buidling screen + request screen)+(room: room screen +  room details screen)
                     NotificationMain(),      // notification (notification screen+notification details screen)
                     MonthlyReportScreen()             // monthly report (monthly report screen+ request screen)
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