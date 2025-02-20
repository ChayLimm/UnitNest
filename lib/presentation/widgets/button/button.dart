import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

Widget secondaryButton(
        {required BuildContext context,
        required VoidCallback trigger,
        required String label,
       }) =>
    InkWell(
      hoverColor: UniColor.white,
      splashColor: UniColor.white,
      onTap:trigger
      ,
      child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: UniColor.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Center(
              child: Text(
            label,
            style:  TextStyle(color: UniColor.primary),
          ))),
    );
    
Widget primaryButton(
        {required BuildContext context,
        required VoidCallback trigger,
        required String label,
        Color? color}) =>
    InkWell(
      hoverColor: UniColor.white,
      splashColor: UniColor.white,
      onTap:trigger
      ,
      child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: color ?? UniColor.primary, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            label,
            style:  UniTextStyles.button,
          ))),
    );