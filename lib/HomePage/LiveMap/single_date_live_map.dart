// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:bharatekrishi/HomePage/LiveMap/doubledate_playback.dart';
// import 'package:calendar_date_picker2/calendar_date_picker2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../Model/home_model.dart';
// import '../../OrderScreen/linked_order.dart';
// import '../../constant/constatnt.dart';
// import '../../languages/function.dart';
// import '../../languages/translation.dart';
//
// class SingleDateLiveMap extends StatefulWidget {
//   final HomeModel imei;
//   SingleDateLiveMap({Key? key, required this.imei});
//
//   @override
//   State<SingleDateLiveMap> createState() => _SingleDateLiveMapState();
// }
//
// class _SingleDateLiveMapState extends State<SingleDateLiveMap> {
//   Completer<GoogleMapController> _controller = Completer();
//   List<LatLng> coordinates = [];
//   List<LatLng> refreshdata = [];
//   final Set<Polyline> _polyline = {};
//   final Set<Marker> _markers = {};
//
//   final CameraPosition _googlemap = CameraPosition(
//       target: LatLng(
//         33.857646,
//         797.269046,
//       ),
//       zoom: 13.5);
//   List<DateTime?> _dialogCalendarPickerValue = [
//     DateTime.now(),
//   ];
//
//   @override
//   void initState() {
//     fetchCalenderdate();
//     getstatus();
//     // getletlang();
//     _startTimer();
//     fetchCoordinates();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _cancelTimer();
//     _controller = Completer();
//     super.dispose();
//   }
//
//   Timer? _timer;
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 15), (timer) async {
//       refreshpolyline();
//     });
//   }
//
//   void _cancelTimer() {
//     // Cancel the timer if it is active
//     if (_timer != null && _timer!.isActive) {
//       _timer!.cancel();
//     }
//   }
//
//
//   void fetchCoordinates() async {
//       final eimeino = widget.imei.imei;
//       final fdate =
//           DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
//     final GoogleMapController controller = await _controller.future;
//     final uri ="https://kkisan.sethstore.com/api/map_getonlylat_long.php?imei=$eimeino&date=$fdate";
//     print(uri);
//     print('single map uri');
//     final response = await http.get(Uri.parse('https://kkisan.sethstore.com/api/map_getonlylat_long.php?imei=$eimeino&date=$fdate'));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       List<dynamic> points = data['coordinates'];
//       setState(() {
//         coordinates = points.map((point) {
//           double lat = point['lattitude'];
//           double lng = point['longitude'];
//           return LatLng(lat, lng);
//         }).toList();
//         _polyline.add(Polyline(
//           polylineId: PolylineId('first'),
//           points: coordinates,
//           color: Colors.blue,
//           width: 3,
//         ));
//         _addMarkers(coordinates.first,coordinates.last);
//         controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target: coordinates.last,
//             zoom: 20)));
//       });
//     }
//   }
//
//
//   void refreshpolyline() async {
//     final eimeino = widget.imei.imei;
//     final fdate =
//     DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
//     final GoogleMapController controller = await _controller.future;
//     _polyline.removeWhere((polyline) => polyline.polylineId ==  PolylineId('update'));
//     _markers.removeWhere((marker) => marker.markerId ==  MarkerId('end'));
//     final lastindex =coordinates.length;
//     // print(lastindex);
//     // print('https://kkisan.sethstore.com/api/map_getonlylat_long.php?imei=350612074501725&date=2023-07-14&lastindex=$lastindex');
//     final response = await http.get(Uri.parse('https://kkisan.sethstore.com/api/map_getonlylat_long.php?imei=$eimeino&date=$fdate&lastindex=$lastindex'));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       List<dynamic> points = data['coordinates'];
//       setState(() {
//         refreshdata = points.map((point) {
//           double lat = point['lattitude'];
//           double lng = point['longitude'];
//           return LatLng(lat, lng);
//         }).toList();
//         print(coordinates.last);
//         _polyline.add(Polyline(
//           polylineId: PolylineId('update'),
//           points: refreshdata,
//           color: Colors.green,
//           width: 3,
//         ));
//         _addMarkers(coordinates.first,refreshdata==null?coordinates.last:refreshdata.last);
//         controller.animateCamera(CameraUpdate.newCameraPosition(
//             CameraPosition(target: refreshdata==null?coordinates.last:refreshdata.last, zoom: 20)));
//       });
//     }
//   }
//
//   void _addMarkers(LatLng firstletlang,LatLng secondletlang) async{
//     BitmapDescriptor startLocation = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 10), "assets/sflag.png");
//     BitmapDescriptor currentlocation =
//         await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 10),
//         "assets/livem/tractoriconm.png");
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: MarkerId('first'),
//           position: firstletlang, // Coordinates of marker 1
//           infoWindow: InfoWindow(
//             title: 'Start',
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//         ),
//       );
//       _markers.add(
//         Marker(
//           markerId: MarkerId('end'),
//           position: secondletlang, // Coordinates of marker 2
//           infoWindow: InfoWindow(
//             title: 'Stop',
//           ),
//           icon: currentlocation,
//         ),
//       );
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     List<MenuTile> _menu = [
//       MenuTile(
//           title: widget.imei.todayjobarea == ''
//               ? '0.0'
//               : '${widget.imei.todayjobarea}',
//           imageData: "assets/mapimg.png",
//           subtitle: "Area"),
//       MenuTile(
//           title: widget.imei.today_engine_hours == ''
//               ? '0:0'
//               : '${widget.imei.today_engine_hours}',
//           imageData: "assets/ghadaimg.png",
//           subtitle: 'Working Hours'),
//       MenuTile(
//           title: widget.imei.today_engine_hours == ''
//               ? '0:0'
//               : '${widget.imei.today_engine_hours}',
//           imageData: "assets/engine.gif",
//           subtitle: "Engine Time"),
//       MenuTile(
//           title: widget.imei.fuel == null ? '0' : '${widget.imei.fuel}',
//           imageData: 'assets/fuelmeter.gif',
//           subtitle: "Fuel"),
//       MenuTile(
//           title: widget.imei.temprature == null
//               ? '0'
//               : '${widget.imei.temprature}',
//           imageData: 'assets/temperature.gif',
//           subtitle: 'Temperature'),
//       MenuTile(
//           title: widget.imei.speed == null ? '' : '${widget.imei.speed}',
//           imageData: "assets/Speedometer.gif",
//           subtitle: "Speed"),
//     ];
//     return Scaffold(
//         body: Stack(
//       children: [
//         SlidingUpPanel(
//           maxHeight: height * 0.72,
//           minHeight: height * 0.2,
//           parallaxEnabled: true,
//           parallaxOffset: 0.5,
//           panelBuilder: (sc) => _panel(sc, _menu),
//           color: Colors.white.withOpacity(0.25),
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
//           body: GoogleMap(
//               myLocationEnabled: false,
//               zoomControlsEnabled: false,
//               zoomGesturesEnabled: true,
//               myLocationButtonEnabled: false,
//               markers: _markers,
//               initialCameraPosition: _googlemap,
//               polylines: _polyline,
//               mapType: MapType.hybrid,
//               onMapCreated: (GoogleMapController controller) {
//                 if (!_controller.isCompleted) {
//                   _controller.complete(controller);
//                 }
//               }
//               ),
//         ),
//         Positioned(
//             top: height * 0.2,
//             right: 10,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Container(
//                 //     height: 35,
//                 //     width: 35,
//                 //     decoration: BoxDecoration(
//                 //       color: Colors.green.withOpacity(0.8),
//                 //       borderRadius: BorderRadius.circular(5),
//                 //     ),
//                 //     child: Icon(
//                 //       Icons.edit,
//                 //       color: Colors.white,
//                 //       size: 25,
//                 //     )),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 // InkWell(
//                 //   onTap: () {
//                 //     areaset == false
//                 //         ? setState(() {
//                 //             areaset = true;
//                 //           })
//                 //         : setState(() {
//                 //             areaset = false;
//                 //           });
//                 //
//                 //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>PolygonPage()));
//                 //   },
//                 //   child: Container(
//                 //       height: 35,
//                 //       width: 35,
//                 //       decoration: BoxDecoration(
//                 //         color: areaset == false
//                 //             ? Colors.green.withOpacity(0.8)
//                 //             : Colors.grey.withOpacity(0.8),
//                 //         borderRadius: BorderRadius.circular(5),
//                 //         boxShadow: [
//                 //           BoxShadow(
//                 //               color: Colors.black54.withOpacity(0.5),
//                 //               spreadRadius: (0),
//                 //               offset: Offset(0, 2),
//                 //               blurRadius: 2)
//                 //         ],
//                 //       ),
//                 //       child: Icon(
//                 //         Icons.add,
//                 //         color: Colors.white,
//                 //         size: 30,
//                 //       )),
//                 // ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     share();
//                   },
//                   child: Container(
//                       height: 35,
//                       width: 35,
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.8),
//                         borderRadius: BorderRadius.circular(5),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black54.withOpacity(0.5),
//                               spreadRadius: (0),
//                               offset: Offset(0, 2),
//                               blurRadius: 2)
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.share,
//                         color: Colors.white,
//                         size: 25,
//                       )),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     _launchNav();
//                   },
//                   child: Container(
//                       height: 35,
//                       width: 35,
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.8),
//                         borderRadius: BorderRadius.circular(5),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black54.withOpacity(0.5),
//                               spreadRadius: (0),
//                               offset: Offset(0, 2),
//                               blurRadius: 2)
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.assistant_direction,
//                         color: Colors.white,
//                         size: 25,
//                       )),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => order_screen(),
//                         ));
//                   },
//                   child: Container(
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(5),
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.black54.withOpacity(0.5),
//                             spreadRadius: (0),
//                             offset: Offset(0, 2),
//                             blurRadius: 2)
//                       ],
//                     ),
//                     child: Image.asset(
//                       'assets/order.png',
//                       width: 20,
//                     ),
//                   ),
//                 ),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 // InkWell(
//                 //   onTap: () {
//                 //     print('lll');
//                 //     showDialog(
//                 //         context: context,
//                 //         builder: (BuildContext context) {
//                 //           return AlertDialog(
//                 //             scrollable: true,
//                 //             title: Text('Connect Now'),
//                 //             content: Container(
//                 //               height: 300,
//                 //               width: 300,
//                 //               child: FutureBuilder<List<orders>>(
//                 //                   future: orderhistory(),
//                 //                   builder: (context, snapshot) {
//                 //                     if (snapshot.hasError)
//                 //                       print(snapshot.error);
//                 //                     return snapshot.hasData
//                 //                         ? ListView.builder(
//                 //                         scrollDirection:
//                 //                         Axis.vertical,
//                 //                         itemCount:
//                 //                         snapshot.data!.length,
//                 //                         itemBuilder:
//                 //                             (BuildContext context,
//                 //                             int index) {
//                 //                           print(snapshot
//                 //                               .data!.length);
//                 //                           print('lllll');
//                 //
//                 //                           return ListTile(
//                 //                               leading: Container(
//                 //                                   height: 50,
//                 //                                   width: 50,
//                 //                                   child: Image.network(snapshot
//                 //                                       .data![
//                 //                                   index]
//                 //                                       .photo !=
//                 //                                       null
//                 //                                       ? '${snapshot.data![index].photo}'
//                 //                                       : 'https://kisansuvidha.gov.in/assets/images/kisan-logo.png')),
//                 //                               title: Text(
//                 //                                   '${snapshot.data![index].name}'),
//                 //                               subtitle: Text(
//                 //                                   '${snapshot.data![index].mobile}'),
//                 //                               trailing:
//                 //                               IconButton(
//                 //                                   onPressed:
//                 //                                       () {
//                 //                                     final mob = snapshot
//                 //                                         .data![
//                 //                                     index]
//                 //                                         .mobile;
//                 //                                     launch(
//                 //                                         "tel://$mob");
//                 //                                   },
//                 //                                   icon: Icon(Icons
//                 //                                       .call)));
//                 //                         })
//                 //                         : Center(
//                 //                         child:
//                 //                         CircularProgressIndicator());
//                 //                   }),
//                 //             ),
//                 //           );
//                 //         });
//                 //   },
//                 //   child: Container(
//                 //       height: 35,
//                 //       width: 35,
//                 //       decoration: BoxDecoration(
//                 //         color: Colors.green.withOpacity(0.8),
//                 //         borderRadius: BorderRadius.circular(5),
//                 //         boxShadow: [
//                 //           BoxShadow(
//                 //               color: Colors.black54.withOpacity(0.5),
//                 //               spreadRadius: (0),
//                 //               offset: Offset(0, 2),
//                 //               blurRadius: 2)
//                 //         ],
//                 //       ),
//                 //       child: Icon(
//                 //         Icons.person,
//                 //         color: Colors.white,
//                 //         size: 25,
//                 //       )),
//                 // ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => DoubleDatePlayBack(
//                                   imei: widget.imei,
//                                 )));
//                   },
//                   child: Container(
//                       height: 35,
//                       width: 35,
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.8),
//                         borderRadius: BorderRadius.circular(5),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black54.withOpacity(0.5),
//                               spreadRadius: (0),
//                               offset: Offset(0, 2),
//                               blurRadius: 2)
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.play_arrow_rounded,
//                         color: Colors.white,
//                         size: 25,
//                       )),
//                 )
//               ],
//             )),
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
//                       ? Colors.orange.withOpacity(0.7)
//                       : status=="Idle"
//                               ? Colors.yellow.withOpacity(0.7)
//                               : Colors.red.withOpacity(0.7),
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
//                             "assets/harvest.png",
//                             height: 40,
//                             width: 40,
//                           )
//                         : Image.asset("assets/mainimg.png",
//                             height: 40, width: 40),
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
//       ],
//     ));
//   }
//
//   Widget _panel(ScrollController sc, List<MenuTile> menu) {
//     final height=MediaQuery.of(context).size.height;
//     final width=MediaQuery.of(context).size.width;
//     return MediaQuery.removePadding(
//         context: context,
//         removeTop: true,
//         removeBottom: true,
//         child: ListView(
//           controller: sc,
//           children: <Widget>[
//             SizedBox(
//               height: 12.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 30,
//                   height: 5,
//                   decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.all(Radius.circular(12.0))),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               padding: EdgeInsets.only(left: 10, right: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     height: 40,
//                     decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.8),
//                         border: Border.all(width: 1, color: Colors.black),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 25,
//                           // padding: EdgeInsets.only(bottom: 8),
//                           alignment: Alignment.center,
//                           child: Image.asset(
//                             "assets/Speedometer.gif",
//                             width: 55,
//                           ),
//                         ),
//                         Text(
//                           widget.imei.speed.toString(),
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Stack(
//                   clipBehavior: Clip.none,
//                   alignment: AlignmentDirectional.bottomCenter,
//                   children: [
//                     Container(
//                       width: width * 0.9,
//                       height: height * 0.07,
//                       padding: EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.99),
//                         borderRadius: BorderRadius.circular(5),
//                         boxShadow: [
//                           BoxShadow(
//                             offset: Offset(0, 1),
//                             color: Colors.black.withOpacity(0.5),
//                             spreadRadius: 2.5,
//                             blurRadius: 3,
//                           )
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text('${widget.imei.lastlocation}',
//                               style: GoogleFonts.oswald(
//                                   fontStyle: FontStyle.normal,
//                                   fontSize: MediaQuery.of(context).size.width *
//                                       0.028)),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                         top: -25,
//                         right: 30,
//                         left: 30,
//                         child: Container(
//                           height: 45,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                               width: 0.2,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: widget.imei.lastlocation == ''
//                               ? Center(child: Text('No data available'))
//                               : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       (choosenLanguage != '')
//                                           ? languages[choosenLanguage]
//                                               ['lastlocation']
//                                           : "",
//                                       style: GoogleFonts.oswald(
//                                           fontStyle: FontStyle.normal,
//                                           color: Colors.black,
//                                           fontSize: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.03,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(
//                                       '${widget.imei.lastupdate}',
//                                       style: GoogleFonts.oswald(
//                                         fontStyle: FontStyle.normal,
//                                         color: Colors.black,
//                                         fontSize:
//                                             MediaQuery.of(context).size.width *
//                                                 0.03,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                         ))
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 50,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                           height: 30,
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade600,
//                                 spreadRadius: 1,
//                                 blurRadius: 1,
//                                 offset: Offset(1, 1),
//                               ),
//                               BoxShadow(
//                                   color: Colors.transparent,
//                                   offset: Offset(-5, -5),
//                                   blurRadius: 5,
//                                   spreadRadius: 1),
//                             ],
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 Colors.grey.shade200,
//                                 Colors.grey.shade300,
//                                 Colors.grey.shade400,
//                                 Colors.grey.shade500,
//                               ],
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               // Text('Engine', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),),
//
//                               Image.asset(
//                                 "assets/engine12.png",
//                                 color: widget.imei.ignition == true
//                                     ? Colors.green
//                                     : Colors.red,
//                                 height: 20,
//                                 width: 20,
//                               ),
//
//                               widget.imei.ignition == true
//                                   ? Text(
//                                       ' On',
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w500),
//                                     )
//                                   : Text(
//                                       ' Off',
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w500),
//                                     )
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: 30,
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade600,
//                                 spreadRadius: 1,
//                                 blurRadius: 1,
//                                 offset: Offset(1, 1),
//                               ),
//                               BoxShadow(
//                                   color: Colors.transparent,
//                                   offset: Offset(-5, -5),
//                                   blurRadius: 5,
//                                   spreadRadius: 1),
//                             ],
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 Colors.grey.shade200,
//                                 Colors.grey.shade300,
//                                 Colors.grey.shade400,
//                                 Colors.grey.shade500,
//                               ],
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               widget.imei.network == 'null'
//                                   ? Icon(
//                                       Icons.signal_cellular_alt_2_bar,
//                                       size: 15,
//                                     )
//                                   : Icon(
//                                       Icons.signal_cellular_alt,
//                                       size: 15,
//                                     ),
//                               Center(
//                                   child: Text(
//                                 widget.imei.network.toString()=="null"?"Bad":"Good",
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w500),
//                               ))
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: 30,
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade600,
//                                 spreadRadius: 1,
//                                 blurRadius: 1,
//                                 offset: Offset(1, 1),
//                               ),
//                               BoxShadow(
//                                   color: Colors.transparent,
//                                   offset: Offset(-5, -5),
//                                   blurRadius: 5,
//                                   spreadRadius: 1),
//                             ],
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 Colors.grey.shade200,
//                                 Colors.grey.shade300,
//                                 Colors.grey.shade400,
//                                 Colors.grey.shade500,
//                               ],
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Icon(
//                                 Icons.satellite_alt,
//                                 size: 20,
//                               ),
//                               Center(
//                                   child: Text(
//                                 widget.imei.gNSSStatus.toString() == '1'
//                                     ? 'EXCELLENT'
//                                     : 'BAD',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 8,
//                                     fontWeight: FontWeight.w500),
//                               ))
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: 30,
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade600,
//                                 spreadRadius: 1,
//                                 blurRadius: 1,
//                                 offset: Offset(1, 1),
//                               ),
//                               BoxShadow(
//                                   color: Colors.transparent,
//                                   offset: Offset(-5, -5),
//                                   blurRadius: 5,
//                                   spreadRadius: 1),
//                             ],
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 Colors.grey.shade200,
//                                 Colors.grey.shade300,
//                                 Colors.grey.shade400,
//                                 Colors.grey.shade500,
//                               ],
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Image.asset(
//                                 "assets/battery.png",
//                                 height: 20,
//                                 width: 20,
//                                 color: Colors.black,
//                               ),
//                               Center(
//                                   child: Text( widget.imei.batteryLevel==""?"":
//                                 '${widget.imei.batteryLevel} %',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w500),
//                               ))
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: 30,
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade600,
//                                 spreadRadius: 1,
//                                 blurRadius: 1,
//                                 offset: Offset(1, 1),
//                               ),
//                               BoxShadow(
//                                   color: Colors.transparent,
//                                   offset: Offset(-5, -5),
//                                   blurRadius: 5,
//                                   spreadRadius: 1),
//                             ],
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 Colors.grey.shade200,
//                                 Colors.grey.shade300,
//                                 Colors.grey.shade400,
//                                 Colors.grey.shade500,
//                               ],
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Icon(
//                                 Icons.battery_5_bar_sharp,
//                                 size: 15,
//                               ),
//                               Center(
//                                   child: Text(
//                                 '${widget.imei.battery} V',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w500),
//                               ))
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Padding(
//                       padding: EdgeInsets.only(
//                           left: MediaQuery.of(context).size.width * 0.06,
//                           right: MediaQuery.of(context).size.width * 0.06),
//                       child: GridView.builder(
//                           itemCount: menu.length,
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           padding: EdgeInsets.all(8.0),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                   childAspectRatio: 3 / 2,
//                                   crossAxisCount: 2,
//                                   crossAxisSpacing: 10,
//                                   mainAxisSpacing: 10,
//                                   mainAxisExtent: 150),
//                           itemBuilder: (context, index) {
//                             return Card(
//                               color: Colors.transparent,
//                               elevation: 12,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topRight,
//                                     end: Alignment.bottomLeft,
//                                     stops: [
//                                       0.1,
//                                       // 0.4,
//                                       // 0.6,
//                                       0.9,
//                                     ],
//                                     colors: [
//                                       Colors.lightGreen,
//                                       // Colors.red,
//                                       // Colors.indigo,
//                                       Colors.green,
//                                     ],
//                                   ),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(
//                                     15,
//                                   )),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(8),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         menu[index].subtitle.toString(),
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                       Image.asset(
//                                         menu[index].imageData.toString(),
//                                         height: 70,
//                                         width: 70,
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         menu[index].title,
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }))
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
//
//   _buildCalendarDialogButton() {
//     const dayTextStyle =
//         TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
//     final weekendTextStyle =
//         TextStyle(color: Colors.black, fontWeight: FontWeight.w600);
//     final anniversaryTextStyle = TextStyle(
//       color: Colors.green,
//       fontWeight: FontWeight.w700,
//       decoration: TextDecoration.underline,
//     );
//     final config = CalendarDatePicker2WithActionButtonsConfig(
//       dayTextStyle: dayTextStyle,
//       calendarType: CalendarDatePicker2Type.single,
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
//                           color: isSelected == true
//                               ? Colors.white
//                               : Colors.red[500],
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
//                           shape: BoxShape.rectangle,
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
//             onPressed: () async {
//               final values = await showCalendarDatePicker2Dialog(
//                 context: context,
//                 config: config,
//                 dialogSize: const Size(325, 400),
//                 borderRadius: BorderRadius.circular(15),
//                 value: _dialogCalendarPickerValue,
//                 dialogBackgroundColor: Colors.white,
//               );
//               if (values != null) {
//                 setState(() {
//                   _dialogCalendarPickerValue = values;
//                   _markers.clear();
//                   _polyline.clear();
//                   fetchCoordinates();
//                 });
//               }
//             },
//             icon: Image.asset('assets/image/calender.png')),
//         Text(
//           DateFormat('dd-MM-yyyy').format(_dialogCalendarPickerValue[0]!),
//           style: TextStyle(color: Colors.white),
//         )
//       ],
//     );
//   }
//
//   List calenderdateList = [];
//
//   Future<void> fetchCalenderdate() async {
//     final eimeino = widget.imei.imei;
//     final apiEndpoint = '${BaseUrlPhp}devicedatabytime.php?imei=$eimeino';
//     final response = await http.get(Uri.parse(apiEndpoint));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         calenderdateList = data;
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   // Set<Marker> _markers = Set<Marker>();
//
//
//   // void getFirstCurrentLocation() async {
//   //   BitmapDescriptor currentLocation = await BitmapDescriptor.fromAssetImage(
//   //       ImageConfiguration(devicePixelRatio: 10), "assets/sflag.png");
//   //   BitmapDescriptor destinationlocation =
//   //       await BitmapDescriptor.fromAssetImage(
//   //           ImageConfiguration(devicePixelRatio: 10),
//   //           "assets/livem/tractoriconm.png");
//   //
//   //   final GoogleMapController controller = await _controller.future;
//   //   final markerId = MarkerId('currentLocation');
//   //   setState(() {
//   //     _markers.add(Marker(
//   //       markerId: markerId,
//   //       infoWindow: InfoWindow(
//   //         title: 'Current Location',
//   //       ),
//   //       position: startLetLang,
//   //       icon: currentLocation,
//   //     ));
//   //   });
//   //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//   //       target: LatLng(startLetLang.latitude, startLetLang.longitude),
//   //       zoom: 13.5)));
//   //   calculateDistance(startLetLang, currentTimeLetLang);
//   //   final markerId2 = MarkerId('Destination');
//   //   _markers.add(Marker(
//   //     markerId: markerId2,
//   //     infoWindow:
//   //         InfoWindow(title: 'Distance', snippet: "$distancekm km"),
//   //     position: currentTimeLetLang,
//   //     icon: destinationlocation,
//   //   ));
//   //   drawPolyline();
//   //   Timer.periodic(Duration(seconds: 5), (timer) async {
//   //     // Move the camera to the new position
//   //     final GoogleMapController controller = await _controller.future;
//   //     controller.animateCamera(CameraUpdate.newCameraPosition(
//   //         CameraPosition(target: currentTimeLetLang, zoom: 13)));
//   //   });
//   // }
//
//   // var startLetLang;
//   // var currentTimeLetLang;
//   //
//   // Future<void> getletlang() async {
//   //   final eimeino = widget.imei.imei;
//   //   final fdate =
//   //       DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
//   //   final apiEndpoint =
//   //       '${BaseUrlPhp}api/nitish_mapget.php?imei=$eimeino&date=$fdate';
//   //   print(apiEndpoint);
//   //   try {
//   //     final response = await http.get(Uri.parse(apiEndpoint));
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = jsonDecode(response.body);
//   //       print(data);
//   //       print('rama');
//   //       setState(() {
//   //         var startlat = double.parse(data['startlat']);
//   //         var startlong = double.parse(data['startlong']);
//   //         var currentlat = double.parse(data['currentlat']);
//   //         var currentlong = double.parse(data['currentlong']);
//   //         startLetLang = LatLng(startlat, startlong);
//   //         currentTimeLetLang = LatLng(currentlat, currentlong);
//   //       });
//   //       getFirstCurrentLocation();
//   //     } else {
//   //       throw Exception('Failed to load data');
//   //     }
//   //   } catch (e) {
//   //     throw Exception('Error: $e');
//   //   }
//   // }
//
//   // final Set<Polyline> _polyline = {};
//   //
//   // void drawPolyline() async {
//   //   var polyline = await _getPolyLine();
//   //   _polyline.add(polyline);
//   //   setState(() {});
//   // }
//   //
//   // Future<Polyline> _getPolyLine() async {
//   //   PolylineId id = PolylineId('poly');
//   //   Polyline polyline = Polyline(
//   //     color: Colors.green,
//   //     width: 3,
//   //     polylineId: id,
//   //     points: await _getPolylineCoordinates(startLetLang, currentTimeLetLang),
//   //   );
//   //   return polyline;
//   // }
//
//   // Future<List<LatLng>> _getPolylineCoordinates(
//   //     LatLng pickupLatLng, LatLng dropLatLng) async {
//   //   List<LatLng> polylineCoordinates = [];
//   //   PolylinePoints polylinePoints = PolylinePoints();
//   //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//   //     apiKey,
//   //     PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
//   //     PointLatLng(dropLatLng.latitude, dropLatLng.longitude),
//   //   );
//   //   if (result.points.isNotEmpty) {
//   //     result.points.forEach((PointLatLng point) {
//   //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//   //     });
//   //   }
//   //   return polylineCoordinates;
//   // }
//
//   double earthRadius = 6371; // Radius of the Earth in kilometers
//   String distancekm = "";
//   double calculateDistance(LatLng currentLetLang, LatLng destinationletlang) {
//     double dLat =
//         degreesToRadians(currentLetLang.latitude - destinationletlang.latitude);
//     double dLng = degreesToRadians(
//         currentLetLang.longitude - destinationletlang.longitude);
//
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(degreesToRadians(currentLetLang.latitude)) *
//             cos(degreesToRadians(destinationletlang.latitude)) *
//             sin(dLng / 2) *
//             sin(dLng / 2);
//
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     double distance = earthRadius * c;
//     setState(() {
//       distancekm = distance.toString();
//     });
//     return distance;
//   }
//
//   double degreesToRadians(double degrees) {
//     return degrees * (pi / 180);
//   }
//
//   Future<void> share() async {
//     final vehicle = widget.imei.vehicleNo;
//     var slet = refreshdata==null?coordinates.last.latitude:refreshdata.last.latitude;
//     var slang = refreshdata==null?coordinates.last.longitude:refreshdata.last.longitude;
//     await FlutterShare.share(
//       title: 'Vehicle Location & Details',
//       text: 'Vehicle no $vehicle',
//       linkUrl: 'https://maps.google.com/?q=$slet,$slang',
//     );
//   }
//
//   _launchNav() async {
//     var currentlet = coordinates.first.latitude;
//     var currentlang = coordinates.first.longitude;
//     var destilet = coordinates.last.latitude;
//     var destilang = coordinates.last.longitude;
//     final url =
//         'https://www.google.com/maps/dir/?api=1&origin=$currentlet,$currentlang&destination=$destilet,$destilang&travelmode=driving&dir_action=navigate';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   String? status;
//   Future<void> getstatus() async {
//     final eimeino = widget.imei.imei;
//     final fdate =
//     DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
//     final apiEndpoint =
//         '${BaseUrlPhp}api/checkvehiclespeed.php?imei=$eimeino&date=$fdate';
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
// }
//
// class MenuTile {
//   String title;
//   String? subtitle;
//   String? imageData;
//   MenuTile({required this.title, this.subtitle, this.imageData});
// }
