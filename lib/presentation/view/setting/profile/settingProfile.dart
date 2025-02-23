import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/setting/profile/edit.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/infoCard/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingProfile extends StatelessWidget {
  const SettingProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<System>(builder: (context, system, child) {
      return Container(
        width: 600,
        color: UniColor.white,
        padding: const EdgeInsets.only(left: 40, right: 40, top: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            label("Profile Picture"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //profile image
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: UniColor.neutral,
                      borderRadius: BorderRadius.circular(40)),
                ),
                InkWell(
                  hoverColor: UniColor.neutralLight,
                  onTap: () async {
                    if (await showProfileEdit(context, system.landlord)) {
                      showCustomSnackBar(context,
                          message: "message", backgroundColor: UniColor.green);
                    } else {
                      showCustomSnackBar(context,
                          message: "message", backgroundColor: UniColor.red);
                    }
                    ;
                  },
                  child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: UniColor.primary, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Edit Profile",
                        style: UniTextStyles.button,
                      ))),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),

            //wrap profile info
            InfoCard(items: [
              InfoItem(label: "User", value: system.landlord.username),
              InfoItem(label: "Phone Number", value: system.landlord.phoneNumber),
            ]),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Your phone number will be display in your tenant's receipts",
              style: UniTextStyles.body,
            )
          ],
        ),
      );
    });
  }
}
