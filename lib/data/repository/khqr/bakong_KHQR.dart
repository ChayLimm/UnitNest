import 'dart:convert';

import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/model/stakeholder/landlord.dart';
import 'package:emonitor/domain/repository/repo.dart';
import 'package:emonitor/global_url.dart';
import 'package:http/http.dart' as http;


class BakongKhqrImpl extends BakongRepository{

  final url = "${global_url+"/khqr"}";//'https://unitnest-api.vercel.app/khqr';
 //'https://unitnest-api.vercel.app/khqr';
 
  @override
  Future<bool> checkPaymentStatus(TransactionKHQR transaction) async {
    // TODO: implement checkPaymentStatus
    final String md5 = transaction.md5;
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = json.encode({
        'md5': md5,
      });
        try {
          print("${url}status");
          final response = await http.post(
            Uri.parse("${url}status"),
            headers: headers,
            body: body,
          );

          if (response.statusCode == 200) {
            // ignore: unnecessary_null_comparison
            if(response != null){
              return true;
            }
          } else {
            return false;
          }
        } catch (e) {
          print('Error: $e');
        }
    throw UnimplementedError();
  }

  @override
  Future<TransactionKHQR> requestKHQR(BakongAccount bakongAccount, double amount) async {
    
    final headers = {
  'Content-Type': 'application/json', // Content-Type in headers
};
    final body = json.encode({
    'bakongAccount': {
       ...bakongAccount.toJson(), // Converts BakongAccount object to JSON
      'amount': amount, // Adds the amount field
    }
  });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        //decode sen
         var decodedResponse = json.decode(response.body);
        return TransactionKHQR(qr: decodedResponse['QR'], md5: decodedResponse['MD5']); 
      } else {
        print('Failed to load data: ${response.statusCode}');
        print('Failed to load data: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error during request');
    }
  }

}