import 'package:emonitor/domain/model/building/building.dart';
import 'package:emonitor/presentation/Provider/main/building_provider.dart';
import 'package:emonitor/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

class BuildingCard extends StatelessWidget {
  final BuildingInfo buildingInfo;
  final Building building;
  final VoidCallback onPressed;

  BuildingCard({
    required this.building,
    required this.buildingInfo,
    required this.onPressed,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: UniColor.neutralLight),
        color: UniColor.white
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/Bulidng.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                            building.name,
                            style: UniTextStyles.body,
                          ),
                      subtitle:  Row(children: [
                        Icon(Icons.location_on,color: UniColor.primary, size: 12),
                        Text(building.address, style: UniTextStyles.body.copyWith(fontSize: 12)),
                      ],
                    ),
                    trailing: IconButton(onPressed: onPressed,
                            icon: const Icon(Icons.more_horiz, size: 24),
                      ),
                    ),
                   
                   
                    Row(
                      children: [
                        _buildBadge("${buildingInfo.availableRoom}. available", false),
                        const SizedBox(width: 8),
                        _buildBadge("${buildingInfo.totalRoom} Rooms", true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow("Floor         : ",buildingInfo.floorCount.toString()),
          _buildDetailRow("Parking space :", buildingInfo.parkingSpace.toString()),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, bool isPrimary) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPrimary ? UniColor.primary : Colors.transparent,
        border: Border.all(color: UniColor.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: isPrimary ? Colors.white : UniColor.primary,
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: UniTextStyles.body),
          Text(value,style: UniTextStyles.label),
        ],
      ),
    );
  }
}
