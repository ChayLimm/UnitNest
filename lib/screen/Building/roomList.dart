import 'package:flutter/material.dart';

import '../utils/component.dart';

class RoomlistScreen extends StatelessWidget {
  final VoidCallback onBack; // Callback to return to previous layout

  const RoomlistScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      floatingActionButton: customFloatingButton(
        onPressed: (){},// place your function here
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          children: [
            // Top section
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: onBack, // Call the function instead of Navigator.pop()
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Building A",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          Text("View all of your room here",style: TextStyle(color: Colors.grey,fontSize: 12),)
                        ],
                      ),
                    ],
                  ),
                  // Custombutton(
                  //   onPressed: (){},
                  //   text: "Add Room",
                  // )
                ],
              ),
            ),
            Center(child: Text("This is the Room Details Screen")),
          ],
        ),
      ),
    );
  }
}
