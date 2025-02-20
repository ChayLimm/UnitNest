import 'package:emonitor/data/model/system/system.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/widgets/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceChargeSetting extends StatelessWidget {
  const PriceChargeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<System>(builder : (context,system,child){
      return Container(
        width: 600,
        color: UniColor.white,
        padding: const EdgeInsets.only(left: 40, right: 40, top: 70),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          //header
          Text("Price Charge",style: UniTextStyles.heading,)
        ],),
      );
    });
  }
}