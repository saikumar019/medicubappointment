import 'package:flutter/material.dart';
import 'helpers/strings.dart';

class ConformedScreen extends StatelessWidget {
  const ConformedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Strings.kBackgroundcolor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height / 20,
          ),
          SizedBox(
            height: height / 4,
          ),
          Center(
            child: Image.asset(
              "assets/images/conformed.png",
              height: height / 5.0,
              width: width / 1.3,
            ),
          ),
          SizedBox(
            height: height / 80,
          ),
          const Center(
            child: Text(
              "Booking Confirmed",
              style: TextStyle(
                  color: Strings.kSecondarycolor,
                  fontFamily: Strings.lato,
                  fontWeight: FontWeight.w700,
                  fontSize: 21),
            ),
          ),
        ],
      ),
    );
  }
}
