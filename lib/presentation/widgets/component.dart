import 'package:flutter/material.dart';

import '../theme/theme.dart';

void showCustomSnackBar(
    BuildContext context,{ required String message, required Color backgroundColor,
    Duration duration = const Duration(seconds: 2)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
     
      duration: duration,
    ),
  );
}

Widget label(String label,[double margin = 10]){
  return Container(
    margin:  EdgeInsets.symmetric(vertical: margin),
    child: Text(label,style: TextStyle(
      color: UniColor.neutral,
      fontSize: 14,
      fontWeight: FontWeight.bold
    ),),
  );
}

BoxShadow shadow() => BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(3, 3),
    );

Future<DateTime?> selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // Default to today
    firstDate: DateTime.now().subtract(const Duration(days: 90)), // 30 days in the past
    lastDate: DateTime.now().add(const Duration(days: 90)),
  );
  return pickedDate;
}

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
      borderSide: BorderSide(color: UniColor.neutralLight), // Default border color
      borderRadius: BorderRadius.circular(8)
    ),
      suffix: Text(suffix),
      labelText: label, 
      labelStyle: TextStyle(
        color: UniColor.neutral
      ),
      border:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: UniColor.neutralLight,width: 1),
      ),
      focusedBorder:  OutlineInputBorder(
        borderSide: BorderSide(color: UniColor.primary, width: 2.0),
        borderRadius: BorderRadius.circular(10)
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: UniColor.red, width: 2),
        borderRadius: BorderRadius.circular(10)
      ),
      floatingLabelStyle:TextStyle(color: UniColor.primary)
    ),
  );
}


Widget customFloatingButton({required VoidCallback onPressed}) {
  return SizedBox(
    width: 40,
    height: 44,
    child: FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(Icons.bookmark_add, color: Colors.white),
    ),
  );
}
// notification card
Widget notificationMessage(){
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      leading: CircleAvatar(radius: 13, backgroundColor: UniColor.iconNormal),
      title: RichText(
        text: const TextSpan(
            children:[
              TextSpan(
                  text: "Payment Request:",
                  style: TextStyle(
                      fontSize: 10
                  )
              ),
              TextSpan(
                  text: "Room A001, Building A1  Vanda",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold
                  )
              ),
            ]
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("2 m", style: TextStyle(fontSize: 10)),
          CircleAvatar(radius: 3, backgroundColor: UniColor.backGroundColor),
        ],
      ),
    ),
  );
}
