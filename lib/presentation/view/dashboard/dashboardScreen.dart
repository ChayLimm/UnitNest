import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime todayDate = DateTime.now();
    String formattedDate = DateFormat('MMMM dd, yyyy').format(todayDate);
    String dayOfWeek = DateFormat('EEEE').format(todayDate);

    print(System.num);

    return Scaffold(
      backgroundColor: UniColor.backGroundColor,
      floatingActionButton:customFloatingButton(
        onPressed: (){},// place your function here
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          children: [
            // top section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Information
                  Row(
                    children: [
                      CircleAvatar(radius: 15, backgroundColor: UniColor.neutralLight),
                      const SizedBox(width: 5),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cheng Chaylim", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("096 728 8086", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),

                  // Date Information
                  Column(
                    children: [
                      Text(formattedDate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(dayOfWeek, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                          borderRadius: BorderRadius.circular(8), // Adjust for rounded corners
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search rooms",
                            border: InputBorder.none, // Remove default border
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
            ),
            // just testing text
            const Center(
              child: Text("Thih is the dashboard screen"),
            ),
          ],
        ),
      ),
    );
  }
}


