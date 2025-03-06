import 'package:emonitor/presentation/view/Building/room/room_details.dart';
import 'package:emonitor/presentation/view/Building/room/roomList.dart';
import 'package:flutter/material.dart';
class RoomMain extends StatelessWidget {
  const RoomMain({super.key});
  // this file is the main file for room which i used for layouting the room screen
  // room = room list screen(74) + room detail screen(34)
  @override
  Widget build(BuildContext context) {
    return const Row(
          children: [
            Expanded(
              flex: 74,
              child: RoomlistScreen()
              ),
            Expanded(
              flex: 34,
              child:RoomDetailScreen()
              ),
          ],
  
      );
  }
}