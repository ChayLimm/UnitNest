import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniColor.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Icon(Icons.bed,color: UniColor.white,),
                      ),
                      const SizedBox(width: 5),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Room Details",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                          Text("View room details",style: TextStyle(color: Colors.grey,fontSize: 12),)
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.mode_edit_outlined,color: Colors.black,size: 24,)
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
