import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';


Widget buildPaymentStatusCard(String label,int data,[Color? color]) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    width: 200,
    decoration: BoxDecoration(color: UniColor.white, borderRadius: BorderRadius.circular(10)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: UniTextStyles.label
            ),
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: color?? UniColor.neutral
                    ),
                child: Icon(
                  Icons.bed,
                  color: UniColor.white,
                  size: 15,
                ))
          ],
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: data.toString(),
                style: UniTextStyles.label.copyWith(color: Colors.black)),
            TextSpan(
                text: " rooms",
                style: UniTextStyles.body.copyWith(color: UniColor.neutral)),
          ]),
        ),
      ],
    ),
  );
}

// from chaylim




