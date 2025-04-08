import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/receipt/receipt_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowRoomHistory extends StatelessWidget {
  const ShowRoomHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.read<RoomProvider>();

    final List<Payment> paymentList = roomProvider.currentSelectedRoom?.paymentList ?? [];
    final List<Payment> paymentListreversed = paymentList.reversed.toList();

    return Dialog.fullscreen(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment History", style: UniTextStyles.heading),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: UniColor.primary),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 200,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: UniColor.neutralLight,
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(paymentListreversed[index].timeStamp.toString()), 
                        onTap: ()=>showReceiptDialog(context, paymentListreversed[index].receipt!),
                      ),
                    ); 
                  },
                  itemCount: paymentListreversed.length,
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildInfo(String label, String data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: UniTextStyles.label),
      Text(data, style: UniTextStyles.body),
    ],
  );
}