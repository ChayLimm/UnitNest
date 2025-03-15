import 'package:emonitor/presentation/Provider/main/notification_provider.dart';
import 'package:emonitor/presentation/view/Notification/notification_details.dart';
import 'package:emonitor/presentation/view/Notification/notification_list_screen.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class NotificationMain extends StatelessWidget {
  const NotificationMain({super.key});
  // this file is the main file for notification which i used for layouting the notification screen
  // notification = notification list screen(53) + notification detail screen(55)
  @override
  Widget build(BuildContext context) {
    final notiProvider = context.watch<NotificationProvider>();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 53,
                child: NotificationListScreen()
                ),
              const Expanded(
                flex: 55,
                child: NotificationDetailScreen()
                ),
            ],
          ),
         
        if(notiProvider.isLoading)...[
          loading()
        ,]
        ],
      ),
    );
  }
}