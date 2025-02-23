import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final List<InfoItem> items;
  late Color? backgroundColor;
  late Color? borderColor;

  InfoCard({
    required this.items,
    this.backgroundColor,
    this.borderColor ,
  }){
    borderColor = UniColor.neutralLight;
    backgroundColor = UniColor.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: borderColor!),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.expand((item) => [
                  Text(item.label,
                      style: UniTextStyles.body.copyWith(
                        color: UniColor.neutral,
                      )),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.value,
                      style: UniTextStyles.body,
                    ),
                  ),
                  if (items.last != item)
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          color: UniColor.neutralLight,
                        )),
                ])
            .toList(),
      ),
    );
  }
}

class InfoItem {
  final String label;
  final String value;

  InfoItem({required this.label, required this.value});
}
