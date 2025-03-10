import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationType notificationType;

  const NotificationDetailScreen({
    required this.notificationType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    Widget screenWidget;
    switch (notificationType) {
      case NotificationType.registration:
        title = "Registration Details";
        subtitle = "View Tenant's information";
        screenWidget=_buildRegisterNotification(context);
        break;
      case NotificationType.paymentRequest:
        title = "Payment Details";
        subtitle = "View Payment information";
        screenWidget=_buildpaymentNotification(context);
        break;
      default:
        title = "Notification Details";
        subtitle = "View details";
        screenWidget=Container();
        break;
    }

    return Scaffold(
      backgroundColor: UniColor.backGroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top section
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
                            color: UniColor.primary,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.person,
                          color: UniColor.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mode_edit_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15,),
            // main content which will display either registerationa and payment notification
            // this screen widget hold the whole screen widget of register and payment request
            screenWidget
          ],
        ),
      ),
    );
  }
}
// Widget notification detail screen for Registeration
Widget _buildRegisterNotification(BuildContext context){
  return Column(
    crossAxisAlignment:CrossAxisAlignment.start,
    children: [
      _buildDetailinfoRow('Room Number','A101 fixed '),
      _buildDetailinfoRow('Floor','1 fixed '),
      Text('Tenant Information', style: UniTextStyles.label),
       _buildDetailinfoRow('Identity ID','IDTB090091 fixed '),
      _buildDetailinfoRow('Name','Bing Bing fixed '),
      _buildDetailinfoRow('Phone Number','0967288086 fixed '),
      _buildDetailinfoRow('Move In Date','30 oct fixed '),
      const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.grey),
            ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          UniButton(
            context: context,
             label: 'Cancel',
              trigger: (){},// passed function here 
               buttonType: ButtonType.secondary),
               const SizedBox(width: 10,),
               UniButton(
            context: context,
             label: 'Save',
              trigger: (){},// passed function here 
               buttonType: ButtonType.primary)
        ],
      )           
    ],
  );
}

// Widget notification detail screen for payment notification 
Widget _buildpaymentNotification(BuildContext context) {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            title: Text('Room Information', style: UniTextStyles.label),
            children: [
              _buildDetailinfoRow('Room Number', 'A101 (fixed)'),
              _buildDetailinfoRow('Building', 'A (fixed)'),
              _buildDetailinfoRow('Floor', '02 (fixed)'),
            ],
          ),
          ExpansionTile(
            title: Text('Tenant Information', style: UniTextStyles.label),
            children: [
              _buildDetailinfoRow('Identity ID', 'IDTB090091 (fixed)'),
              _buildDetailinfoRow('Name', 'A (fixed)'),
              _buildDetailinfoRow('Phone Number', '02 (fixed)'),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: UniColor.neutralLight,
                width: 1,
              ),
            ),
            child: Row( // Change Column to Row ✅
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/Bulidng.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/Bulidng.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          _buildDetailinfoRow('Water meter', '02 (fixed)'),
          _buildDetailinfoRow('Electricity', '02 (fixed)'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UniButton(
                context: context,
                 label: 'View Receipt',
                  trigger: (){},// passed function here 
                   buttonType: ButtonType.secondary),
              Row(
                children: [
                  UniButton(
                context: context,
                 label: 'Cancel',
                  trigger: (){},// passed function here 
                   buttonType: ButtonType.secondary),
                   const SizedBox(width: 10,),
                   UniButton(
                context: context,
                 label: 'Primary',
                  trigger: (){},// passed function here 
                   buttonType: ButtonType.primary),
                   const SizedBox(width: 10,),
                ],
              )     
            ],
          )
        ],
      ),
    ),
  );
}

// the info as row
Widget _buildDetailinfoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$title :",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: UniColor.neutralDark,
                fontSize: 12)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    ),
  );
}