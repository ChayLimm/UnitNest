import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/presentation/Provider/main/notification_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/dialog/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationDetail extends StatefulWidget {
  final UniNotification notification;
  const RegistrationDetail({super.key,required this.notification});

  @override
  State<RegistrationDetail> createState() => _RegistrationDetailState();
}

class _RegistrationDetailState extends State<RegistrationDetail> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Building? selectedBuilding;
  Room? selectedRoom;
  double tenantDeposit = 0;

  @override
  void initState() {
    super.initState();
    // Initialize selectedBuilding with the first item in the list
    selectedBuilding = context.read<NotificationProvider>().buildingList.first;
  }

  @override
  Widget build(BuildContext context) {
    final notiProvider = context.read<NotificationProvider>();
    final NotifyRegistration data = widget.notification.notifyData;

    return notiProvider.currentNotifyDetails ==null ?
   Center(
    child: Text("Please select a notification to start", style: UniTextStyles.body,),
   ) :
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.notification.read == false) ...{
          label('Building'),
          DropdownButtonFormField2<Building>(
            onChanged: (value) {
              setState(() {
                selectedBuilding = value;
                selectedRoom = null; // Reset selected room when building changes
              });
            },
            value: selectedBuilding,
            items: notiProvider.buildingList
                .map((item) => DropdownMenuItem<Building>(
                      value: item,
                      child: Text(item.name, style: UniTextStyles.body),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return "Please select a building";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          label('Room'),
          DropdownButtonFormField2<Room>(
            onChanged: (value) {
              setState(() {
                selectedRoom = value;
              });
            },
            value: selectedRoom,
            items: RoomService.instance
                .availableRoom(building: selectedBuilding!, dateTime: DateTime.now())
                .map((item) => DropdownMenuItem<Room>(
                      value: item,
                      child: Text(item.name, style: UniTextStyles.body),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return "Please select a room";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          label("Deposit"),
          Form(
            key: _formKey,
            child: buildTextFormField(
              onChanged: (value) {
                tenantDeposit = double.parse(value);
              },
              initialValue: tenantDeposit.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Deposit amount is required";
                }
                if (double.tryParse(value) == null) {
                  return "Please enter a valid number";
                }
                return null;
              },
            ),
          ),
        },
        Text('Tenant Information', style: UniTextStyles.label),
        _buildDetailinfoRow('Identity ID  :', data.idIdentification),
        _buildDetailinfoRow('Name         :', data.name),
        _buildDetailinfoRow('Phone Number :', '${data.phone} '),
        _buildDetailinfoRow('Register on  :', '${data.registerOnDate}'),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1, color: Colors.grey),
        ),
        if (widget.notification.read == false) ...{
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              UniButton(
                  context: context,
                  label: 'Reject',
                  trigger: () async {
                    final isReject = await showConfirmationDialog(
                        context: context,
                        title: "Confirmation",
                        content: "Are you sure you want to reject this request?");
                    if (isReject) {
                      notiProvider.reject(widget.notification);
                      showCustomSnackBar(context,
                          message: "Rejected Request",
                          backgroundColor: UniColor.red);
                    }
                  },
                  buttonType: ButtonType.secondary),
              const SizedBox(width: 10),
              if(selectedBuilding != null && selectedRoom != null)...[
              UniButton(
                  context: context,
                  label: 'Approve',
                  trigger: () async {
                    if (_formKey.currentState!.validate()) {
                      final bool isApprove = await notiProvider.approve(context, widget.notification, selectedRoom, tenantDeposit);
                      if (isApprove) {
                        showCustomSnackBar(context,
                            message:"Assign tenant to ${selectedRoom!.name} successfully!",
                            backgroundColor: UniColor.green);
                      }
                    }
                  },
                  buttonType: ButtonType.primary
                  )
                ]
            ],
          )
        }
      ],
    );
  }

  Widget _buildDetailinfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: UniTextStyles.label),
          Text(value, style: UniTextStyles.body),
        ],
      ),
    );
  }
}