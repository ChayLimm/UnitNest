import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget showRoomHistory(BuildContext context){

  final roomProvider = context.watch<RoomProvider>();
  final List<Payment> paymentList = roomProvider.currentSelectedRoom!.paymentList;

  return Dialog.fullscreen(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text("Payment History",style: UniTextStyles.heading,),
          DataTable(
            columns: const [
              DataColumn(label: Text("DateTime")),
              DataColumn(label: Text("Paid by")),
              DataColumn(label: Text("Phone number")),
              DataColumn(label: Text("Total")),
          ], 
          rows: [
      
          ])
        ],
      ),
    ),
  );
}
