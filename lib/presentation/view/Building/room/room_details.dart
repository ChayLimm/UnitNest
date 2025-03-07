import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/presentation/Provider/main/building_provider.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatelessWidget {
  RoomDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider,child) {
        final Room? room = roomProvider.currentSelectedRoom;
        return Scaffold(
        backgroundColor: UniColor.white,
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
                            Icons.bed,
                            color: UniColor.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Room Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            Text(
                              "View room details",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            )
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
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              
              // ignore: unnecessary_null_comparison
              room==null
              ?Center(
                child: Text(
                  'No room available, Please add one'
                  ,style: UniTextStyles.body,
                  ),)
              :Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // spacing around divider te nah
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Divider(height: 1, color: Colors.grey),
                        ),
                        _buildDetailinfoRow('Room Number', roomProvider.currentSelectedRoom!.name),
                        _buildDetailinfoRow('Floor', roomProvider.currentSelectedBuilding!.floorCount.toString()),
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Divider(height: 1, color: Colors.grey),
                        ),
                        Text('Rental Information', style: UniTextStyles.label),
                        _buildDetailinfoRow('Payment Status', roomProvider.currentSelectedRoom!.roomStatus.toString()),
                        _buildDetailinfoRow('Monthly', '20'),
                        _buildDetailinfoRow('Deposit', '20'),
                        _buildDetailinfoRow('Vehicle', '20'),
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Divider(height: 1, color: Colors.grey),
                        ),
                        Text('Tenant Information', style: UniTextStyles.label),
                        _buildDetailinfoRow('Identity ID', '20'),
                        _buildDetailinfoRow('Name','30'),
                        _buildDetailinfoRow('Phone number', 'hello'),
                        _buildDetailinfoRow('Move In Date', 'work' ),// plij lbeab dak date time na 
                        const SizedBox(height: 40,), // just a white space
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
  });
  }
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
