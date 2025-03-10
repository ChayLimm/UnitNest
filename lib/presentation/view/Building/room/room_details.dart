import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/json/jsonconvertor.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/presentation/Provider/main/building_provider.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatelessWidget {
  RoomDetailScreen({super.key});

  Future<bool> onEditorAssignTenant(BuildContext context, Room? room) async {
    // access to provider 
    final roomProvider = context.read<RoomProvider>();
    // some variable
    String room_number = room?.name??'';
    String floor = '01';
    double monthly = room?.price?? 0;
    double deposit = room?.tenant?.deposit??0;
    int vehicle = 1;
    PaymentStatus paymentStatus=PaymentStatus.unpaid;
    // tenant part 
    String tenantID= room?.tenant?.identifyID??'';
    String tenant_name=room?.tenant?.userName??'';
    String tenant_phoneNumber=room?.tenant?.contact??'';
    int rentParking=room?.tenant?.rentParking??0;
    final isFormTrue = await uniForm(
        context: context,
        title: 'Edit Room Details',
        subtitle: 'Edit room details information',
        form: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label("Room Number"),
            buildTextFormField(
              initialValue: room_number,
              onChanged: (value) {
              room_number = value;
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "room number name is required";
              }
              return null;
            }),
            label("Floor"),
            buildTextFormField(
              initialValue: floor,
              onChanged: (value) {
              floor = value;
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "floor is required";
              }
              return null;
            }),
            label("Payment status"),
             buildDropdownFormField(
            value: paymentStatus,
            items: PaymentStatus.values,
            onChanged: (value) {
              paymentStatus = value!;
            },
          ),
            label("Monthly"),
            buildTextFormField(
              initialValue: monthly.toString(),
              onChanged: (value) {
              monthly = double.parse(value);
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "Parking space is required";
              }
              return null;
            }),
            label("Deposit"),
            buildTextFormField(onChanged: (value) {
              deposit = double.parse(value);
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "Parking space is required";
              }
              return null;
            }),
            label("Vehicle"),
            buildTextFormField(onChanged: (value) {
              vehicle = int.parse(value);
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "Parking space is required";
              }
              return null;
            }),
            label("Tenant ID"),
            buildTextFormField(
              initialValue: tenantID,
              onChanged: (value) {
              tenantID = value;
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "Tenant ID is required";
              }
              return null;
            }),
            label("Tenant Name"),
            buildTextFormField(
              initialValue: tenant_name,
              onChanged: (value) {
              tenant_name= value;
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "Tenant name is required";
              }
              return null;
            }),
            label("Tenant Phone Number"),
            buildTextFormField(
              initialValue: tenant_phoneNumber,
              onChanged: (value) {
              tenant_phoneNumber= value;
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "Tenant phone number is required";
              }
              return null;
            }),
            label("Rent parking"),
            buildTextFormField(
              initialValue: rentParking.toString(),
              onChanged: (value) {
              rentParking = int.parse(value);
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return " Rent parking is required";
              }
              return null;
            }),
          ],
        ),
        onDone: () async {
          final newRoom=Room(
            id: room?.id,
            name: room_number,
            price: monthly,
            tenant: Tenant(
              identifyID: tenantID,
               userName: tenant_name,
                contact: tenant_phoneNumber,
                 deposit: deposit,
                 rentParking: rentParking,
                 )    
          );
           roomProvider.addOrUpdateRoom(newRoom);
          // final newBuidling = Room(
          //     id: room?.id,
          //     name: room_number,
          //     price: monthly.
          //     tenant:
          //     );
          // buildingProvider.updateOrAddBuilding(newBuidling);
        });
        // onDone: () async {
        //   print('Room number:'+ room_number);
        //   print('Floor:'+ floor);
        //   print('payment status: ${paymentStatus.status}');
        //   print('Monthly:'+ monthly.toString());
        //   print('Deposit:'+ deposit.toString());
        // });
    return isFormTrue;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(builder: (context, roomProvider, child) {
      final Room? room = roomProvider.currentSelectedRoom;
      return Scaffold(
        backgroundColor: UniColor.white,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top section
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: UniColor.primary,
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(
                            Icons.bed,
                            color: UniColor.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Room Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            Text(
                              "View room details",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () async{
                          final isFormTrue = await onEditorAssignTenant(
                            context,roomProvider.currentSelectedRoom
                          );
                          if (isFormTrue == true) {
                            showCustomSnackBar(context,
                                message:"Room ${roomProvider.currentSelectedRoom!.name} is Edited successfully!",
                                backgroundColor: UniColor.green);
                          } else if (isFormTrue == false) {
                            showCustomSnackBar(context,
                                message: "Room ${roomProvider.currentSelectedRoom!.name} is failed to edit!",
                                backgroundColor: UniColor.red);
                          }
                        },
                        icon: const Icon(
                          Icons.mode_edit_outlined,
                          color: Colors.black,
                          size: 24,
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              // ignore: unnecessary_null_comparison
              room == null
                  ? Center(
                      child: Text(
                        'No room available, Please add one',
                        style: UniTextStyles.body,
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // spacing around divider te nah
                              const Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Divider(
                                    height: 1, color: Colors.grey),
                              ),
                              _buildDetailinfoRow('Room Number',
                                  roomProvider.currentSelectedRoom!.name),
                              _buildDetailinfoRow(
                                  'Floor',
                                  roomProvider
                                      .currentSelectedBuilding!.floorCount
                                      .toString()),
                              const Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Divider(
                                    height: 1, color: Colors.grey),
                              ),
                              Text('Rental Information',
                                  style: UniTextStyles.label),
                              _buildDetailinfoRow(
                                  'Payment Status',
                                  roomProvider.currentSelectedRoom!.roomStatus.status
                                      .toString()),
                              _buildDetailinfoRow('Monthly', roomProvider.currentSelectedRoom!.price.toString()),
                              _buildDetailinfoRow('Deposit', roomProvider.currentSelectedRoom!.tenant?.deposit.toString()??'0'),
                              _buildDetailinfoRow('Vehicle', '20'),
                              const Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Divider(
                                    height: 1, color: Colors.grey),
                              ),
                              Text('Tenant Information',
                                  style: UniTextStyles.label),
                              _buildDetailinfoRow('Identity ID', roomProvider.currentSelectedRoom!.tenant?.identifyID??'NA'),
                              _buildDetailinfoRow('Name', roomProvider.currentSelectedRoom!.tenant?.userName??'NA'),
                              _buildDetailinfoRow('Phone number', roomProvider.currentSelectedRoom!.tenant?.contact??'NA'),
                              _buildDetailinfoRow('Move In Date','20 oct (fixed)'), // plij lbeab dak date time na
                              const SizedBox(
                                height: 40,
                              ), // just a white space
                            ],
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      );
    });
  }

// the info as row
  Widget _buildDetailinfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title :",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: UniColor.neutralDark,
                  fontSize: 12)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
