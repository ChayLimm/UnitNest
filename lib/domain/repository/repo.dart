import 'package:emonitor/data/model/payment/transaction.dart';
import 'package:emonitor/data/model/stakeholder/landlord.dart';
import 'package:emonitor/data/model/system/system.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> register ({required String email,required String password});
  Future<User?> login ({required String email,required String password});
  Future<void> logOut ();
  Future<void> resetPassword (String email);
}

abstract class BakongRepository{
  Future<TransactionKHQR> requestKHQR (BakongAccount bakongAccount, double amount);
  Future<bool> checkPaymentStatus(TransactionKHQR transaction);
}

abstract class DatabaseRepository{
  Future<System> fetchSystem (String systemID);
  Future<void> synceToCloud (System system);
}