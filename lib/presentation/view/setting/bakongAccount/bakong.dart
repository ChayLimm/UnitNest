import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/model/stakeholder/landlord.dart';
import 'package:emonitor/data/repository/khqr/bakong_KHQR.dart';
import 'package:emonitor/presentation/Provider/Setting/setting_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:emonitor/presentation/widgets/form/dialogForm.dart';
import 'package:emonitor/presentation/widgets/infoCard/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bakong_khqr/view/bakong_khqr.dart';
import 'package:provider/provider.dart';

class Bakong extends StatelessWidget {
  Future<TransactionKHQR> requestKHQR(
      BakongAccount bakongAccount, double amount) async {
    return BakongKhqrImpl().requestKHQR(bakongAccount, amount);
  }

  Future<void> onDone() async {}

  ///
  /// Dialog
  ///
  Future<bool> editBakong(BuildContext context) async {
    final settingProvider = context.read<SettingProvider>();
    //for form edit
    String newBakongAccountID = settingProvider.setting.bakongAccount.bakongID;
    String newBakongAccountLocation = settingProvider.setting.bakongAccount.location;
    String newBakongAccountName = settingProvider.setting.bakongAccount.username;

    final isFromTrue = await uniForm(
      context: context,
      title: "Edit Bakong Account Info",
      subtitle: "Set up your Bakong account",
      onDone: onDone,
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Account ID"),
          buildTextFormField(
            initialValue: newBakongAccountID,
            onChanged: (value) {
              newBakongAccountID = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Account ID is required";
              } else {
                return null;
              }
            },
          ),
          label("Username"),
          buildTextFormField(
            initialValue: newBakongAccountName,
            onChanged: (value) {
              newBakongAccountName = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Username ID is required";
              } else {
                return null;
              }
            },
          ),
          label("Locaiton "),
          buildTextFormField(
            initialValue: newBakongAccountLocation,
            onChanged: (value) {
              newBakongAccountLocation = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Location ID is required";
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );

    if (isFromTrue) {
      BakongAccount newBakongAccount = BakongAccount(
          bakongID: newBakongAccountID,
          username: newBakongAccountName,
          location: newBakongAccountLocation);
      await settingProvider.updateBakongAccount(newBakongAccount);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
        builder: (context, settingProvider, child) {
      final BakongAccount bakongAccount = settingProvider.setting.bakongAccount;

      return Row(
        children: [
          //Bakong Info
          Expanded(
            flex: 57,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 70,
                left: 40,
                right: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Bakong Account",
                      style: UniTextStyles.heading,
                    ),
                    subtitle: Text(
                      "View your bakong account here",
                      style: UniTextStyles.body,
                    ),
                    trailing: SizedBox(
                      width: 60,
                      child: UniButton(
                        buttonType: ButtonType.secondary,
                          context: context,
                          label: "Edit ",
                          trigger: () async {
                            final isFromTrue = await editBakong(context);
                            isFromTrue
                                ? showCustomSnackBar(context,
                                    message: "Update Successfully",
                                    backgroundColor: UniColor.green)
                                : showCustomSnackBar(context,
                                    message: "Update Successfully",
                                    backgroundColor: UniColor.red);
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: UniSpacing.xl,
                  ),
                  InfoCard(items: [
                    InfoItem(
                        label: "Account ID", value: bakongAccount.bakongID),
                    InfoItem(label: "Username", value: bakongAccount.username),
                    InfoItem(label: "Location", value: bakongAccount.location),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Support payment with : ",
                        style: UniTextStyles.label,
                      ),
                      const Image(
                        image: AssetImage(
                          'assets/images/khqr.png',
                        ),
                        height: 24,
                        width: 50,
                      )
                    ],
                  ),
                  Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: UniSpacing.s),
                      child: Divider(
                        color: UniColor.neutralLight,
                      )),
                  Text(
                    "Please ensure your Bakong KHQR details are correct.\nThis info will be used to generate payment QR codes for your tenants.",
                    style: UniTextStyles.body.copyWith(color: UniColor.neutral),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: UniColor.neutralLight,
            width: 1,
          ),
          //KHQR
          Expanded(
              flex: 32,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 70,
                  left: 20,
                  right: 20,
                ),
                child: FutureBuilder<TransactionKHQR>(
                  future: requestKHQR(bakongAccount, 0.1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return Center(
                        child:
                            //Call bakong API
                            BakongKhqrView(
                                merchantName: bakongAccount.username,
                                amount: "0",
                                qrString: snapshot.data!.qr),
                      );
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  },
                ),
              ))
        ],
      );
    });
  }
}
