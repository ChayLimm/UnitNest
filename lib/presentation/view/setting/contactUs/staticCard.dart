import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StaticCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String email;
  final IconData icon;

  StaticCard({
    required this.title,
    required this.subtitle,
    required this.email,
    this.icon = Icons.chat_bubble_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: UniColor.iconNormal,size: 18,),
            ],
          ),
         const SizedBox(height: UniSpacing.s),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
         const SizedBox(height: 8.0),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {},
            child: Text(
              email,
              style: TextStyle(
                fontSize: 12.0,
                color: UniColor.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}