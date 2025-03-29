import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/telegram_service.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/utils/date_formator.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/infoCard/uni_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnpaidList extends StatefulWidget {
  const UnpaidList({super.key});

  @override
  State<UnpaidList> createState() => _UnpaidListState();
}

class _UnpaidListState extends State<UnpaidList> {
  bool isSendingReminder = false;

  Future<void> sendReminder(List<Room> unpaidRooms) async {
    final priceCharge = PaymentService.instance.getPriceChargeFor(DateTime.now());

    setState(() {
      isSendingReminder = true;
    });

    try {
      // Send requests concurrently with throttling (adjust delay if needed)
      for (Room room in unpaidRooms) {
        int chatID = int.parse(room.tenant!.chatID);
        TelegramService.instance.sendReminder(chatID,
            "Hello ${room.tenant!.userName}, your rent payment is due on ${priceCharge!.fineStartOn}/${DateTime.now().month}/${DateTime.now().year}. Please make the payment on time to avoid late fees.");

        await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (e) {
      setState(() {
        isSendingReminder = false;
      });
      throw "Error in sending reminder : $e";
    }
    setState(() {
      isSendingReminder = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(builder: (context, roomProvider, child) {
      ///
      /// Render data
      ///
      List<Room> unPaid = [];
    

      for (Building building in roomProvider.repository.rootData!.listBuilding) {
        // Fetch pending rooms and add to unPaid list
        List<Room> unPaids = RoomService.instance.unPaid(building: building, dateTime: DateTime.now());
        unPaid.addAll(unPaids);
      }

      print("Unpaid : ${unPaid.length}");
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text("Unpaid rooms", style: UniTextStyles.label),
                     if(unPaid.isNotEmpty)...[ UniButton(
                          context: context,
                          label: "Send reminder",
                          trigger: () async {
                            await sendReminder(unPaid);
                          },
                          buttonType: ButtonType.secondary)]
                    ],
                  ),
                  ...unPaid.map((item) => UniTile(
                      icon: Icon(
                        Icons.circle,
                        color: UniColor.red,
                        size: 16,
                      ),
                      title: item.tenant!.userName,
                      subtitle: item.tenant!.contact,
                      status: "",
                      trailing:item.name,
                         // "Last Paid : ${DateTimeUtils.formatDateTime(item.paymentList.last.timeStamp)}",
                      onTap: () {

                      })),
                ],
              ),
            ),
          ),
            if (isSendingReminder)
              Positioned.fill(
                child: Container(
                  color: Colors.white, // Semi-transparent background
                  child: Center(
                    child: loading(Colors.transparent), // Ensure this is a proper loading widget
                  ),
                ),
              ),        
          ],
      );
    });
  }
}
