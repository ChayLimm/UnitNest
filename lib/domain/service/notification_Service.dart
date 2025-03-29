import 'dart:typed_data';
import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/domain/service/telegram_service.dart';
import 'package:emonitor/domain/service/tenant_service.dart';
import 'package:emonitor/presentation/Provider/main/building_provider.dart';
import 'package:emonitor/presentation/view/receipt/receipt_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationService {
  static NotificationService? _instance;
  RootDataService repository;
  NotificationService.internal(this.repository);

  /// initializer
  static void initialize(RootDataService repository){
    if(_instance == null){
      _instance = NotificationService.internal(repository);
    }else{
      throw "Notification service is already init";
    }
  }

  ///
  ///Single ton
  ///

  static NotificationService get instance {
    if(_instance == null){
      throw "Notification service must be init first";
    } return _instance!;
  }

Future<bool> approve({required BuildContext context,required UniNotification notification,Room? room,double deposit =0,int tenantRentParking = 0}) async {
   print("Appoving in notification service ");
   final buildingProvider = context.read<BuildingProvider>();
   switch(notification.dataType){
      case NotificationType.paymentRequest:
        /// Convert data first
        NotifyPaymentRequest notiData = notification.notifyData;
        /// find the whose request is this
        for(var building in repository.rootData!.listBuilding){
          for(var room in building.roomList){
             print("room in loop tenant chatid : ${room.tenant!.chatID}");
              if(room.tenant != null && room.tenant!.chatID == notification.chatID){

                  Consumption newConsumption = Consumption(
                    waterMeter: notiData.water, 
                    electricityMeter: notiData.electricity
                  );

                  Payment payment =  await PaymentService.instance.proccessPayment(room.tenant!.chatID,newConsumption);

                    // generating reciept and get the pngbyte
                    final Uint8List? pngbyte = await Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ShowReceiptDialog(payment: payment
                      );
                    }));
                    // Null checker
                    if(pngbyte == null || pngbyte.isEmpty){
                      // room.roomStatus = Availibility.available;
                      // room.tenant = null;
                      print("cancel the payment reuqest");
                      return false;                   
                    }else{
                      // approve
                      String? recieptURL = await RootDataService.uploadImageToFirebaseStorage(pngbyte);
                      if(recieptURL != null){
                      payment.receipt = recieptURL;
                      // approve legit tenant
                      notification.read = true;
                      // notification.isApprove = true;

                      payment.paymentStatus = PaymentStatus.pending;

                      room.paymentList.add(payment);
                      print("approve payment success5555 ${notification.toJson()}");
                      ////debug
                      print("Noti in list");
                      for(var item in repository.notificationList!.listNotification){
                        if(item!.id == notification.id){
                         item.read = true;
                        }
                      }
                      repository.synceToCloud();

                      TelegramService.instance.sendReceipt(notification.chatID, payment.receipt!, "Payment is due on 5/${DateTime.now().month}/${DateTime.now().year}");
                      buildingProvider.refresh();

                      return true;
                      }else{
                        print("In Notification service, reciept url is null");
                      }
                    }             
            }else{
                print( "Can not find tenant in notification approval");
              
            }
          }
        }
        
        break;

    
      case NotificationType.registration:
        print("proccesing approve registration");
        // convert data to registertype
        NotifyRegistration notiData = notification.notifyData;
        ///init tenant
        Tenant newTenant = Tenant(
          chatID: notification.chatID, 
          identifyID: notiData.idIdentification , 
          userName: notiData.name, 
          contact: notiData.phone, 
          deposit: deposit,
          rentParking: tenantRentParking
          );
        Payment? payment =  await TenantService.instance.registrationTenant(newTenant, room!);

         for(var building in repository.rootData!.listBuilding){
          for(var room in building.roomList){
              if(room.tenant != null){
                print("Tenant to find : ${newTenant.chatID}");
                print("Tenant chatID: ${room.tenant!.chatID}");
              }
              if(room.tenant != null && room.tenant!.chatID == newTenant.chatID){
                  // Payment payment =  await PaymentService.instance.proccessPayment(room.tenant!.id);
                  print("check context");
                  print("contintue to receipt");

                   if(payment != null){
                      final Uint8List? pngbyte = await Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ShowReceiptDialog(payment: payment
                      );
                    }));
                    // Null checker
                    if(pngbyte == null || pngbyte.isEmpty){
                      room.roomStatus = Availibility.available;
                      room.tenant = null;
                      return false;
                    }else{
                      // approve
                      print("Uploading image to cloude");
                      String? recieptURL = await RootDataService.uploadImageToFirebaseStorage(pngbyte);
                      if(recieptURL != null){
                      print("Reciept URL = $recieptURL");
                      payment.receipt = recieptURL;
                      notification.read = true;
                      notification.isApprove = true;

                      room.paymentList.add(payment);

                      print("approve payment success");
                      TelegramService.instance.sendReceipt(notification.chatID, payment.receipt!, "Payment is due on 5/${DateTime.now().month}/${DateTime.now().year}");
                      buildingProvider.refresh();
                      repository.synceToCloud();
                      return true;
                      }else{
                        print("In Notification service, reciept url is null");
                      }
                    }
                   }else{
                    throw "Can not process payment in approval ";
                   }
            }
          }
        }
       
       break;   
    }
   
   return false;
}

Future<void> reject(UniNotification notification) async{
        TelegramService.instance.sendMesage(int.parse(notification.chatID),
        "Request rejected!, please contact landlord for more info"
      );
      notification.read = true;
      ////debug
      // print("Noti in list");
      // for(var item in repository.notificationList!.listNotification){
      //   if(item!.id == notification.id){
      //     item.read = true;
      //   }
      // }
      print("reject sync to cloud");
      //
      repository.synceToCloud();
    }

}