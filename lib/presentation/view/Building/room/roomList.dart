import 'dart:async';

import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomlistScreen extends StatelessWidget {
  const RoomlistScreen({
    super.key,
  });

  Future<bool> showForm(BuildContext context) async{

    // initial attribute for form
    String name = "";
    double price = 0;

    final roomProvider = context.read<RoomProvider>();

    final isFromTrue = await uniForm(
      context: context, 
      title: "Add room", 
      subtitle: "Edi your room here", 
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          label("Room name"),
          buildTextFormField(
            onChanged: (value){
              name = value;
            }, 
            validator: (value){
              if(value == null || value.isEmpty){
                return "Room name is requried";
              }return null;
            }
            ),
          label("Room price"),
          buildTextFormField(
            onChanged: (value){
              price = double.parse(value);
            }, 
            validator: (value){
              if(value == null || value.isEmpty){
                return "Room price is requried";
              }return null;
            }
            ),
        ],
      ), 
      onDone: () async {
        Room newRoom = Room(name: name, price: price);
        await roomProvider.addOrUpdateRoom(newRoom);
      }
      );
    return isFromTrue;
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<RoomProvider>(builder: (context,roomProvider,child){

      final Building building = roomProvider.currentSelectedBuilding!; 

      return Scaffold(
      backgroundColor: UniColor.white,
      floatingActionButton: customFloatingButton(
        onPressed: () {

        }, // place your function here
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(width: 1, color: UniColor.neutralLight),
                right: BorderSide(width: 1, color: UniColor.neutralLight))),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            // Top section
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }, // Call the function instead of Navigator.pop()
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            building.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "View all of your room here",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          )
                        ],
                      ),
                    ],
                  ),
                  // my own custom button widget i did not use your primary button 
                  UniButton(
                    context: context, 
                    label: "Add Room", 
                    trigger: ()async{
                      final isFormTrue = await showForm(context);
                      if(isFormTrue){
                        showCustomSnackBar(context, message: "Add Room successfully!!", backgroundColor: UniColor.green);
                      }else{
                        showCustomSnackBar(context, message: "Add Room failed!!", backgroundColor: UniColor.red);

                      }
                    }, 
                    buttonType: ButtonType.primary
                    )

                ],
              ),
            ),
            // the tab bar section 
            Expanded(
              child: DefaultTabController(
                length: 5,
                child: Column(
                  children: [
                    // list of tab bars
                   const TabBar(
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Available'),
                        Tab(text: 'Unpaid'),
                        Tab(text: 'Pending'),
                        Tab(text: 'Paid'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        buildFilterInfo(context,roomProvider.currentSelectedBuilding!.roomList),// i passed the dummy data sample and function get color
                        buildTabview('Avaiable'), // it return just a text this widget only return text !
                        buildTabview('Unpaid'),
                        buildTabview('Pending '),
                        buildTabview('Paid')
                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
 
    }); 
    
     }
}
// in this screen i have created 4 custom widget
//1- buildFilterInfo(line 174) : this widget is the main widget which contain the table of tenant for 'all' tab
//2- buildTableData (line 233): this widget is the row of the table of tenant for 'all' tab 
//3- buildStatusButton (line 276): this widget is the custom button for get color button based on its status
//4- buildTabview (line 262): this widget is the testing tab view for each tab bar


// the whole widget which contain the table of tenant for 'all' tab 
Widget buildFilterInfo(BuildContext context,List<Room> rentalData) {
  return Container(
    padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border(
            top: BorderSide(color: UniColor.neutralLight, width: 1),
            bottom: BorderSide(color: UniColor.neutralLight, width: 1),
            left: BorderSide(color: UniColor.neutralLight, width: 1),
            right: BorderSide(color: UniColor.neutralLight, width: 1))),
    child: Column(
      children: [
        // top section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Room Lists",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: UniColor.neutralLight, width: 1),
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
        ),
        // table data content
        buildTableData(context,rentalData)
      ],
    ),
  );
}

// widget for table data as row (1 roe of datatable)
Widget buildTableData(BuildContext context, List<Room> rentalData) {
  return SingleChildScrollView(
    child: DataTable(
      showCheckboxColumn: false,
      columnSpacing: 75, // Adjust spacing if needed
      columns: const [
        DataColumn(label: Text('Room')),
        DataColumn(label: Text('Tenant')),
        DataColumn(label: Text('Phone Number')),
        DataColumn(label: Text('Receipt ID')),
        DataColumn(label: Text('Status')),
      ],
      rows: rentalData.map((room) {

        //render data
        Color statusColor;
        PaymentStatus paymentStatus = PaymentService.instance.getRoomPaymentStatus(room, DateTime.now());
        Payment? payment  = PaymentService.instance.getPaymentFor(room, DateTime.now());

        switch(paymentStatus){
          case PaymentStatus.unpaid:
            statusColor = UniColor.red;
            break;
          case PaymentStatus.pending:
            statusColor = UniColor.yellow;
            break;
          case PaymentStatus.paid:
            statusColor = UniColor.green;
        }
        

        return 
        DataRow(
          onSelectChanged: (value) {
            final roomProvider = context.read<RoomProvider>();
            roomProvider.setCurrentSelectedRoom(room);
          },
          cells: [
          DataCell(Text(room.name),onTap: () {
            print(room.name);
          },),
          DataCell(Text(room.tenant?.userName?? "No Tenant")),
          DataCell(Text(room.tenant?.contact ?? "No Tenant")),
          DataCell(Text(payment == null ? "Null" : payment.transaction.md5)),
          DataCell(buildStatusButton(paymentStatus, statusColor))
        ]
       );
      }
     ).toList(),
    ),
  );
}

//no need tp care about this , i just implement the sample widget for testing
// sameple widget data (for testing)
Widget buildTabview(String text) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(
              top: BorderSide(color: UniColor.neutralLight, width: 1),
              bottom: BorderSide(color: UniColor.neutralLight, width: 1),
              left: BorderSide(color: UniColor.neutralLight, width: 1),
              right: BorderSide(color: UniColor.neutralLight, width: 1))),
      child: Center(child: Text(text)));
}

// the custom widget custom button for get color button based on its status
Widget buildStatusButton(PaymentStatus paymentSatus, Color colorStatus) {
  return Container(
    width: 60,
    height: 20,
    decoration: BoxDecoration(
      color: colorStatus.withOpacity(0.2), // Make the background lighter
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        paymentSatus.name,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: colorStatus,
        ),
      ),
    ),
  );
}


