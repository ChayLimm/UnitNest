import 'package:emonitor/domain/model/stakeholder/landlord.dart';
import 'package:emonitor/presentation/Provider/Setting/setting_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool> showProfileEdit(BuildContext context, Landlord landlord) async {
  final settingProvider = Provider.of<SettingProvider>(context, listen: false);

  // Show the dialog and wait for the result
  bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final GlobalKey<FormState> editKey = GlobalKey<FormState>();

      String userName = landlord.username;
      String phoneNumber = landlord.phoneNumber;

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
                  "Change your profile",
                  style: TextStyle(
                    fontSize: 18, // Use your h2 variable here
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Change your username and phone number",
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
                    label("Username"),
                    buildTextFormField(
                      initialValue: userName,
                      onChanged: (value) {
                        userName = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username is required.";
                        }
                        return null;
                      },
                    ),
                    label("Phone Number"),
                    buildTextFormField(
                      initialValue: phoneNumber,
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required.";
                        }
                        return null;
                      },
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
                UniButton(
                  buttonType: ButtonType.secondary,
                  context: context,
                  trigger: () {
                    Navigator.pop(context, false); // Return false on cancel
                  },
                  label: "Cancel",
                ),
                const SizedBox(width: 10),

                UniButton(
                  buttonType: ButtonType.primary,
                  context: context,
                  trigger: () async {
                    if (editKey.currentState!.validate()) {
                      
                      settingProvider.updateProfile(userName, phoneNumber);
                      Navigator.pop(context, true); // Return true after success
                    } else {
                      Navigator.pop(context, false); // Return false if validation fails
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
