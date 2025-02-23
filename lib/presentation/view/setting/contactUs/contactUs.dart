import 'package:emonitor/presentation/theme/theme.dart';
import 'package:emonitor/presentation/view/setting/contactUs/staticCard.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: 40,right: 40, top: 70),
    child: Container(
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Contact Us", style: UniTextStyles.heading,),
            subtitle: Text("Email, Call or complete the form to learn how\nUnitNest can solve your problem", style: UniTextStyles.body,),
          ),
          const SizedBox(height: UniSpacing.xl,),
          StaticCard(title: "Chat to sale",subtitle: "talk to our friendly team",email: "UnitNestOffical@gmail.com",icon: Icons.call,),
                    const SizedBox(height: UniSpacing.s,),

          StaticCard(title: "Chat to user",subtitle: "We're here to help",email: "UnitNestOffical@gmail.com",icon: Icons.chat_bubble_outline,),
                              const SizedBox(height: UniSpacing.s,),

          StaticCard(title: "Visit Us",subtitle: "Visit our office",email: "UnitNestOffical@gmail.com",icon: Icons.pin_drop_outlined,),
             
            ],
          )
      
    ),);
  }
}