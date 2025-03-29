import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'notification.g.dart'; // Include the generated file


///
/// declare enum
///

enum NotificationType {
  @JsonValue("registration")
  registration("registration"),

  @JsonValue("paymentRequest")
  paymentRequest("paymentRequest");

  final String status;
  const NotificationType(this.status);
}

enum NotificationStatus {
  @JsonValue("pending")
  pending("pending"),

  @JsonValue("aprrove")
  aprrove("aprrove"),

  @JsonValue("reject")
  reject("reject");

  final String status;
  const NotificationStatus(this.status);
}


@JsonSerializable(explicitToJson: true)
class NotificationList{
  final String id = Uuid().v4();
   List<UniNotification?> listNotification;
  NotificationList(this.listNotification);

  factory NotificationList.fromJson(Map<String, dynamic> json) => _$NotificationListFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationListToJson(this);
}

@JsonSerializable()
class UniNotification {
  String id;
  final String chatID;
  final String systemID;
  final NotificationType dataType;
  NotificationStatus status;
  bool isApprove ;
  final dynamic notifyData;
  bool read ;

  UniNotification({
    required this.isApprove,
    required this.id,
    required this.chatID,
    required this.systemID,
    required this.notifyData,
    required this.dataType,
    required this.status,
    this.read= false
  });

  factory UniNotification.fromJson(Map<String, dynamic> json) {
  // Parse the `dataType` field into the `NotificationType` enum
  final dataTypeString = json['dataType'] as String;

  final dataType = NotificationType.values.firstWhere(
    (type) => type.status == dataTypeString, // Use the `status` field for comparison
    orElse: () => throw FormatException('Invalid dataType: $dataTypeString'),
  );

  //statu enum convert
  final statusString = json['status'] as String;
  final status = NotificationStatus.values.firstWhere(
    (status) => statusString == status.status,
    orElse: () => throw FormatException('Invalid status type: $dataTypeString'),

  );

  // Determine the type of `notifyData` based on the `dataType` enum
  final notifyData = dataType == NotificationType.registration
      ? NotifyRegistration.fromJson(json['notifyData'])
      : NotifyPaymentRequest.fromJson(json['notifyData']);

  return UniNotification(
    id : "null",
    chatID: json['chatID'],
    systemID: json['systemID'],
    notifyData: notifyData,
    dataType: dataType, // Use the parsed enum value
    read: json['read'],
    isApprove: json['isApprove'],
    status: status
  );
}

  Map<String, dynamic> toJson() {
    print("to json part");
    print(dataType.status);
    if(dataType.status == "paymentRequest"){
      NotifyPaymentRequest data = notifyData;
      return {
      'id' : id,
      'chatID': chatID,
      'systemID': systemID,
      'dataType': dataType.status,
      'notifyData': data.toJson(),
      'read' : read,
      'isApprove' : isApprove,
      'status':status.name
    };
    }else{
       NotifyRegistration data = notifyData;
       return {
      'id' : id,
      'chatID': chatID,
      'systemID': systemID,
      'dataType':  dataType.status,
      'notifyData': data.toJson(),
      'read' : read,
      'isApprove' : isApprove,
      'status':status.name
    };
   }
  }
}

@JsonSerializable()
class NotifyRegistration {
  String name;
  String phone;
  String idIdentification;
  DateTime registerOnDate;

  NotifyRegistration({
    required this.name,
    required this.phone,
    required this.idIdentification,
    required this.registerOnDate,
  });

  factory NotifyRegistration.fromJson(Map<String, dynamic> json) =>
      _$NotifyRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyRegistrationToJson(this);
}

@JsonSerializable()
class NotifyPaymentRequest {
  DateTime requestDateOn;
  double water;
  double electricity;
  double waterAccuracy;
  double electricityAccuracy;
  String photo1URL;
  String photo2URL;

  NotifyPaymentRequest({
    required this.requestDateOn,
    required this.water,
    required this.electricity,
    required this.waterAccuracy,
    required this.electricityAccuracy,
    required this.photo1URL,
    required this.photo2URL,
  });

  factory NotifyPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$NotifyPaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyPaymentRequestToJson(this);
}