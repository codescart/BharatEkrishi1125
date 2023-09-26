import 'package:flutter/material.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';

import 'Widget/notification_popup.dart';

class notification_screen extends StatefulWidget {
  const notification_screen({Key? key}) : super(key: key);

  @override
  State<notification_screen> createState() => _notification_screenState();
}

class _notification_screenState extends State<notification_screen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // centerTitle: true,
        flexibleSpace: Container(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightGreenAccent, Colors.green,]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                },
                  icon: Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white,),),
              Text(languages[choosenLanguage]['Notifications'], style:TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => ExitConfirmationDialog(),
                        );
                      },
                      child: Image.asset("assets/setting.png", width: 35,)
                    )
                ),
              ],
              ),
          )
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              height: 1000,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 20,),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 5, right:0),
                            // width: 325,
                            height: 60,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset("assets/tempim.png", width: 40,),
                                    // Text("Temperature", style: TextStyle(fontSize: 10),)
                                    Text("25\'C",style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15,),),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(languages[choosenLanguage]['Temperature is about'], style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),
                                      SizedBox(width: 2,),
                                      Text('25\'C...', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),

                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.lightGreenAccent, Colors.green,]),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      topRight: Radius.circular(-5),
                                    ),
                                    // border: Border.all(
                                    //   width: 0, color: Colors.black54
                                    // ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(-2,2),
                                        color: Colors.black54.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius:3
                                      )
                                    ]
                                  ),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("10:20 AM",style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),),
                                    Text("26 Nov, 2022", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white))
                                  ],
                                ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.only(left: 5, right:0),
                            // width: 325,
                            height: 60,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset("assets/engine.png", width: 40,),
                                    // Text("Temperature", style: TextStyle(fontSize: 10),)
                                    Text("On",style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 16,),),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(languages[choosenLanguage]['Engine Status is'], style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),
                                      SizedBox(width: 2,),
                                      Text('On...', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),

                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.lightGreenAccent, Colors.green,]),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        topRight: Radius.circular(-5),
                                      ),
                                      // border: Border.all(
                                      //   width: 0, color: Colors.black54
                                      // ),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(-2,2),
                                            color: Colors.black54.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius:3
                                        )
                                      ]
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("9:02 AM",style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),),
                                      Text("26 Nov, 2022", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.only(left: 5, right:0),
                            // width: 325,
                            height: 60,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset("assets/fuelim.png", width: 40,),
                                    // Text("Temperature", style: TextStyle(fontSize: 10),)
                                    Text("6Ltr.",style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15,),),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(languages[choosenLanguage]['Fuel is about'], style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),
                                      SizedBox(width: 2,),
                                      Text('6 Leter....', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.lightGreenAccent, Colors.green,]),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        topRight: Radius.circular(-5),
                                      ),
                                      // border: Border.all(
                                      //   width: 0, color: Colors.black54
                                      // ),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(-2,2),
                                            color: Colors.black54.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius:3
                                        )
                                      ]
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("7:10 AM",style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),),
                                      Text("26 Nov, 2022", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.only(left: 5, right:0),
                            // width: 325,
                            height: 60,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset("assets/speed1.png", width: 40,),
                                    // Text("Temperature", style: TextStyle(fontSize: 10),)
                                    Text("50km",style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15,),),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(languages[choosenLanguage]['Speed is about'], style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),
                                      SizedBox(width: 2,),
                                      Text('50km/hour....', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),

                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.lightGreenAccent, Colors.green,]),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        topRight: Radius.circular(-5),
                                      ),
                                      // border: Border.all(
                                      //   width: 0, color: Colors.black54
                                      // ),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(-2,2),
                                            color: Colors.black54.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius:3
                                        )
                                      ]
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("5:20 PM",style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),),
                                      Text("25 Nov, 2022", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.only(left: 5, right:0),
                            // width: 325,
                            height: 60,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset("assets/voltim.png", width: 40,),
                                    // Text("Temperature", style: TextStyle(fontSize: 10),)
                                    Text("240V",style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15,),),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(languages[choosenLanguage]['Power is about'], style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),
                                      SizedBox(width: 2,),
                                      Text('240Volts...', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.lightGreenAccent, Colors.green,]),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        topRight: Radius.circular(-5),
                                      ),
                                      // border: Border.all(
                                      //   width: 0, color: Colors.black54
                                      // ),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(-2,2),
                                            color: Colors.black54.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius:3
                                        )
                                      ]
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("10:20 AM",style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),),
                                      Text("26 Nov, 2022", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
        ],
        ),
      )));
  }
}
// Widget _buildPopupDialog(BuildContext context) {
//   bool light = true;
//   return AlertDialog(
//     // insetPadding: EdgeInsets.only(top: 0, left:5, right: 5, bottom: 5),
//     title:Column(
//       children: [
//         Container(
//           child: Image.asset('assets/cancel.png', width: 20,),
//         ),
//         Text('Notification Setting'),
//       ],
//     ),
//     content: Container(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               height: 70,
//               padding: EdgeInsets.only(right: 5, left: 5),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: Offset(0, 1),
//                       color: Colors.black.withOpacity(0.5),
//                       spreadRadius: 2.5,
//                       blurRadius: 3,
//                     )
//                   ],
//                   color: Colors.white
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Temperature setting', style: TextStyle(color: Colors.black54, fontSize: 11),),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Image.asset("assets/tempim.png", width: 35,),
//                       Container(
//                         width: 60,
//                         height: 30,
//                         child: TextFormField(
//                           textAlignVertical: TextAlignVertical.bottom,
//                           decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 1, color: Colors.green), //<-- SEE HERE
//                             ),
//                             hintText: "edit",
//                               hintStyle: TextStyle(color: Colors.black54,)
//                           ),
//                         ),),
//                       ToggleSwitch(
//                         customWidths: [40.0, 40.0],
//                         cornerRadius: 15,
//                         activeBgColors: [[Colors.green], [Colors.redAccent]],
//                         activeFgColor: Colors.white,
//                         inactiveBgColor: Colors.grey,
//                         inactiveFgColor: Colors.white,
//                         totalSwitches: 2,
//                         icons: [Icons.notifications, Icons.notifications_off],
//                         onToggle: (index) {
//                           print('switched to: $index');
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 15,),
//             Container(
//               padding: EdgeInsets.only(left: 5, right:5),
//               // width: 325,
//               height: 70,
//                decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: Offset(0, 1),
//                       color: Colors.black.withOpacity(0.5),
//                       spreadRadius: 2.5,
//                       blurRadius: 3,
//                     )
//                   ],
//                   color: Colors.white
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Engine setting', style: TextStyle(color: Colors.black54, fontSize: 11),),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Image.asset("assets/engine.png", width: 40,),
//                       // Text("Temperature", style: TextStyle(fontSize: 10),)
//                       Container(
//                         width: 60,
//                         height: 30,
//                         child: TextFormField(
//                           textAlign: TextAlign.start,
//                           textAlignVertical: TextAlignVertical.bottom,
//                           decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 1, color: Colors.green), //<-- SEE HERE
//                             ),
//                             hintText: 'edit',
//                             hintStyle: TextStyle(color: Colors.black54)
//                           ),
//                         ),),
//                       ToggleSwitch(
//                         customWidths: [40.0, 40.0],
//                         cornerRadius: 15,
//                         activeBgColors: [[Colors.green], [Colors.redAccent]],
//                         activeFgColor: Colors.white,
//                         inactiveBgColor: Colors.grey,
//                         inactiveFgColor: Colors.white,
//                         totalSwitches: 2,
//                         icons: [Icons.notifications, Icons.notifications_off],
//                         onToggle: (index) {
//                           print('switched to: $index');
//                         },
//                       ),
//                      ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 15,),
//             Container(
//               padding: EdgeInsets.only(left: 5, right:5),
//               // width: 325,
//               height: 70,
//                decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: Offset(0, 1),
//                       color: Colors.black.withOpacity(0.5),
//                       spreadRadius: 2.5,
//                       blurRadius: 3,
//                     )
//                   ],
//                   color: Colors.white
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Speed setting', style: TextStyle(color: Colors.black54, fontSize: 11),),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Image.asset("assets/speed1.png", width: 40,),
//                       // Text("Temperature", style: TextStyle(fontSize: 10),)
//                       Container(
//                         width: 60,
//                         height: 30,
//                         child: TextFormField(
//                           textAlignVertical: TextAlignVertical.bottom,
//                           decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 1, color: Colors.green), //<-- SEE HERE
//                             ),
//                               hintText: 'edit',
//                               hintStyle: TextStyle(color: Colors.black54)
//                           ),
//
//                         ),),
//                       ToggleSwitch(
//                         customWidths: [40.0, 40.0],
//                         cornerRadius: 15,
//                         activeBgColors: [[Colors.green], [Colors.redAccent]],
//                         activeFgColor: Colors.white,
//                         inactiveBgColor: Colors.grey,
//                         inactiveFgColor: Colors.white,
//                         totalSwitches: 2,
//                         icons: [Icons.notifications, Icons.notifications_off],
//                         onToggle: (index) {
//                           print('switched to: $index');
//                         },
//                       ),
//
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 15,),
//             Container(
//               padding: EdgeInsets.only(left: 5, right:5),
//               // width: 325,
//               height: 70,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: Offset(0, 1),
//                       color: Colors.black.withOpacity(0.5),
//                       spreadRadius: 2.5,
//                       blurRadius: 3,
//                     )
//                   ],
//                   color: Colors.white
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Subscribtion setting ', style: TextStyle(color: Colors.black54, fontSize: 11),),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Image.asset("assets/expiry.png", width: 35,),
//                       // Text("Temperature", style: TextStyle(fontSize: 10),)
//                       Container(
//                         width: 60,
//                         height: 30,
//                         child: TextFormField(
//                           textAlignVertical: TextAlignVertical.bottom,
//                           decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 1, color: Colors.green), //<-- SEE HERE
//                             ),
//                               hintText: 'edit',
//                               hintStyle: TextStyle(color: Colors.black54)
//                           ),
//                         ),),
//                       ToggleSwitch(
//                         customWidths: [40.0, 40.0],
//                         cornerRadius: 15,
//                         activeBgColors: [[Colors.green], [Colors.redAccent]],
//                         activeFgColor: Colors.white,
//                         inactiveBgColor: Colors.grey,
//                         inactiveFgColor: Colors.white,
//                         totalSwitches: 2,
//                         icons: [Icons.notifications, Icons.notifications_off],
//                         onToggle: (index) {
//                           print('switched to: $index');
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     actions: <Widget>[
//       new ElevatedButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         child: const Text('Close'),
//       ),
//     ],
//   );
// }
