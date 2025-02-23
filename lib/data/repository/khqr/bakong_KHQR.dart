import 'dart:convert';

import 'package:emonitor/data/model/payment/transaction.dart';
import 'package:emonitor/data/model/stakeholder/landlord.dart';
import 'package:emonitor/domain/repository/repo.dart';
import 'package:http/http.dart' as http;


class BakongKhqrImpl extends BakongRepository{

  @override
  Future<bool> checkPaymentStatus(TransactionKHQR transaction) async {
    // TODO: implement checkPaymentStatus
    final String md5 = transaction.md5;
    const url = 'https://unitnest-api.vercel.app/khqr';
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = json.encode({
        'md5': md5,
      });
        try {
          final response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: body,
          );

          if (response.statusCode == 200) {
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
    const url = 'https://unitnest-api.vercel.app/khqr';
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