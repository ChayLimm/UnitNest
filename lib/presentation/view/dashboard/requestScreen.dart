import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';


class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:UniColor.backGroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Requests",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
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


