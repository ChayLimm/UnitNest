import 'dart:convert';
import 'dart:io';


import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/model/system/system.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/presentation/Provider/main/notification_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key});
void writeJsonToFile(String jsonString, ) {
  // Create a File object
  File file = File('json.json');

  // Write the JSON string to the file
  file.writeAsStringSync(jsonString);

}

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(builder: (context,notiProvider,child){

      // //dummy 
      //           Room testRoom =  Room(name: "Testing01", price: 100);
      //           Payment payment = Payment(
      //             parkingAmount: 10, 
      //             parkingFee: 10, 
      //             hygiene: 1, 
      //             tenantChatID: "ChatID", 
      //             totalPrice: 100, 
      //             roomID: "testRoom", 
      //             deposit: 100, 
      //             transaction: TransactionKHQR(qr: "qr", md5: "md5")
      //             );
      //             testRoom.paymentList.add(payment);
      //             Building testBuilding = Building(name: "Building Test", address: "Toul kork");
      //             testBuilding.roomList.add(testRoom);

      //             system.listBuilding.add(testBuilding);

      //             final  data = system.toJson();

      return  Scaffold(
      backgroundColor: UniColor.backGroundColor,
      floatingActionButton: customFloatingButton(
        onPressed: (){

        },// place your function here
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),        width: MediaQuery.of(context).size.width * 0.65,
        child:  Center(
          child: UniButton(
            context: context, 
            label: "Test payment", 
            trigger: ()async{
              final test= UniNotification(isApprove: false, id: Uuid().v4(), chatID: "chatID", systemID: "systemID", notifyData: NotifyRegistration(name: "name", phone: "phone", idIdentification: "idIdentification", registerOnDate: DateTime.now()), dataType: NotificationType.registration, status: NotificationStatus.pending);
              notiProvider.rootDataService.notificationList!.listNotification.add(test);
              notiProvider.rootDataService.synceToCloud();
            }, 
            buttonType: ButtonType.primary
            ),
        ),
      ),
    );
    });
  }
}
