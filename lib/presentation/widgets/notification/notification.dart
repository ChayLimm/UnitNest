import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  registration,
  paymentRequest
}

class UniNotification extends StatelessWidget {
  final NotificationType notificationType;
  final String notificationMessage;
  final String timeStamp;
  final VoidCallback? onAcceptTrigger;
  final VoidCallback? onDenyTrigger;
  final VoidCallback? onTap;

  const UniNotification({
    required this.notificationType,
    required this.notificationMessage,
    required this.timeStamp,
    this.onDenyTrigger,
    this.onAcceptTrigger,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (notificationType) {
      case NotificationType.registration:
        return _buildRegisterNotification(context);
      case NotificationType.paymentRequest:
        return _buildPaymentNotification();
      default:
        return Container(); // Return an empty container for unknown types
    }
  }

// some widgets for the notification list screen
// in this screen i have implemented and used following custom widget
// 1. primaryButton(from button.dart)
// 2. secondaryButton (from button.dart)
// 3. tabViewAll[line 97] (in this file): for all notification tab view
// 4. tabViwRequest [line 124] (in this file) : for request tab view
// 5. registerNotification [line 150] (in this file) : for register notification type
// 6. PaymentRequestNotification[line 182] (in this file)	: for payment request notification type
// 7. paymentNotification [line 204] (in this file) : for payment notification type
// 8. buildTabview [83] (in this file) : for testing only

  // Helper method to build the registration notification
  Widget _buildRegisterNotification(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          leading: CircleAvatar(radius: 15, backgroundColor: UniColor.iconNormal),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notificationMessage,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: UniColor.neutral),
              ),
              Text(
                '$timeStamp min ago',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: UniColor.neutralLight),
              ),
              Row(
                children: [
                  UniButton(
                    context: context,
                    label: "Accept",
                    trigger: onAcceptTrigger ?? () {},
                    buttonType: ButtonType.primary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  UniButton(
                    context: context,
                    label: "Deny",
                    trigger: onDenyTrigger ?? () {},
                    buttonType: ButtonType.secondary,
                  ),
                ],
              )
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: UniColor.iconNormal,
          ),
        ),
      ),
    );
  }

  // Helper method to build the payment notification
  Widget _buildPaymentNotification() {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          leading: CircleAvatar(radius: 15, backgroundColor: UniColor.iconNormal),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notificationMessage,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: UniColor.neutral),
              ),
              Text(
                '$timeStamp min ago',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: UniColor.neutralLight),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: UniColor.iconNormal,
          ),
        ),
      ),
    );
  }
}
