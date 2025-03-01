import 'package:emonitor/domain/repository/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  // required injection of the IMPL in multiple provider
  final AuthRepository repository;
  AuthenticationService(this.repository);

  //just the login part with no database impl
  Future<User?> login(String email, String password) async{
    final User? user = await repository.login(email: email, password: password);
    return user?? null;
  }

  //registration of user
  Future<User?> register(String email, String password) async{
    final User? user = await repository.register(email: email, password: password);
    return user?? null;
  }

  //forgot password
  Future<void> resetPassword(String email) async{
    await repository.resetPassword(email);
    return;
  }

  //log out from the current user
  Future<void> logOut()async{
    repository.logOut();
  }

}