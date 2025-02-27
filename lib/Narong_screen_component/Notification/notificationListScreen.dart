import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:flutter/material.dart';


class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniColor.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(color: UniColor.neutralLight, width: 1),
                right: BorderSide(color: UniColor.neutralLight, width: 1))),
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
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    // list of tab bars
                    TabBar(
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
// in this screen i have implemented and used following custom widget
// 1. primaryButton(from button.dart)
// 2. secondaryButton (from button.dart)
// 3. tabViewAll[line 97] (in this file): for all notification tab view
// 4. tabViwRequest [line 124] (in this file) : for request tab view
// 5. registerNotification [line 150] (in this file) : for register notification type
// 6. PaymentRequestNotification[line 182] (in this file)	: for payment request notification type
// 7. paymentNotification [line 204] (in this file) : for payment notification type
// 8. buildTabview [83] (in this file) : for testing only 


// widget for testing 
Widget buildTabview(String text) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
Widget tabViewAll(context){
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
          registerNotification(context),
          PaymentRequestNotification(),
          paymentNotification(),
          registerNotification(context),
          PaymentRequestNotification(),
          registerNotification(context),
          PaymentRequestNotification(),
          registerNotification(context),
          PaymentRequestNotification(),
        ],
      )
      );
}

// widget for request tab view
Widget tabViwRequest(context){
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
          registerNotification(context),
          PaymentRequestNotification(),
          registerNotification(context),
          PaymentRequestNotification(),
          registerNotification(context),
          PaymentRequestNotification(),
          registerNotification(context),
          PaymentRequestNotification(),
        ],
      )
      );
}

// widget for resgister notification type
Widget registerNotification(context){
  return InkWell(
    onTap: (){print("registerNotification");},
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: CircleAvatar(radius: 15, backgroundColor: UniColor.iconNormal),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vanda has requested the account registeration",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: UniColor.neutral),),
            Text('5 min ago',style: TextStyle(fontSize: 10,fontWeight:FontWeight.bold,color: UniColor.neutralLight),),
            Row(
              children: [
                primaryButton(context: context, trigger: (){}, label: "Accept"),
                SizedBox(width: 10,),
                secondaryButton(context: context, trigger: (){}, label: "Deny"),
              ],
            )
          ],
        ),
        trailing: IconButton(
          onPressed: (){},
          icon: Icon(Icons.arrow_forward_ios,
            color: UniColor.iconNormal,),
           )
      ),
    ),
  );
}

// widget for payment request notification type
Widget PaymentRequestNotification(){
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      leading: CircleAvatar(radius: 15, backgroundColor: UniColor.iconNormal),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Request: Room A001, Building A1  Vanda",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: UniColor.neutral),),
          Text('5 min ago',style: TextStyle(fontSize: 10,fontWeight:FontWeight.bold,color: UniColor.neutralLight),),
        ],
      ),
       trailing: IconButton(
          onPressed: (){},
          icon: Icon(Icons.arrow_forward_ios,
            color: UniColor.iconNormal,),
           )
    ),
  );
}

// widget for payment notification type
Widget paymentNotification(){
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      leading: CircleAvatar(radius: 15, backgroundColor: UniColor.iconNormal),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Request: Room A001, Building A1  Vanda",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: UniColor.neutral),),
          Text('5 min ago',style: TextStyle(fontSize: 10,fontWeight:FontWeight.bold,color: UniColor.neutralLight),),
        ],
      ),
    ),
  );
}