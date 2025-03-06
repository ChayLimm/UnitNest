import 'package:emonitor/domain/model/payment/transaction.dart';
import 'package:emonitor/domain/repository/repo.dart';
import 'package:emonitor/domain/service/root_data.dart';
import 'package:flutter/material.dart';

class KhqrService {
  static KhqrService? _instance;
  
  // Dependencies
  final BakongRepository bakongRepository;
  final RootDataService rootDataRepository;

  KhqrService._internal({required this.bakongRepository, required this.rootDataRepository});

  ///
  /// Initialization
  ///
  static void initialize({required BakongRepository bakongRepository, required RootDataService rootDataRepository}) {
    if (_instance == null) {
      _instance = KhqrService._internal(
        bakongRepository: bakongRepository,
        rootDataRepository: rootDataRepository,
      );
    } else {
      throw "KhqrService is already initialized";
    }
  }

  // Singleton getter
  static KhqrService get instance {
    if (_instance == null) {
      throw "KhqrService must be initialized first";
    } else {
      return _instance!;
    }
  }

  ///
  /// business logic
  /// 

  Future<TransactionKHQR> requestKHQR(double amount) async{
    try{
      TransactionKHQR newTransactionKHQR = await bakongRepository.requestKHQR(rootDataRepository.rootData!.landlord.settings!.bakongAccount, amount);
      
      return newTransactionKHQR;
    }catch (e){
      throw e;
    }
  }

  ///
  ///check payment status
  Future<bool> checkTransStatus(TransactionKHQR transaction)async{
    try{
      
      return await bakongRepository.checkPaymentStatus(transaction);
    }catch (e){
      rethrow;
    }
  }

}