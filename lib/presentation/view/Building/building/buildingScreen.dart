import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/presentation/Provider/main/building_provider.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class BuildingScreen extends StatelessWidget {
  const BuildingScreen({
    super.key,
  });

  Future<bool> addOrEditRoom(BuildContext context) async{
    // call provider 
    final buildingProvider = context.read<BuildingProvider>();
    // declare variable for the edit form
    String name = "";
    String address= "";
    int floorCount = 0;
    int parkingSpace = 0;

    final isFormTrue = await uniForm(
      context: context, 
      title: "Add Building", 
      subtitle: "Add new building", 
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Building name"),
          buildTextFormField(
            onChanged: (value){
              name = value;
            }, 
            validator: (value){
              if(value == null || value.isEmpty){
                return "Building name is required";
              }
              return null;
            }
          ),label("Address"),
          buildTextFormField(
            onChanged: (value){
              address = value;
            }, 
            validator: (value){
              if(value == null || value.isEmpty){
                return "Address is required";
              }
              return null;
            }
          ),
          label("floor count"),
          buildTextFormField(
            onChanged: (value){
              floorCount = int.parse(value);
            }, 
            validator: (value){
              if(value == null || value.isEmpty){
                return "floor count is required";
              }
              return null;
            }
          ),
          label("Parking space"),
          buildTextFormField(
            onChanged: (value){
              parkingSpace = int.parse(value);
            }, 
            validator: (value){
              if(value == null || value.isEmpty){
                return "Parking space is required";
              }
              return null;
            }
          ),
        ],
      ), 
      onDone: ()async{
        final newBuidling = Building(name: name, address: address,floorCount: floorCount,parkingSpace: parkingSpace);
        buildingProvider.updateOrAddBuilding(newBuidling);
       }    
    );
    return isFormTrue;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BuildingProvider>(builder: (context, buildingProvider, child){
      return Scaffold(
      backgroundColor: UniColor.white,
      floatingActionButton: customFloatingButton(
        onPressed: () {

        }, // place your function here
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(color: UniColor.neutralLight, width: 1),
                right: BorderSide(color: UniColor.neutralLight, width: 1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top section
            _buildTopSection(
              context: context,
              ontrigger:() async{
                
                // open dialog forn to add building
                final isFromTrue = await addOrEditRoom(context);
                if(isFromTrue){
                  showCustomSnackBar(context, message: "Add building succesfully!", backgroundColor: UniColor.green);
                }else{
                  showCustomSnackBar(context, message: "Add building failed!", backgroundColor: UniColor.red);
                }
            }
            ),
            
            // pass the function to return dialog in here 
            // Bulidng screen with grid of building card list
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 75),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 560, // Maximum width of each grid item
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buildingProvider.buildingList.length,
              itemBuilder: (context, index) {
                final building = buildingProvider.buildingList[index];
                BuildingInfo buildingInfo = buildingProvider.buildingInfo(building);
                return InkWell(
                  onTap: () {
                    // Change the current selected building in RoomProvider in order for the room screeen rebuild with new building
                    final roomProvider = context.read<RoomProvider>();
                    roomProvider.setCurrentSelectedBuilding(building);
                    // note that /building/room the room widget will show roomProvider.currentSelectedBuilding to for data
                    Navigator.pushNamed(context, "/building/room");
                  },
                  child: _buildBuildingCard(
                      image: 'assets/images/Bulidng.jpg',
                      buildingTitle: building.name,
                      location: building.address,
                      availableRoom: buildingInfo.availableRoom,
                      totalRoom: building.roomList.length,
                      name: building.name,
                      address: building.address,
                      floorCount: building.floorCount.toString(),
                      parkingSpace: building.parkingSpace.toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  
    }
    ) ;
    
    }
}
// Custom widget part
// in this screen i have used 
// 1- buildTopSection: for building screen header
// 2- buildBuildingCard: for building card
// 3- _buildDetailRow: for building card detail row
// 4- customFloatingButton: for floating button (from component.dart)
// 5- customButton: for custom button (from button.dart)


// i turned all function widget to private just to prevent calling outside of this file
// if you want to use it outside of this file, just remove the underscore(_) before the function name
// header section for building screen
Widget _buildTopSection({required BuildContext context, required VoidCallback ontrigger}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Building list",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "View all of your buildings here",
            style: TextStyle(color: UniColor.neutralLight, fontSize: 12),
          ),
        ],
      ),
      UniButton(
        context: context, 
        label: "Add building", 
        trigger: ontrigger,
        buttonType: ButtonType.primary
        )
    ],
  );
}


// Building info card widget
Widget _buildBuildingCard(
    {required String image,
    required String buildingTitle,
    required String location,
    required int availableRoom,
    required int totalRoom ,
    required String name,
    required String address,
    required String floorCount,
    required String parkingSpace,
    
    }) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: UniColor.neutralLight),
    ),
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: 90,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    buildingTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: UniColor.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(location,
                          style: TextStyle(
                              fontSize: 12, color: UniColor.neutralDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 90,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: UniColor.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            availableRoom.toString() + " " + "available",
                            style: TextStyle(
                                color: UniColor.primary,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 85,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: UniColor.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            totalRoom.toString() + " " + "Rooms",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildDetailRow("Name", name),
        _buildDetailRow("Address", address),
        _buildDetailRow("Floor count", floorCount),
        _buildDetailRow("Parking space", parkingSpace),
      ],
    ),
  );
}


// Building info card detail row
Widget _buildDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
