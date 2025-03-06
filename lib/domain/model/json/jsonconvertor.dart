import 'package:emonitor/domain/model/building/room.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jsonconvertor.g.dart';


class AvailibilityConverter extends JsonConverter<Availibility, Map<String, dynamic>> {
  const AvailibilityConverter();

  @override
  Availibility fromJson(Map<String, dynamic> json) {
    final String status = json['status'] as String;
    return Availibility.values.firstWhere(
      (e) => e.status == status,
      orElse: () => throw ArgumentError('Unknown status: $status'),
    );
  }

  @override
  Map<String, dynamic> toJson(Availibility object) {
    return {
      'status': object.status,
      'color': object.color.value, // Convert the Color object to an int
    };
  }
}



@JsonEnum(alwaysCreate: true)
enum PaymentStatus {
  @JsonValue("Unpaid")
  unpaid("Unpaid"),
  @JsonValue("Pending")
  pending("Pending"),
  @JsonValue("Paid")
  paid("Paid");

  final String status;
  const PaymentStatus(this.status);
}

@JsonEnum(alwaysCreate: true)
enum PaymentApproval {
  @JsonValue("Rejected")
  reject("Rejected"),
  @JsonValue("Pending")
  pending("Pending"),
  @JsonValue("Approved")
  approve("Approved");

  final String status;
  const PaymentApproval(this.status);
}

