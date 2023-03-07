import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:http/http.dart';
import 'package:medicub_appointment/helpers/strings.dart';
import 'package:medicub_appointment/homescreen.dart';
import 'package:medicub_appointment/profile/registration_screen.dart';

import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../otp_verify.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final controller = Get.put(LoginController());
  final FocusNode _pinPutFocusNode = FocusNode();
  String? number;
  bool numberLength = false;
  bool otpSend = false;
  bool show = false;
  String? userUnique;
  String? uniqueId;
  String? sessionId;
  Future<void> getUniqueUserId() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();

    setState(() {
      uniqueId = prefer.getString('user');
    });
    // getUser();
  }

  final TextEditingController _numberController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Color(0xFF0000000).withOpacity(0.28)),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        debugPrint("Will pop");
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF3F4F4),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height / 5,
              ),
              Center(
                child: Image.asset(
                  "assets/images/jeevan.png",
                  height: height / 2.9,
                  width: width / 1.2,
                ),
              ),
              otpSend == false
                  ? Padding(
                      padding: EdgeInsets.only(left: width / 12),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Color(0xff383337),
                            fontFamily: Strings.lato,
                            fontWeight: FontWeight.w600,
                            fontSize: 21),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: height / 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 12),
                child: Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffFFFFFF),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          number = value;
                        });
                        print(number);
                        if (number!.length == 10) {
                          setState(() {
                            otpGenerate();
                          });
                        }

                        numberLength = !numberLength;
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('([0-9]+(.[0-9]+)?)')),
                      ],
                      controller: _numberController,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: "Enter Mobile Number",
                          hintStyle: TextStyle(
                              color: const Color(0xff09726C).withOpacity(0.26)),
                          suffixIcon: _numberController.text.length == 10
                              ? const Icon(
                                  Icons.verified,
                                  color: Strings.kPrimarycolor,
                                )
                              : const SizedBox(),
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
                height: height / 50,
              ),

              Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()));
                      },
                      child: Text(
                        "Register?",
                        style: TextStyle(
                            color: Strings.kPrimarycolor,
                            fontSize: 18,
                            decoration: TextDecoration.underline),
                      )))
              // _numberController.text.length == 10
              //     ? Column(
              //         children: [
              //           Padding(
              //             padding: EdgeInsets.symmetric(
              //                 horizontal: width / 10, vertical: height / 50),
              //             child: PinPut(
              //               fieldsCount: 6,
              //               validator: (s) {},
              //               onSubmit: (String pin) {
              //                 print(pin);
              //               },
              //               focusNode: _pinPutFocusNode,
              //               controller: _pinPutController,
              //               submittedFieldDecoration:
              //                   _pinPutDecoration.copyWith(
              //                 borderRadius: BorderRadius.circular(10.0),
              //               ),
              //               selectedFieldDecoration: _pinPutDecoration,
              //               pinAnimationType: PinAnimationType.rotation,
              //               followingFieldDecoration:
              //                   _pinPutDecoration.copyWith(
              //                 borderRadius: BorderRadius.circular(5.0),
              //                 border: Border.all(
              //                   color: Strings.kPrimarycolor,
              //                 ),
              //               ),
              //             ),
              //           ),
              //           Padding(
              //             padding: EdgeInsets.symmetric(horizontal: width / 5),
              //             child: RichText(
              //               text: TextSpan(
              //                 text: "Didn't receive a code?",
              //                 style: const TextStyle(
              //                     color: Color(0xff09726C), fontSize: 12),
              //                 children: [
              //                   TextSpan(
              //                       text: ' Resend code',
              //                       recognizer: TapGestureRecognizer()
              //                         ..onTap = () {
              //                           resendOtp();
              //                         },
              //                       style: const TextStyle(
              //                           fontSize: 14,
              //                           color: Color(
              //                             0xff09726C,
              //                           ),
              //                           decoration: TextDecoration.underline,
              //                           fontWeight: FontWeight.w700)),
              //                 ],
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: height / 60,
              //           ),
              //           Center(
              //             child: MaterialButton(
              //               minWidth: width / 1.2,
              //               elevation: 2,
              //               color: const Color(0xffF89122),
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               onPressed: (() async {
              //                 loginOtp();

              //                 // await verifyOtp();
              //               }),
              //               child: const Text(
              //                 "Login",
              //                 style: TextStyle(
              //                     color: Strings.kWhitecolor,
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.bold,
              //                     fontFamily: Strings.latoBold),
              //               ),
              //             ),
              //           )
              //         ],
              //       )
              //     : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  

  Future<void> otpGenerate() async {
    try {
      var url = '${Strings.baseUrl}Generate_otp';

      var data = {'mobile': _numberController.text};

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 201) {
        setState(() {
          otpSend == true;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerify(
                    phoneNumber: _numberController.text,
                  )),
        );
      } else if (response.statusCode == 403) {
        print(response.body);

        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "Hey",
          message: "User is not Registered, Please Register",
          duration: Duration(seconds: 3),
        )..show(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loginOtp() async {
    try {
      const url = "${Strings.baseUrl}Login";

      var data = {
        'mobile': _numberController.text,
        'mobile_otp': _pinPutController.text,
      };

      var response = await post(Uri.parse(url), body: (data));

      var message = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }

      // var userUnique = message["user_unique_id"];
      // var sessionId = message["session_unique_id"];

      // var isProfileCompleted = message["is_profile_completed"];
      // final SharedPreferences prefer = await SharedPreferences.getInstance();

      // prefer.setString("user", userUnique);
      // prefer.setString("isProfile", isProfileCompleted);
      // prefer.setString("sessionId", sessionId);
      // prefer.setString("mobileNumber", _numberController.text);
      // getUniqueUserId();

      // print("login");

    } catch (err) {}
  }

  // Future<void> getUser() async {
  //   try {
  //     var url = 'http://jeevanraksha.co/API/r_usersbyid';

  //     var data = {
  //       'user_unique_id': uniqueId,
  //       'session_unique_id': sessionId,
  //     };

  //     var response = await post(Uri.parse(url), body: data);

  //     if (response.statusCode == 200) {
  //       var message = response.body;

  //       _pinPutController.clear();
  //       var users = jsonDecode(message);
  //       var isProfileCompleted;
  //       var userActiveStatus;

  //       var isP = users["Users"][0]["is_profile_completed"];
  //       var isU = users["Users"][0]["account_status"];

  //       setState(() {
  //         isProfileCompleted = isP;
  //         userActiveStatus = isU;
  //       });
  //       if (isProfileCompleted == "1" && userActiveStatus == "1") {
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => HomeScreen()),
  //         // );
  //         setState(() {
  //           _pinPutController.clear();
  //         });
  //       } else if (isProfileCompleted == "0" || isProfileCompleted == null) {
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => ProfileCompletion()),
  //         // );
  //         setState(() {
  //           _pinPutController.clear();
  //         });
  //       } else if (userActiveStatus == "0" || userActiveStatus == null) {
  //         Flushbar(
  //           flushbarPosition: FlushbarPosition.TOP,
  //           titleColor: Strings.kBlackcolor,
  //           messageColor: Strings.kBlackcolor,
  //           backgroundColor: Colors.white,
  //           leftBarIndicatorColor: Strings.kPrimarycolor,
  //           title: "Hey",
  //           message: "Your Account Not Verified By Admin",
  //           duration: const Duration(seconds: 6),
  //         ).show(context);
  //         setState(() {
  //           _pinPutController.clear();
  //         });
  //       } else if (userActiveStatus == "-1") {
  //         Flushbar(
  //           flushbarPosition: FlushbarPosition.TOP,
  //           titleColor: Strings.kBlackcolor,
  //           messageColor: Strings.kBlackcolor,
  //           backgroundColor: Colors.white,
  //           leftBarIndicatorColor: Strings.kPrimarycolor,
  //           title: "Hey",
  //           message: "Your Account was Rejected",
  //           duration: const Duration(seconds: 6),
  //         ).show(context);
  //         setState(() {
  //           _pinPutController.clear();
  //         });
  //       } else {}
  //     } else if (response.statusCode == 403) {
  //       Flushbar(
  //         flushbarPosition: FlushbarPosition.TOP,
  //         titleColor: Strings.kBlackcolor,
  //         messageColor: Strings.kBlackcolor,
  //         backgroundColor: Colors.white,
  //         leftBarIndicatorColor: Strings.kPrimarycolor,
  //         title: "Hey",
  //         message: "Your session has been expired please login",
  //         duration: const Duration(seconds: 6),
  //       ).show(context);

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //       );
  //     }
  //     setState(() {
  //       _pinPutController.clear();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}

class LoginController extends GetxController {
  var uniq = "".obs;
  var userName = "".obs;

  void updateUniqId(String id) {
    uniq.value = id;
  }
}
