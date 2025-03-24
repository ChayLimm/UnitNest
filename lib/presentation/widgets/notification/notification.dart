import 'package:emonitor/domain/model/Notification/notification.dart';
import 'package:emonitor/domain/model/stakeholder/tenant.dart';
import 'package:emonitor/domain/service/tenant_service.dart';
import 'package:emonitor/presentation/Provider/main/notification_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/utils/date_formator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UniNotify extends StatelessWidget {
  final UniNotification notification;
  final Function(UniNotification) onTap;

  const UniNotify({
    required this.notification,
    required this.onTap,
    super.key,
  });

   String _getNotificationMessage() {
    switch (notification.dataType) {
      case NotificationType.registration:
        final request = notification.notifyData as NotifyRegistration;
        return "${request.name} has registered as a tenant";
      case NotificationType.paymentRequest:
        final request = notification.notifyData as NotifyPaymentRequest;
        final Tenant? tenant = TenantService.instance.getTenantByChatID(notification.chatID);
        return "${tenant?.userName ?? "Unknown"} has requested a payment";
      default:
        return "Unknown notification";
    }
  }
  String _getTimeAgo() {
    switch (notification.dataType) {
      case NotificationType.registration:
        return DateTimeUtils.timeAgo(notification.notifyData.registerOnDate);
      case NotificationType.paymentRequest:
        return DateTimeUtils.timeAgo(notification.notifyData.requestDateOn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notiProvider = context.read<NotificationProvider>();
        return Dismissible(
          onDismissed: (direction) => notiProvider.removeNotification(notification) ,
          key: Key(notification.id),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            onTap: ()=>onTap(notification),
            leading:  Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:notification.read ? UniColor.iconLight : UniColor.iconNormal, // Use the same color as the icon
                width: 1.0, // Adjust the border width as needed
              ),
            ),
            padding: const EdgeInsets.all(2.0), // Adjust padding to control the space between the icon and the border
            child: Icon(
              Icons.person,
              color: notification.read ? UniColor.iconLight : UniColor.iconNormal,
            ),
          ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getNotificationMessage(),
                  style:  UniTextStyles.body.copyWith(fontWeight: FontWeight.w500)
                ),
                Text(
                  _getTimeAgo() ,
                  style:  UniTextStyles.label.copyWith(
                    fontWeight: FontWeight.w500,fontSize: 12,
                    color: !notification.read ? UniColor.primary : null
                    )
                ),
              ],
            ),
           
              ),
        );
  }

 
}
