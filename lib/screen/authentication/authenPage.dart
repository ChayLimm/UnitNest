import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/model/system/system.dart';
import 'package:emonitor/screen/dashboard/main.dart';
import 'package:emonitor/utils/component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late System system;

  bool isRegister = false;
  bool isloading = false;
  bool isObscured = true;

  String email = "";
  String password = "";
  String warning = "";

  User? user;

  @override
  Widget build(BuildContext context) {
    void switchPage() {
      setState(() {
        isRegister = !isRegister;
        warning = "";
      });
    }

    void toggleLoading() {
      setState(() {
        isloading = !isloading;
      });
    }

    Future<void> storeSystemData(System systemData) async {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        await firestore
            .collection('system')
            .doc(systemData.id)
            .set(systemData.toJson());

        print("System data stored successfully!");
      } catch (e) {
        print("Error storing system data: $e");
      }
    }

    Future<void> logout() async {
      await _auth.signOut();
      setState(() {
        user = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged Out Successfully!')),
      );
    }

    void register(String email, String password) async {
      try {
        toggleLoading();
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //create system for the user
        setState(() {
          user = _auth.currentUser;
        });
        final userID = user!.uid;

        System systemTemp = System(
          id: userID,
        );

        storeSystemData(systemTemp);
        system = systemTemp;
        toggleLoading();
        return;
      } on FirebaseAuthException catch (e) {
        toggleLoading();
        String message = 'An error occurred';
        if (e.code == 'email-already-in-use') {
          message = 'This email is already in use.';
        } else if (e.code == 'weak-password') {
          message = 'The password is too weak.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        }
        setState(() {
          warning = "Warning : $message";
        });
        return;
      }
    }

    void login(String email, String password) async {
      try {
        toggleLoading();
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final userID = _auth.currentUser!.uid;
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('system')
            .doc(userID)
            .get();
        if (doc.exists) {
          Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
          setState(() {
            system = System.fromJson(docData);
            user = _auth.currentUser;
          });
        }
        toggleLoading();
      } on FirebaseAuthException catch (e) {
        toggleLoading();
        String message = 'An error occurred';
        if (e.code == 'user-not-found') {
          message = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          message = 'Incorrect password.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        } else if (e.code == 'user-disabled') {
          message = 'This user account has been disabled.';
        } else if (e.code == 'invalid-credential') {
          message = 'Incorrect password.';
        } else if (e.code == 'too-many-requests') {
          message =
              'We have blocked all requests from this device due to unusual activity. Please try again later.';
        }
        print(e.code);
        setState(() {
          warning = "Warning : $message";
        });
        return;
      }
    }

    return user != null
        ? MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => system),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Poppins',
              ),
              home: DashBoard(), // Your home widget
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: grey,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [shadow()],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      //left panel
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: blue),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.check_box,
                                    color: white,
                                  ),
                                  title: AutoSizeText(
                                    "UnitNest",
                                    style: TextStyle(
                                        fontSize: h2,
                                        fontWeight: FontWeight.w600,
                                        color: white),
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 38,),
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        "Start your journey ",
                                        style: TextStyle(
                                          fontSize: h,
                                          fontWeight: FontWeight.w600,
                                          color: white,
                                        ),
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        "with us",
                                        style: TextStyle(
                                          fontSize: h,
                                          fontWeight: FontWeight.w600,
                                          color: white,
                                        ),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(
                                          height:
                                              10), // Add spacing between texts
                                      AutoSizeText(
                                        "Redefine Rental Management – Stress Less, Earn \nMore",
                                        style: TextStyle(
                                          fontSize:
                                              p1, // Smaller font size for this part
                                          color: grey, // Color for this part
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  )),
                              // const SizedBox(height: 10,),

                              // const SizedBox(height: 100,),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            80, 244, 244, 244),
                                        borderRadius: BorderRadius.circular(8)),
                                  ))
                            ],
                          ),
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      //right panel
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 72, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  isRegister ? "Create an account" : "Login",
                                  style: TextStyle(
                                    fontSize: h,
                                    fontWeight: FontWeight.w600,
                                    color: black,
                                  ),
                                  maxLines: 1,
                                ),
                                Row(
                                  children: [
                                    AutoSizeText(
                                      isRegister
                                          ? "Already have account?"
                                          : "Don't have account yet?",
                                      style: TextStyle(
                                        fontSize: p1,
                                        color: darkGrey,
                                      ),
                                      maxLines: 1,
                                    ),
                                    TextButton(
                                        style: ButtonStyle(
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets
                                                  .zero), // Remove padding
                                          minimumSize: WidgetStateProperty.all(
                                              Size.zero), // Remove minimum size
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // Reduce tap area
                                        ),
                                        onPressed: switchPage,
                                        child: Text(
                                          isRegister ? " Log in" : " Sign up",
                                          style: TextStyle(
                                            fontSize: p1,
                                            color: blue,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 44,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTextFormField(
                                        label: "Email",
                                        onChanged: (value) {
                                          setState(() {
                                            email = value;
                                          });
                                        },
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? "Email is required"
                                                : null,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        obscureText: isObscured,
                                        decoration: InputDecoration(
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: red, width: 2)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      lightGrey), // Default border color
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide:
                                                  BorderSide(color: grey)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: blue, width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          floatingLabelStyle:
                                              TextStyle(color: blue),
                                          suffix: SizedBox(
                                            height: 24,
                                            child: IconButton(
                                              iconSize: 20,
                                              color: darkGrey,
                                              padding: EdgeInsets.zero,
                                              icon: Icon(isObscured
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onPressed: () {
                                                setState(() {
                                                  isObscured = !isObscured;
                                                });
                                              },
                                            ),
                                          ),
                                          label: const Text("Password"),
                                          labelStyle: const TextStyle(
                                              color: Color(0xFF757575)),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            password = value;
                                          });
                                        },
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? "Password is required"
                                                : null,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (isRegister) ...[
                                        TextFormField(
                                          obscureText: isObscured,
                                          decoration: InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: red, width: 2)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        lightGrey), // Default border color
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide:
                                                    BorderSide(color: grey)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: blue, width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            floatingLabelStyle:
                                                TextStyle(color: blue),
                                            suffix: SizedBox(
                                              height: 24,
                                              child: IconButton(
                                                iconSize: 20,
                                                color: darkGrey,
                                                padding: EdgeInsets.zero,
                                                icon: Icon(isObscured
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    isObscured = !isObscured;
                                                  });
                                                },
                                              ),
                                            ),
                                            label:
                                                const Text("Confirm password"),
                                            labelStyle: const TextStyle(
                                                color: Color(0xFF757575)),
                                          ),
                                          validator: (value) => value == null ||
                                                  value.isEmpty
                                              ? "Password is required"
                                              : password == value
                                                  ? null
                                                  : "Password does not match",
                                        ),
                                      ],
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!isloading) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (isRegister) {
                                                register(email, password);
                                              } else {
                                                login(email, password);
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: blue,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 44,
                                          child: Center(
                                            child: isloading
                                                ? CircularProgressIndicator(
                                                    color: white,
                                                  )
                                                : AutoSizeText(
                                                    isRegister
                                                        ? "Create Account"
                                                        : "Login",
                                                    style: TextStyle(
                                                        color: white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: AutoSizeText(
                                              "This app is a demo. Features may be limited or change.",
                                              style: TextStyle(
                                                  color: darkGrey,
                                                  fontSize: 10),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: AutoSizeText(
                                          warning,
                                          style: TextStyle(
                                            color: red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            )
        );
  }
}
