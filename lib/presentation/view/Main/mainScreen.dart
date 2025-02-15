import 'package:emonitor/domain/usecases/system.dart';
import 'package:emonitor/presentation/view/dashboard/dashboardScreen.dart';
import 'package:emonitor/presentation/view/dashboard/requestScreen.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import '../Building/buildingScreen.dart';
import '../Building/roomDetails.dart';
import '../Building/roomList.dart';
import '../MonthlyReport/monthlyReportScreen.dart';
import '../Notification/notificationDetails.dart';
import '../Notification/notificationListScreen.dart';


class MainScreen extends StatefulWidget {
  final System system;
  MainScreen({required this.system});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isRoomDetails = false;
  bool isNotificationClicked = false;
  int selectedIndex = 0;

  final Map<String, IconData> menuItems = {
    "Dashboard": Icons.dashboard,
    "Building": Icons.home,
    "Notification": Icons.notifications,
    "Monthly report": Icons.data_exploration,
  };

  // Toggle functions
  void toggleRoomDetails() {
    setState(() {
      isRoomDetails = !isRoomDetails;
      isNotificationClicked = false; // Reset notifications
    });
  }

  // void toggleNotification() {
  //   setState(() {
  //     isNotificationClicked = !isNotificationClicked;
  //     isRoomDetails = false; // Reset room details
  //   });
  // }

  void onMenuItemClick(int index) {
    setState(() {
      selectedIndex = index;
      isRoomDetails = false;
      isNotificationClicked = (index == 2); // Activate notifications when clicking Notification
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Drawer (15%)
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            width: MediaQuery.of(context).size.width * 0.15,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                // Menu Items
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final menuItem = menuItems.entries.elementAt(index);
                      final isSelected = index == selectedIndex;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 45,
                          child: ListTile(
                            onTap: () => onMenuItemClick(index),
                            leading: Icon(
                              menuItem.value,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            title: Text(
                              menuItem.key,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Settings at the Bottom
                const Spacer(),
                const ListTile(
                  leading: Icon(Icons.settings, color: Colors.black),
                  title: Text(
                    "Setting",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Container(
            width: MediaQuery.of(context).size.width *
                (isNotificationClicked ? 0.4 : (isRoomDetails ? 0.6 : 0.65)),
            child: isNotificationClicked
                ? NotificationListScreen() // Show Notification
                : (isRoomDetails
                ? RoomlistScreen(onBack: toggleRoomDetails)
                : _buildContentScreen()),// screen display based on the index of screen from switch case
          ),

          // Right Side Panel
          Container(
            width: MediaQuery.of(context).size.width *
                (isNotificationClicked ? 0.45 : (isRoomDetails ? 0.25 : 0.20)),
            color: Colors.white,
            child: isNotificationClicked
                ? NotificationDetailScreen() // Right panel when Notification is active
                : (isRoomDetails
                ? RoomDetailScreen()
                : RequestScreen()),
          ),
        ],
      ),
    );
  }

  // Function to select the corrent screen dynamically based on its index
  Widget _buildContentScreen() {
    switch (selectedIndex) {
      case 0: return  DashboardScreen();
      case 1: return BuildingScreen(onNavigate: toggleRoomDetails);
      case 2: return NotificationListScreen();
      case 3: return  MonthlyReportScreen();
      default: return  DashboardScreen();
    }
  }
}
