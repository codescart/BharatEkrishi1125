// import 'dart:async';
// import 'dart:convert';
// import 'package:calendar_date_picker2/calendar_date_picker2.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../../Model/home_model.dart';
// import '../../constant/constatnt.dart';
//
// class DoubleDatePlayBack extends StatefulWidget {
//   final HomeModel imei;
//   DoubleDatePlayBack({Key? key, required this.imei});
//   @override
//   _DoubleDatePlayBackState createState() => _DoubleDatePlayBackState();
// }
//
// class _DoubleDatePlayBackState extends State<DoubleDatePlayBack> {
//   Completer<GoogleMapController> _controller = Completer();
//   final CameraPosition _googlemap = CameraPosition(
//       target: LatLng(
//         33.857646,
//         797.269046,
//       ),
//       zoom: 20);
//   @override
//   void initState() {
//     fetchCalenderdate();
//     _drawpolyline();
//     // _startTimer();
//     super.initState();
//   }
//
//   double speed = 0.0;
//   double overspeed = 0.0;
//   final Set<Marker> _markers = {};
//
//   var datelength = 1;
//   final Set<Polyline> _polyline = {};
//   List<LatLng> polylineCoordinates = [];
//   List<double> movelat = [];
//   List<double> movelong = [];
//   List<String> date = [];
//   var latsds;
//   var longsds;
//
//   _drawpolyline() async {
//     GoogleMapController mapController = await _controller.future;
//
//     BitmapDescriptor overspeedmarker = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 10), "assets/livem/overspeed.png");
//
//     BitmapDescriptor stoppointm = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 20),
//         "assets/livem/stoppointm.png");
//
//     BitmapDescriptor startendpoint = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 20),
//         "assets/livem/startpointm.png");
//     var imei = widget.imei.imei;
//     var firstdate =
//         DateFormat('yyyy-dd-MM').format(_dialogCalendarPickerValue[0]!);
//     var lastdate =
//         DateFormat('yyyy-dd-MM').format(_dialogCalendarPickerValue[1]!);
//     print(
//         'https://sethstore.com/kkisan/mapget_copy.php?predate=$firstdate&nextdate=$lastdate&imei=$imei');
//     print('pankajajayyy');
//     final response = await http.post(
//       Uri.parse(
//           'https://sethstore.com/kkisan/mapget_copy.php?predate=$firstdate&nextdate=$lastdate&imei=$imei'
//           // 'https://sethstore.com/kkisan/mapget_copy.php?predate=2023-06-1%2015:10:42%20&nextdate=2023-06-29%2015:10:42&imei=350317179749480'
//           ),
//     );
//     final data = jsonDecode(response.body);
//     setState(() {
//       datelength = data.length;
//       latsds = double.parse(data[0]['latitude']);
//       longsds = double.parse(data[0]['longitude']);
//       print('raja');
//       var rr = datelength - 1;
//       speed = double.parse(data[rr]['speed']);
//       overspeed = double.parse(data[rr]['overspeeding']);
//       print(speed);
//       print('savan');
//       _markers.add(Marker(
//         markerId: MarkerId('Gaddi'),
//         position: LatLng(latsds, longsds),
//         infoWindow: InfoWindow(
//           title: 'Start',
//           snippet: data[0]['latitude'] + ',' + data[0]['longitude'],
//         ),
//         icon: startendpoint,
//         // BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//       ));
//     });
//
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(latsds, longsds), zoom: 20)));
//
//     int m = 1;
//     int d = 1;
//     int f = 1;
//
//     for (int i = 0; i < data.length; i++) {
//       var latsd = double.parse(data[i]['latitude']);
//       var nei = i + 1;
//       var latsdm = double.parse(data[nei]['latitude']);
//       var longsd = double.parse(data[i]['longitude']);
//       var cspeed = double.parse(data[i]['speed'].toString());
//       var vspeed = double.parse(vehicalsetspeed);
//       var ignition = data[i]['ignition'].toString();
//       var datef = data[i]['servertime'].toString();
//       movelat.add(latsd);
//       movelong.add(longsd);
//       date.add(datef);
//       polylineCoordinates.add(LatLng(latsd, longsd));
//       _polyline.add(Polyline(
//         polylineId: PolylineId(data[i]['imei'].toString()),
//         points: polylineCoordinates,
//         color: Colors.blue,
//         width: 3,
//       ));
//       setState(() {});
//       if (cspeed > vspeed) {
//         setState(() {
//           m++;
//           _markers.add(Marker(
//             markerId: MarkerId('s' + '$m'),
//             position: LatLng(latsd, longsd),
//             infoWindow: InfoWindow(
//               title: 'OverSpeed $m',
//               snippet: cspeed.toString() + date[i],
//             ),
//             icon: overspeedmarker,
//           ));
//         });
//       }
//       if (latsd != latsdm) {
//         if (ignition == "true" && cspeed <= 0) {
//           setState(() {
//             d++;
//             _markers.add(
//                 // added markers
//                 Marker(
//               markerId: MarkerId('o' + '$d'),
//               position: LatLng(latsd, longsd),
//               infoWindow: InfoWindow(
//                 title: 'ENGINE OFF $d',
//                 snippet: cspeed.toString() + ' ' + date[i],
//               ),
//               icon: stoppointm,
//             ));
//           });
//         }
//       }
//       if (latsd != latsdm) {
//         if (ignition == "false") {
//           setState(() {
//             f++;
//             _markers.add(Marker(
//               markerId: MarkerId('b' + '$f'),
//               position: LatLng(latsd, longsd),
//               infoWindow: InfoWindow(
//                 title: 'ENGINE OFF $f',
//                 snippet: cspeed.toString() + ' ' + date[i],
//               ),
//               icon: stoppointm,
//             ));
//           });
//         }
//       }
//       // _startTimer();
//     }
//   }
//
//   String vehicalsetspeed = "20";
//   int jumpspeed = 10;
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         body: Stack(
//       alignment: Alignment.topCenter,
//       children: [
//         GoogleMap(
//             myLocationEnabled: false,
//             zoomControlsEnabled: false,
//             zoomGesturesEnabled: true,
//             myLocationButtonEnabled: false,
//             markers: _markers,
//             initialCameraPosition: _googlemap,
//             polylines: _polyline,
//             mapType: MapType.satellite,
//             onMapCreated: (GoogleMapController controller) {
//               if (!_controller.isCompleted) {
//                 _controller.complete(controller);
//               }
//               _drawpolyline();
//             }),
//         Positioned(
//           top: height * 0.06,
//           left: width * 0.025,
//           child: Container(
//             height: height * 0.1,
//             width: width * 0.95,
//             decoration: BoxDecoration(
//               color: status=="Running"
//                   ? Colors.green.withOpacity(0.7)
//                   : status=="Overspeed"
//                   ? Colors.orange.withOpacity(0.7)
//                   : status=="Idle"
//                   ? Colors.yellow.withOpacity(0.7)
//                   : Colors.red.withOpacity(0.7),
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                   bottomRight: Radius.circular(20)),
//               boxShadow: [
//                 BoxShadow(color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(
//                       Icons.arrow_back_ios,
//                       size: 20,
//                       color: Colors.white,
//                     )),
//                 Column(
//                   children: [
//                     widget.imei.vehicleCatId == '2'
//                         ? Image.asset(
//                       "assets/harvest.png",
//                       height: 40,
//                       width: 40,
//                     )
//                         : Image.asset("assets/mainimg.png",
//                         height: 40, width: 40),
//                     Text(status==null?"":status.toString(),
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.imei.vehicleNo!,
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                           color: Colors.white),
//                     ),
//                     _buildCalendarDialogButton()
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//             top: height * 0.16,
//             left: width * 0.025,
//             child: Container(
//               height: height * 0.04,
//               width: width * 0.3,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(15),
//                       bottomRight: Radius.circular(15)),
//                   color: Colors.green.withOpacity(0.7)),
//               child: Text(
//                 '${widget.imei.today_engine_hours}',
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             )),
//         Positioned(
//           right: width * 0.01,
//           bottom: 0,
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 isOpen = true;
//               });
//             },
//             child: isOpen == false
//                 ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CircleAvatar(
//                       radius: 20,
//                       child: Text(
//                         "${buttonValues[selectedButtonIndex]}x",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       backgroundColor: Colors.green,
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: List.generate(buttonValues.length, (index) {
//                       return InkWell(
//                         onTap: () {
//                           setState(() {
//                             selectedButtonIndex = index;
//                             jumpspeed = buttonValues[selectedButtonIndex] * 1;
//                             isOpen = false;
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircleAvatar(
//                             child: Text(
//                               '${buttonValues[index]}x',
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                             ),
//                             backgroundColor: selectedButtonIndex == index
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//           ),
//         ),
//         Positioned(
//           right: width * 0.15,
//           bottom: 0,
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 speedisOpen = true;
//               });
//             },
//             child: speedisOpen == false
//                 ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CircleAvatar(
//                       radius: 20,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "${speedbuttonValues[speedselectedButtonIndex]}",
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                           Text(
//                             "km/h",
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ],
//                       ),
//                       backgroundColor: Colors.green,
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: List.generate(speedbuttonValues.length, (index) {
//                       return InkWell(
//                         onTap: () {
//                           setState(() {
//                             speedselectedButtonIndex = index;
//                             vehicalsetspeed =
//                                 speedbuttonValues[speedselectedButtonIndex];
//                             speedisOpen = false;
//                             polylineCoordinates.clear();
//                             movelat.clear();
//                             movelong.clear();
//                             date.clear();
//                             _markers.clear();
//                             _polyline.clear();
//                             _drawpolyline();
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircleAvatar(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   '${speedbuttonValues[index]}',
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 10),
//                                 ),
//                                 Text(
//                                   'km/h',
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 10),
//                                 ),
//                               ],
//                             ),
//                             backgroundColor: speedselectedButtonIndex == index
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//           ),
//         ),
//         Positioned(
//           right: width * 0.29,
//           bottom: 0,
//           child: InkWell(
//             onTap: () {
//               liveiconplay(prv: false);
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CircleAvatar(
//                 radius: 20,
//                 child: Icon(Icons.play_arrow),
//                 backgroundColor: Colors.green,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ));
//   }
//
//   List<DateTime?> _dialogCalendarPickerValue = [
//     DateTime.now().add(const Duration(days: -2)),
//     DateTime.now()
//   ];
//
//   List calenderdateList = [];
//
//   Future<void> fetchCalenderdate() async {
//     final eimeino = widget.imei.imei;
//     final apiEndpoint =
//         'https://kkisan.sethstore.com/devicedatabytime.php?imei=$eimeino';
//     try {
//       final response = await http.get(Uri.parse(apiEndpoint));
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         setState(() {
//           calenderdateList = data;
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   _buildCalendarDialogButton() {
//     const dayTextStyle =
//         TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
//     final weekendTextStyle =
//         TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
//     final anniversaryTextStyle = TextStyle(
//       color: Colors.red[400],
//       fontWeight: FontWeight.w700,
//       decoration: TextDecoration.underline,
//     );
//     final config = CalendarDatePicker2WithActionButtonsConfig(
//       dayTextStyle: dayTextStyle,
//       calendarType: CalendarDatePicker2Type.range,
//       selectedDayHighlightColor: Colors.purple[800],
//       closeDialogOnCancelTapped: true,
//       firstDayOfWeek: 1,
//       weekdayLabelTextStyle: const TextStyle(
//         color: Colors.black87,
//         fontWeight: FontWeight.bold,
//       ),
//       controlsTextStyle: const TextStyle(
//         color: Colors.black,
//         fontSize: 15,
//         fontWeight: FontWeight.bold,
//       ),
//       centerAlignModePicker: true,
//       customModePickerIcon: const SizedBox(),
//       selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
//       dayTextStylePredicate: ({required date}) {
//         TextStyle? textStyle;
//         if (date.weekday == DateTime.saturday ||
//             date.weekday == DateTime.sunday) {
//           textStyle = weekendTextStyle;
//         }
//         var eventDay = "${date.year}-${date.month}-${date.day}";
//         for (var i = 0; i < calenderdateList.length; i++) {
//           if (eventDay == calenderdateList[i]) {
//             textStyle = anniversaryTextStyle;
//           }
//         }
//         return textStyle;
//       },
//       dayBuilder: ({
//         required date,
//         textStyle,
//         decoration,
//         isSelected,
//         isDisabled,
//         isToday,
//         // index
//       }) {
//         Widget? dayWidget;
//         var geAllDay = "${date.year}-${date.month}-${date.day}";
//         for (var i = 0; i < calenderdateList.length; i++) {
//           if (geAllDay == calenderdateList[i]) {
//             dayWidget = Container(
//               decoration: decoration,
//               child: Center(
//                 child: Stack(
//                   alignment: AlignmentDirectional.center,
//                   children: [
//                     Text(
//                       MaterialLocalizations.of(context).formatDecimal(date.day),
//                       style: textStyle,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 27.5),
//                       child: Container(
//                         height: 4,
//                         width: 4,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color:
//                               isSelected == true ? Colors.white : Colors.green,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         }
//         return dayWidget;
//       },
//       yearBuilder: ({
//         required year,
//         decoration,
//         isCurrentYear,
//         isDisabled,
//         isSelected,
//         textStyle,
//       }) {
//         return Center(
//           child: Container(
//             decoration: decoration,
//             height: 36,
//             width: 72,
//             child: Center(
//               child: Semantics(
//                 selected: isSelected,
//                 button: true,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       year.toString(),
//                       style: textStyle,
//                     ),
//                     if (isCurrentYear == true)
//                       Container(
//                         padding: const EdgeInsets.all(5),
//                         margin: const EdgeInsets.only(left: 5),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.redAccent,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: () async {
//             final values = await showCalendarDatePicker2Dialog(
//               context: context,
//               config: config,
//               dialogSize: const Size(325, 400),
//               borderRadius: BorderRadius.circular(15),
//               value: _dialogCalendarPickerValue,
//               dialogBackgroundColor: Colors.white,
//             );
//             if (values != null) {
//               setState(() {
//                 _dialogCalendarPickerValue = values;
//                 _markers.clear();
//                 _polyline.clear();
//                 _drawpolyline();
//               });
//             }
//           },
//           icon: Image.asset('assets/image/calender.png'),
//         ),
//         Text(
//           "${DateFormat('dd-MM-yyyy').format(_dialogCalendarPickerValue[0]!)} to ${DateFormat('dd-MM-yyyy').format(_dialogCalendarPickerValue[1]!)}",
//           style: TextStyle(color: Colors.white),
//         )
//       ],
//     );
//   }
//
//   List<int> buttonValues = [6, 5, 4, 3, 2, 1];
//   int selectedButtonIndex = 5;
//   bool isOpen = false;
//
//   List<String> speedbuttonValues = ['35', '30', '25', '20', '15', '10', '5'];
//   int speedselectedButtonIndex = 3;
//   bool speedisOpen = false;
//
//   @override
//   void dispose() {
//     // Cancel the timer when the widget is disposed
//     // _cancelTimer();
//     _controller = Completer();
//     super.dispose();
//   }
//
//   // Timer? _timer;
//   //
//   // void _startTimer() async{
//   //   print('Data Found');
//   //   // Set up a timer that triggers every 5 seconds
//   //   if (latsds == null && longsds == null) {
//   //     print('Data Not Found');
//   //   } else {
//   //       _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
//   //         // Move the camera to the new position
//   //         final GoogleMapController controller = await _controller.future;
//   //         controller.animateCamera(CameraUpdate.newCameraPosition(
//   //             CameraPosition(target: LatLng(latsds, longsds), zoom: 20)));
//   //       });
//   //   }
//   // }
//   //
//   // void _cancelTimer() {
//   //   // Cancel the timer if it is active
//   //   if (_timer != null && _timer!.isActive) {
//   //     _timer!.cancel();
//   //   }
//   // }
//   //
//   Timer? countdownTimer;
//
//   bool play = false;
//   int countl = 1;
//   int count = 1;
//   var inplay = 1;
//   bool prv = false;
//
//   liveiconplay({required bool prv}) {
//     setState(() {
//       play = true;
//     });
//     countdownTimer = Timer.periodic(
//         Duration(seconds: 1),
//         (_) => setState(() {
//               prv == false ? countl++ : countl--;
//               inplay = countl * jumpspeed;
//               liveicon(countl * jumpspeed);
//             }));
//   }
//
//   liveicon(int count) async {
//     BitmapDescriptor livmovementicon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(devicePixelRatio: 20),
//       "assets/livem/tractoriconm.png",
//     );
//     _markers.add(Marker(
//       markerId: MarkerId('Gaddis'),
//       position: LatLng(movelat[count], movelong[count]),
//       infoWindow: InfoWindow(
//         title: 'Gadi',
//       ),
//       icon: livmovementicon,
//     ));
//   }
//
//
//   String? status;
//   Future<void> getstatus() async {
//     final eimeino = widget.imei.imei;
//     final datefirst =
//     DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
//     final datesecond =
//     DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[1]!);
//     final apiEndpoint =
//         '${BaseUrlPhp}api/checkvehiclespeed.php?imei=$eimeino&predate=$datefirst&nextdate=$datesecond';
//     print(apiEndpoint);
//     try {
//       final response = await http.get(Uri.parse(apiEndpoint));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print(data);
//         print('rama');
//         setState(() {
//           status =data['status'].toString();
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//
// }
//
// // class MenuTile {
// //   String title;
// //   String? subtitle;
// //   String? imageData;
// //   MenuTile({required this.title, this.subtitle, this.imageData});
// // }
