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
  final List<Notification?> listNotification;
  NotificationList(this.listNotification);

  factory NotificationList.fromJson(Map<String, dynamic> json) => _$NotificationListFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationListToJson(this);
}




@JsonSerializable()
class Notification {
  late String id;
  final String chatID;
  final String systemID;
  final NotificationType dataType;
  NotificationStatus status;
  final dynamic notifyData;
  bool? read = false;

  Notification({
    required this.id,
    required this.chatID,
    required this.systemID,
    required this.notifyData,
    required this.dataType,
    required this.status,
    this.read
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
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

  return Notification(
    id : "docId!",
    chatID: json['chatID'],
    systemID: json['systemID'],
    notifyData: notifyData,
    dataType: dataType, // Use the parsed enum value
    read: json['read'],
    status: status
  );
}

  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'systemID': systemID,
      'dataType': dataType.toString().split('.').last,
      'notifyData': notifyData.toJson(),
      'read' : read
    };
  }
}

@JsonSerializable()
class NotifyRegistration {
  String chatID;
  String name;
  String phone;
  String idIdentification;
  DateTime registerOnDate;

  NotifyRegistration({
    required this.chatID,
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