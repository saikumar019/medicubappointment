import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:another_flushbar/flushbar.dart';
import '../helpers/strings.dart';

class RegistrationScreen extends StatefulWidget {
  String? mobileNumber, userUniqueId;
  RegistrationScreen({super.key, this.mobileNumber, this.userUniqueId});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var _formKey = GlobalKey<FormState>();
  final TextEditingController _mobilenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  String? aadhaarNumber;

  String? mobileNumber;

  String? uniqueId;
  String? session;
  String rangeSelectedValue = 'Gender';

  // List of items in our dropdown menu
  var rangeItems = ['Gender', 'Male', 'Female', 'Others'];
  Future<void> getUniqueUserId() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();

    setState(() {
      mobileNumber = prefer.getString('mobileNumber');

      session = prefer.getString("sessionId");

      uniqueId = prefer.getString('user');
    });

    print(mobileNumber);
  }

  @override
  void initState() {
    // getUniqueUserId();

    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        debugPrint("Will pop");
        return false;
      },
      child: Scaffold(
        backgroundColor: Strings.kBackgroundcolor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Strings.kPrimarycolor,
          toolbarHeight: height / 15,
          centerTitle: true,
          title: const Text(
            "Registration",
            style: TextStyle(
                color: Strings.kBlackcolor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // SizedBox(
                //   height: height / 80,
                // ),
                // const Center(
                //   child: Text(
                //     "Please enter all the below fields to avail \nyou FREE Digital Health Card",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         color: Strings.kSecondarycolor,
                //         fontSize: 14,
                //         fontWeight: FontWeight.w500,
                //         fontFamily: Strings.latoBold),
                //   ),
                // ),

                Center(
                  child: Image.asset(
                    "assets/images/jeevan.png",
                    height: height / 2.9,
                    width: width / 1.2,
                  ),
                ),

                // const Center(
                //   child: Text(
                //     "Change Profile",
                //     style: TextStyle(
                //         color: Color(0xff000000),
                //         fontSize: 12,
                //         decoration: TextDecoration.underline,
                //         fontWeight: FontWeight.bold,
                //         fontFamily: Strings.latoBold),
                //   ),
                // ),
                // SizedBox(
                //   height: height / 70,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 12),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _fullnameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: "Enter Full Name",
                            hintStyle: TextStyle(
                                color:
                                    const Color(0xff09726C).withOpacity(0.26)),
                            // suffixIcon: const Icon(Icons.verified),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            fillColor: const Color(0xffFFFFFF)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 70,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 12),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return 'Enter a valid email!';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: "Enter Email Address",
                            hintStyle: TextStyle(
                                color:
                                    const Color(0xff09726C).withOpacity(0.26)),
                            // suffixIcon: const Icon(Icons.verified),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            fillColor: const Color(0xffFFFFFF)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 70,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 12),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _mobilenumberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          // ignore: unrelated_type_equality_checks
                          if (value!.length < 10) {
                            return 'Enter 10 digits Number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: "Enter Mobile Number",
                            hintStyle: TextStyle(
                                color:
                                    const Color(0xff09726C).withOpacity(0.26)),
                            // suffixIcon: const Icon(Icons.verified),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffFFFFFF)),
                            ),
                            fillColor: const Color(0xffFFFFFF)),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: width / 12),
                //   child: Material(
                //     elevation: 1,
                //     borderRadius: BorderRadius.circular(10),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: const Color(0xffFFFFFF),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: TextFormField(
                //         controller: _mobilenumberController
                //           ..text = widget.mobileNumber.toString(),
                //         keyboardType: TextInputType.number,
                //         decoration: InputDecoration(
                //             isDense: true,
                //             hintText: "Enter Mobile Number",
                //             hintStyle: TextStyle(
                //                 color: const Color(0xff09726C).withOpacity(0.26)),
                //             // suffixIcon: const Icon(Icons.verified),
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //               borderSide:
                //                   const BorderSide(color: Color(0xffFFFFFF)),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //               borderSide:
                //                   const BorderSide(color: Color(0xffFFFFFF)),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //               borderSide:
                //                   const BorderSide(color: Color(0xffFFFFFF)),
                //             ),
                //             fillColor: const Color(0xffFFFFFF)),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: height / 70,
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: width / 12),
                //   child: Material(
                //     elevation: 1,
                //     borderRadius: BorderRadius.circular(10),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: const Color(0xffFFFFFF),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: TextFormField(
                //         controller: _aadharController,
                //         onChanged: (value) {
                //           // setState(() {
                //           //   number = value;
                //           // });
                //           // print(number);
                //           // if (number!.length == 10) {
                //           //   otpGenerate();

                //           //   numberLength = !numberLength;
                //           // }
                //         },
                //         validator: (value) {
                //           if (value!.length != 12) {
                //             return 'Enter 12 Digit Aadhar Number';
                //           }
                //           return null;
                //         },
                //         keyboardType:
                //             const TextInputType.numberWithOptions(decimal: true),
                //         inputFormatters: [
                //           FilteringTextInputFormatter.allow(
                //               RegExp('([0-9]+(.[0-9]+)?)')),
                //         ],
                //         decoration: InputDecoration(
                //             isDense: true,
                //             hintText: "Enter Mobile Number",
                //             hintStyle: TextStyle(
                //                 color: const Color(0xff09726C).withOpacity(0.26)),
                //             suffixIcon: _aadharController.text.length == 12
                //                 ? const Icon(
                //                     Icons.verified,
                //                     color: Strings.kPrimarycolor,
                //                   )
                //                 : const SizedBox(),
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //               borderSide:
                //                   const BorderSide(color: Color(0xffFFFFFF)),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //               borderSide:
                //                   const BorderSide(color: Color(0xffFFFFFF)),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //               borderSide:
                //                   const BorderSide(color: Color(0xffFFFFFF)),
                //             ),
                //             fillColor: const Color(0xffFFFFFF)),
                //       ),
                //     ),
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 12),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffFFFFFF),
                    child: Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton(
                        // Initial Value
                        value: rangeSelectedValue,
                        isExpanded: true,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        iconSize: 29,
                        underline: SizedBox(),

                        // Array list of items

                        items: rangeItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(items),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            rangeSelectedValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: height / 70,
                ),
                Center(
                  child: MaterialButton(
                    minWidth: width / 1.2,
                    elevation: 2,
                    color: const Color(0xffF89122),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: (() async {
                      if (rangeSelectedValue.isNotEmpty) {
                        if (_formKey.currentState!.validate()) {
                          if (_mobilenumberController.text.length == 10) {
                            profileRegistration();
                          } else {
                            Flushbar(
                              flushbarPosition: FlushbarPosition.TOP,
                              titleColor: Strings.kBlackcolor,
                              messageColor: Strings.kBlackcolor,
                              backgroundColor: Colors.white,
                              leftBarIndicatorColor: Strings.kPrimarycolor,
                              title: "Hey",
                              message: "Number is invalid",
                              duration: const Duration(seconds: 6),
                            ).show(context);
                          }
                        }
                      } else {}
                    }),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Strings.kWhitecolor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: Strings.latoBold),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 50,
                ),

                Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Strings.kPrimarycolor,
                              fontSize: 18,
                              decoration: TextDecoration.underline),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> profileRegistration() async {
    try {
      var url = '${Strings.baseUrl}Register';

      var data = {
        'name': _fullnameController.text,
        'email': _emailController.text,
        'mobile': _mobilenumberController.text,
        'gender': rangeSelectedValue.toString(),
      };

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 201) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "",
          message: "Registration successfully completed",
          duration: const Duration(seconds: 3),
        ).show(context).then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
      } else if (response.statusCode == 403) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "Hey",
          message: "User already exists!",
          duration: const Duration(seconds: 6),
        ).show(context);
      }

      var message = jsonDecode(response.body);
      var is_profile_completed;

      final SharedPreferences prefer = await SharedPreferences.getInstance();

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => CongratsScreen()),
      // );

      print(message);
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> setUniqueUserId() async {
  //   final SharedPreferences prefer = await SharedPreferences.getInstance();

  //   prefer.setString('value', _fullnameController.text);
  //   // prefer.setString('isUser', )
  // }
}
