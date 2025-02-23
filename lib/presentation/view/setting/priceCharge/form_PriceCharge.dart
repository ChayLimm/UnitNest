import 'package:emonitor/data/model/system/priceCharge.dart';
import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool> showAddPriceCharge(BuildContext context) async {
  final system = Provider.of<System>(context, listen: false);

  double electricityPrice = 0;
  double waterPrice = 0;
  double parkingFee = 0;
  double hygieneFee = 0;
  double finePerDayPrice = 0;
  double fineStartOn = 5;
  
  // Show the dialog and wait for the result
  bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final GlobalKey<FormState> editKey = GlobalKey<FormState>();

   
      return SimpleDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            const Column(
              children: [
                Text(
                  "Add new price charge",
                  style: TextStyle(
                    fontSize: 18, // Use your h2 variable here
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "The new price charge will be applied after adding.",
                  style: TextStyle(fontSize: 14), // Use your p1 variable here
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context, false); // Pass false on close
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            width: 450,
            child: Center(
              child: Form(
                key: editKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: UniSpacing.s,),
                    label("Electricity"),
                    buildTextFormField(
                       validator: (value){
                         if (value == null || value.isEmpty) {
                              return "Electricity per day Price is required";
                            }
                            if (double.tryParse(value) == null) {
                              return "Must be digits";
                            }
                            return null; // Valid input
                       },
                      onChanged: (value){
                             if(double.tryParse(value!) != null){
                            electricityPrice = double.parse(value);
                          }                       
                      }
                      ),
                       label("Water"),
                    buildTextFormField(
                       validator: (value){
                         if (value == null || value.isEmpty) {
                              return "Water per day Price is required";
                            }
                            if (double.tryParse(value) == null) {
                              return "Must be digits";
                            }
                            return null; //
                       },
                      onChanged: (value){
                             if(double.tryParse(value!) != null){
                            waterPrice = double.parse(value);
                          }                       
                      }
                      ),
                       label("Parking Fee"),
                    buildTextFormField(
                       validator: (value){
                         if (value == null || value.isEmpty) {
                              return "Parking fee Price is required";
                            }
                            if (double.tryParse(value) == null) {
                              return "Must be digits";
                            }
                            return null; //
                       },
                      onChanged: (value){
                             if(double.tryParse(value!) != null){
                            parkingFee = double.parse(value);
                          }                       
                      }
                      ),
                       label("Hygiene Fee"),
                    buildTextFormField(
                       validator: (value){
                       if (value == null || value.isEmpty) {
                              return "Hygiene fee price is required";
                            }
                            if (double.tryParse(value) == null) {
                              return "Must be digits";
                            }
                            return null; //
                       },
                      onChanged: (value){
                             if(double.tryParse(value!) != null){
                            hygieneFee = double.parse(value);
                          }                       
                      }
                      ), label("Fine per day"),
                    buildTextFormField(
                       validator: (value){
                        if (value == null || value.isEmpty) {
                              return "fine per day Price is required";
                            }
                            if (double.tryParse(value) == null) {
                              return "Must be digits";
                            }
                            return null; //
                       },
                      onChanged: (value){
                             if(double.tryParse(value!) != null){
                           finePerDayPrice = double.parse(value);
                          }                       
                      }
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: UniColor.backGroundColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                secondaryButton(
                  context: context,
                  trigger: () {
                    Navigator.pop(context, false); 
                  },
                  label: "Cancel",
                ),
                const SizedBox(width: 10),

                primaryButton(
                  context: context,
                  trigger: () async {
                    if (editKey.currentState!.validate()) {
                      PriceCharge newPriceCharge = PriceCharge(electricityPrice: electricityPrice, waterPrice: waterPrice, hygieneFee: hygieneFee, finePerDay: finePerDayPrice, fineStartOn: fineStartOn, rentParkingPrice: parkingFee, startDate: DateTime.now());
                      await system.addPriceCharge(newPriceCharge);
                      Navigator.pop(context, true); 
                    } else {

                    }
                  },
                  label: "Done",
                ),
                
              ],
            ),
          ),
        ],
      );
    },
  );

  // Return the result after the dialog is closed
  return result ?? false; // Ensure it defaults to false if null
}
