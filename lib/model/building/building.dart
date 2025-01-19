import 'package:emonitor/model/building/room.dart';
import 'package:uuid/uuid.dart';



class Building {
  final String id =  Uuid().v4();
  String name;
  String address;
  int floorCount;
  int parkingSpace;
  List<Room> roomList = [];
  Building({required this.name, required this.address,this.floorCount = 0, this.parkingSpace = 0});

}

