import 'package:emonitor/domain/repository/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService  {
  static AuthenticationService? _instance;
  // required injection of the IMPL in multiple provider
  final AuthRepository repository;
  AuthenticationService._internal(this.repository);

  //initialize
  static void initialize(AuthRepository repository){
    if(_instance == null){
      _instance = AuthenticationService._internal(repository);
    }else{
      throw "auth service is already init";
    }
  }

  // singletone
  static AuthenticationService get instance {
    if(_instance == null){
      throw "must init auth service first";
    }else{
      return _instance!;
    }
  }

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
  Future<void> sendPasswordResetEmail() async{
    await repository.sendPasswordResetEmail();
    return;
  }

  //log out from the current user
  Future<void> logOut()async{
    repository.logOut();
    return;
  }
}