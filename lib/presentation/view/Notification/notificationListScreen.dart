import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/domain/model/system/system.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/Notification/notification_main.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/notification/notification.dart';
import 'package:flutter/material.dart';

class NotificationListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniColor.backGroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(color: UniColor.neutralLight, width: 1),
                right: BorderSide(color: UniColor.neutralLight, width: 1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notification",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Mark as read",
                        style: TextStyle(color: UniColor.primary),
                      ))
                ],
              ),
            ),
            // Notifications List
            // place need to change
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    // list of tab bars
                    TabBar(
                      indicatorColor: UniColor.primary,
                      labelColor: UniColor.primary,
                      unselectedLabelColor: UniColor.neutralDark,
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Request'),
                        Tab(text: 'Archive'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TabBarView(children: [
                          tabViewAll(context),
                          tabViwRequest(context),
                          buildTabview("Archive"),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


// widget for testing
Widget buildTabview(String text) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(
              top: BorderSide(color: UniColor.neutralLight, width: 1),
              bottom: BorderSide(color: UniColor.neutralLight, width: 1),
              left: BorderSide(color: UniColor.neutralLight, width: 1),
              right: BorderSide(color: UniColor.neutralLight, width: 1))),
      child: Center(child: Text(text)));
}

// tab view for all notification
Widget tabViewAll(context) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(
              top: BorderSide(color: UniColor.neutralLight, width: 1),
              bottom: BorderSide(color: UniColor.neutralLight, width: 1),
              left: BorderSide(color: UniColor.neutralLight, width: 1),
              right: BorderSide(color: UniColor.neutralLight, width: 1))),
      child: ListView(
        children: [
          UniNotification(
              notificationType: NotificationType.registration,
              notificationMessage:
                  'Vanda has requested the account registeration',
              timeStamp: '2',
              onTap: () {
                print('registeration notification is cliked');
              }),
          UniNotification(
              notificationType: NotificationType.paymentRequest,
              notificationMessage:
                  'Payment Request: Room A001, Building A1  Vanda',
              timeStamp: '2',
              onTap: () {
                print('payment notification is clicked');
              }),
        ],
      ));
}

// widget for request tab view
Widget tabViwRequest(context) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(
              top: BorderSide(color: UniColor.neutralLight, width: 1),
              bottom: BorderSide(color: UniColor.neutralLight, width: 1),
              left: BorderSide(color: UniColor.neutralLight, width: 1),
              right: BorderSide(color: UniColor.neutralLight, width: 1))),
      child: ListView(
        children: [
          UniNotification(
              notificationType: NotificationType.registration,
              notificationMessage:
                  'Vanda has requested the account registeration',
              timeStamp: '2',
              onTap: () {
                print('registeration notification is cliked');
              }),
          UniNotification(
              notificationType: NotificationType.paymentRequest,
              notificationMessage:
                  'Payment Request: Room A001, Building A1  Vanda',
              timeStamp: '2',
              onTap: () {
                print('payment notification is clicked');
              }),
        ],
      ));
}
