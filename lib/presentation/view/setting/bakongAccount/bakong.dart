import 'package:emonitor/data/model/payment/transaction.dart';
import 'package:emonitor/data/model/stakeholder/landlord.dart';
import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/data/repository/khqr/bakong_KHQR.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:emonitor/presentation/widgets/infoCard/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bakong_khqr/view/bakong_khqr.dart';
import 'package:provider/provider.dart';

class Bakong extends StatefulWidget {
  const Bakong({super.key});

  @override
  State<Bakong> createState() => _BakongState();
}

class _BakongState extends State<Bakong> {

    String newBakongAccountID = " ";
    String newBakongAccountLocation = " ";
    String newBakongAccountName = " ";

  Future<TransactionKHQR> requestKHQR (BakongAccount bakongAccount) async {
    return  BakongKhqrImpl().requestKHQR(bakongAccount,0.1);
  }

  Future<void> onDone() async {
    final system = Provider.of<System>(context,listen: false);
    BakongAccount newBakongAccount = BakongAccount(bakongID: newBakongAccountID, username: newBakongAccountName, location: newBakongAccountLocation);
    await system.updateBakongAccount(newBakongAccount);
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<System>(builder : (context,system,child) {
      final BakongAccount bakongAccount = system.landlord.settings!.bakongAccount;
      return  Row(
          children: [
            //Bakong Info
            Expanded(
              flex: 57,
              child: Padding(
               padding:const EdgeInsets.only(top: 70,left: 40,right: 40,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text("Bakong Account",style: UniTextStyles.heading,),
                      subtitle:  Text("View your bakong account here",style: UniTextStyles.body,),
                      trailing: SizedBox(
                        width: 50,
                        child: secondaryButton(context: context, label: "Edit", trigger: () async{
                         
                          if(await showFormDialog(
                            context: context, 
                            title: "Edit Bakong Account Info", 
                            subtitle: "Set up your Bakong account", 
                            onDone: onDone,
                            form: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                label("Account ID"),
                                buildTextFormField(
                                  initialValue: bakongAccount.bakongID,
                                  onChanged: (value){
                                    newBakongAccountID = value;
                                  }, 
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Account ID is required";
                                    }else{
                                      return null;
                                    }
                                  },
                                  ),
                                   label("Username"),
                                buildTextFormField(
                                  initialValue: bakongAccount.username,
                                  onChanged: (value){
                                    newBakongAccountName = value;
                                  }, 
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Username ID is required";
                                    }else{
                                      return null;
                                    }
                                  },
                                  ), label("Locaiton "),
                                buildTextFormField(
                                  initialValue:  bakongAccount.location,
                                  onChanged: (value){
                                    newBakongAccountLocation = value;
                                  }, 
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Location ID is required";
                                    }else{
                                      return null;
                                    }
                                  },
                                  ),
                              ],
                            ), 
                            )
                        ){
                          showCustomSnackBar(context, message: "Updated Successfully", backgroundColor: UniColor.green);
                        }else{
                           showCustomSnackBar(context, message: "Update Failed", backgroundColor: UniColor.red);
                        }
                        
                        }),
                      ),
                    ),
                    const SizedBox(height: UniSpacing.xl,),
                    InfoCard(items: [
                      InfoItem(label: "Account ID", value: bakongAccount.bakongID),
                      InfoItem(label: "Username", value: bakongAccount.username),
                      InfoItem(label: "Location", value: bakongAccount.location),
                    ]),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Support payment with : ",style: UniTextStyles.label,),
                        const Image(
                          image: AssetImage('assets/images/khqr.png',),
                          height: 24,
                          width: 50,
                
                          )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: UniSpacing.s),
                      child: Divider(color: UniColor.neutralLight,))
                    ,
                    Text("Please ensure your Bakong KHQR details are correct.\nThis info will be used to generate payment QR codes for your tenants.",
                    style: UniTextStyles.body.copyWith(color: UniColor.neutral),)
                  ],
                ),
              ),
            ),
             Container(
              color: UniColor.neutralLight,
              width: 1,
             )
            ,
            //KHQR
            Expanded(
              flex: 32,
              child: Padding(
                 padding:const EdgeInsets.only(top: 70,left: 20,right: 20,),
                  child:FutureBuilder<TransactionKHQR>(
                      future: requestKHQR(bakongAccount),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          return Center(
                          child: 
                          //Call bakong API
                          BakongKhqrView(merchantName: bakongAccount.bakongID, amount: "0", qrString: snapshot.data!.qr),
                        );
                        } else {
                          return const Center(child: Text('No data available'));
                        }
                      },
                    ),
            )) 
          ],
        );}
      
      );
  }
}
 