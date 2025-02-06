import 'package:flutter/material.dart';

import '../utils/component.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
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
                  Text("Notification",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  TextButton(
                      onPressed: (){},
                      child: Text("Mark as read",style: TextStyle(color: blue),)
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
                    leading: Icon(Icons.notifications, color: Colors.blue),
                    title: Text("Notification ${index + 1}"),
                    subtitle: Text("This is a notification message."),
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
