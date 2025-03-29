import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/presentation/Provider/main/notification_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/Notification/widget/payment_detail.dart';
import 'package:emonitor/presentation/view/Notification/widget/registration_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen();

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    Widget screenWidget;

    return Consumer<NotificationProvider>(
        builder: (context, notiProvider, child) {
      ///
      /// Render data
      ///
      switch (notiProvider.currentNotifyDetails?.dataType) {
        case NotificationType.registration:
          title = "Registration Details";
          subtitle = "View Tenant's information";
          screenWidget = RegistrationDetail(
            notification: notiProvider.currentNotifyDetails!,
          );
          break;
        case NotificationType.paymentRequest:
          title = "Payment Details";
          subtitle = "View Payment information";
          screenWidget = PaymentDetail(
            notification: notiProvider.currentNotifyDetails!,
          );
          break;
        default:
          title = "";
          subtitle = "";
          screenWidget = SizedBox(
            height: 600,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ 
                   ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/emptyNotification.png',
                      scale: 0.9,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 32,),
                  Text("Start by selecting notification",style: UniTextStyles.label,),
                  const SizedBox(height: 10,),
                  Text("Click on a notfication for more details",style: UniTextStyles.body,)
                  ],
              ),
            ),
          );
          break;
      }

      return Scaffold(
        backgroundColor: UniColor.backGroundColor2,
        body: Stack(
          children: [
            
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // top section
                
                       ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(title,style: UniTextStyles.label,),
                        subtitle: Text(subtitle,style: UniTextStyles.body.copyWith(fontSize: 12),),
                        leading: title.isNotEmpty ? Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: UniColor.primary,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Icon(
                                Icons.person,
                                color: UniColor.white,
                              ),
                            ): null
                       ),
                        
                     
                    // main content which will display either registerationa and payment notification
                    // this screen widget hold the whole screen widget of register and payment request
                    // if(notiProvider.isLoading == false)...[
                     screenWidget,

                    
                   
                  ],
                ),
              ),
            ),
             if(notiProvider.isLoading)...[
                      Container(color :Colors.white)
            ]
          ],
        ),
      );
    });
  }
}
