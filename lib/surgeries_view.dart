import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'consultation.dart';
import 'helpers/strings.dart';

class SurgeriesView extends StatefulWidget {
  List? suegeries;
  String? surgeryname;
  String? location;
  String? uniq;
  Map? latlong;
  SurgeriesView(
      {super.key,
      this.suegeries,
      this.surgeryname,
      this.location,
      this.uniq,
      this.latlong});

  @override
  State<SurgeriesView> createState() => _SurgeriesViewState();
}

class _SurgeriesViewState extends State<SurgeriesView> {
  @override
  List dummy = [];
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.surgeryname.toString()),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height / 100,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: width / 20,
                right: width / 20,
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.suegeries!.length,
                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3,

                  //     // childAspectRatio: 1,
                  //     crossAxisSpacing: 2,
                  //     mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    if (widget.suegeries![index]["ParentuniqueID"] ==
                        widget.uniq) {
                      var dummys = widget.suegeries![index]["speciality"];

                      print(dummys);
                    }
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConsultationScreen(
                                      latitudeLongtitude: widget.latlong,
                                      loc: widget.location,
                                      num: widget.suegeries![index]
                                          ["SubSpeciality"],
                                      subid: widget.suegeries![index]
                                          ["SubSpecialityuniqueID"],
                                      uniq: widget.uniq,
                                    )),
                          );
                        },
                        // child: widget.suegeries![index]["ParentuniqueID"] ==
                        //         widget.uniq.toString()
                        //
                        //
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height / 70,
                            ),
                            Image.network(
                              widget.suegeries![index]["SubspecialityIcons"],
                              height: height / 15,
                              width: width / 5,
                            ),

                            Text(
                              widget.suegeries![index]["SubSpeciality"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: Strings.lato,
                                  fontWeight: FontWeight.w700),
                            ),

                            // ListTileTheme(
                            //   dense: true,
                            //   child: ExpansionTile(
                            //     // onExpansionChanged: (value) {
                            //     //   subSpeacality = subSpeacality
                            //     //       .where((element) =>
                            //     //           element["speciality_unique_id"] ==
                            //     //           specality[index]
                            //     //               ["speciality_unique_id"])
                            //     //       .toList();
                            //     // },
                            //     tilePadding: EdgeInsets.all(0),
                            //     childrenPadding: EdgeInsets.all(0),

                            //     collapsedIconColor:
                            //         Color.fromARGB(255, 107, 54, 54),
                            //     iconColor: Colors.black,
                            //     expandedAlignment: Alignment.center,
                            //     // leading: SizedBox(
                            //     //   width: 1,
                            //     // ),

                            //     // trailing: const SizedBox(),
                            //     // leading: const SizedBox(
                            //     //   width: 0,
                            //     //   height: 0,
                            //     // ),
                            //     title: Center(
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Text(
                            //           specality[index]["speciality"]
                            //               .toString(),
                            //           style: const TextStyle(
                            //               fontFamily: Strings.lato,
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w700,
                            //               color: Strings.kBlackcolor),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //     ),
                            //     // children: <Widget>[
                            //     //   SizedBox(
                            //     //     height: 40,
                            //     //     child: ListView.builder(
                            //     //         itemCount: subSpeacality.length,
                            //     //         itemBuilder: ((context, index) {
                            //     //           // if (specality[index]
                            //     //           //         ["speciality_unique_id"] ==
                            //     //           //     subSpeacality[index]
                            //     //           //         ["ParentuniqueID"]) {}
                            //     //           return Text(subSpeacality[index]
                            //     //               ["speciality"]);
                            //     //         })),
                            //     //   )
                            //     // ],
                            //   ),
                            // ),
                          ],
                        ));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
