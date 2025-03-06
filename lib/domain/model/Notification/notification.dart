import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart'; // Include the generated file

@JsonSerializable()
class NotificationList{
  final List<Notification> listNotification;
  NotificationList(this.listNotification);
}

@JsonEnum()
enum NotificationType {
  @JsonValue('registration')
  registration,
  @JsonValue('paymentRequest')
  paymentRequest,
}


@JsonSerializable()
class Notification {
  String chatID;
  String systemID;
  NotificationType dataType;
  dynamic notifyData;

  Notification({
    required this.chatID,
    required this.systemID,
    required this.notifyData,
  }) : dataType = notifyData is NotifyRegistration
            ? NotificationType.registration
            : NotificationType.paymentRequest;

  factory Notification.fromJson(Map<String, dynamic> json) {
    final notifyData = json['dataType'] == 'registration'
        ? NotifyRegistration.fromJson(json['notifyData'])
        : NotifyPaymentRequest.fromJson(json['notifyData']);

    return Notification(
      chatID: json['chatID'],
      systemID: json['systemID'],
      notifyData: notifyData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'systemID': systemID,
      'dataType': dataType.toString().split('.').last,
      'notifyData': notifyData.toJson(),
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