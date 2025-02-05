import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emonitor/model/stakeholder/landlord.dart';
import 'package:emonitor/model/system/priceCharge.dart';
import 'package:emonitor/model/system/system.dart';
import 'package:emonitor/screen/main.dart';
import 'package:emonitor/utils/component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final PageController _pageController = PageController();

  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyPriceCharge = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyBakong = GlobalKey<FormState>();

  late System system;
  Landlord? newLandlord;

  bool isRegister = false;
  bool isloading = false;
  bool isObscured = true;
  bool isUserRegistrationform = false;

  String userName = " ";
  String phoneNumber = " ";

  String email = " ";
  String password = " ";

  String warning = " ";

  //MultiRegistration form
   double electricityPrice = 0;
   double waterPrice= 0;
   double hygieneFee= 0;
   double finePerDay= 0;
   double rentParkingPrice= 0;
   DateTime fineStartOn = DateTime(DateTime.now().year,DateTime.now().month, 05);
   DateTime startDate= DateTime.now();

   //Bakong
   String bakongID = ""; 
   String location = ""; 
   String bakongName = ""; 

  User? user;

  @override
  Widget build(BuildContext context) {

    void switchPage() {
      setState(() {
        isRegister = !isRegister;
        warning = "";
        userName = "";
        phoneNumber = "";
        email = "";
        password = "";
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

    void register(Landlord landlord,String email, String password) async {
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
          landlord: landlord
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

    void nextPage() {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }

    void previousPage() {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }

    void registerLandLord(){
      List<PriceCharge> priceChargeList = [PriceCharge(electricityPrice: electricityPrice, waterPrice: waterPrice, hygieneFee: hygieneFee, finePerDay: finePerDay, fineStartOn: double.parse(fineStartOn.day.toString()), rentParkingPrice: rentParkingPrice, startDate: startDate)];
      BakongAccount newBakongAccount = BakongAccount(bakongID: bakongID, username: bakongName, location: location);
      LandlordSettings newSetting = LandlordSettings(bakongAccount: newBakongAccount, priceChargeList: priceChargeList);

      setState(() {
        system.landlord.settings = newSetting;
      });
      system.syncCloud();
    }
    // login("test@gmail.com", "Team1234");

    return user != null && system.landlord.settings != null 
    ? MyApp(system: system)
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
                        child: user == null?
                       //register or login
                        SingleChildScrollView(
                          child:Column(
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
                           if (isRegister) ...[
                                         buildTextFormField(
                                          label: "Username",
                                          onChanged: (value) {
                                            setState(() {
                                              userName = value;
                                            });
                                          },
                                          validator: (value) =>
                                              value == null || value.isEmpty
                                                  ? "Username is required"
                                                  : null,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ), buildTextFormField(
                                          label: "Phone number",
                                          onChanged: (value) {
                                            setState(() {
                                              phoneNumber = value;
                                            });
                                          },
                                          validator: (value) =>
                                              value == null || value.isEmpty
                                                  ? "PhoneNumber is required"
                                                  : null,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),],
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
                                                  newLandlord = Landlord(username: userName, phoneNumber: phoneNumber);
                                                  register(newLandlord!,email, password);
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
                        )
                                      
                       //Multi Registration form
                      : PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(), 
                        pageSnapping: true,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText("Hello, ${system.landlord.username}",style:  TextStyle(
                                  fontSize: h,
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                ),
                              ),
                              const SizedBox(height: 32,),
                              AutoSizeText("To provide you with the best experience and ensure our system functions smoothly, we require some basic information. This helps us personalize your account, process transactions securely, and offer tailored services. Rest assured, your data will be handled securely and used only for the purpose of improving your experience.",style:  TextStyle(
                                  fontSize: p1,
                                  color: black,
                                ),),
                              const SizedBox(height: 16,),
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                 TextButton(
                                  onPressed: (){
                                  nextPage();
                                 },
                                 child: Text("Next >",style: TextStyle(
                                  color: blue,
                                  fontSize: p1,
                                 ),),
                                 )
                                ],
                              )
                            ],
                          ),
                       
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText("PriceCharge",style: TextStyle(
                                  fontSize: h,
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                ),),
                            AutoSizeText("Set up your Price Charge Form for future payments.",style:  TextStyle(
                                  fontSize: p1,
                                  color: darkGrey,
                                ),
                              ),
                            const SizedBox(height: 20,),
                            Form(
                              key: _keyPriceCharge,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Expanded(
                                    child: buildTextFormField(
                                      suffix: "m³",
                                      keyboardType: TextInputType.number,
                                      label: "Water",
                                      onChanged: (value){
                                        setState(() {
                                          waterPrice =  double.parse(value);
                                        });
                                      }, 
                                      validator:  (value) =>
                                        value == null || value.isEmpty
                                            ? "Water price is required"
                                            : null,
                                      ),
                                  ),
                                  const SizedBox(width: 10,),
                                    Expanded(
                                      child: buildTextFormField(
                                      suffix: "",
                                      keyboardType: TextInputType.number,
                                      label: "Electricity",
                                      onChanged: (value){
                                        setState(() {
                                          electricityPrice =  double.parse(value);
                                        });
                                      }, 
                                      validator:  (value) =>
                                        value == null || value.isEmpty
                                            ? "Electricity price is required"
                                            : null,
                                      ),
                                    ),
                                ],
                               ),
                                const SizedBox(height: 10,),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Expanded(
                                    child: buildTextFormField(
                                      suffix: "\$",
                                      keyboardType: TextInputType.number,
                                      label: "Parking",
                                      onChanged: (value){
                                        setState(() {
                                          rentParkingPrice =  double.parse(value);
                                        });
                                      }, 
                                      validator:  (value) =>
                                        value == null || value.isEmpty
                                            ? "Parking price is required"
                                            : null,
                                      ),
                                  ),
                                  const SizedBox(width: 10,),
                                    Expanded(
                                      child: buildTextFormField(
                                      suffix: "\$",
                                      keyboardType: TextInputType.number,
                                      label: "Hygiene",
                                      onChanged: (value){
                                        setState(() {
                                          hygieneFee =  double.parse(value);
                                        });
                                      }, 
                                      validator:  (value) =>
                                        value == null || value.isEmpty
                                            ? "Electricity price is required"
                                            : null,
                                      ),
                                    ),
                                ],
                               ),
                                const SizedBox(height: 10,), Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Expanded(
                                    child: buildTextFormField(
                                      suffix: "\$",
                                      keyboardType: TextInputType.number,
                                      label: "Fine",
                                      onChanged: (value){
                                        setState(() {
                                          finePerDay =  double.parse(value);
                                        });
                                      }, 
                                      validator:  (value) =>
                                        value == null || value.isEmpty
                                            ? "Water price is required"
                                            : null,
                                      ),
                                  ),
                                   
                                ],
                               ),
                               const SizedBox(height: 10,),
                                  AutoSizeText("Fine will start counting after : ",style:  TextStyle(
                                  fontSize: p1,
                                  color: darkGrey,
                                ),),
                               const SizedBox(height: 10,),
                               GestureDetector(
                                onTap: () async {
                                  DateTime? newDate = await selectDate(context);
                                  if(newDate != null){
                                    setState(() {
                                      fineStartOn = newDate;
                                    });
                                  }
                                },
                                 child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: lightGrey,
                                      width: 1
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                         Icon(
                                          Icons.date_range, 
                                          color: black,
                                          size: 20,
                                          ),
                                        AutoSizeText("${fineStartOn.day}/${fineStartOn.month}/${fineStartOn.year}",style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w500
                                        ),
                                       ),
                                      ],
                                    ),
                                  ),
                                 ),
                               ),
                               const SizedBox(height: 10,),
                               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                  onPressed: (){
                                  previousPage();
                                 },
                                 child: Text("< Previous",style: TextStyle(
                                  color: blue,
                                  fontSize: p1,
                                 ),),
                                 ),
                                 TextButton(
                                  onPressed: (){
                                    if(_keyPriceCharge.currentState!.validate()){
                                       nextPage();
                                    };
                                 },
                                 child: Text("Next >",style: TextStyle(
                                  color: blue,
                                  fontSize: p1,
                                 ),),
                                 ),
                                ],
                              )
                                ],
                              ),
                            )
                          ],
                        ),
                      
                        Form(
                          key: _keyBakong,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText("Bakong",style:TextStyle(
                                    fontSize: h,
                                    fontWeight: FontWeight.w600,
                                    color: black,
                                  )
                              ,),
                               AutoSizeText("Set up your Price Charge Form for future payments.",style:  TextStyle(
                                    fontSize: p1,
                                    color: darkGrey,
                                  ),
                                ),
                              const SizedBox(height: 20,),
                              buildTextFormField(
                                label: "Username",
                                onChanged: (value){
                                  setState(() {
                                    bakongName = value;
                                  });
                                }, 
                                validator: (value){
                                  if(value == null||value.isEmpty){
                                    return "bakong Name is required";
                                  }
                                  return null;
                                }
                                ),
                                const SizedBox(height: 10,),
                              buildTextFormField(
                                label: "Bakong ID",
                                onChanged: (value){
                                  setState(() {
                                    bakongID = value;
                                  });
                                }, 
                                validator: (value){
                                  if(value == null||value.isEmpty){
                                    return "Bakong ID is required";
                                  }return null;
                                }
                                ),
                                const SizedBox(height: 10,),
                                
                                 buildTextFormField(
                                label: "Location",
                                onChanged: (value){
                                  setState(() {
                                    location = value;
                                  });
                                }, 
                                validator: (value){
                                  if(value == null||value.isEmpty){
                                    return "Location is required";
                                  }
                                  return null;
                                }
                                ),
                                const SizedBox(height: 10,),
                                
                                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                    onPressed: (){
                                    previousPage();
                                   },
                                   child: Text("< Previous",style: TextStyle(
                                    color: blue,
                                    fontSize: p1,
                                   ),),
                                   ),
                                   TextButton(
                                    onPressed: (){
                                      if(_keyBakong.currentState!.validate()){
                                        registerLandLord();
                                      }
                                   },
                                   child: Text("Done ",style: TextStyle(
                                    color: blue,
                                    fontSize: p1,
                                   ),),
                                   ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      
                      ],
                      )
                      )
                      )
                    ],
                  ),
                ),
              ),
            )
        );
  }
}
