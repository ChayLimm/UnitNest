import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/presentation/Provider/Setting/setting_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/setting/priceCharge/widget/add_price_form.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
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
                            label: "Fine start on", value: "${priceCharge.fineStartOn.toInt()} / ${DateTime.now().month} / ${DateTime.now().year}"),
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
                    
                        child: 
                        Column(
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
                    
                  )
                )
            ],
          ));
    });
  }
}
