// focus on impl code with the api service only
// for logic of login and retrieve is in data/usecase

import 'package:emonitor/domain/repository/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepository {
  

  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Throw specific error if needed
    
      throw Exception("Reset password failed: $e");
    }
  }

  @override
Future<User?> login({required String email, required String password}) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    // Specific Firebase exception
    throw FirebaseAuthException(
      code: e.code,
      message: "Sign-in failed: ${e.message}",
    );
  } catch (e) {
    // Catch any other general error
    throw Exception("Sign-in failed: $e");
  }
}

  @override
  Future<User?> register({ required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
    // Specific Firebase exception
    throw FirebaseAuthException(
      code: e.code,
      message: "Sign-in failed: ${e.message}",
    );
  } catch (e) {
    // Catch any other general error
    throw Exception("Sign-in failed: $e");
  }
  }

  @override
  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
    // Specific Firebase exception
    throw FirebaseAuthException(
      code: e.code,
      message: "Sign-in failed: ${e.message}",
    );
  } catch (e) {
    // Catch any other general error
    throw Exception("Sign-in failed: $e");
  }
}



}


// class UnitNestAuth{

//   final _auth = FirebaseAuth.instance;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;



// void register(Landlord landlord,String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       //create system for the user
//       final User? user = _auth.currentUser;
//       final userID = user!.uid;

//       System system = System(
//         id: userID, 
//         landlord : landlord,

//       );

//       storeSystemData(system);    

//       return ;
//     } on FirebaseAuthException catch (e) {
//       String message = 'An error occurred';
//       if (e.code == 'email-already-in-use') {
//         message = 'This email is already in use.';
//       } else if (e.code == 'weak-password') {
//         message = 'The password is too weak.';
//       } else if (e.code == 'invalid-email') {
//         message = 'The email address is not valid.';
//       }
//       return ;
//     }
//   }
//    Future<void> storeSystemData(System systemData) async {
//   try {

//     // Store the data in the 'system' collection
//     await firestore.collection('system').doc(systemData.id).set(systemData.toJson());

//     print("System data stored successfully!");
//   } catch (e) {
//     print("Error storing system data: $e");
//   }
// }

// }