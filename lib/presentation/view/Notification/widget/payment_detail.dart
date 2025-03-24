
import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/service/finder_service.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/presentation/Provider/main/notification_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/dialog/image_dialog.dart';
import 'package:emonitor/presentation/widgets/dialog/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PaymentDetail extends StatelessWidget {
  final UniNotification notification;
  
  const PaymentDetail({super.key, required this.notification, });

  @override
  Widget build(BuildContext context) {
    ///
    /// init data
    ///
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   
    ///
    /// render data
    ///
    final notiProvider = context.read<NotificationProvider>();

    final NotifyPaymentRequest data = notification.notifyData;
    final Room? room = notiProvider.room;
    final Building? building = notiProvider.building;

    final Consumption preConsumption = room!.consumptionList.last;

    double? water = data.water;
    double? electricity = data.electricity;

    return building !=null && room.tenant!= null ?
     Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text('Room Information', style: UniTextStyles.label),
              children: [
                _buildDetailinfoRow('Room Number :', room.name),
                _buildDetailinfoRow('Building    :', building.name),
              ],
            ),
            ExpansionTile(
              title: Text('Tenant Information', style: UniTextStyles.label),
              children: [
                _buildDetailinfoRow('Name         :', room.tenant!.userName),
                _buildDetailinfoRow('Identity ID  :', room.tenant!.identifyID),
                _buildDetailinfoRow('Phone Number :', room.tenant!.contact),
              ],
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: UniColor.neutralLight,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ImageDialog(imageUrl: data.photo1URL);
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: NetworkImage(data.photo1URL),
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ImageDialog(imageUrl: data.photo2URL);
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: NetworkImage(data.photo2URL),
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
                  const SizedBox(width: 10),
                ],
              ),
            ),   
           if(notification.read == false)...{
            Form(
              key:_formKey ,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label("Electric meter"),
                buildTextFormField(
                  onChanged: (value){
                    electricity = double.parse(value);
                  },
                  initialValue: electricity.toString(),
                  validator:(value) {
                    if(value == null || value.isEmpty){
                      return "Electricity meter is required";
                    }
                    if(double.parse(value) < preConsumption.electricityMeter){
                      return "New meter can not be less than the previous one";
                    }
                    return null;
                  },
                ),
                label("Water meter"),
                buildTextFormField(
                  onChanged: (value){
                    water = double.parse(value);
                  },
                  initialValue: water.toString(),
                  validator:(value) {
                    if(value == null || value.isEmpty){
                      return "Water metter is required";
                    }
                    if(double.parse(value) < preConsumption.waterMeter){
                      return "New meter can not be less than the previous one";
                    }
                    return null;
                  },
                ),

              ],
            )
            ),
             const SizedBox(
              height: UniSpacing.l,
            )}
            , if(notification.read == false)...{
             
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            UniButton(
                      context: context,
                      label: 'Reject',
                      trigger: () async {
                        final isReject =  await showConfirmationDialog(context: context,title: "Confirmation",content: "Are you sure what want to reject this request?");
                        if(isReject){
                          notiProvider.reject(notification);
                          showCustomSnackBar(context, message: "Rejected Request", backgroundColor: UniColor.red);
                        }
                      }, // passed function here
                      buttonType: ButtonType.secondary),
                    const SizedBox(width: 10),
                    UniButton(
                      context: context,
                      label: 'View receipt',
                      trigger: () async {
                        if(_formKey.currentState!.validate()){

                        UniNotification newNoti =  UniNotification(
                            isApprove: notification.isApprove, 
                            id: notification.id, 
                            chatID: notification.chatID, 
                            systemID: notification.systemID, 
                            notifyData: NotifyPaymentRequest(requestDateOn: data.requestDateOn, water: water!, electricity: electricity!, waterAccuracy: data.waterAccuracy, electricityAccuracy: data.electricityAccuracy, photo1URL: data.photo1URL, photo2URL: data.photo2URL),
                             dataType: notification.dataType, 
                             status: notification.status
                             );

                          await notiProvider.approve(context,newNoti,null,null,null);
                        
                        }
                      }, // passed function here
                      buttonType: ButtonType.primary),
              
             
              ],
            )
          } ],
        ),
      ),
    ) 
    : const Expanded(child: Center(
      child: Text("Room or Tenant is not exist"),
    ));
  }

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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

