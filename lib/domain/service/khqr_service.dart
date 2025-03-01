import 'package:emonitor/data/model/payment/transaction.dart';
import 'package:emonitor/domain/repository/repo.dart';
import 'package:emonitor/domain/service/root_data.dart';

class KhqrService {

  //injection of IMPL needed in multiple provider
  final BakongRepository bakongRepository;
  final RootDataService rootDataRepository;

  KhqrService({required this.bakongRepository, required this.rootDataRepository});

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