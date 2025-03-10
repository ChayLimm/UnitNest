import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/system/system.dart';
import 'package:emonitor/presentation/view/Notification/notificationDetails.dart';
import 'package:emonitor/presentation/view/Notification/notificationListScreen.dart';
import 'package:flutter/material.dart';
class notification extends StatelessWidget {
  const notification({super.key});
  // this file is the main file for notification which i used for layouting the notification screen
  // notification = notification list screen(53) + notification detail screen(55)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 53,
              child: NotificationListScreen()
              ),
            Expanded(
              flex: 55,
              child: NotificationDetailScreen(notificationType: NotificationType.paymentRequest,)
              ),
          ],
        ),  
      ),
    );
  }
}