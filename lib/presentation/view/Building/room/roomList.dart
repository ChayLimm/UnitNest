import 'dart:async';

import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/dialog/show_confirmation_dialog.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RoomlistScreen extends StatelessWidget {
  const RoomlistScreen({
    super.key,
  });

  Future<bool> showForm(BuildContext context) async {
    // Initial attribute for form
    String name = "";
    double price = 0;
    double electricityMeter = 0;
    double waterMeter = 0;

    final roomProvider = context.read<RoomProvider>();
    final isFromTrue = await uniForm(
      context: context,
      title: "Add room",
      subtitle: "Edit your room here",
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Room name"),
          buildTextFormField(
            onChanged: (value) {
              name = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Room name is required";
              }
              return null;
            },
          ),
          label("Room price"),
          buildTextFormField(
            onChanged: (value) {
              price = double.parse(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Room price is required";
              }
              return null;
            },
          ),
          label("Electricity Meter"),
          buildTextFormField(
            onChanged: (value) {
              electricityMeter = double.parse(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "electricityMeter is required";
              }
              return null;
            },
          ),
          label("Water Meter"),
          buildTextFormField(
            onChanged: (value) {
              waterMeter = double.parse(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Water meter is required";
              }
              return null;
            },
          ),
        ],
      ),
      onDone: () async {
        Consumption newConsumption = Consumption(waterMeter: waterMeter, electricityMeter: electricityMeter);
        Room newRoom = Room(name: name, price: price);
        newRoom.consumptionList.add(newConsumption);
        await roomProvider.addOrUpdateRoom(newRoom);
      },
    );
    return isFromTrue;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(builder: (context, roomProvider, child) {
      final Building building = roomProvider.currentSelectedBuilding!;
      return Scaffold(
        backgroundColor: UniColor.backGroundColor,
       
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              // Top section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
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
                  // My own custom button widget
                  UniButton(
                    context: context,
                    label: "Add Room",
                    trigger: () async {
                      final isFormTrue = await showForm(context);
                      if (isFormTrue) {
                        showCustomSnackBar(context,
                            message: "Add Room successfully!!",
                            backgroundColor: UniColor.green);
                      } else {
                        showCustomSnackBar(context,
                            message: "Add Room failed!!",
                            backgroundColor: UniColor.red);
                      }
                    },
                    buttonType: ButtonType.primary,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Display the room list directly
              Expanded(
                child:roomProvider.isLoading? loading(Colors.transparent): FilterInfoWidget(rentalData: roomProvider.currentSelectedBuilding!.roomList),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// The whole widget which contains the table of tenants for the 'all' tab
class FilterInfoWidget extends StatefulWidget {
  final List<Room> rentalData;

  const FilterInfoWidget({super.key, required this.rentalData});

  @override
  State<FilterInfoWidget> createState() => _FilterInfoWidgetState();
}

class _FilterInfoWidgetState extends State<FilterInfoWidget> {
  PaymentStatus selectedStatus = PaymentStatus.unpaid; // Selected status in dropdown
  List<Room> sortedList = []; // Sorted list of rooms

  @override
  void initState() {
    super.initState();
    // Initialize sortedList with the initial rentalData
    sortedList = widget.rentalData;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(builder: (context, roomProvider, child) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: UniColor.neutralLight, width: 1),
        ),
        child: Column(
          children: [
            // Top section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Text(
                      "Room Lists",
                      style: UniTextStyles.label,
                    ),
                  
              Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: UniColor.primary,
                              
                            ),
                            borderRadius: BorderRadius.circular(10)

                          ),
                          child: DropdownButton<PaymentStatus>(
                            focusColor: UniColor.primary,
                            value: selectedStatus, // Currently selected value
                            hint:  Text("Select Payment Status",style: UniTextStyles.body,), // Placeholder text
                            onChanged: (PaymentStatus? newValue) {
                              if (newValue != null) {
                               setState(() {
                                  selectedStatus = newValue; // Update selected status
                                  // Sort the list based on the selected status
                                  sortedList = roomProvider.sortRoomsByLastPaymentStatus(
                                      widget.rentalData, selectedStatus);
                                });
                              }
                            },
                            items: PaymentStatus.values.map((PaymentStatus status) {
                              return DropdownMenuItem<PaymentStatus>(
                                value: status,
                                child: Text(status.status,style: UniTextStyles.body,), // Display the status text
                              );
                            }).toList(),
                              
                              isDense: true,
                              icon: null,
                              underline: const SizedBox(),
                              dropdownColor: Colors.white, 
                              style: UniTextStyles.body.copyWith(color: UniColor.primary), 
                          
                          ),
                        ),
                          IconButton(
                          onPressed: () async {
                            await roomProvider.refreshRoomsPayment();
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  
                ],
              ),
            ),
            // Table data content
            buildTableData(context, sortedList), // Pass the sorted list to the table
          ],
        ),
      );
    });
  }
}
// Widget for table data as row (1 row of DataTable)
Widget buildTableData(BuildContext context, List<Room> rentalData) {
  
  final roomProvider = context.read<RoomProvider>();

  return SingleChildScrollView(
    child: SizedBox(
      width: double.infinity,
      child: DataTable(
        showCheckboxColumn: false,
        columnSpacing: 75,
        columns: const [
          DataColumn(label: Text('Room')),
          DataColumn(label: Text('Tenant')),
          DataColumn(label: Text('Phone Number')),
          DataColumn(label: Text('Status')),
        ],
        rows: rentalData.map((room) {
          // Render data
          Color? statusColor;
          PaymentStatus? paymentStatus = PaymentService.instance.getRoomPaymentStatus(room, DateTime.now());
          Payment? payment = RoomService.instance.getPaymentFor(room, DateTime.now());

          switch (paymentStatus) {
            case PaymentStatus.unpaid:
              statusColor = UniColor.red;
              break;
            case PaymentStatus.pending:
              statusColor = UniColor.yellow;
              break;
            case PaymentStatus.paid:
              statusColor = UniColor.green;
              break;
            default:
              statusColor = null;
              break;
          }

          return DataRow(
            onSelectChanged: (value) {
              roomProvider.setCurrentSelectedRoom(room);
            },
            onLongPress: () async {
              final isRemove = await showConfirmationDialog(context: context, title: "Confirmation", content: "Are you sure you want to delete room : ${room.name}?");
              if(isRemove){
                roomProvider.removeRoom(room);
                showCustomSnackBar(context, message: "Remove ${room.name} successfully", backgroundColor: UniColor.green);
              }
            },
            cells: [
              DataCell(
                Text(room.name),
                onTap: () {
                  print(room.name);
                },
              ),
              DataCell(Text(room.tenant?.userName ?? "- - - -")),
              DataCell(Text(room.tenant?.contact ?? "- - - -")),
              DataCell(buildStatusButton(paymentStatus, statusColor)),
            ],
          );
        }).toList(),
      ),
    ),
  );
}

// The custom widget for the status button
Widget buildStatusButton(PaymentStatus? paymentStatus, Color? colorStatus) {
  return Container(
    width: 60,
    height: 20,
    decoration: BoxDecoration(
      color:colorStatus !=null? colorStatus.withOpacity(0.2): UniColor.backGroundColor2, // Make the background lighter
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(paymentStatus?.name?? "Available",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: colorStatus?? UniColor.neutralDark,
        ),
      ),
    ),
  );
}