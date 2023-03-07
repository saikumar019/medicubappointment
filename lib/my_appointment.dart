import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/strings.dart';
import 'profile/login.dart';

class AppointmentList extends StatefulWidget {
  AppointmentList({
    super.key,
  });

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List todayAppointments = [];
  List pastAppointments = [];
  List upcomingAppointments = [];
  List doctorstodayAppointments = [];
  List doctorspastAppointments = [];
  List doctorsupcomingAppointments = [];

  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   await launchUrl(launchUri);
  // }

  // Future<void> _launchURL(String weburl) async {
  //   String url = weburl;

  //   var uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // static Future<void> openMap(String latitude, String longitude) async {
  //   String googleUrl =
  //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  //   var googleuri = Uri.parse(googleUrl);

  //   if (await canLaunchUrl(googleuri)) {
  //     await launchUrl(googleuri);
  //   } else {
  //     throw 'Could not launch $googleuri';
  //   }
  // }

  Future<void> appointmentList() async {
    try {
      var url = '${Strings.baseUrl}User_appointment_doctors_clinics';
      var data = {
        'user_unique_id': uniqId,
      };
      var response = await post(Uri.parse(url), body: (data));
      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        print(message);
        setState(() {
          doctorstodayAppointments = message["data"]["Appointments_doctors"];
          todayAppointments = message["data"]["Appointments_clinics"];
        });
      } else if (response.statusCode == 403) {}
    } catch (e) {
      print(e.toString());
    }
  }

  String? page;
  String? uniqId;
  String? sessionId;
  void getValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      uniqId = pref.getString("user");
    });
    appointmentList();
    print(page);
    print(uniqId);
  }

  @override
  void initState() {
    getValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Strings.kBackgroundcolor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Strings.kPrimarycolor,
          leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(Icons.arrow_back)),
          title: const Text(
            "My Appointments",
            style: TextStyle(
                color: Strings.kBlackcolor,
                fontWeight: FontWeight.w700,
                fontFamily: Strings.lato,
                fontSize: 18),
          ),
          toolbarHeight: height / 12,
          elevation: 2,
          shadowColor: Strings.kBlackcolor.withOpacity(0.16),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  doctorstodayAppointments.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: doctorstodayAppointments.length,
                          itemBuilder: ((context, index) {
                            // var coordinates = jsonDecode(
                            //     doctorstodayAppointments[index]["location"]);

                            // var lat = coordinates["latitude"];
                            // var lon = coordinates["longitude"];
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 20,
                                    vertical: height / 100),
                                child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Strings.kWhitecolor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(4),
                                          leading: CircleAvatar(
                                            radius: 35,
                                            backgroundColor:
                                                Strings.kPrimarycolor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: doctorstodayAppointments[
                                                          index]["image"] !=
                                                      null
                                                  ? CircleAvatar(
                                                      radius: 35,
                                                      backgroundImage: NetworkImage(
                                                          doctorstodayAppointments[
                                                              index]["image"]),
                                                    )
                                                  : const CircleAvatar(
                                                      radius: 35,
                                                      backgroundImage: AssetImage(
                                                          "assets/images/profile.png"),
                                                    ),
                                            ),
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 2.5,
                                                    child:
                                                        doctorstodayAppointments[
                                                                        index][
                                                                    "status"] ==
                                                                "0"
                                                            ? Text("")
                                                            : Text(
                                                                doctorstodayAppointments[
                                                                        index][
                                                                    "DoctorsName"],
                                                                style: const TextStyle(
                                                                    color: Strings
                                                                        .kBlackcolor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontFamily:
                                                                        Strings
                                                                            .lato,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                doctorstodayAppointments[index]
                                                    ["Subspeciality"],
                                                style: const TextStyle(
                                                    color: Strings.kBlackcolor,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: Strings.lato,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(
                                                width: width / 2.5,
                                                child: Text(
                                                  doctorstodayAppointments[
                                                      index]["payment_status"],
                                                  style: const TextStyle(
                                                      color:
                                                          Strings.kBlackcolor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: Strings.lato,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: doctorstodayAppointments[
                                                          index]["status"]
                                                      .toString() ==
                                                  "1".toString()
                                              ? const Text(
                                                  "Process",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.green),
                                                )
                                              : doctorstodayAppointments[index]
                                                              ["status"]
                                                          .toString() ==
                                                      "-1".toString()
                                                  ? const SizedBox(
                                                      child: Text(
                                                        "Cancelled",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Colors.red),
                                                      ),
                                                    )
                                                  : doctorstodayAppointments[
                                                                      index]
                                                                  ["status"]
                                                              .toString() ==
                                                          "0".toString()
                                                      ? const Text(
                                                          "New",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color: Strings
                                                                  .kPrimarycolor),
                                                        )
                                                      : doctorstodayAppointments[
                                                                          index]
                                                                      ["status"]
                                                                  .toString() ==
                                                              "2".toString()
                                                          ? const Text(
                                                              "Completed",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : const SizedBox(),
                                        )
                                        //               : doctorstodayAppointments[index]
                                        //                           ["status"] ==
                                        //                       "2"
                                        //                   ? ListTile(
                                        //                       contentPadding:
                                        //                           const EdgeInsets.all(4),
                                        //                       leading: CircleAvatar(
                                        //                         radius: 35,
                                        //                         backgroundColor:
                                        //                             Strings.kPrimarycolor,
                                        //                         child: Padding(
                                        //                           padding:
                                        //                               const EdgeInsets.all(
                                        //                                   4.0),
                                        //                           child: doctorstodayAppointments[
                                        //                                           index][
                                        //                                       "DoctorImage"] !=
                                        //                                   null
                                        //                               ? CircleAvatar(
                                        //                                   radius: 35,
                                        //                                   backgroundImage: NetworkImage(
                                        //                                       doctorstodayAppointments[
                                        //                                               index]
                                        //                                           [
                                        //                                           "DoctorImage"]),
                                        //                                 )
                                        //                               : const CircleAvatar(
                                        //                                   radius: 35,
                                        //                                   backgroundImage:
                                        //                                       AssetImage(
                                        //                                           "assets/images/profile.png"),
                                        //                                 ),
                                        //                         ),
                                        //                       ),
                                        //                       title: Row(
                                        //                         children: [
                                        //                           SizedBox(
                                        //                             width: width / 2.5,
                                        //                             child: Text(
                                        //                               doctorstodayAppointments[
                                        //                                       index]
                                        //                                   ["DoctorsName"],
                                        //                               style: const TextStyle(
                                        //                                   color: Strings
                                        //                                       .kBlackcolor,
                                        //                                   fontWeight:
                                        //                                       FontWeight
                                        //                                           .w600,
                                        //                                   fontFamily:
                                        //                                       Strings.lato,
                                        //                                   fontSize: 14),
                                        //                             ),
                                        //                           ),
                                        //                           const Spacer(),
                                        //                         ],
                                        //                       ),
                                        //                       subtitle: doctorstodayAppointments[
                                        //                                           index]
                                        //                                       ["status"]
                                        //                                   .toString() ==
                                        //                               "1".toString()
                                        //                           ? const Text(
                                        //                               "Process",
                                        //                               style: TextStyle(
                                        //                                   fontWeight:
                                        //                                       FontWeight
                                        //                                           .w900,
                                        //                                   color:
                                        //                                       Colors.green),
                                        //                             )
                                        //                           : doctorstodayAppointments[
                                        //                                               index]
                                        //                                           ["status"]
                                        //                                       .toString() ==
                                        //                                   "2".toString()
                                        //                               ? const Text(
                                        //                                   "Completed",
                                        //                                   style: TextStyle(
                                        //                                       fontWeight:
                                        //                                           FontWeight
                                        //                                               .w900,
                                        //                                       color: Colors
                                        //                                           .green),
                                        //                                 )
                                        //                               : doctorstodayAppointments[
                                        //                                                   index]
                                        //                                               [
                                        //                                               "status"]
                                        //                                           .toString() ==
                                        //                                       "-1"
                                        //                                           .toString()
                                        //                                   ? const SizedBox(
                                        //                                       child: Text(
                                        //                                         "Cancelled",
                                        //                                         style: TextStyle(
                                        //                                             fontWeight:
                                        //                                                 FontWeight
                                        //                                                     .w900,
                                        //                                             color: Colors
                                        //                                                 .red),
                                        //                                       ),
                                        //                                     )
                                        //                                   : doctorstodayAppointments[index]
                                        //                                                   [
                                        //                                                   "status"]
                                        //                                               .toString() ==
                                        //                                           "0".toString()
                                        //                                       ? const Text(
                                        //                                           "New",
                                        //                                           style: TextStyle(
                                        //                                               fontWeight: FontWeight
                                        //                                                   .w900,
                                        //                                               color:
                                        //                                                   Strings.kPrimarycolor),
                                        //                                         )
                                        //                                       : const SizedBox(),
                                        //                     )
                                        //                   : doctorstodayAppointments[index]
                                        //                               ["status"] ==
                                        //                           "0"
                                        //                       ? Column(
                                        //                           crossAxisAlignment:
                                        //                               CrossAxisAlignment
                                        //                                   .start,
                                        //                           children: [
                                        //                             Padding(
                                        //                               padding:
                                        //                                   EdgeInsets.only(
                                        //                                       left: width /
                                        //                                           19,
                                        //                                       top: height /
                                        //                                           70),
                                        //                               child: Row(
                                        //                                 children: [
                                        //                                   CircleAvatar(
                                        //                                     radius: 35,
                                        //                                     backgroundColor:
                                        //                                         Strings
                                        //                                             .kPrimarycolor,
                                        //                                     child: Padding(
                                        //                                       padding:
                                        //                                           const EdgeInsets
                                        //                                                   .all(
                                        //                                               4.0),
                                        //                                       child: doctorstodayAppointments[index]
                                        //                                                   [
                                        //                                                   "DoctorImage"] !=
                                        //                                               null
                                        //                                           ? CircleAvatar(
                                        //                                               radius:
                                        //                                                   35,
                                        //                                               backgroundImage:
                                        //                                                   NetworkImage(doctorstodayAppointments[index]["DoctorImage"]),
                                        //                                             )
                                        //                                           : const CircleAvatar(
                                        //                                               radius:
                                        //                                                   35,
                                        //                                               backgroundImage:
                                        //                                                   AssetImage("assets/images/profile.png"),
                                        //                                             ),
                                        //                                     ),
                                        //                                   ),
                                        //                                   SizedBox(
                                        //                                     width:
                                        //                                         width / 50,
                                        //                                   ),
                                        //                                   Text(
                                        //                                     doctorstodayAppointments[
                                        //                                                 index]
                                        //                                             [
                                        //                                             "DoctorsName"]
                                        //                                         .toString(),
                                        //                                     style: const TextStyle(
                                        //                                         color: Strings
                                        //                                             .kBlackcolor,
                                        //                                         fontWeight:
                                        //                                             FontWeight
                                        //                                                 .w600,
                                        //                                         fontFamily:
                                        //                                             Strings
                                        //                                                 .lato,
                                        //                                         fontSize:
                                        //                                             16),
                                        //                                   ),
                                        //                                 ],
                                        //                               ),
                                        //                             ),
                                        //                             SizedBox(
                                        //                               height: height / 100,
                                        //                             ),
                                        //                             Row(
                                        //                               mainAxisAlignment:
                                        //                                   MainAxisAlignment
                                        //                                       .spaceAround,
                                        //                               children: [
                                        //                                 MaterialButton(
                                        //                                   minWidth:
                                        //                                       width / 3,
                                        //                                   elevation: 2,
                                        //                                   color: const Color(
                                        //                                       0xffF89122),
                                        //                                   shape:
                                        //                                       RoundedRectangleBorder(
                                        //                                     borderRadius:
                                        //                                         BorderRadius
                                        //                                             .circular(
                                        //                                                 10),
                                        //                                   ),
                                        //                                   onPressed: (() {
                                        //                                     _doctorstodaydelete(
                                        //                                         doctorstodayAppointments[
                                        //                                                 index]
                                        //                                             [
                                        //                                             "appointment_unique_id"]);
                                        //                                   }),
                                        //                                   child: const Text(
                                        //                                     "Cancel",
                                        //                                     style: TextStyle(
                                        //                                         color: Strings
                                        //                                             .kWhitecolor,
                                        //                                         fontSize:
                                        //                                             15,
                                        //                                         fontWeight:
                                        //                                             FontWeight
                                        //                                                 .bold,
                                        //                                         fontFamily:
                                        //                                             Strings
                                        //                                                 .latoBold),
                                        //                                   ),
                                        //                                 ),
                                        //                                 Container(
                                        //                                     padding:
                                        //                                         const EdgeInsets
                                        //                                             .all(0),
                                        //                                     margin:
                                        //                                         const EdgeInsets
                                        //                                             .all(0),
                                        //                                     height:
                                        //                                         height / 20,
                                        //                                     child: const VerticalDivider(
                                        //                                         color: Color(
                                        //                                             0xffADB0B5))),
                                        //                                 SizedBox(
                                        //                                   height:
                                        //                                       height / 100,
                                        //                                 ),
                                        //                                 Row(
                                        //                                   mainAxisAlignment:
                                        //                                       MainAxisAlignment
                                        //                                           .spaceEvenly,
                                        //                                   mainAxisSize:
                                        //                                       MainAxisSize
                                        //                                           .max,
                                        //                                   children: [
                                        //                                     GestureDetector(
                                        //                                       child:
                                        //                                           const CircleAvatar(
                                        //                                         radius: 15,
                                        //                                         backgroundColor:
                                        //                                             Strings
                                        //                                                 .kPrimarycolor,
                                        //                                         child: Icon(
                                        //                                           Icons
                                        //                                               .phone,
                                        //                                           color: Strings
                                        //                                               .kWhitecolor,
                                        //                                         ),
                                        //                                       ),
                                        //                                       onTap: () {
                                        //                                         print(doctorstodayAppointments[
                                        //                                                 index]
                                        //                                             [
                                        //                                             "DoctorMobile"]);

                                        //                                         _makePhoneCall(
                                        //                                             (doctorstodayAppointments[index]
                                        //                                                 [
                                        //                                                 "DoctorMobile"]));
                                        //                                       },
                                        //                                     ),
                                        //                                     SizedBox(
                                        //                                       width: width /
                                        //                                           20,
                                        //                                     ),
                                        //                                     SizedBox(
                                        //                                       width: width /
                                        //                                           20,
                                        //                                     ),
                                        //                                     GestureDetector(
                                        //                                       onTap: () {
                                        //                                         openMap(lat,
                                        //                                             lon);
                                        //                                       },
                                        //                                       child: CircleAvatar(
                                        //                                           radius: 15,
                                        //                                           backgroundColor: Strings.kPrimarycolor,
                                        //                                           child: SvgPicture.asset(
                                        //                                             "assets/svg/distance.svg",
                                        //                                             height:
                                        //                                                 19,
                                        //                                           )),
                                        //                                     ),
                                        //                                   ],
                                        //                                 )
                                        //                               ],
                                        //                             ),
                                        //                             SizedBox(
                                        //                               height: height / 100,
                                        //                             ),
                                        //                           ],
                                        //                         )
                                        //                       : doctorstodayAppointments[
                                        //                                           index]
                                        //                                       ["status"]
                                        //                                   .toString() ==
                                        //                               "1".toString()
                                        //                           ? ListTile(
                                        //                               contentPadding:
                                        //                                   const EdgeInsets
                                        //                                       .all(4),
                                        //                               leading: CircleAvatar(
                                        //                                 radius: 35,
                                        //                                 backgroundColor:
                                        //                                     Strings
                                        //                                         .kPrimarycolor,
                                        //                                 child: Padding(
                                        //                                   padding:
                                        //                                       const EdgeInsets
                                        //                                           .all(4.0),
                                        //                                   child: doctorstodayAppointments[
                                        //                                                   index]
                                        //                                               [
                                        //                                               "DoctorImage"] !=
                                        //                                           null
                                        //                                       ? CircleAvatar(
                                        //                                           radius:
                                        //                                               35,
                                        //                                           backgroundImage:
                                        //                                               NetworkImage(doctorstodayAppointments[index]
                                        //                                                   [
                                        //                                                   "DoctorImage"]),
                                        //                                         )
                                        //                                       : const CircleAvatar(
                                        //                                           radius:
                                        //                                               35,
                                        //                                           backgroundImage:
                                        //                                               AssetImage(
                                        //                                                   "assets/images/profile.png"),
                                        //                                         ),
                                        //                                 ),
                                        //                               ),
                                        //                               // tileColor: Colors.white,

                                        //                               title: Row(
                                        //                                 children: [
                                        //                                   SizedBox(
                                        //                                     width:
                                        //                                         width / 2.5,
                                        //                                     child: Text(
                                        //                                       doctorstodayAppointments[
                                        //                                               index]
                                        //                                           [
                                        //                                           "DoctorsName"],
                                        //                                       style: const TextStyle(
                                        //                                           color: Strings
                                        //                                               .kBlackcolor,
                                        //                                           fontWeight:
                                        //                                               FontWeight
                                        //                                                   .w600,
                                        //                                           fontFamily:
                                        //                                               Strings
                                        //                                                   .lato,
                                        //                                           fontSize:
                                        //                                               14),
                                        //                                     ),
                                        //                                   ),
                                        //                                 ],
                                        //                               ),

                                        //                               subtitle: doctorstodayAppointments[
                                        //                                                   index]
                                        //                                               [
                                        //                                               "status"]
                                        //                                           .toString() ==
                                        //                                       "1".toString()
                                        //                                   ? const Text(
                                        //                                       "Process",
                                        //                                       style: TextStyle(
                                        //                                           fontWeight:
                                        //                                               FontWeight
                                        //                                                   .w900,
                                        //                                           color: Colors
                                        //                                               .green),
                                        //                                     )
                                        //                                   : doctorstodayAppointments[index]
                                        //                                                   [
                                        //                                                   "status"]
                                        //                                               .toString() ==
                                        //                                           "-1"
                                        //                                               .toString()
                                        //                                       ? const SizedBox(
                                        //                                           child:
                                        //                                               Text(
                                        //                                             "Cancelled",
                                        //                                             style: TextStyle(
                                        //                                                 fontWeight:
                                        //                                                     FontWeight.w900,
                                        //                                                 color: Colors.red),
                                        //                                           ),
                                        //                                         )
                                        //                                       : doctorstodayAppointments[index]["status"]
                                        //                                                   .toString() ==
                                        //                                               "0"
                                        //                                                   .toString()
                                        //                                           ? const Text(
                                        //                                               "New",
                                        //                                               style: TextStyle(
                                        //                                                   fontWeight: FontWeight.w900,
                                        //                                                   color: Strings.kPrimarycolor),
                                        //                                             )
                                        //                                           : doctorstodayAppointments[index]["status"].toString() ==
                                        //                                                   "2".toString()
                                        //                                               ? const Text(
                                        //                                                   "Completed",
                                        //                                                   style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green),
                                        //                                                 )
                                        //                                               : const SizedBox(),
                                        //                             )
                                        //                           : const SizedBox())),
                                        // );
                                        )));
                          }))
                      : const SizedBox(),
                  todayAppointments.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todayAppointments.length,
                          itemBuilder: ((context, index) {
                            // var address = jsonDecode(
                            //     todayAppointments[index]["address"]);

                            // var contacts = jsonDecode(
                            //     todayAppointments[index]["contact_details"]);

                            // print(contacts);
                            // var coordinates = jsonDecode(
                            //     todayAppointments[index]["location"]);

                            // // var latLong = jsonDecode(coordinates);

                            // var lat = coordinates["latitude"];
                            // var lon = coordinates["longitude"];
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 20,
                                    vertical: height / 100),
                                child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Strings.kWhitecolor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 2.5,
                                                    child: todayAppointments[
                                                                    index]
                                                                ["status"] ==
                                                            "0"
                                                        ? Text("")
                                                        : Text(
                                                            todayAppointments[
                                                                    index]
                                                                ["ClinicsName"],
                                                            style: const TextStyle(
                                                                color: Strings
                                                                    .kBlackcolor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    Strings
                                                                        .lato,
                                                                fontSize: 14),
                                                          ),
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                              Text(
                                                todayAppointments[index]
                                                    ["Subspeciality"],
                                                style: const TextStyle(
                                                    color: Strings.kBlackcolor,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: Strings.lato,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(
                                                width: width / 2.5,
                                                child: Text(
                                                  todayAppointments[index]
                                                      ["payment_status"],
                                                  style: const TextStyle(
                                                      color:
                                                          Strings.kBlackcolor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: Strings.lato,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: todayAppointments[index]
                                                          ["status"]
                                                      .toString() ==
                                                  "1".toString()
                                              ? const Text(
                                                  "Process",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.green),
                                                )
                                              : todayAppointments[index]
                                                              ["status"]
                                                          .toString() ==
                                                      "-1".toString()
                                                  ? const SizedBox(
                                                      child: Text(
                                                        "Cancelled",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Colors.red),
                                                      ),
                                                    )
                                                  : todayAppointments[index]
                                                                  ["status"]
                                                              .toString() ==
                                                          "0".toString()
                                                      ? const Text(
                                                          "New",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color: Strings
                                                                  .kPrimarycolor),
                                                        )
                                                      : doctorstodayAppointments[
                                                                          index]
                                                                      ["status"]
                                                                  .toString() ==
                                                              "2".toString()
                                                          ? const Text(
                                                              "Completed",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : const SizedBox(),
                                        ))));
                          }))
                      : const Text(""),
                ],
              ),
            ),
          )
          //Todays Appointments
        ]));
  }

  _doctorstodaydelete(String appointmentid) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to cancel the appointment?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box

                    // appointmetCancelation(appointmentid);
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  _todaydelete(String appointmentid) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to cancel the appointment?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box

                    // appointmetCancelation(appointmentid);
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
