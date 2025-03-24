import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

class UniTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final String status;
  final String trailing;
  final VoidCallback onTap;

  const UniTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.trailing,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: icon
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(subtitle,
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(fontSize: 10,color: UniColor.yellow),
          ),
        ],
      ),
      trailing: Text(trailing,
        style: UniTextStyles.label
      ),
    );
  }
}