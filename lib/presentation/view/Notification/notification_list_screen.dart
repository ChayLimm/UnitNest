import 'package:emonitor/presentation/Provider/main/notification_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Consumer<NotificationProvider>(builder: (context, notiProvider,child){
      
      return Scaffold(
      backgroundColor: UniColor.backGroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: UniColor.neutralLight, width: 1),
                  right: BorderSide(color: UniColor.neutralLight, width: 1))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      // list of tab bars
                      TabBar(
                        indicatorColor: UniColor.primary,
                        labelColor: UniColor.primary,
                        unselectedLabelColor: UniColor.neutralDark,
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Archive'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(  horizontal: 10, vertical: 5),
                          child: TabBarView(children: [
                            tabViewAll(context),
                            buildAchive(context),
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
      ),
    );
  
    });
    
   }
}


// widget for testing
Widget buildAchive(BuildContext context) {
  final notiProvider = context.read<NotificationProvider>();// change from watch

  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: UniColor.neutralLight, width: 1,)),
      child: ListView(
  children: [
    ...notiProvider.notiList
        .where((noti) => noti != null && noti.read == true)
        .map((noti) {
          return UniNotify(
            notification: noti!,
            onTap: notiProvider.setCurrentNotifyDetails,
          );
        }) .toList(), // Convert the iterable to a list
  ],
));
}

// tab view for all notification
Widget tabViewAll(BuildContext context) {

  final notiProvider = context.watch<NotificationProvider>();

  final notiList = notiProvider.notiList.where((noti) => noti != null && noti.read == false);

  print("rebuild tab view");
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: UniColor.neutralLight, width: 1),
    ),
    child: Stack(
      children: [
       if(notiList.isEmpty)...{
        SizedBox(
            height: 600,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ 
                   ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/emptyRequest.png',
                      scale: 1.1,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // const SizedBox(height: 32,),
                  Text("No Notifications",style: UniTextStyles.label,),
                  const SizedBox(height: 10,),
                  Text("You have no notification right now.\n               Come back later",style: UniTextStyles.body,)
                  ],
              ),
            ),
          )
       },
       if(notiList.isNotEmpty)...[
        ListView(
          children: [
            ...notiList.map((noti) {
                  return UniNotify(
                    notification: noti!,
                    onTap: notiProvider.setCurrentNotifyDetails,
                  );
                }), // Convert the iterable to a list
          ],
        ),
       ],
       
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Add your refresh logic here
              notiProvider.refreshNotification();
            },
          ),
        ),
      ],
    ),
  );
}
