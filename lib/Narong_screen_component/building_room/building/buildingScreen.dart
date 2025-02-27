import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form.dart';
import 'package:flutter/material.dart';

class BuildingScreen extends StatelessWidget {
  const BuildingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // dummy data for testing only
    List<Map<String, dynamic>> buildings = [
      {
        'image':'assets/images/Bulidng.jpg', // Becarefil with '/' and '\' in the path
        'buildingTitle': 'Building A',
        'location': 'Phnom Penh, Cambodia',
        'availableRoom': 2,
        'totalRoom': 15,
        'name': 'A',
        'address': 'Toul kork',
        'floorCount': '2',
        'parkingSpace': '15'
      },
      {
        'image': 'assets/images/noImage.jpeg',
        'buildingTitle': 'Building B',
        'location': 'Siem Reap, Cambodia',
        'availableRoom': 5,
        'totalRoom': 20,
        'name': 'B',
        'address': 'Siem reap',
        'floorCount': '3',
        'parkingSpace': '30'
      },
    ];
    // function to open a dialof form
    // void _openFormDialog(BuildContext context) async {
    //   bool result = await showFormDialog(
    //     context: context,
    //     title: "User Form",
    //     subtitle: "Please fill in the details",
    //     form: Form(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           TextFormField(
    //             decoration: const InputDecoration(labelText: "Name"),
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return "Please enter your name";
    //               }
    //               return null;
    //             },
    //           ),
    //           TextFormField(
    //             decoration: const InputDecoration(labelText: "Email"),
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return "Please enter your email";
    //               }
    //               return null;
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //     onDone: () async {
    //       // Handle form submission (e.g., send data to backend)
    //       await Future.delayed(
    //           const Duration(seconds: 2)); // Simulating API call
    //       print("Form submitted successfully");
    //     },
    //   );
    //   if (result) {
    //     print("User clicked Done");
    //   } else {
    //     print("User clicked Cancel");
    //   }
    // }
    return Scaffold(
      backgroundColor: UniColor.white,
      floatingActionButton: customFloatingButton(
        onPressed: () {}, // place your function here
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(color: UniColor.neutralLight, width: 1),
                right: BorderSide(color: UniColor.neutralLight, width: 1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top section
            _buildTopSection(ontrigger:(){}),// pass the function to return dialog in here 
            // Bulidng screen with grid of building card list
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 75),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 560, // Maximum width of each grid item
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: buildings.length,
              itemBuilder: (context, index) {
                final building = buildings[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/building/room");
                  },
                  child: _buildBuildingCard(
                      image: building['image'],
                      buildingTitle: building['buildingTitle'],
                      location: building['location'],
                      availableRoom: building['availableRoom'],
                      totalRoom: building['totalRoom'],
                      name: building['name'],
                      address: building['address'],
                      floorCount: building['floorCount'],
                      parkingSpace: building['parkingSpace']),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
// Custom widget part
// in this screen i have used 
// 1- buildTopSection: for building screen header
// 2- buildBuildingCard: for building card
// 3- _buildDetailRow: for building card detail row
// 4- customFloatingButton: for floating button (from component.dart)
// 5- customButton: for custom button (from button.dart)


// i turned all function widget to private just to prevent calling outside of this file
// if you want to use it outside of this file, just remove the underscore(_) before the function name
// header section for building screen
Widget _buildTopSection({required VoidCallback ontrigger}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Building list",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "View all of your buildings here",
            style: TextStyle(color: UniColor.neutralLight, fontSize: 12),
          ),
        ],
      ),
      customButton(
        onPressed: ontrigger,
        text: "Add building",
      ),
    ],
  );
}


// Building info card widget
Widget _buildBuildingCard(
    {required String image,
    required String buildingTitle,
    String location = "Unknown",
    int availableRoom = 0,
    int totalRoom = 0,
    required String name,
    required String address,
    required String floorCount,
    required String parkingSpace,
    }) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: UniColor.neutralLight),
    ),
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: 90,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    buildingTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: UniColor.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(location,
                          style: TextStyle(
                              fontSize: 12, color: UniColor.neutralDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 90,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: UniColor.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            availableRoom.toString() + " " + "available",
                            style: TextStyle(
                                color: UniColor.primary,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 85,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: UniColor.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            totalRoom.toString() + " " + "Rooms",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildDetailRow("Name", name),
        _buildDetailRow("Address", address),
        _buildDetailRow("Floor count", floorCount),
        _buildDetailRow("Parking space", parkingSpace),
      ],
    ),
  );
}


// Building info card detail row
Widget _buildDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$title :",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: UniColor.neutralDark,
                fontSize: 12)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    ),
  );
}
