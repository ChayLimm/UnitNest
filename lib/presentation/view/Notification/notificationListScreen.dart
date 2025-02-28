import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';


class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniColor.backGroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Notification",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  TextButton(
                      onPressed: (){},
                      child: Text("Mark as read",style: TextStyle(color: UniColor.primary),)
                  )
                ],
              ),
            ),
            // Notifications List
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.blue),
                    title: Text("Notification ${index + 1}"),
                    subtitle: const Text("This is a notification message."),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
