import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/receipt/receipt_view.dart';
import 'package:emonitor/presentation/widgets/infoCard/uni_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceList extends StatelessWidget {
  const InvoiceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(builder: (context,roomProvider,child){

    ///
    /// Render data
    /// 

    List<Room> pendingRoom = [];

    for (Building building in roomProvider.repository.rootData!.listBuilding) {   
      // Fetch pending rooms and add to pendingRoom list
      List<Room> pendingRooms = RoomService.instance.pending(building: building, dateTime: DateTime.now());
      pendingRoom.addAll(pendingRooms);
    }   

   return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pending Invoices",style: UniTextStyles.label),
              
            ],
          ),
          const SizedBox(height: 10),
          ...pendingRoom.map((item)=>UniTile(
            icon: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: UniColor.primary,
              ),
              child: const Icon(Icons.receipt_long,color: Colors.white,size: 20,),
            ),
            title:"INV#${item.paymentList.last.transaction.hashCode.toString()}",
            trailing: "\$ ${item.paymentList.last.totalPrice.toString()}",
            subtitle: item.name,
            status: "Pending",
            onTap: () {
             showReceiptDialog(context,item.paymentList.last.receipt!);
              },
            ))
         
        ],
      ),
    ),
  );
    });
    
  }
}


