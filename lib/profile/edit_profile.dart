import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:page_transition/page_transition.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import '../helpers/strings.dart';
import 'my_profile.dart';

class EditProfile extends StatefulWidget {
  String? uniqueId;
  EditProfile({super.key, this.uniqueId});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? uniqId;
  List userProfileData = [];
  String? isSessionId;

  String imageProfile = '';
  String? sharedImage = '';
  String gender = 'Male';
  String bloodgroup = 'Blood Group';

  // List of items in our dropdown menu
  var genderItems = ['Male', 'Female', 'Others'];

  var bloodItems = ['Blood Group', 'O+', 'O-', 'AB+', 'AB-', 'B+', 'B-'];

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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alternativemobilenumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController __bloodgroupController = TextEditingController();
  String? aadhaarNumber;

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfile()),
                  );
                }),
                icon: const Icon(Icons.arrow_back)),
            iconTheme: const IconThemeData(color: Strings.kBlackcolor),
            elevation: 0,
            backgroundColor: Strings.kPrimarycolor,
            toolbarHeight: height / 15,
            centerTitle: true,
            title: const Text(
              "My Profile",
              style: TextStyle(
                  color: Strings.kBlackcolor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          body: userProfileData.isNotEmpty
              ? SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 20,
                        ),
                        SizedBox(
                          height: height / 50,
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
                                controller: _fullnameController
                                  ..text = userProfileData[0]["name"]
                                          .toString()
                                          .isNotEmpty
                                      ? userProfileData[0]["name"]
                                      : "",
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Name",
                                    hintStyle: TextStyle(
                                        color: const Color(0xff09726C)
                                            .withOpacity(0.26)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
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
                                controller: _emailController
                                  ..text = userProfileData.isNotEmpty
                                      ? userProfileData[0]["email"]
                                      : "",
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Email Address",
                                    hintStyle: TextStyle(
                                        color: const Color(0xff09726C)
                                            .withOpacity(0.26)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    fillColor: const Color(0xffFFFFFF)),
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return 'Enter a valid email!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 70,
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
                                controller: _mobileController
                                  ..text = userProfileData.isNotEmpty
                                      ? userProfileData[0]["mobile"]
                                      : "",
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Mobile Number",
                                    hintStyle: TextStyle(
                                        color: const Color(0xff09726C)
                                            .withOpacity(0.26)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    fillColor: const Color(0xffFFFFFF)),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter 10 digits Mobile Number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 12),
                          child: Row(
                            children: [
                              userProfileData.isNotEmpty
                                  ? Material(
                                      elevation: 1,
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffFFFFFF),
                                      child: Padding(
                                        padding: EdgeInsets.all(width / 28),
                                        child: Text(
                                            "${userProfileData[0]["gender"]}"),
                                      ))
                                  : const Text(""),
                              SizedBox(
                                width: width / 100,
                              ),
                              // Spacer(),
                              SizedBox(
                                height: height / 20,
                                width: width / 2,
                                child: Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffFFFFFF),
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButton(
                                      // Initial Value
                                      value: gender,
                                      isExpanded: true,

                                      // Down Arrow Icon
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),

                                      iconSize: 29,
                                      underline: const SizedBox(),

                                      // Array list of items

                                      items: genderItems.map((String items) {
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
                                          gender = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 12),
                          child: Row(
                            children: [
                              userProfileData.isNotEmpty
                                  ? Material(
                                      elevation: 1,
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffFFFFFF),
                                      child: Padding(
                                        padding: EdgeInsets.all(width / 28),
                                        child: Text(
                                            "${userProfileData[0]["blood_group"]}"),
                                      ))
                                  : const Text(""),
                              SizedBox(
                                width: width / 100,
                              ),
                              // Spacer(),
                              SizedBox(
                                height: height / 20,
                                width: width / 2,
                                child: Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffFFFFFF),
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButton(
                                      // Initial Value
                                      value: bloodgroup,
                                      isExpanded: true,

                                      // Down Arrow Icon
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),

                                      iconSize: 29,
                                      underline: const SizedBox(),

                                      // Array list of items

                                      items: bloodItems.map((String items) {
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
                                          bloodgroup = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 100,
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
                                controller: _alternativemobilenumberController
                                  ..text = userProfileData[0]
                                              ["alternate_mobile_no"] !=
                                          null
                                      ? userProfileData[0]
                                              ["alternate_mobile_no"]
                                          .toString()
                                      : "",
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Alternative Mobile Number",
                                    hintStyle: TextStyle(
                                        color: const Color(0xff09726C)
                                            .withOpacity(0.26)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    fillColor: const Color(0xffFFFFFF)),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter 10 digits Mobile Number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 100,
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
                                controller: _ageController
                                  ..text = userProfileData[0]["age"] != null
                                      ? userProfileData[0]["age"].toString()
                                      : "",
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Age",
                                    hintStyle: TextStyle(
                                        color: const Color(0xff09726C)
                                            .withOpacity(0.26)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFFFFF)),
                                    ),
                                    fillColor: const Color(0xffFFFFFF)),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Age';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 50,
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
                              if (_formKey.currentState!.validate()) {
                                profileUpdate();
                              }
                            }),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                  color: Strings.kWhitecolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Strings.latoBold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 40,
                        ),
                      ],
                    ),
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

  Future<void> profileUpdate() async {
    try {
      var url = '${Strings.baseUrl}Profile_update';

      var data = {
        'user_unique_id': uniqId,
        'name': _fullnameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'alternate_mobile_no': _alternativemobilenumberController.text,
        'age': _ageController.text,
        'gender': gender.toString(),
        'blood_group': bloodgroup.toString(),
      };

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 201) {
        var message = jsonDecode(response.body);

        profileData();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              "Your Profile Updated Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: Strings.lato,
              ),
            )));
      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
