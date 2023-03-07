// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:medicub_appointment/profile/edit_profile.dart';
import 'package:medicub_appointment/surgeries_view.dart';
// import 'package:medicub/clinic/clinic.dart';
// import 'package:medicub/diagnostic/diagnostic_view.dart';
// import 'package:medicub/hospitals/hospitals.dart';
// import 'package:medicub/login.dart';
// import 'package:medicub/my_appointment.dart';
// import 'package:medicub/pharmacy/pharmacy_screen.dart';
// import 'package:medicub/profile/my_profile.dart';
import 'package:place_picker/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'clinics_doctors.dart';
import 'profile/login.dart';
import 'helpers/strings.dart';
import 'my_appointment.dart';
import 'profile/my_profile.dart';

class HomeScreen extends StatefulWidget {
  String? userName;
  String? usrUniqueId;
  HomeScreen({super.key, this.userName, this.usrUniqueId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uniqId;

  String userName = "";
  String? number = "";
  String? name;

  var UserprofileData;

  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");
      number = pref.getString("number");
      name = pref.getString("name");
    });

    print(uniqId);
    lookUp();
    profileData();
  }

  final controller = Get.put(LoginController());
  var myIns;
  List partners = [];
  List clinics = [];
  List doctors = [];

  var myins1;
  bool isSelected = false;
  bool isSelected1 = false;

  bool isSelected2 = false;
  bool isSelected3 = false;

  List specality = [];
  List subSpeacality = [];
  var partId;

  var partId1;

  // String? _selectedLocation;

  // var _latitude = "";
  // var _longitude = "";
  // var _altitude = "";
  // var _speed = "";
  // var _address = "";
  // var _address1 = "";

  // var _address2 = "";

  // Future<void> _updatePosition() async {
  //   Position position = await _determinePosition();
  //   List<Placemark> pm =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);

  //   Placemark place = pm[0];

  //   setState(() {
  //     _latitude = position.latitude.toString();
  //     _longitude = position.longitude.toString();
  //     _altitude = position.altitude.toString();
  //     _speed = position.speed.toString();

  //     _address = pm[0].toString();

  //     _address1 = place.locality.toString();
  //     _address2 = place.subLocality.toString();

  //     // _address1 = _address[0][8].toString();
  //     // _address2 = _address[0][9].toString();
  //     print(_address);

  //     // _address2 = pm[8].toString();
  //   });
  // }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   return await Geolocator.getCurrentPosition();
  // }

  var _address = "";
  // var _address1 = "";

  var _address2 = "";
  String? subLocality1name;

  String? administrative1name;

  LocationResult? location;
  LatLng? latlang;
  double? latitude;
  double? longitude;

  void showPlacePicker() async {
    LocationResult? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyDnlgk_3dfS6s98DMe47PoBD5RxmkK3Cro")));

    setState(() {
      location = result;

      // _address1 = location!.locality.toString();
      _address2 = location!.locality.toString();
      latlang = location!.latLng;

      print(_address2);

      latitude = latlang!.latitude;
      longitude = latlang!.longitude;

      _address = location!.formattedAddress.toString();
      subLocality1name = location!.subLocalityLevel1!.name;
      administrative1name = location!.administrativeAreaLevel1!.name;

      // print(_address);

      // _address2 = pm[8].toString();
    });
    // Handle the result in your way
    print(result);
  }

  String rangeSelectedValue = '10';

  // List of items in our dropdown menu
  var rangeItems = ['10', '50', '100', '200', '500', '1000'];
  // var rangeSelectedValue;

  @override
  void initState() {
    getValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        debugPrint("Will pop");
        return false;
      },
      child: Scaffold(
          drawer: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 30,
                ),
                Container(
                  // color: Strings.kPrimarycolor.withOpacity(0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 40,
                      ),
                      Container(
                        width: double.infinity,
                        color: Strings.kPrimarycolor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: height / 100),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 15),
                                child: Row(
                                  children: [
                                    // userImage != null
                                    //     ? CircleAvatar(
                                    //         radius: 60,
                                    //         backgroundColor: Strings.kPrimarycolor,
                                    //         child: CircleAvatar(
                                    //             radius: 55,
                                    //             backgroundImage:
                                    //                 NetworkImage(userImage.toString())),
                                    //       )
                                    //     : const CircleAvatar(
                                    //         radius: 60,
                                    //         backgroundColor: Strings.kPrimarycolor,
                                    //         child: CircleAvatar(
                                    //             radius: 55,
                                    //             backgroundImage: AssetImage(
                                    //                 "assets/images/profile.png")),
                                    //       ),
                                    // SizedBox(
                                    //   width: width / 40,
                                    // ),
                                    userName.isEmpty
                                        ? const Text("")
                                        : CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                Strings.kWhitecolor,
                                            child: Text(
                                              userName[0].toUpperCase(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                    SizedBox(
                                      width: width / 18,
                                    ),

                                    Column(
                                      children: [
                                        Container(
                                          // color: Strings.kPrimarycolor,
                                          width: width / 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userName.toUpperCase(),
                                                style: const TextStyle(
                                                    color: Strings.kWhitecolor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: Strings.lato,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                "$number",
                                                style: const TextStyle(
                                                    color: Strings.kWhitecolor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: Strings.lato,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Strings.kWhitecolor,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: height / 20,
                      // ),

                      SizedBox(
                        height: height / 100,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: height / 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentList()),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 19),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svg/appointments.svg"),
                              SizedBox(
                                width: width / 80,
                              ),
                              Text(
                                "My Appointments",
                                style: TextStyle(
                                    color: const Color(0xff1C1C1C)
                                        .withOpacity(0.6),
                                    fontFamily: Strings.lato,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: height / 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfile()),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 19),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svg/profile.svg"),
                              SizedBox(
                                width: width / 80,
                              ),
                              Text(
                                "My Account",
                                style: TextStyle(
                                    color: const Color(0xff1C1C1C)
                                        .withOpacity(0.6),
                                    fontFamily: Strings.lato,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: height / 20,
                    ),
                    SizedBox(
                      height: height / 300,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          logoutHome();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginScreen()),
                              (Route<dynamic> route) => false);
                          // Navigator.popUntil(context, ModalRoute.withName("/transition1"));

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => MyProfile()),
                          // );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 19),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svg/logout.svg"),
                              SizedBox(
                                width: width / 80,
                              ),
                              Text(
                                "Logout",
                                style: TextStyle(
                                    color: const Color(0xff1C1C1C)
                                        .withOpacity(0.6),
                                    fontFamily: Strings.lato,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
          backgroundColor: Strings.kBackgroundcolor,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: false,
            backgroundColor: Strings.kPrimarycolor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Welcome   $userName",
                //   style: const TextStyle(
                //       color: Strings.kBlackcolor,
                //       fontWeight: FontWeight.w700,
                //       fontFamily: Strings.lato,
                //       fontSize: 18),
                // ),
                // Center(
                //   child: Obx(() => Text(controller.uniq.toString())),
                // ),
                // SizedBox(
                //   height: height / 80,
                // ),
              ],
            ),
            // toolbarHeight: height / 7,
            elevation: 2,
            shadowColor: Strings.kBlackcolor.withOpacity(0.16),
          ),

          // body: CardList(),
          body: Column(
            children: [
              SizedBox(
                height: height / 30,
              ),
              CarouselSlider(
                  items: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/11.png",
                              ),
                              fit: BoxFit.fill)),
                      // child: Image.asset(
                      //   "assets/images/9.png",
                      // ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/10.png",
                              ),
                              fit: BoxFit.fill)),
                      // child: Image.asset(
                      //   "assets/images/9.png",
                      // ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/11.png",
                              ),
                              fit: BoxFit.fill)),
                      // child: Image.asset(
                      //   "assets/images/9.png",
                      // ),
                    ),
                  ],
                  options: CarouselOptions(
                    height: height / 8,

                    // aspectRatio: 16 / 10,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  )),
              SizedBox(
                height: height / 30,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width / 20, right: width / 20, top: width / 20),
                child: Row(
                  children: [
                    const Text(
                      "Plan Your Surgery",
                      style: TextStyle(
                          color: Strings.kSecondarytextColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: Strings.lato,
                          fontSize: 18),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            // DropdownButton(
                            //   // Initial Value
                            //   value: rangeSelectedValue,

                            //   // Down Arrow Icon
                            //   icon: const Icon(Icons.keyboard_arrow_down),

                            //   // Array list of items

                            //   items: rangeItems.map((String items) {
                            //     return DropdownMenuItem(
                            //       value: items,
                            //       child: Text(items),
                            //     );
                            //   }).toList(),
                            //   // After selecting the desired option,it will
                            //   // change button value to selected value
                            //   onChanged: (String? newValue) {
                            //     setState(() {
                            //       rangeSelectedValue = newValue!;
                            //     });
                            //   },
                            // ),
                            // SizedBox(
                            //   width: width / 90,
                            // ),
                            // Text("km"),
                          ],
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showPlacePicker();
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.pin_drop,
                                color: Strings.kPrimarycolor,
                              ),
                              administrative1name != null
                                  ? Text(
                                      "${administrative1name}/${_address2}",
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Strings.kSecondarytextColor,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: Strings.lato,
                                          fontSize: 10),
                                    )
                                  : const Center(child: Text("Location")),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height / 30,
              ),
              Padding(
                padding: EdgeInsets.only(left: width / 50),
                child: SizedBox(
                  height: height / 3,
                  width: double.infinity,
                  child: GridView.builder(
                      itemCount: specality.length,
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0 / 1.0,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 1),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Map coordinates = {
                              "latitude": latitude,
                              "longitude": longitude
                            };
                            // Map coordinates = {
                            //   "latitude": "17.52492244067104",
                            //   "longitude": "78.32495349489083"
                            // };

                            if ((latitude != null) && (latlang != null)) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SurgeriesView(
                                          latlong: coordinates,
                                          suegeries: subSpeacality,
                                          surgeryname: specality[index]
                                              ["speciality"],
                                          location: _address2,
                                          uniq: specality[index]
                                              ["speciality_unique_id"],
                                        )),
                              );
                            } else {
                              Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                titleColor: Strings.kBlackcolor,
                                messageColor: Strings.kBlackcolor,
                                backgroundColor: Colors.white,
                                leftBarIndicatorColor: Strings.kPrimarycolor,
                                title: "Hey",
                                message: "Please Select Location",
                                duration: const Duration(seconds: 3),
                              )..show(context);
                            }

                            // setState(() {
                            //   isSelected = !isSelected;
                            // });
                            // if ((latitude.toString().isNotEmpty) &&
                            //     (latlang.toString().isNotEmpty)) {
                            //   if (rangeItems.isNotEmpty) {
                            //     searchDoctors(
                            //         specality[index]["speciality_unique_id"],
                            //         specality[index]["speciality"]);
                            //   } else {
                            //     Flushbar(
                            //       flushbarPosition: FlushbarPosition.TOP,
                            //       titleColor: Strings.kBlackcolor,
                            //       messageColor: Strings.kBlackcolor,
                            //       backgroundColor: Colors.white,
                            //       leftBarIndicatorColor: Strings.kPrimarycolor,
                            //       title: "Hey",
                            //       message: "Select Range Distance",
                            //       duration: Duration(seconds: 3),
                            //     )..show(context);
                            //   }
                            // } else {
                            //   Flushbar(
                            //     flushbarPosition: FlushbarPosition.TOP,
                            //     titleColor: Strings.kBlackcolor,
                            //     messageColor: Strings.kBlackcolor,
                            //     backgroundColor: Colors.white,
                            //     leftBarIndicatorColor: Strings.kPrimarycolor,
                            //     title: "Hey",
                            //     message: "Select Latitude&Longitude",
                            //     duration: Duration(seconds: 3),
                            //   )..show(context);
                            // }
                          },
                          child: Card(
                            elevation:
                                2.0, // this field changes the shadow of the card 1.0 is default
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.2, color: Colors.white),
                                borderRadius: BorderRadius.circular(20)),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: height / 70,
                                ),
                                Image.network(
                                  specality[index]["icons"],
                                  height: height / 15,
                                  width: width / 5,
                                ),
                                SizedBox(
                                  height: height / 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    specality[index]["speciality"],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: Strings.lato,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                height: height / 40,
              ),
              isSelected == true
                  ? Center(
                      child: MaterialButton(
                        minWidth: width / 1.2,
                        elevation: 2,
                        color: const Color(0xffF89122),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: (() async {}),
                        child: const Text(
                          "Search",
                          style: TextStyle(
                              color: Strings.kWhitecolor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: Strings.latoBold),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          )),
    );
  }

  void Selected(int a) {
    setState(() {});
  }

  Future<void> lookUp() async {
    try {
      var url = '${Strings.baseUrl}Lookup';

      var response = await get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);

        var data = message["data"];

        setState(() {
          specality = data["speciality"];
          subSpeacality = data["sub_speciality"];
        });
      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void logoutHome() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
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
          UserprofileData = message["data"];
        });

        // userName = UserprofileData[0]["name"];
        // var sharedImage;
        setState(() {
          userName = UserprofileData[0]["name"];
          number = UserprofileData[0]["mobile"];

          // sharedImage = UserprofileData[0]["image_url"];
        });

        // setState(() {
        //   userImage = preferences.getString("image")!;
        // });

      } else if (response.statusCode == 403) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> searchDoctors(String speuniq, String serName) async {
    if (rangeSelectedValue.isNotEmpty) {
      Map coordinates = {"latitude": latitude, "longitude": longitude};
      // Map coordinates = {
      //   "latitude": "17.52492244067104",
      //   "longitude": "78.32495349489083"
      // };
      var cord = jsonEncode(coordinates);

      if ((latitude != null) && (longitude != null)) {
        try {
          var url = '${Strings.baseUrl}search_doctors_clinics';

          var data = {
            'speciality_unique_id': speuniq,
            'coordinates': cord,
            'range': rangeSelectedValue
          };

          var response = await post(Uri.parse(url), body: (data));

          if (response.statusCode == 200) {
            var message = jsonDecode(response.body);

            setState(() {
              var data = message["data"];

              clinics = data["clinics"];
              doctors = data["doctors"];
            });

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClinicsAndDoctors(
                          clinics: clinics,
                          doctors: doctors,
                          serName: serName,
                        )));

            print(message);
          } else if (response.statusCode == 404) {
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              titleColor: Strings.kBlackcolor,
              messageColor: Strings.kBlackcolor,
              backgroundColor: Colors.white,
              leftBarIndicatorColor: Strings.kPrimarycolor,
              title: "Hey",
              message: "Doctors & Clinics Not Found",
              duration: const Duration(seconds: 3),
            )..show(context);
          }
        } catch (e) {
          print(e.toString());
        }
      } else {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "Hey",
          message: "Please select location",
          duration: const Duration(seconds: 3),
        )..show(context);
      }
    }
  }
}
