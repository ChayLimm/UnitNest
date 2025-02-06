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

BoxShadow shadow() => BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(3, 3),
    );

void showCustomSnackBar(
    BuildContext context, String message, Color backgroundColor,
    {Duration duration = const Duration(seconds: 3)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: duration,
    ),
  );
}

Future<DateTime?> selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // Default to today
    firstDate: DateTime.now().subtract(Duration(days: 90)), // 30 days in the past
    lastDate: DateTime.now().add(Duration(days: 90)),
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
      borderSide: BorderSide(color: lightGrey), // Default border color
      borderRadius: BorderRadius.circular(8)
    ),
      suffix: Text(suffix),
      labelText: label, 
      labelStyle: const TextStyle(
        color: Color(0xFF757575)
      ),
      border:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: lightGrey,width: 1),
      ),
      focusedBorder:  OutlineInputBorder(
        borderSide: BorderSide(color: blue, width: 2.0),
        borderRadius: BorderRadius.circular(10)
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: red, width: 2),
        borderRadius: BorderRadius.circular(10)
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: color ?? blue, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ))),
    );
    Widget customFloatingButton({required VoidCallback onPressed}) {
  return Container(
    width: 40,
    height: 44,
    child: FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.bookmark_add, color: Colors.white),
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}
// notification card
Widget notificationMessage() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      leading: CircleAvatar(radius: 13, backgroundColor: darkGrey),
      title: RichText(
        text: TextSpan(
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
          Text("2 m", style: TextStyle(fontSize: 10)),
          CircleAvatar(radius: 3, backgroundColor: blue),
        ],
      ),
    ),
  );
}
