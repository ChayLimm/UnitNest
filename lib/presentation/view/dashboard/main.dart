// import 'package:emonitor/domain/usecases/system.dart';
// import 'package:emonitor/authentication/presentation/authenPage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DashBoard extends StatelessWidget {
//    DashBoard({super.key});
//   final _auth = FirebaseAuth.instance;
//   User? get user => _auth.currentUser;

//   @override
//   Widget build(BuildContext context) {

//     Future<void> logout() async{
//       await _auth.signOut();
//     }

//     return Consumer<System>(builder: (context,system,child){
//       return  Scaffold(
//       body: Center(
//        child:  Column(children: [
//         TextButton(onPressed:(){
//           logout();
//           Navigator.push(context, MaterialPageRoute(builder: (context)=> const Register()));
//           }, child:  const Text("signout"))
//        ],),
//       ),
//     );
//     });
//   }
// }