import 'package:emonitor/domain/model/system/priceCharge.dart';
import 'package:emonitor/presentation/Provider/Setting/setting_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/button/button.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceChargeFormDialog extends StatefulWidget {
  @override
  _PriceChargeFormDialogState createState() => _PriceChargeFormDialogState();
}

class _PriceChargeFormDialogState extends State<PriceChargeFormDialog> {
  double electricityPrice = 0;
  double waterPrice = 0;
  double rentParkingPrice = 0;
  double hygieneFee = 0;
  double finePerDayPrice = 0;
  double fineStartOn = 5;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Add New Price Charge",style: UniTextStyles.heading,),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label("Electricity"),
                buildTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Electricity per day Price is required";
                    }
                    if (double.tryParse(value) == null) {
                      return "Must be digits";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (double.tryParse(value) != null) {
                      setState(() {
                        electricityPrice = double.parse(value);
                      });
                    }
                  },
                ),
                label("Water"),
                buildTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Water per day Price is required";
                    }
                    if (double.tryParse(value) == null) {
                      return "Must be digits";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (double.tryParse(value!) != null) {
                      setState(() {
                        waterPrice = double.parse(value);
                      });
                    }
                  },
                ),
                label("Parking Fee"),
                buildTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Parking fee Price is required";
                    }
                    if (double.tryParse(value) == null) {
                      return "Must be digits";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (double.tryParse(value!) != null) {
                      setState(() {
                        rentParkingPrice = double.parse(value);
                      });
                    }
                  },
                ),
                label("Hygiene Fee"),
                buildTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Hygiene fee price is required";
                    }
                    if (double.tryParse(value) == null) {
                      return "Must be digits";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (double.tryParse(value!) != null) {
                      setState(() {
                        hygieneFee = double.parse(value);
                      });
                    }
                  },
                ),
                label("Fine per day"),
                buildTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Fine per day Price is required";
                    }
                    if (double.tryParse(value) == null) {
                      return "Must be digits";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (double.tryParse(value!) != null) {
                      setState(() {
                        finePerDayPrice = double.parse(value);
                      });
                    }
                  },
                ),
                label("Fine Start On"),
                UniButton(
                  context: context,
                  label: "${fineStartOn.toInt()}/${DateTime.now().month}/${DateTime.now().year}",
                  trigger: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2025, 1, 1),
                      lastDate: DateTime(2025, 12, 31),
                      initialDate: DateTime.now(),
                    );
                    setState(() {
                      fineStartOn = selectedDate?.day.toDouble() ?? 5;
                    });
                  },
                  buttonType: ButtonType.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
       Row(mainAxisAlignment: MainAxisAlignment.end,
        children: [
         
        UniButton(context: context, label: "Cancel", trigger: (){
                    Navigator.of(context).pop(false);

      }, buttonType: ButtonType.secondary) ,
      UniButton(context: context, label: "Save", trigger: ()async {
            if (_formKey.currentState?.validate() ?? false) {
              PriceCharge pricecharge = PriceCharge(
                electricityPrice: electricityPrice,
                waterPrice: waterPrice,
                hygieneFee: hygieneFee,
                finePerDay: finePerDayPrice,
                fineStartOn: fineStartOn,
                rentParkingPrice: rentParkingPrice,
                startDate: DateTime.now(),
              );
              final settingProvider = context.read<SettingProvider>();
              await settingProvider.addPriceCharge(pricecharge);
              Navigator.of(context).pop(true);
            } else {
              Navigator.of(context).pop(false);
            }
          }, buttonType: ButtonType.primary), 
       ],)
      ],
    );
  }
}

Future<bool> showDialogForm(BuildContext context) async {
  bool result = await showDialog(
    context: context,
    builder: (context) {
      return PriceChargeFormDialog();
    },
  );
  return result;
}
