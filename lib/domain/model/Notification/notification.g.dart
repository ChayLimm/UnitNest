// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationList _$NotificationListFromJson(Map<String, dynamic> json) =>
    NotificationList(
      (json['listNotification'] as List<dynamic>)
          .map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationListToJson(NotificationList instance) =>
    <String, dynamic>{
      'listNotification': instance.listNotification,
    };

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      chatID: json['chatID'] as String,
      systemID: json['systemID'] as String,
      notifyData: json['notifyData'],
    )..dataType = $enumDecode(_$NotificationTypeEnumMap, json['dataType']);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'chatID': instance.chatID,
      'systemID': instance.systemID,
      'dataType': _$NotificationTypeEnumMap[instance.dataType]!,
      'notifyData': instance.notifyData,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.registration: 'registration',
  NotificationType.paymentRequest: 'paymentRequest',
};

NotifyRegistration _$NotifyRegistrationFromJson(Map<String, dynamic> json) =>
    NotifyRegistration(
      chatID: json['chatID'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      idIdentification: json['idIdentification'] as String,
      registerOnDate: DateTime.parse(json['registerOnDate'] as String),
    );

Map<String, dynamic> _$NotifyRegistrationToJson(NotifyRegistration instance) =>
    <String, dynamic>{
      'chatID': instance.chatID,
      'name': instance.name,
      'phone': instance.phone,
      'idIdentification': instance.idIdentification,
      'registerOnDate': instance.registerOnDate.toIso8601String(),
    };

NotifyPaymentRequest _$NotifyPaymentRequestFromJson(
        Map<String, dynamic> json) =>
    NotifyPaymentRequest(
      requestDateOn: DateTime.parse(json['requestDateOn'] as String),
      water: (json['water'] as num).toDouble(),
      electricity: (json['electricity'] as num).toDouble(),
      waterAccuracy: (json['waterAccuracy'] as num).toDouble(),
      electricityAccuracy: (json['electricityAccuracy'] as num).toDouble(),
      photo1URL: json['photo1URL'] as String,
      photo2URL: json['photo2URL'] as String,
    );

Map<String, dynamic> _$NotifyPaymentRequestToJson(
        NotifyPaymentRequest instance) =>
    <String, dynamic>{
      'requestDateOn': instance.requestDateOn.toIso8601String(),
      'water': instance.water,
      'electricity': instance.electricity,
      'waterAccuracy': instance.waterAccuracy,
      'electricityAccuracy': instance.electricityAccuracy,
      'photo1URL': instance.photo1URL,
      'photo2URL': instance.photo2URL,
    };
