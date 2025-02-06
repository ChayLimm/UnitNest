import 'package:emonitor/utils/component.dart';
import 'package:flutter/material.dart';


class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: blue,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Icon(Icons.person,color: white,),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Registation Details",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                          Text("View Tenant's information",style: TextStyle(color: Colors.grey,fontSize: 12),)
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.mode_edit_outlined,color: Colors.black,size: 24,)
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
