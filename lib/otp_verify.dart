import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:http/http.dart';
import 'package:medicub_appointment/helpers/strings.dart';
import 'package:medicub_appointment/homescreen.dart';

import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerify extends StatefulWidget {
  String? phoneNumber;
  OtpVerify({super.key, this.phoneNumber});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController _pinPutController = TextEditingController();
  // final controller = Get.put(LoginController());
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
      sessionId = prefer.getString('sessionId');
    });
    // getUser();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
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
    return Scaffold(
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
            // otpSend == false
            //     ? Padding(
            //         padding: EdgeInsets.only(left: width / 12),
            //         child: const Text(
            //           "Login/Register",
            //           style: TextStyle(
            //               color: Color(0xff383337),
            //               fontFamily: Strings.lato,
            //               fontWeight: FontWeight.w600,
            //               fontSize: 21),
            //         ),
            //       )
            //     : SizedBox(),
            // SizedBox(
            //   height: height / 50,
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: width / 12),
            //   child: Material(
            //     elevation: 1,
            //     borderRadius: BorderRadius.circular(10),
            //     color: const Color(0xffFFFFFF),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: const Color(0xffFFFFFF),
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: TextFormField(
            //         onChanged: (value) {
            //           setState(() {
            //             number = value;
            //           });
            //           print(number);
            //           if (number!.length == 10) {
            //             setState(() {
            //               otpGenerate();
            //             });
            //           }

            //           numberLength = !numberLength;
            //         },
            //         keyboardType:
            //             const TextInputType.numberWithOptions(decimal: true),
            //         inputFormatters: [
            //           FilteringTextInputFormatter.allow(
            //               RegExp('([0-9]+(.[0-9]+)?)')),
            //         ],
            //         controller: _numberController,
            //         decoration: InputDecoration(
            //             isDense: true,
            //             hintText: "Enter Mobile Number",
            //             hintStyle: TextStyle(
            //                 color: const Color(0xff09726C).withOpacity(0.26)),
            //             suffixIcon: _numberController.text.length == 10
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
              padding: EdgeInsets.symmetric(
                  horizontal: width / 10, vertical: height / 50),
              child: Text("Mobile Otp Sent to ${widget.phoneNumber}"),
            ),

            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 10, vertical: height / 50),
                  child: PinPut(
                    fieldsCount: 6,
                    validator: (s) {},
                    onSubmit: (String pin) {
                      print(pin);
                    },
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    selectedFieldDecoration: _pinPutDecoration,
                    pinAnimationType: PinAnimationType.rotation,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Strings.kPrimarycolor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 5),
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't receive a code?",
                      style: const TextStyle(
                          color: Color(0xff09726C), fontSize: 12),
                      children: [
                        TextSpan(
                            text: ' Resend code',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                resendOtp();
                              },
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(
                                  0xff09726C,
                                ),
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 60,
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
                      loginOtp();

                      // await verifyOtp();
                    }),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Strings.kWhitecolor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: Strings.latoBold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> resendOtp() async {
    try {
        const url = "${Strings.baseUrl}Resend_otp";

      

      var data = {'mobile': widget.phoneNumber.toString()};

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 201) {
        print(response.body);
      } else if (response.statusCode == 403) {}
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> otpGenerate() async {
  //   try {
  //     var url = '${Strings.baseUrl}Generate_otp';

  //     var data = {'mobile': _numberController.text};

  //     var response = await post(Uri.parse(url), body: (data));

  //     if (response.statusCode == 201) {
  //       // var message = jsonDecode(response.body);

  //       setState(() {
  //         otpSend == true;
  //       });
  //     } else if (response.statusCode == 403) {
  //       print(response.body);

  //       // Flushbar(
  //       //   flushbarPosition: FlushbarPosition.TOP,
  //       //   titleColor: Strings.kBlackcolor,
  //       //   messageColor: Strings.kBlackcolor,
  //       //   backgroundColor: Colors.white,
  //       //   leftBarIndicatorColor: Strings.kPrimarycolor,
  //       //   title: "Hey",
  //       //   message: "Us",
  //       //   duration: Duration(seconds: 3),
  //       // )..show(context);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> loginOtp() async {
    try {
      const url = "${Strings.baseUrl}Login";

      var data = {
        'mobile': widget.phoneNumber.toString(),
        'mobile_otp': _pinPutController.text,
      };

      var response = await post(Uri.parse(url), body: (data));

      var message = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var userUnique = message["user_unique_id"];
        var name = message["name"];
        var number = message["mobile"];

        // var isProfileCompleted = message["is_profile_completed"];
        final SharedPreferences prefer = await SharedPreferences.getInstance();

        prefer.setString("user", userUnique);
        prefer.setString("name", name);
        prefer.setString("number", number);

        // prefer.setString("isProfile", isProfileCompleted);

        prefer.setString("mobileNumber", _numberController.text);
        getUniqueUserId();

        print("login");
      }
    } catch (err) {}
  }
}
