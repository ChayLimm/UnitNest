import 'package:flutter/material.dart';

import '../utils/component.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Requests",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return notificationMessage();
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}


