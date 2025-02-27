import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniColor.backGroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "Requests",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,color: UniColor.neutralDark),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return notificationMessage();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
// notification card
Widget notificationMessage(){
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      leading: CircleAvatar(radius: 13, backgroundColor: UniColor.iconNormal),
      title: RichText(
        text: TextSpan(
            children:[
               TextSpan(
                  text: "Payment Request:",
                  style: TextStyle(
                      fontSize: 10,
                      color: UniColor.neutralDark
                  )
              ),
              TextSpan(
                  text: "Room A001, Building A1  Vanda",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: UniColor.neutral
                  )
              ),
            ]
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("2 m", style: TextStyle(fontSize: 10)),
          CircleAvatar(radius: 3, backgroundColor: UniColor.primary),
        ],
      ),
    ),
  );
}