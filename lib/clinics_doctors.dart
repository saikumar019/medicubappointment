import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:another_flushbar/flushbar.dart';

import 'helpers/strings.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/svg.dart';

import 'my_appointment.dart';

class ClinicsAndDoctors extends StatefulWidget {
  List? clinics = [];
  List? doctors = [];
  String? serName = "";
  ClinicsAndDoctors({super.key, this.clinics, this.doctors, this.serName});

  @override
  State<ClinicsAndDoctors> createState() => _ClinicsAndDoctorsState();
}

class _ClinicsAndDoctorsState extends State<ClinicsAndDoctors> {
  DateTime? _selectedDate;
  String? selectedDate;
  String? page;
  String? uniqId;
  String? sessionId;

  // var rangeSelectedValue;
  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      page = pref.getString('value');
      uniqId = pref.getString("user");
      sessionId = pref.getString('sessionId');
    });
    print(page);
    print(uniqId);
  }

  @override
  void initState() {
    getValue();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            elevation: 0,
            title: Text(widget.serName.toString())),
        body: Column(children: [
          // SizedBox(
          //   height: height / 100,
          // ),
          Container(
            padding: const EdgeInsets.all(0),
            color: const Color(0xFF286FB4),
            height: height / 16,
            child: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: height / 5,
              elevation: 1,
              backgroundColor: Colors.grey.shade100,
              bottom: TabBar(
                isScrollable: false,
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: const TextStyle(
                    // fontFamily: Strings.poppins,
                    ),
                indicatorWeight: 2,
                indicatorColor: const Color(0xFF286FB4),
                labelColor: const Color(0xFF286FB4),
                indicatorSize: TabBarIndicatorSize.tab,
                overlayColor:
                    MaterialStateProperty.all(const Color(0xFFFFFFFFF)),
                labelStyle: const TextStyle(
                    // fontFamily: Strings.poppins,
                    fontWeight: FontWeight.w900),
                tabs: const [
                  Tab(
                    child: Text(
                      "Doctors",
                      style: TextStyle(
                        fontSize: 16,
                        // fontFamily: Strings.poppins,
                      ),
                    ),
                  ),
                  Tab(
                      child: Text(
                    "Clinics",
                    style: TextStyle(fontSize: 16),
                  )),
                ],
              ),
            ),
          ),
          Expanded(
              child: TabBarView(
            children: [
              ListView.builder(
                  itemCount: widget.doctors!.length,
                  itemBuilder: ((context, index) {
                    var coordinates =
                        jsonDecode(widget.doctors![index]["location"]);

                    // var latLong = jsonDecode(coordinates);

                    var lat = coordinates["latitude"];
                    var lon = coordinates["longitude"];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // crossAxisAlignment: ,

                                children: [
                                  widget.doctors![index]["image"] != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 35,
                                            backgroundColor:
                                                Strings.kPrimarycolor,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor:
                                                  Strings.kPrimarycolor,
                                              backgroundImage: NetworkImage(
                                                  widget.doctors![index]
                                                      ["image"]),
                                            ),
                                          ))
                                      : const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 35,
                                            backgroundColor:
                                                Strings.kPrimarycolor,
                                            child: Center(
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    Strings.kWhitecolor,
                                                backgroundImage: AssetImage(
                                                    "assets/images/intro1.png"),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: width / 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.doctors![index]["name"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Strings.kBlackcolor,
                                            fontSize: 19),
                                      ),
                                      Text(
                                        widget.doctors![index]["subspeciality"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Strings.kBlackcolor,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        "Online_availability: ${widget.doctors![index]["online_availability"]}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Strings.kTextbagroundcolor,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 8,
                                  ),
                                  widget.doctors![index]["DISTANCE"]
                                              .toString() ==
                                          "0"
                                      ? const Text("0.0 Km")
                                      : Text(
                                          "${widget.doctors![index]["DISTANCE"].toString().substring(0, 5)} Km",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Strings.kBlackcolor,
                                              fontSize: 14),
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: height / 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: (() {
                                      _makePhoneCall(
                                          widget.doctors![index]["mobile"]);
                                    }),
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Strings.kPrimarycolor,
                                      child: Icon(
                                        Icons.phone,
                                        color: Strings.kWhitecolor,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: width / 20,
                                  // ),

                                  GestureDetector(
                                    onTap: () {
                                      openMap(lat, lon);
                                    },
                                    child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Strings.kPrimarycolor,
                                        child: SvgPicture.asset(
                                          "assets/svg/distance.svg",
                                          height: 19,
                                        )),
                                  ),

                                  Center(
                                    child: MaterialButton(
                                      // minWidth: width / 1.2,
                                      elevation: 2,
                                      color: const Color(0xffF89122),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: (() async {
                                        _doctorsonlinepickDateDialog(
                                            widget.doctors![index]
                                                ["doctors_unique_id"]);
                                      }),
                                      child: const Text(
                                        "Book Appointment",
                                        style: TextStyle(
                                            color: Strings.kWhitecolor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: Strings.latoBold),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
              ListView.builder(
                  itemCount: widget.clinics!.length,
                  itemBuilder: ((context, index) {
                    var coordinates =
                        jsonDecode(widget.clinics![index]["location"]);

                    // var latLong = jsonDecode(coordinates);

                    var lat = coordinates["latitude"];
                    var lon = coordinates["longitude"];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Image.network(
                                  //   widget.clinics![index]["mobile"].toString(),
                                  //   height: height / 10,
                                  //   scale: 1,
                                  //   width: width / 5,
                                  // ),
                                  SizedBox(
                                    width: width / 20,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.clinics![index]["name"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Strings.kBlackcolor,
                                                fontSize: 19),
                                          ),
                                          Text(
                                            widget.clinics![index]
                                                ["subspeciality"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Strings.kBlackcolor,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                      // Spacer(),
                                      SizedBox(
                                        width: width / 5,
                                      ),
                                      widget.clinics![index]["DISTANCE"]
                                                  .toString() ==
                                              "0"
                                          ? const Text("0.0 Km")
                                          : Text(
                                              "${widget.clinics![index]["DISTANCE"].toString().substring(0, 5)} Km",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Strings.kBlackcolor,
                                                  fontSize: 14),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height / 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: (() {
                                      _makePhoneCall(
                                          widget.clinics![index]["mobile"]);
                                    }),
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Strings.kPrimarycolor,
                                      child: Icon(
                                        Icons.phone,
                                        color: Strings.kWhitecolor,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: width / 20,
                                  // ),

                                  GestureDetector(
                                    onTap: () {
                                      openMap(lat, lon);
                                    },
                                    child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Strings.kPrimarycolor,
                                        child: SvgPicture.asset(
                                          "assets/svg/distance.svg",
                                          height: 19,
                                        )),
                                  ),
                                  // Spacer(),
                                  Center(
                                    child: MaterialButton(
                                      // minWidth: width / 1.2,
                                      elevation: 2,
                                      color: const Color(0xffF89122),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: (() async {
                                        _cliniconlinepickDateDialog(
                                            widget.clinics![index]
                                                ["clinic_unique_id"]);
                                      }),
                                      child: const Text(
                                        "Book Appointment",
                                        style: TextStyle(
                                            color: Strings.kWhitecolor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: Strings.latoBold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
            ],
          ))
        ]),
      ),
    );
  }

  Future _doctorsonlinepickDateDialog(String doctorsuniq) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          String rangeSelectedValue = 'offline';

          var rangeItems = [
            'offline',
            'online',
          ];

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Choose Appointment_mode'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      DropdownButton(
                        // Initial Value
                        value: rangeSelectedValue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items

                        items: rangeItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
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
                    ],
                  ),
                ),
              ),
              actions: [
                MaterialButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      Navigator.pop(context);

                      docAppointmentAction(doctorsuniq, rangeSelectedValue);
                    })
              ],
            );
          });
        });
  }

  Future<void> docAppointmentAction(
      String doctorsId, String appointmode) async {
    try {
      var url = '${Strings.baseUrl}book_appointment';

      var data = {
        'doctors_unique_id': doctorsId,
        "clinics_unique_id": "",
        'appointment_mode': appointmode,
        'user_unique_id': uniqId,
      };

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 201) {
        var message = jsonDecode(response.body);
        print(message);
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "Hey",
          message: "Appointment Created Successfully",
          duration: const Duration(seconds: 6),
        ).show(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentList()),
        );
      } else if (response.statusCode == 403) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future _cliniconlinepickDateDialog(String clinicUniqueId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          String rangeSelectedValue = 'offline';

          var rangeItems = [
            'offline',
            'online',
          ];

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Choose Appointment_mode'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      DropdownButton(
                        // Initial Value
                        value: rangeSelectedValue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items

                        items: rangeItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
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
                    ],
                  ),
                ),
              ),
              actions: [
                MaterialButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      Navigator.pop(context);

                      clinicAppointmentAction(
                          clinicUniqueId, rangeSelectedValue);
                    })
              ],
            );
          });
        });
  }

  Future<void> clinicAppointmentAction(
      String clinicsId, String appointmode) async {
    try {
      var url = '${Strings.baseUrl}book_appointment';

      var data = {
        'doctors_unique_id': "",
        "clinics_unique_id": clinicsId,
        'appointment_mode': appointmode,
        'user_unique_id': uniqId,
      };

      var response = await post(Uri.parse(url), body: (data));

      if (response.statusCode == 201) {
        var message = jsonDecode(response.body);
        print(message);
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          titleColor: Strings.kBlackcolor,
          messageColor: Strings.kBlackcolor,
          backgroundColor: Colors.white,
          leftBarIndicatorColor: Strings.kPrimarycolor,
          title: "Hey",
          message: "Appointment Created Successfully",
          duration: const Duration(seconds: 6),
        ).show(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentList()),
        );
      } else if (response.statusCode == 403) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static Future<void> openMap(String latitude, String longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
