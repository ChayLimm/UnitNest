import 'package:emonitor/data/model/stakeholder/landlord.dart';
import 'package:emonitor/data/model/system/priceCharge.dart';
import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/setting/priceCharge/priceChargeSetting.dart';
import 'package:emonitor/presentation/view/setting/profile/settingProfile.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  final Landlord landlord;
  Setting({super.key, required this.landlord});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int currentPage = 0;


  @override
  Widget build(BuildContext context) {
    return Consumer<System>(builder: (context,system,child){
      return  Scaffold(
      //background
     body: Container(
      color: UniColor.white,
      alignment: Alignment.center,
      //setting widget
       child: Container(
        color: UniColor.white,
        width: 1400,
         child: Row(
          children: [
            // drawer
            Expanded(
              flex: 50,
              child: Container(
                padding: const EdgeInsets.only(top : 70,left: 200,right: 20),
                color: UniColor.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header("Settings"),
                    const SizedBox(height: 16,),
                    label("Account Settings"),
                  Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentPage == 0 ? UniColor.backGroundColor : UniColor.white,
                              ),
                              child: customListTile("Profile", Icons.account_circle, () {
                              setState(() {
                                currentPage = 0;
                              });
                            }),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currentPage == 1 ? UniColor.backGroundColor : UniColor.white,
                          ),
                            child:
                        customListTile("Password & Security", Icons.lock, () {
                        setState(() {
                          currentPage = 1;
                        });
                      }),
                    ),
                    label("System Settings"),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentPage == 2 ? UniColor.backGroundColor : UniColor.white,
                      ),
                      child: customListTile("Price Charge", Icons.price_change, () {
                        setState(() {
                          currentPage = 2;
                        });
                      }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentPage == 3 ? UniColor.backGroundColor : UniColor.white,
                      ),
                      child: customListTile("Account Banking", Icons.qr_code_scanner, () {
                        setState(() {
                          currentPage = 3;
                        });
                      }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentPage == 4 ? UniColor.backGroundColor : UniColor.white,
                      ),
                      child: customListTile("Rules", Icons.description, () {
                        setState(() {
                          currentPage = 4;
                        });
                      }),
                    ),
                    label("Other"),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentPage == 5 ? UniColor.backGroundColor : UniColor.white,
                      ),
                      child: customListTile("Contact Us", Icons.phone_in_talk, () {
                        setState(() {
                          currentPage = 5;
                        });
                      }),
                    ),

                  ],
                ),
                )
              ),
            Container(
              color: UniColor.neutralLight,
              width: 1,
            )
              ,
            // setting info
            Expanded(
              flex: 90,
              child: Container(
                color: UniColor.white,
                child: IndexedStack(
                  index: currentPage,
                  children: [
                    SettingProfile(),
                    Center(child: Text("data2"),),
                    PriceChargeSetting(),
                    Center(child: Text("data4"),),
                    Center(child: Text("data5"),),
                    Center(child: Text("data6"),),
                  ],
                ),
                )
                ),
          ],
          ),
       ),
     )
    );
 
    });
    
    
   
  }

 Widget customListTile(String title, IconData icon, VoidCallback trigger) {
  return ListTile(
        onTap: trigger,
        hoverColor: UniColor.backGroundColor,
        leading: Icon(icon, size: 18),
        title: Text(title, style: UniTextStyles.body),
        trailing: const Icon(Icons.arrow_forward_ios, size: 13),
  );
}


  Widget header(String title){
    return Column(
      children: [
        Row(
          children: [
             Icon(Icons.arrow_back_ios,size: 16,color: UniColor.neutral,),
            const SizedBox(width: 10,),
            Text(title,style: UniTextStyles.heading),
          ],
        ),
        Divider(
          color: UniColor.neutralLight,
        )
      ],
    );
  }
}