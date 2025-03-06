// import 'package:emonitor/presentation/theme/theme.dart';
// import 'package:emonitor/presentation/widgets/button/button.dart';
// import 'package:emonitor/presentation/widgets/component.dart';
// import 'package:flutter/material.dart';

// class RoomlistScreen extends StatelessWidget {
//   const RoomlistScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // dummy data sample
//     final List<Map<String, String>> rentalData = [
//       {
//         'room': 'A001',
//         'type': 'Studio',
//         'tenant': 'Cheng ChayLim',
//         'phone': '(855) 555-0118',
//         'receipt': 'INV3124134',
//         'status': 'Paid'
//       },
//       {
//         'room': 'A001',
//         'type': 'Studio',
//         'tenant': 'Cheng ChayLim',
//         'phone': '(855) 555-0118',
//         'receipt': 'INV3124134',
//         'status': 'Paid'
//       },
//       {
//         'room': 'A001',
//         'type': 'Studio',
//         'tenant': 'Cheng ChayLim',
//         'phone': '(855) 555-0118',
//         'receipt': 'INV3124134',
//         'status': 'Pending'
//       },
//       {
//         'room': 'A001',
//         'type': 'Studio',
//         'tenant': 'Cheng ChayLim',
//         'phone': '(855) 555-0118',
//         'receipt': 'INV3124134',
//         'status': 'Unpaid'
//       },
//       {
//         'room': 'A001',
//         'type': 'Studio',
//         'tenant': 'Cheng ChayLim',
//         'phone': '(855) 555-0118',
//         'receipt': 'INV3124134',
//         'status': 'Paid'
//       },
//       {
//         'room': 'A001',
//         'type': 'Studio',
//         'tenant': 'Cheng ChayLim',
//         'phone': '(855) 555-0118',
//         'receipt': 'INV3124134',
//         'status': 'Unpaid'
//       },
//     ];
//     Color getStatusColor(String status) {
//       switch (status) {
//         case 'Paid':
//           return Colors.green.shade200;
//         case 'Pending':
//           return Colors.orange.shade200;
//         case 'Unpaid':
//           return Colors.red.shade200;
//         default:
//           return Colors.grey.shade200;
//       }
//     }

//     return Scaffold(
//       backgroundColor: UniColor.white,
//       floatingActionButton: customFloatingButton(
//         onPressed: () {}, // place your function here
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//             border: Border(
//                 left: BorderSide(width: 1, color: UniColor.neutralLight),
//                 right: BorderSide(width: 1, color: UniColor.neutralLight))),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: Column(
//           children: [
//             // Top section
//             Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.arrow_back_ios),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         }, // Call the function instead of Navigator.pop()
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Building A",
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "View all of your room here",
//                             style: TextStyle(color: Colors.grey, fontSize: 12),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   // my own custom button widget i did not use your primary button 
//                   customButton(
//                     onPressed: () {},
//                     text: "Add room",
//                   )
//                 ],
//               ),
//             ),
//             // the tab bar section 
//             Expanded(
//               child: DefaultTabController(
//                 length: 5,
//                 child: Column(
//                   children: [
//                     // list of tab bars
//                     TabBar(
//                       tabs: [
//                         Tab(text: 'All'),
//                         Tab(text: 'Available'),
//                         Tab(text: 'Unpaid'),
//                         Tab(text: 'Pending'),
//                         Tab(text: 'Paid'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Expanded(
//                       child: TabBarView(children: [
//                         buildFilterInfo(rentalData, getStatusColor),// i passed the dummy data sample and function get color
//                         buildTabview('Avaiable'), // it return just a text this widget only return text !
//                         buildTabview('Unpaid'),
//                         buildTabview('Pending '),
//                         buildTabview('Paid')
//                       ]),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// // in this screen i have created 4 custom widget
// //1- buildFilterInfo(line 174) : this widget is the main widget which contain the table of tenant for 'all' tab
// //2- buildTableData (line 233): this widget is the row of the table of tenant for 'all' tab 
// //3- buildStatusButton (line 276): this widget is the custom button for get color button based on its status
// //4- buildTabview (line 262): this widget is the testing tab view for each tab bar


// // the whole widget which contain the table of tenant for 'all' tab 
// Widget buildFilterInfo(List<Map<String, String>> rentalData,
//     Color Function(String) getStatusColor) {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border(
//             top: BorderSide(color: UniColor.neutralLight, width: 1),
//             bottom: BorderSide(color: UniColor.neutralLight, width: 1),
//             left: BorderSide(color: UniColor.neutralLight, width: 1),
//             right: BorderSide(color: UniColor.neutralLight, width: 1))),
//     child: Column(
//       children: [
//         // top section
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 30),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Room Lists",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Container(
//                 width: 200,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: UniColor.neutralLight, width: 1),
//                   color: Colors.white, // Background color
//                   borderRadius:
//                       BorderRadius.circular(8), // Adjust for rounded corners
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search rooms",
//                     border: InputBorder.none, // Remove default border
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                     prefixIcon: Icon(Icons.search), // Add search icon
//                   ),
//                   onChanged: (value) {
//                     // Handle search input change
//                   },
//                   onSubmitted: (value) {
//                     // Handle search submission
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // table data content
//         buildTableData(rentalData, getStatusColor)
//       ],
//     ),
//   );
// }

// // widget for table data as row (1 roe of datatable)
// Widget buildTableData(List<Map<String, String>> rentalData,
//     Color Function(String) getStatusColor) {
//   return SingleChildScrollView(
//     child: DataTable(
//       columnSpacing: 30, // Adjust spacing if needed
//       columns: const [
//         DataColumn(label: Text('Room')),
//         DataColumn(label: Text('Type')),
//         DataColumn(label: Text('Tenant')),
//         DataColumn(label: Text('Phone Number')),
//         DataColumn(label: Text('Receipt ID')),
//         DataColumn(label: Text('Status')),
//       ],
//       rows: rentalData.map((data) {
//         return DataRow(cells: [
//           DataCell(Text(data['room']!)),
//           DataCell(Text(data['type']!)),
//           DataCell(Text(data['tenant']!)),
//           DataCell(Text(data['phone']!)),
//           DataCell(Text(data['receipt']!)),
//           DataCell(buildStatusButton(data, getStatusColor))
//         ]);
//       }).toList(),
//     ),
//   );
// }

// //no need tp care about this , i just implement the sample widget for testing
// // sameple widget data (for testing)
// Widget buildTabview(String text) {
//   return Container(
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border(
//               top: BorderSide(color: UniColor.neutralLight, width: 1),
//               bottom: BorderSide(color: UniColor.neutralLight, width: 1),
//               left: BorderSide(color: UniColor.neutralLight, width: 1),
//               right: BorderSide(color: UniColor.neutralLight, width: 1))),
//       child: Center(child: Text(text)));
// }

// // the custom widget custom button for get color button based on its status
// Widget buildStatusButton(data, Color Function(String) getStatusColor) {
//   Color colorStatus = getStatusColor(data['status']!);
//   return Container(
//     width: 60,
//     height: 20,
//     decoration: BoxDecoration(
//       color: colorStatus.withOpacity(0.2), // Make the background lighter
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Center(
//       child: Text(
//         data['status']!,
//         style: TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//           color: getStatusColor(data['status']!),
//         ),
//       ),
//     ),
//   );
// }
