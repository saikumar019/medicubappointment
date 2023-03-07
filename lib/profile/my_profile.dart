import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medicub_appointment/homescreen.dart';
import 'package:medicub_appointment/profile/edit_profile.dart';

import 'package:page_transition/page_transition.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import '../helpers/strings.dart';
import 'my_profile.dart';

class MyProfile extends StatefulWidget {
  String? uniqueId;
  MyProfile({super.key, this.uniqueId});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String? uniqId;
  List userProfileData = [];

  getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");
    });

    profileData();
  }

  @override
  void initState() {
    getValue();

    super.initState();
  }

  @override
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
          // drawer: Drawer(),

          appBar: AppBar(
            leading: IconButton(
                onPressed: (() {
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }),
                icon: const Icon(Icons.arrow_back)),
            iconTheme: const IconThemeData(color: Strings.kBlackcolor),
            elevation: 0,
            backgroundColor: Strings.kPrimarycolor,
            toolbarHeight: height / 15,
            centerTitle: true,
            title: const Text(
              "Manage Profile",
              style: TextStyle(
                  color: Strings.kBlackcolor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          body: userProfileData.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 19),
                        child: const Text(
                          "Your Profile",
                          style: TextStyle(
                              color: Color(0xff006699),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: height / 60,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 19),
                        child: Container(
                          height: 3,
                          width: width / 5,
                          color: Colors.green,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width / 30, vertical: height / 100),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: const Color(0XFFb3e6ff).withOpacity(0.4),
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width / 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 20,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Name",
                                      style: TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Color(0xff006699),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "   :  ${userProfileData[0]["name"]}",
                                      style: const TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Strings.kBlackcolor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 70,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Number",
                                      style: TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Color(0xff006699),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      " : ${userProfileData[0]["mobile"]}",
                                      style: const TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Strings.kBlackcolor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 80,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Color(0xff006699),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      " :  ${userProfileData[0]["email"]}",
                                      style: const TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Strings.kBlackcolor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 80,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "AlternateMobileNo",
                                      style: TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Color(0xff006699),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    userProfileData[0]["alternate_mobile_no"] !=
                                            null
                                        ? Text(
                                            " : ${userProfileData[0]["alternate_mobile_no"]}",
                                            style: const TextStyle(
                                                fontFamily: Strings.lato,
                                                color: Strings.kBlackcolor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : const Text(
                                            " :",
                                            style: TextStyle(
                                                fontFamily: Strings.lato,
                                                color: Strings.kBlackcolor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 100,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Gender",
                                      style: TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Color(0xff006699),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      " : ${userProfileData[0]["gender"]}",
                                      style: const TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Strings.kBlackcolor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 80,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Age",
                                      style: TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Color(0xff006699),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    userProfileData[0]["age"] != null
                                        ? Text(
                                            " : ${userProfileData[0]["age"]}",
                                            style: const TextStyle(
                                                fontFamily: Strings.lato,
                                                color: Strings.kBlackcolor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : const Text(
                                            " :",
                                            style: TextStyle(
                                                fontFamily: Strings.lato,
                                                color: Strings.kBlackcolor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          )
                                  ],
                                ),
                                SizedBox(
                                  height: height / 80,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "BloodGroup",
                                      style: TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Color(0xff006699),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      " : ${userProfileData[0]["blood_group"]}",
                                      style: const TextStyle(
                                          fontFamily: Strings.lato,
                                          color: Strings.kBlackcolor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfile()));
                                      },
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(
                                            color: Strings.kPrimarycolor,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height / 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator())),
    );
  }

  Future<void> profileData() async {
    try {
      var url = '${Strings.baseUrl}R_userbyid';

      var data = {
        'user_unique_id': uniqId,
      };

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);

        setState(() {
          userProfileData = message["data"];
        });
      } else if (response.statusCode == 403) {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> profileUpdate() async {
  //   try {
  //     var url = '${Strings.baseUrl}Profile_update';

  //     // var data = {
  //     //   'user_unique_id': uniqId,
  //     //   'name': _fullnameController.text,
  //     //   'email': _emailController.text,
  //     //   'mobile': _mobileController.text,
  //     //   'alternate_mobile_no': _alternativemobilenumberController.text,
  //     //   'date_of_birth': _dateController.text,
  //     //   'gender': gender.toString(),
  //     //   'blood_group': __bloodgroupController.text,
  //     // };

  //     var response = await post(Uri.parse(url), body: (data));

  //     if (response.statusCode == 201) {
  //       var message = jsonDecode(response.body);

  //       profileData();

  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: Colors.black,
  //           content: Text(
  //             "Your Profile Updated Successfully",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontFamily: Strings.lato,
  //             ),
  //           )));
  //     } else if (response.statusCode == 403) {
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => const LoginScreen()));
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
