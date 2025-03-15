import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/presentation/Provider/main/building_provider.dart';
import 'package:emonitor/presentation/Provider/main/room_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/Building/building/widget/building_card.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildingScreen extends StatelessWidget {
  const BuildingScreen({
    super.key,
  });
  
  // this funciton will return the dialog for deleting anf editing the building
  Future<void> onEditorDeleteDialog(BuildContext context, Building? building) async {
    final buildingProvider = context.read<BuildingProvider>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: UniColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Edit Building',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: UniColor.neutralDark,
                  )  
                ),
                const WidgetSpan(child: SizedBox(width: 5)),// just white spacing between text in text span 
                TextSpan(
                  text: building?.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: UniColor.primary
                  )
                ),
                TextSpan(
                  text: '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: UniColor.neutralDark
                  )
                ),
              ]
            )
          ),
          content: const Text(
            'Do you want to edit or delete this building?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    buildingProvider.removeBuilding(building!);
                    showCustomSnackBar(context,
                        message: "Deleted Successfully!",
                        backgroundColor: UniColor.green);
                    Navigator.of(context).pop();
                  }, // function to delete must be passed here
                  child: Container(
                    width: 100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: UniColor.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            color: UniColor.primary,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    final bool isEditSuccessful =
                        await addOrEditBuilding(context, building);
                    if (isEditSuccessful) {
                      showCustomSnackBar(context,
                          message: "Edit building successfully!",
                          backgroundColor: UniColor.green);
                    } else {
                      showCustomSnackBar(context,
                          message: "Edit building failed!",
                          backgroundColor: UniColor.red);
                    }
                    Navigator.of(context).pop();
                  }, // function edit will be passed here
                  child: Container(
                    width: 100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: UniColor.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // function to add or edit room
  Future<bool> addOrEditBuilding(BuildContext context, Building? building) async {
    // call provider
    final buildingProvider = context.read<BuildingProvider>();
    // declare variable for the edit form
    String name = building?.name ?? "";
    String address = building?.address ?? "";
    int floorCount = building?.floorCount ?? 0;
    int parkingSpace = building?.parkingSpace ?? 0;

    final isFormTrue = await uniForm(
        context: context,
        title: building == null ? "Add Building" : "Edit Building",
        subtitle:building == null ? "Add new building" : "Edit building details",
        form: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label("Building name"),
            buildTextFormField(
                initialValue: name,
                onChanged: (value) {
                  name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Building name is required";
                  }
                  return null;
                }),
            label("Address"),
            buildTextFormField(
                initialValue: address,
                onChanged: (value) {
                  address = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Address is required";
                  }
                  return null;
                }),
            label("floor count"),
            buildTextFormField(
                initialValue: floorCount.toString(),
                onChanged: (value) {
                  floorCount = int.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "floor count is required";
                  }
                  return null;
                }),
            label("Parking space"),
            buildTextFormField(
                initialValue: parkingSpace.toString(),
                onChanged: (value) {
                  parkingSpace = int.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Parking space is required";
                  }
                  return null;
                }),
          ],
        ),
        onDone: () async {
          final newBuidling = Building(
              id: building?.id,
              name: name,
              address: address,
              floorCount: floorCount,
              parkingSpace: parkingSpace);
          buildingProvider.updateOrAddBuilding(newBuidling);
        });
    return isFormTrue;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BuildingProvider>(builder: (context, buildingProvider, child) {
      return Scaffold(
        backgroundColor: UniColor.backGroundColor,
        floatingActionButton: customFloatingButton(
          onPressed: () {

          }, // place your function here
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top section
              _buildTopSection(
                  context: context,
                  ontrigger: () async {
                    // open dialog forn to add building
                    final isFromTrue = await addOrEditBuilding(context, null);
                    if (isFromTrue) {
                      showCustomSnackBar(context,
                          message: "Add building succesfully!",
                          backgroundColor: UniColor.green);
                    } else {
                      showCustomSnackBar(context,
                          message: "Add building failed!",
                          backgroundColor: UniColor.red);
                    }
                  }),

              // pass the function to return dialog in here
              // Bulidng screen with grid of building card list
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:380, // Maximum width of each grid item
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1 / 0.6, // 1 refer to width and o.75 refer to 75% of total width
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: buildingProvider.buildingList.length,
                      itemBuilder: (context, index) {

                        /// render data
                        final building = buildingProvider.buildingList[index];
                        BuildingInfo buildingInfo = buildingProvider.buildingInfo(building);

                        return InkWell(
                          onTap: () {
                            // Change the current selected building in RoomProvider in order for the room screeen rebuild with new building
                            final roomProvider = context.read<RoomProvider>();
                            roomProvider.setCurrentSelectedBuilding(building);
                            roomProvider.setDefaultRoom();
                            // note that /building/room the room widget will show roomProvider.currentSelectedBuilding to for data
                            Navigator.pushNamed(context, "/building/room");
                          },
                          child: BuildingCard(
                              building: building,
                              buildingInfo: buildingInfo,
                              onPressed: () {
                                onEditorDeleteDialog(context, building);
                              }
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Building list",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "View all of your buildings here",
              style: TextStyle(color: UniColor.neutral, fontSize: 12),
            ),
          ],
        ),
        UniButton(
            context: context,
            label: "Add building",
            trigger: ontrigger,
            buttonType: ButtonType.primary)
      ],
    ),
  );
}

