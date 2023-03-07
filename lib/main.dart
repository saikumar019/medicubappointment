import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:medicub_appointment/profile/edit_profile.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'profile/login.dart';
import 'helpers/strings.dart';
import 'homescreen.dart';
import 'intro.dart';
import 'profile/registration_screen.dart';

int? initScreen;

String? user;
// String? isProfile;
String? isSessionId;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  isSessionId = preferences.getString("sessionId");

  user = preferences.getString('user');

  initScreen = preferences.getInt("initScreen");

  await preferences.setInt('initScreen', 1);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Strings.kPrimarycolor,
      ),
      initialRoute: getRoute(),
      routes: {
        'login': (context) => const LoginScreen(),
        'onboard': (context) => TestScreen(),
        'profile': (context) => RegistrationScreen(),
        'home': (context) => HomeScreen(),
        'myhome': (context) => Splashscreen(),
      },
    );
  }

  String getRoute() {
    if (user == null) {
      if (initScreen == 0 || initScreen == null) {
        return "login";
      } else {
        return "login";
      }
    } else {
      if (user != null) {
        return "myhome";
      } else {
        return "";
      }
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<Splashscreen> {
  String? isProfileCompleted;
  String? userActiveStatus;
  String? uniqueId;
  String? sessionId;
  Future<void> getUniqueUserId() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();

    setState(() {
      uniqueId = prefer.getString('user');
    });
    // getUser();
  }

  @override
  void initState() {
    getUniqueUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
            child: Image.asset(
          "assets/images/jeevan.png",
          height: height / 4,
          width: width / 2,
        )));
  }

  // Future<void> getUser() async {
  //   try {
  //     var url = 'http://jeevanraksha.co/API/r_usersbyid';

  //     var data = {
  //       'user_unique_id': user,
  //       'session_unique_id': isSessionId,
  //     };

  //     var response = await post(Uri.parse(url), body: data);

  //     if (response.statusCode == 200) {
  //       var message = response.body;

  //       var users = jsonDecode(message);

  //       var isP = users["Users"][0]["is_profile_completed"];
  //       var isU = users["Users"][0]["account_status"];

  //       setState(() {
  //         isProfileCompleted = isP;
  //         userActiveStatus = isU;
  //       });
  //       if (isProfileCompleted == "1" && userActiveStatus == "1") {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomeScreen()),
  //         );
  //       } else if (isProfileCompleted == "0" || isProfileCompleted == null) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => RegistrationScreen()),
  //         );
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
  //       } else {}

  //       // isProfileCompleted = users["Users"][0]["is_profile_completed"];
  //       // userActiveStatus = users["Users"][0]["account_status"];
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
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
            child: Image.asset(
          "assets/images/jeevan.png",
          height: height / 4,
          width: width / 2,
        )));
  }
}
