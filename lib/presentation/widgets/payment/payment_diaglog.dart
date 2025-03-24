import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/domain/model/building/room.dart';
import 'package:emonitor/domain/model/payment/payment.dart';
import 'package:emonitor/domain/service/payment_service.dart';
import 'package:emonitor/domain/service/room_service.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:emonitor/domain/service/telegram_service.dart';
import 'package:emonitor/presentation/Provider/main/building_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/Main/mainScreen.dart';
import 'package:emonitor/presentation/view/receipt/receipt_generator.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PaymentDialog extends StatefulWidget {
  Building? initBuilding;
  Room? initRoom;
  PaymentDialog({super.key,this.initBuilding,this.initRoom});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {

  final _formKey = GlobalKey<FormState>(); // Genera

  Building? selectedBuilding;
  Room? selectedRoom; 

  double electricityMeter = 0;
  double waterMeter = 0;

  bool lastPayment = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedBuilding = widget.initBuilding?? context.read<BuildingProvider>().buildingList.first;
  }

  @override
  Widget build(BuildContext context) {

    final buildingProvider = context.read<BuildingProvider>();

    return Dialog.fullscreen(
      child: 
      Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Container(
              margin:const EdgeInsets.only(top: 20),
              width: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Payment Details",style: UniTextStyles.heading,),
                  IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close,color: UniColor.primary,))
                ],),
                const SizedBox(
                  height: 24,
                )
                ,
                  Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label('Building'),
                          DropdownButtonFormField2<Building>(
                            onChanged: (value) {
                              setState(() {
                                selectedBuilding = value;
                                selectedRoom = null; // Reset selected room when building changes
                              });
                            },
                            value: selectedBuilding,
                            items: context.read<BuildingProvider>().buildingList
                                .map((item) => DropdownMenuItem<Building>(
                                      value: item,
                                      child: Text(item.name, style: UniTextStyles.body),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return "Please select a building";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label('Room'),
                          DropdownButtonFormField2<Room>(
                            onChanged: (value) {
                              setState(() {
                                selectedRoom = value;
                              });
                            },
                            value: selectedRoom,
                            items: RoomService.instance.unPaid(building: selectedBuilding!, dateTime: DateTime.now()).map((item) => DropdownMenuItem<Room>(
                                      value: item,
                                      child: Text(item.name, style: UniTextStyles.body),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return "Please select a room";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if(selectedRoom!=null)...[
                label("Tenant details"),
                 buildInfo("Username",selectedRoom!.tenant!.userName),
                 buildInfo("Contact",selectedRoom!.tenant!.contact),
                 buildInfo("Parking",selectedRoom!.tenant!.rentParking.toString()),
                 buildInfo("Current deposit",selectedRoom!.tenant!.deposit.toString()),
                ],

                const SizedBox(height: 10,),
                label("Electicity"),
                buildTextFormField(onChanged: (value){
                  electricityMeter = double.parse(value);
                }, validator: (value){
                  if(value == null || value.isEmpty){
                    return "Electricity is required";
                  }
                  return null;
                }),
                const SizedBox(height: 10,),
                label("Water"),
                buildTextFormField(onChanged: (value){
                  waterMeter = double.parse(value);
                }, validator: (value){
                  if(value == null || value.isEmpty){
                    return "Electricity is required";
                  }
                  return null;
                }),
                const SizedBox(height: 10,),
                label("Last payment"),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: lastPayment? UniColor.primary : UniColor.neutralLight
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTile(
                      leading: Text("Last Payment",style: UniTextStyles.body.copyWith(color: lastPayment? UniColor.primary : null),),
                      trailing: Checkbox(
                        activeColor: UniColor.primary,
                        value: lastPayment,
                        onChanged: (value) {
                          setState(() {
                            lastPayment = value!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          lastPayment = !lastPayment;
                        });
                      },
                    ),
                ),
                const SizedBox(height: 10,),
                Text("Room price and parking wont be charge",style: UniTextStyles.body,),
                const SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UniButton(context: context, label: "Cancel", trigger: (){
                      Navigator.pop(context);
                    }, buttonType: ButtonType.secondary),
            
                     UniButton(context: context, label: "Confirm", trigger: ()async{
                      if(_formKey.currentState!.validate()) {
                        //perform the payment
                        Consumption newConsumption = Consumption(waterMeter: waterMeter, electricityMeter: electricityMeter);
                        
                        Payment newPayment = await PaymentService.instance.proccessPayment(selectedRoom!.tenant!.chatID,newConsumption,lastPayment);
                       
                        final Uint8List? pngbyte = await Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ShowReceiptDialog(payment: newPayment);
                        }));

                            // Null checker
                      if(pngbyte == null || pngbyte.isEmpty){
                        ///reject
                        Navigator.pop(context,false);
                      }else{
                        // approve
                        print("Upladoing image to cloude");
                        String? recieptURL = await RootDataService.uploadImageToFirebaseStorage(pngbyte);
                        if(recieptURL != null){
                        print("Reciept URL = $recieptURL");
                        newPayment.receipt = recieptURL;
                        selectedRoom!.paymentList.add(newPayment);
                        print("approve payment success");

                        TelegramService.instance.sendReceipt(selectedRoom!.tenant!.chatID, newPayment.receipt!, "Payment is due on 5/${DateTime.now().month}/${DateTime.now().year}");
                        buildingProvider.refresh();
                        buildingProvider.repository.synceToCloud();
                        Navigator.push(context,MaterialPageRoute(builder: (context){
                          return Mainscreen();
                        }));
                        }else{
                          print("In Notification service, reciept url is null");
                        }
                      }
                      }
                    }, buttonType: ButtonType.primary)
                  ],
                )
                

              ],),
            ),
          ),
        )
      ),
    );
  }
}

Widget buildInfo(String label, String data){
  return Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label,style: UniTextStyles.label,),
      Text(data,style: UniTextStyles.body,),
   ],
  );
}