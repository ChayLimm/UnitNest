import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';

class BuildingScreen extends StatelessWidget {

  const BuildingScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniColor.backGroundColor,
      floatingActionButton: customFloatingButton(
        onPressed: (){},// place your function here
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top section
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Building list",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      Text("View all of your building here",style: TextStyle(color: Colors.grey,fontSize: 12),)
                    ],
                  ),
                  // Custombutton(
                  //   onPressed: (){},
                  //   text: "Add building",
                  // )
                  primaryButton(
                    context: context,
                    trigger: (){}, // pass function here
                    label: "Add building",
                    color: UniColor.primary
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, "/building/room");
              }, // Call the function instead of navigation
              child: const Text("Go to Room Details"),
            ),
            const Center(child: Text("This is the Building Screen")),
          ],
        ),
      ),
    );
  }
}