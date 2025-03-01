import 'package:emonitor/data/model/building/room.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'building.g.dart';


@JsonSerializable(explicitToJson: true)
class Building {
  final String id =  const Uuid().v4();
  String name;
  String address;
  int floorCount;
  int parkingSpace;
  List<Room> roomList = [];
  Building({required this.name, required this.address,this.floorCount = 0, this.parkingSpace = 0});

  factory Building.fromJson(Map<String, dynamic> json) => _$BuildingFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingToJson(this);

 
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Building && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

}