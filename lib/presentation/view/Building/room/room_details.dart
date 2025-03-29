import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/Building/room/room_history.dart';
import 'package:emonitor/presentation/view/receipt/receipt_view.dart';
import 'package:emonitor/presentation/view/utils/date_formator.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatelessWidget {
  RoomDetailScreen({super.key});

  Future<bool> onEditRoom(BuildContext context, Room? room) async {
    // access to provider
    final roomProvider = context.read<RoomProvider>();
    // some variable
    String room_number = room?.name ?? '';
    String floor = '01';
    double monthly = room?.price ?? 0;
    double deposit = room?.tenant?.deposit ?? 0;
    PaymentStatus paymentStatus = PaymentStatus.unpaid;
    // tenant part
    String chatID = room?.tenant?.chatID ?? '';
    String tenantID = room?.tenant?.identifyID ?? '';
    String tenant_name = room?.tenant?.userName ?? '';
    String tenant_phoneNumber = room?.tenant?.contact ?? '';
    int rentParking = room?.tenant?.rentParking ?? 0;

    String chatid = room?.tenant?.chatID?? " ";

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
                },
                validator: (value) {
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
                },
                validator: (value) {
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
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Parking space is required";
                  }
                  return null;
                }),
            label("Deposit"),
            buildTextFormField(
              initialValue: deposit.toString(),
              onChanged: (value) {
              deposit = double.parse(value);
            }, validator: (value) {
              if (value == null || value.isEmpty) {
                return "Parking space is required";
              }
              return null;
            }),
            label("Vehicle"),
            buildTextFormField(
              initialValue: rentParking.toString(),
              onChanged: (value) {
              rentParking = int.parse(value);
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
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tenant ID is required";
                  }
                  return null;
                }),
             label("Tenant Chat ID"),
            buildTextFormField(
                initialValue: chatid,
                onChanged: (value) {
                  chatid = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tenant ID is required";
                  }
                  return null;
                }),
            label("Tenant Name"),
            buildTextFormField(
                initialValue: tenant_name,
                onChanged: (value) {
                  tenant_name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tenant name is required";
                  }
                  return null;
                }),
            label("Tenant Phone Number"),
            buildTextFormField(
                initialValue: tenant_phoneNumber,
                onChanged: (value) {
                  tenant_phoneNumber = value;
                },
                validator: (value) {
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
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return " Rent parking is required";
                  }
                  return null;
                }),
          ],
        ),
        onDone: () async {
          final newRoom = Room(
              id: room?.id,
              name: room_number,
              price: monthly,
              roomStatus: room!.roomStatus,
              tenant: Tenant(
                chatID: chatid,
                identifyID: tenantID,
                userName: tenant_name,
                contact: tenant_phoneNumber,
                deposit: deposit,
                rentParking: rentParking,
              ));
          newRoom.consumptionList = room.consumptionList;
          newRoom.paymentList = room.paymentList;
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
      Payment? thisMonthPayment;

      if(room !=null && room.tenant != null ){
        thisMonthPayment= RoomService.instance.getPaymentFor(room, DateTime.now());
      }

      return Scaffold(
        backgroundColor: UniColor.backGroundColor2,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top section
             if(room != null)...[
              ListTile(
                contentPadding:  EdgeInsets.zero,
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: UniColor.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.bed,
                    color: UniColor.white,
                  ),
                ),
                title: const Text(
                  "Room Details",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "View room details",
                  style: TextStyle(
                    color: UniColor.neutral,
                    fontSize: 12,
                  ),
                ),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(onPressed: () async{ 
                        await showDialog(context: context, builder: (context){
                          return showRoomHistory(context);
                        });
                      }, icon: Icon(Icons.history,color: UniColor.iconNormal,)),
                      IconButton(
                    onPressed: () async {
                      final isFormTrue = await onEditRoom(context, roomProvider.currentSelectedRoom);
                      if (isFormTrue == true) {
                        showCustomSnackBar(context,
                            message:
                                "Room ${roomProvider.currentSelectedRoom!.name} is Edited successfully!",
                            backgroundColor: UniColor.green);
                      } else if (isFormTrue == false) {
                        showCustomSnackBar(context,
                            message:
                                "Room ${roomProvider.currentSelectedRoom!.name} is failed to edit!",
                            backgroundColor: UniColor.red);
                      }
                    },
                    icon:  Icon(
                      Icons.mode_edit_outlined,color: UniColor.iconNormal,
                      size: 24,
                    ),
                  ),
                    ],
                  ),
                )
                
              )],
              const SizedBox(
                height: 15,
              ),

              // ignore: unnecessary_null_comparison
            room == null ? SizedBox(
            height: 700,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ 
                   ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/emptyRoom.png',
                      scale: 0.9,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 32,),
                  Text("Start by selecting room",style: UniTextStyles.label,),
                  const SizedBox(height: 10,),
                  Text("Click on a room for more details",style: UniTextStyles.body,)
                  ],
              ),
            ),
          )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // spacing around divider te nah
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:
                                  Divider(height: 1, color: UniColor.neutralLight),
                            ),
                            _buildDetailinfoRow('Room Number',
                                roomProvider.currentSelectedRoom!.name),
                            _buildDetailinfoRow(
                                'Floor',
                                roomProvider.currentSelectedBuilding!.floorCount
                                    .toString()),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:
                                  Divider(height: 1, color: UniColor.neutralLight),
                            ),
                          const SizedBox(height: 10,),
                            Text('Rental Information',
                                style: UniTextStyles.label),
                            _buildDetailinfoRow(
                                'Room Status',
                                roomProvider
                                    .currentSelectedRoom!.roomStatus.status
                                    .toString()),
                            _buildDetailinfoRow(
                                'Monthly',
                                roomProvider.currentSelectedRoom!.price
                                    .toString()),
                            _buildDetailinfoRow(
                                'Deposit',
                                roomProvider
                                        .currentSelectedRoom!.tenant?.deposit
                                        .toString() ??
                                    '0'),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:
                                  Divider(height: 1, color: UniColor.neutralLight),
                            ),
                             if(room.tenant != null)...[
                            Text('Tenant Information',style: UniTextStyles.label),
                            _buildDetailinfoRow('Vehicle', roomProvider.currentSelectedRoom!.tenant!.rentParking.toString()),
                            _buildDetailinfoRow('Identity ID',roomProvider.currentSelectedRoom!.tenant?.identifyID ??'NA'),
                            _buildDetailinfoRow('Name',roomProvider.currentSelectedRoom!.tenant?.userName ??'NA'),
                            _buildDetailinfoRow('Phone number',roomProvider.currentSelectedRoom!.tenant?.contact ??'NA'),
                            _buildDetailinfoRow('Move In Date',roomProvider.currentSelectedRoom!.tenant != null ? DateTimeUtils.formatDateTime(roomProvider.currentSelectedRoom!.tenant!.registeredOn) : 'NA'), // plij lbeab dak date time na]
                             ],
                             if(room.tenant == null)...[
                             const SizedBox(height: 20,),
                             SizedBox(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[ 
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/noTenant.png',
                                        scale: 0.9,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 32,),
                                    Text("Room is current available",style: UniTextStyles.label,),
                                    const SizedBox(height: 10,),
                                    Text("Register via telegram bot to assign tenant",style: UniTextStyles.body,)
                                    ],
                                ),
                              ),
                            )
                             ],
                            const SizedBox(
                              height: 40,
                            ), // just a white space
                            if(thisMonthPayment != null)...[
                              UniButton(
                                context: context, 
                              label: "View Receipt",
                              trigger: ()async{
                                showReceiptDialog(context, thisMonthPayment!.receipt!);
                              }, 
                              buttonType: ButtonType.secondary
                              )
                            ]
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
