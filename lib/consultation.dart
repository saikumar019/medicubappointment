import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:medicub_appointment/my_appointment.dart';

import 'helpers/strings.dart';
import 'package:http/http.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultationScreen extends StatefulWidget {
  String? loc;
  String? num;
  String? uniq;
  String? subid;
  Map? latitudeLongtitude;
  ConsultationScreen(
      {super.key,
      this.loc,
      this.num,
      this.uniq,
      this.latitudeLongtitude,
      this.subid});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  String rangeSelectedValue = 'Offline';

  var rangeItems = [
    'Offline',
    'Online',
  ];

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
  }

  void initState() {
    getValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.num.toString()),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: height / 10,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: Strings.kPrimarycolor,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButton(
                  // Initial Value
                  value: rangeSelectedValue,
                  isExpanded: true,

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
              ),
            ),
            SizedBox(
              height: height / 100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 15),
              child: TextFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Strings.kPrimarycolor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Strings.kPrimarycolor), //<-- SEE HERE
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Strings.kPrimarycolor), //<-- SEE HERE
                    ),
                  ),
                  controller: _nameController..text = name.toString()),
            ),
            SizedBox(
              height: height / 100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 15),
              child: TextFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Strings.kPrimarycolor), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Strings.kPrimarycolor), //<-- SEE HERE
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Strings.kPrimarycolor), //<-- SEE HERE
                    ),
                  ),
                  controller: _numberController..text = number.toString()),
            ),
            SizedBox(
              height: height / 100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 15),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Strings.kPrimarycolor), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Strings.kPrimarycolor), //<-- SEE HERE
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Strings.kPrimarycolor), //<-- SEE HERE
                  ),
                ),
                controller: _locationController
                  ..text = "${widget.num}".toString(),
              ),
            ),
            SizedBox(
              height: height / 100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 15),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Strings.kPrimarycolor), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Strings.kPrimarycolor), //<-- SEE HERE
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Strings.kPrimarycolor), //<-- SEE HERE
                  ),
                ),
                controller: _serviceController
                  ..text = "${widget.loc}".toString(),
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            new Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 15),
              child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  elevation: 5.0,
                  minWidth: double.infinity,
                  height: 35,
                  color: Strings.kPrimarycolor,
                  child: new Text('Submit',
                      style:
                          new TextStyle(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      appointmentAction();
                      // profileRegistration();
                    }
                  }),
            ),
            // Text(widget.loc.toString()),
            // Text(widget.num.toString()),
            // Text(widget.uniq.toString())
          ],
        ),
      ),
    );
  }

  Future<void> appointmentAction() async {
    var cord = jsonEncode(widget.latitudeLongtitude);
    try {
      var url = '${Strings.baseUrl}book_appointment';

      var data = {
        'name': name,
        "mobile": number,
        'location': cord,
        'appointment_mode': rangeSelectedValue,
        'user_unique_id': uniqId,
        'subspeciality_id': widget.subid,
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
          duration: const Duration(seconds: 2),
        ).show(context).then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentList()),
            ));
      } else if (response.statusCode == 403) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
