import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;


final List<String> items = [
  'On',
  'Off',
];
String? selectedValue;

final List<String> deta = [
  'Activated',
  'Deactivated',
];
String?  selectValue;

var status;
var selId;

class ExitConfirmationDialog extends StatelessWidget {

  const ExitConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>Container(
    height: 430,
    padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: Container(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.topRight,
              child: Image.asset('assets/cancel.png', width: 35,),
            ),
          ),
          SizedBox(height: 10,),
          Text(languages[choosenLanguage]['Notification Setting'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20, ),),
          SizedBox(height: 10,),
          Container(
            height: MediaQuery.of(context).size.height/2.5,
            child: FutureBuilder<List<order>>(
                future: orderhistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int Itemindex) {
                        return  Container(
                          // height: 70,
                          margin: EdgeInsets.only(right: 5, left: 5,top: 10,bottom: 10),
                          padding: EdgeInsets.only(right: 5, left: 5,top: 2,bottom: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2.5,
                                  blurRadius: 3,
                                )
                              ],
                              color: Colors.white
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(languages[choosenLanguage]['Temperature setting'], style: TextStyle(color: Colors.black54, fontSize: 11),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data![Itemindex].notification_short_txt.toString(), style: TextStyle(color: Colors.black54, fontSize: 11),),
                                  // Image.asset("assets/tempim.png", width: 35,),
                                  // Container(
                                  //   width: 60,
                                  //   height: 30,
                                  //   child: TextFormField(
                                  //     textAlignVertical: TextAlignVertical.bottom,
                                  //     decoration: InputDecoration(
                                  //         enabledBorder: OutlineInputBorder(
                                  //           borderSide: BorderSide(
                                  //               width: 1, color: Colors.green), //<-- SEE HERE
                                  //         ),
                                  //         hintText: "45\'C",
                                  //         hintStyle: TextStyle(color: Colors.black54,)
                                  //     ),
                                  //   ),),
                                  ToggleSwitch(
                                    initialLabelIndex: snapshot.data![Itemindex].active_ind.toString()=="0"?0:1,
                                    customWidths: [40.0, 40.0],
                                    cornerRadius: 15,
                                    activeBgColors: [ [Color(0xffff9966),Color(0xffff0000)], [Color(0xff00ff00),Color(0xff009900)]],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    icons: [ Icons.notifications_off, Icons.notifications],
                                    iconSize: 40,
                                    onToggle: (index) {
                                      print('switched to: $index');
                                      status= index;
                                      selId= snapshot.data![Itemindex].id.toString();
                                      print(status);
                                      print(selId);
                                      update_status();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      })
                      : Center(
                      child: Text(
                        'You have No order',
                        style: TextStyle(fontSize: 25),
                      ));
                }),
          ),
          // Container(
          //   height: 70,
          //   padding: EdgeInsets.only(right: 5, left: 5),
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(0, 1),
          //           color: Colors.black.withOpacity(0.5),
          //           spreadRadius: 2.5,
          //           blurRadius: 3,
          //         )
          //       ],
          //       color: Colors.white
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(languages[choosenLanguage]['Temperature setting'], style: TextStyle(color: Colors.black54, fontSize: 11),),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Image.asset("assets/tempim.png", width: 35,),
          //           // Container(
          //           //   width: 60,
          //           //   height: 30,
          //           //   child: TextFormField(
          //           //     textAlignVertical: TextAlignVertical.bottom,
          //           //     decoration: InputDecoration(
          //           //         enabledBorder: OutlineInputBorder(
          //           //           borderSide: BorderSide(
          //           //               width: 1, color: Colors.green), //<-- SEE HERE
          //           //         ),
          //           //         hintText: "45\'C",
          //           //         hintStyle: TextStyle(color: Colors.black54,)
          //           //     ),
          //           //   ),),
          //           ToggleSwitch(
          //             customWidths: [40.0, 40.0],
          //             cornerRadius: 15,
          //             activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
          //             activeFgColor: Colors.white,
          //             inactiveBgColor: Colors.grey,
          //             inactiveFgColor: Colors.white,
          //             totalSwitches: 2,
          //             icons: [Icons.notifications, Icons.notifications_off],
          //             iconSize: 40,
          //             onToggle: (index) {
          //               print('switched to: $index');
          //             },
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 15,),
          // Container(
          //   padding: EdgeInsets.only(left: 5, right:5),
          //   // width: 325,
          //   height: 70,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(0, 1),
          //           color: Colors.black.withOpacity(0.5),
          //           spreadRadius: 2.5,
          //           blurRadius: 3,
          //         )
          //       ],
          //       color: Colors.white
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(languages[choosenLanguage]['Speed setting'], style: TextStyle(color: Colors.black54, fontSize: 11),),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Image.asset("assets/speed1.png", width: 40,),
          //           // Text("Temperature", style: TextStyle(fontSize: 10),)
          //           // Container(
          //           //   width: 85,
          //           //   height: 30,
          //           //   child: TextFormField(
          //           //     textAlignVertical: TextAlignVertical.bottom,
          //           //     decoration: InputDecoration(
          //           //         enabledBorder: OutlineInputBorder(
          //           //           borderSide: BorderSide(
          //           //               width: 1, color: Colors.green), //<-- SEE HERE
          //           //         ),
          //           //         hintText: '60 km/h',
          //           //         hintStyle: TextStyle(color: Colors.black54)
          //           //     ),
          //           //
          //           //   ),),
          //           ToggleSwitch(
          //             customWidths: [40.0, 40.0],
          //             cornerRadius: 15,
          //             activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
          //             activeFgColor: Colors.white,
          //             inactiveBgColor: Colors.grey,
          //             inactiveFgColor: Colors.white,
          //             totalSwitches: 2,
          //             icons: [Icons.notifications, Icons.notifications_off],
          //             onToggle: (index) {
          //               print('switched to: $index');
          //             },
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 15,),
          // Container(
          //   padding: EdgeInsets.only(left: 5, right:5),
          //   // width: 325,
          //   height: 70,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(0, 1),
          //           color: Colors.black.withOpacity(0.5),
          //           spreadRadius: 2.5,
          //           blurRadius: 3,
          //         )
          //       ],
          //       color: Colors.white
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(languages[choosenLanguage]['Engine setting'], style: TextStyle(color: Colors.black54, fontSize: 11),),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Image.asset("assets/engine.png", width: 40,),
          //           // Container(
          //           //   // width: 100,
          //           //   height: 40,
          //           //   alignment: Alignment.bottomLeft,
          //           //   child:
          //           //   DropdownButtonHideUnderline(
          //           //     child:DropdownButton(
          //           //       hint: Text(
          //           //         'On',
          //           //         style: TextStyle(
          //           //           fontSize: 14,
          //           //           color: Theme
          //           //               .of(context)
          //           //               .hintColor,
          //           //         ),
          //           //       ),
          //           //       items: items
          //           //           .map((item) =>
          //           //           DropdownMenuItem<String>(
          //           //             value: item,
          //           //             child: Text(
          //           //               item,
          //           //               style: const TextStyle(
          //           //                 fontSize: 14,
          //           //               ),
          //           //             ),
          //           //           ))
          //           //           .toList(),
          //           //       value: selectedValue,
          //           //       onChanged: (value) {
          //           //         selectedValue = value as String;
          //           //         // setState(() {
          //           //         //
          //           //         // });
          //           //        },
          //           //       // buttonHeight: 40,
          //           //       // buttonWidth: 140,
          //           //       // itemHeight: 40,
          //           //     ),
          //           //   ),
          //           // ),
          //           ToggleSwitch(
          //             customWidths: [40.0, 40.0],
          //             cornerRadius: 15,
          //             activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
          //             activeFgColor: Colors.white,
          //             inactiveBgColor: Colors.grey,
          //             inactiveFgColor: Colors.white,
          //             totalSwitches: 2,
          //             icons: [Icons.notifications, Icons.notifications_off],
          //             onToggle: (index) {
          //               print('switched to: $index');
          //             },
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 15,),
          // Container(
          //   padding: EdgeInsets.only(left: 5, right:5),
          //   // width: 325,
          //   height: 70,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(0, 1),
          //           color: Colors.black.withOpacity(0.5),
          //           spreadRadius: 2.5,
          //           blurRadius: 3,
          //         )
          //       ],
          //       color: Colors.white
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(languages[choosenLanguage]['Subscribtion setting'], style: TextStyle(color: Colors.black54, fontSize: 11),),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Image.asset("assets/expiry.png", width: 35,),
          //           // Text("Temperature", style: TextStyle(fontSize: 10),)
          //           // DropdownButtonHideUnderline(
          //           //   child:DropdownButton(
          //           //     hint: Text(
          //           //       'activated',
          //           //       style: TextStyle(
          //           //         fontSize: 14,
          //           //         color: Theme
          //           //             .of(context)
          //           //             .hintColor,
          //           //       ),
          //           //     ),
          //           //     items: deta
          //           //         .map((item) =>
          //           //         DropdownMenuItem<String>(
          //           //           value: item,
          //           //           child: Text(
          //           //             item,
          //           //             style: const TextStyle(
          //           //               fontSize: 14,
          //           //             ),
          //           //           ),
          //           //         ))
          //           //         .toList(),
          //           //     value: selectValue,
          //           //     onChanged: (value) {
          //           //       selectValue = value as String;
          //           //       // setState(() {
          //           //       //
          //           //       // });
          //           //     },
          //           //     // buttonHeight: 40,
          //           //     // buttonWidth: 140,
          //           //     // itemHeight: 40,
          //           //   ),
          //           // ),
          //           ToggleSwitch(
          //             customWidths: [40.0, 40.0],
          //             cornerRadius: 15,
          //             activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
          //             activeFgColor: Colors.white,
          //             inactiveBgColor: Colors.grey,
          //             inactiveFgColor: Colors.white,
          //             totalSwitches: 2,
          //             icons: [Icons.notifications, Icons.notifications_off],
          //             onToggle: (index) {
          //               print('switched to: $index');
          //             },
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    ),
  );
}
//change status of selected list=====
update_status() async {
  final res = await http.get(
    Uri.parse("${baseUrlPhp}notificationtypeupdate.php?id=$selId&statuscode=$status"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  final resBody = json.decode(res.body);
  if (resBody["error"] == "200") {
    Fluttertoast.showToast(
        msg: resBody['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    // Navigator.pop(context);
  } else {
    Fluttertoast.showToast(
        msg: resBody['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

//========================


// notification list=======================
Future<List<order>> orderhistory() async {
  final prefs = await SharedPreferences.getInstance();
  final user_id = prefs.getString('user_id') ?? 0;
  final response = await http.get(
    Uri.parse('${baseUrlPhp}notificationtype.php?userid=$user_id'),
  );
  var jsond = json.decode(response.body)["data"];
  List<order> allround = [];
  for (var a in jsond) {
    order al = order(
      a['id'],
      a['role_id'],
      a['userid'],
      a['notification_short_txt'],
      a['notification_longt_txt'],
      a['active_ind'],
      a['created_at'],
      a['updated_at'],
      a['deleted_at'],
    );
    allround.add(al);
  }
  return allround;
}


class order {
  String? id;
  String? role_id;
  String? userid;
  String? notification_short_txt;
  String? notification_longt_txt;
  String? active_ind;
  String? created_at;
  String? updated_at;
  String? deleted_at;
  order(
      this.id,
      this.role_id,
      this.userid,
      this.notification_short_txt,
      this.notification_longt_txt,
      this.active_ind,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      );
}