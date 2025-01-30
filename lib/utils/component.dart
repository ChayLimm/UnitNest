import 'package:flutter/material.dart';

Color red = const Color(0xFFEC5665);
Color yellow = const Color(0xFFF8A849);
Color green = const Color(0xFF4FAC80);
Color grey = const Color(0xFFF8F8F8);
Color blue = const Color(0xFF4A90E2);
Color lightGrey = const Color(0xFFD4D4D4);
Color darkGrey = const Color(0xFF6F6F6F);
Color white =  const Color(0xFFFFFFFF);
Color black =  const Color(0xFF000000);

double h = 32;
double h1 = 22;
double h2 = 18;
double p1 = 12;
double p2 =10;

TextFormField buildTextFormField({
  String? label,
  String? initialValue,
  String suffix = " ",
  required Function(String) onChanged,
  required String? Function(String?) validator,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    initialValue: initialValue,
    onChanged: onChanged,
    validator: validator,
    keyboardType: keyboardType,
    decoration: InputDecoration(    
      enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: lightGrey), // Default border color
      borderRadius: BorderRadius.circular(8)
    ),
      suffix: Text(suffix),
      labelText: label, 
      labelStyle: const TextStyle(
        color: Color(0xFF757575)
      ),
      border:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightGrey,width: 1),
      ),
      focusedBorder:  OutlineInputBorder(
        borderSide: BorderSide(color: blue, width: 2.0),
        borderRadius: BorderRadius.circular(8)
      ),
      floatingLabelStyle:TextStyle(color: blue)
    ),
  );
}

Widget customeButton(
        {required BuildContext context,
        required VoidCallback trigger,
        required String label,
        Color? color}) =>
    GestureDetector(
      onTap: () {
        trigger;
      },
      child: Container(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: color ?? blue, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ))),
    );
