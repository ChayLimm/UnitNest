import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/presentation/Provider/Setting/setting_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:emonitor/presentation/widgets/infoCard/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class PriceChargeSetting extends StatefulWidget {
  const PriceChargeSetting({super.key});

  @override
  State<PriceChargeSetting> createState() => _PriceChargeSettingState();
}

class _PriceChargeSettingState extends State<PriceChargeSetting> {
  DateTime currentPriceCharge = DateTime.now();
  int? selectedIndex;


  ///
  /// Event trigger
  /// 
  Future<void> onDone() async{
   
    return;
  }

  ///
  /// Dialog 
  /// 
  Future<bool> showDialogForm(BuildContext context) async{
      ///
      /// Init data for add form;
      ///
      double electricityPrice = 0;
      double waterPrice = 0;
      double rentParkingPrice = 0;
      double hygieneFee = 0;
      double finePerDayPrice = 0;
      double fineStartOn = 5;

     final isFormTrue = await uniForm(
        context: context, 
        title: "Add New Price Charge", 
        subtitle: "Set up your monthly price charge", 
        onDone: onDone,
        form: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            rentParkingPrice = double.parse(value);
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
            )
          ],
        ), 
    );
 
      if(isFormTrue){
        PriceCharge pricecharge = PriceCharge(electricityPrice: electricityPrice, waterPrice: waterPrice, hygieneFee: hygieneFee, finePerDay: finePerDayPrice, fineStartOn: fineStartOn, rentParkingPrice: rentParkingPrice, startDate: DateTime.now());
        final settingProvider = context.read<SettingProvider>();
        await settingProvider.addPriceCharge(pricecharge);
        return true;
      }else{
        return false;
      }

  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, settingProvider, child) {

      PriceCharge priceCharge = selectedIndex == null
          ? settingProvider.setting.priceChargeList
              .last // Default to latest price charge
          : settingProvider.setting.priceChargeList[selectedIndex!];

      bool isValid = priceCharge.endDate == null;

      String formattedStartDate =DateFormat('dd/MM/yyyy').format(priceCharge.startDate);
          
      String formattedEndDate = isValid
          ? "Null"
          : DateFormat('dd/MM/yyyy').format(priceCharge.endDate!);


      return Container(
          color: UniColor.white,
          child: Row(
            children: [
              //left
              Expanded(
                flex: 57,
                child: Container(
                 padding:const EdgeInsets.only(top: 70,left: 40,right: 40,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //header
                      ListTile(
                        
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Price Charge",
                          style: UniTextStyles.heading,
                        ),
                        subtitle: Text(
                          "Set up your price charge here",
                          style: UniTextStyles.body,
                        ),
                        trailing: SizedBox(
                          width: 60,
                          height: 44,
                          child: UniButton(
                            buttonType: ButtonType.primary,
                              context: context,
                              trigger: () async {
                               final formIsTrue = await showDialogForm(context);
                               formIsTrue ? showCustomSnackBar(context, message: "Updated Successfully", backgroundColor: UniColor.green)
                                          : showCustomSnackBar(context, message: "Updated Failed", backgroundColor: UniColor.red);
                              },
                              label: "Add"),
                        ),
                      ),
                      const SizedBox(
                        height: UniSpacing.xl,
                      ),
                     
                      
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Start Date $formattedStartDate",
                            style: UniTextStyles.label),
                        subtitle: Text("End Date : $formattedEndDate",
                            style: UniTextStyles.body),
                        trailing: Text(
                          isValid ? "Valid" : "Invalid",
                          style: UniTextStyles.label.copyWith(
                            color: isValid ? UniColor.green : UniColor.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: UniSpacing.s,
                      ),
                      InfoCard(items: [
                        InfoItem(
                            label: "Electricity",
                            value: "${priceCharge.electricityPrice}"),
                        InfoItem(
                            label: "Water",
                            value: "\$ ${priceCharge.waterPrice} "),
                        InfoItem(
                            label: "Parking",
                            value: "\$ ${priceCharge.rentParkingPrice} "),
                        InfoItem(
                            label: "Hygiene",
                            value: "\$ ${priceCharge.hygieneFee} "),
                        InfoItem(
                            label: "Fine Per day",
                            value: "\$ ${priceCharge.finePerDay}"),
                        InfoItem(
                            label: "Fine start on", value: "${priceCharge.finePerDay.toInt()} / ${DateTime.now().month} / ${DateTime.now().year}"),
                      ])
                    ],
                  ),
                ),
              ),
              Container(
                color: UniColor.neutralLight,
                width: 1,
              ),
              ///right
              Expanded(
                  flex: 32,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 70, left: 20, right: 20),
                    child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "History",
                              style: UniTextStyles.heading,
                            ),
                            const SizedBox(
                              height: UniSpacing.s,
                            ),
                            DataTable(
                              showCheckboxColumn: false,
                              columnSpacing: 7,
                              dataTextStyle: UniTextStyles.body,
                              columns: [
                                DataColumn(
                                    label: Text("Start",
                                        style: UniTextStyles.label
                                            .copyWith(color: UniColor.neutral))),
                                DataColumn(
                                    label: Text("End",
                                        style: UniTextStyles.label
                                            .copyWith(color: UniColor.neutral))),
                                DataColumn(
                                    label: Text("Status",
                                        style: UniTextStyles.label
                                            .copyWith(color: UniColor.neutral))),
                              ],
                              rows: List.generate(
                                  settingProvider.setting.priceChargeList.length,
                                  (index) {
                                int reversedIndex = settingProvider.setting.priceChargeList.length - 1 - index;
                                var item = settingProvider.setting .priceChargeList[reversedIndex];
                        
                                return DataRow(
                                          
                                  selected: selectedIndex == reversedIndex, // Highlights selected row
                                  onSelectChanged: (value) {
                                    setState(() {
                                      selectedIndex = reversedIndex;
                                      currentPriceCharge = item.startDate; // Update selection
                                      print("Selected date: $currentPriceCharge");
                                    });
                                  },
                                  cells: [
                                  
                                    DataCell(Text(DateFormat('dd/MM/yyyy')
                                        .format(item.startDate))),
                                    DataCell(Text(
                                      item.endDate == null ? "Null" : DateFormat('dd/MM/yyyy').format(item.endDate!),
                                      style: UniTextStyles.body,
                                    )),
                                    DataCell(Text(
                                      item.endDate == null ? "Valid" : "Invalid",
                                      style: UniTextStyles.body.copyWith(
                                          color: item.endDate == null ? UniColor.green : UniColor.red),
                                    )),
                                   
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                    ),
                  )
                )
            ],
          ));
    });
  }
}
