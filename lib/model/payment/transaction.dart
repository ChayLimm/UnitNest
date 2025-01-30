import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';


@JsonSerializable()
class TransactionKHQR{
 
  final String md5;
  final String qr;

  TransactionKHQR({
    required this.qr,
    required this.md5,
  });
  
  factory TransactionKHQR.fromJson(Map<String, dynamic> json) => _$TransactionKHQRFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionKHQRToJson(this);
 
}
