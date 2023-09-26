import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:bharatekrishi/HomePage/LiveMap/doubledateplayback.dart';
import 'package:bharatekrishi/widgets/launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:bharatekrishi/Model/home_model.dart';
import 'package:bharatekrishi/constant/Utils.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:http/http.dart' as http;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../OrderScreen/linked_order.dart';
import '../../constant/constatnt.dart';
import '../../languages/function.dart';
import '../../languages/translation.dart';
import '../../widgets/radial_gauge.dart';

String? orderdate;

class SingleMapScreen extends StatefulWidget {
  final HomeModel? homeModel;
  SingleMapScreen({
    Key? key,
    this.homeModel,
  }) : super(key: key);

  @override
  State<SingleMapScreen> createState() => _SingleMapScreenState();
}

class _SingleMapScreenState extends State<SingleMapScreen> {
  final List<Polygon> _polygons = [];
  final List<Polyline> _polyline = [];
  final List<Marker> _markers = [];
  final List<LatLng> _googleMapPolygonPoints = [];
  final List<LatLng> _machinePolygonPoints = [];
  String polygonArea = '0';

  Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _googlemap = const CameraPosition(
      target: LatLng(
        33.857646,
        797.269046,
      ),
      zoom: 13.5);
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
  ];

  @override
  void initState() {
    super.initState();
    fetchCalenderdate();
    orderdate = DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
    _getstatus();
    _fetchLocations();
    orderpolygons();
    getCurrentLocation();
  }

  List<LatLng> parseCoordinates(String coordinatesString) {
    if (coordinatesString == 'null') {
      return [const LatLng(0.0, 0.0)];
    }
    final List<String> parts =
        coordinatesString.replaceAll(RegExp(r'[^0-9.,\s]+'), '').split(',');
    final List<LatLng> coordinates = [];
    for (int i = 0; i < parts.length; i += 2) {
      final double lat = double.parse(parts[i]);
      final double lng = double.parse(parts[i + 1]);
      if (lat != null && lng != null) {
        coordinates.add(LatLng(lat, lng));
      }
    }
    return coordinates;
  }

  orderpolygons() async {
    String userid = widget.homeModel!.usersId.toString();
    String vehicleid = widget.homeModel!.vehicleId.toString();
    // final fdate = DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
    final res = await http.get(
        Uri.parse('${baseUrlCi}getcoverarea/$userid/$vehicleid/$orderdate'));
    // print(BaseUrlCi + 'getcoverarea/$userid/$vehicleid/$orderdate');
    // print('res');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print(data);
      for (var datas in data) {
        String coordinatesString = datas['orders_lat_long'].toString();
        String polygonId = datas['id'].toString();
        List<LatLng> polygonCoordinates = parseCoordinates(coordinatesString);
        if (polygonCoordinates != null) {
          _polygons.add(
            Polygon(
              polygonId: PolygonId(polygonId.toString()),
              points: polygonCoordinates,
              fillColor: Colors.lightGreen.withOpacity(0.6),
              strokeColor: Colors.red,
              strokeWidth: 2,
            ),
          );
        } else {
          print("There is no data attached on this date.");
        }
      }
    } else {
      print('No data available');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    List<MenuTile> _menu = [
      MenuTile(
          title: widget.homeModel!.todayjobarea == ''
              ? '0.0'
              : '${widget.homeModel!.todayjobarea}',
          imageData: Image.asset(
            "assets/mapimg.png",
            height: 70,
            width: 70,
          ),
          subtitle: "Area"),
      MenuTile(
          title: widget.homeModel!.today_engine_hours == ''
              ? '0:0'
              : '${widget.homeModel!.today_engine_hours}',
          imageData: Image.asset(
            "assets/ghadaimg.png",
            height: 70,
            width: 70,
          ),
          subtitle: 'Working Hours'),
      MenuTile(
          title: widget.homeModel!.today_engine_hours == ''
              ? '0:0'
              : '${widget.homeModel!.today_engine_hours}',
          imageData: Image.asset(
            "assets/engine.gif",
            height: 70,
            width: 70,
          ),
          subtitle: "Engine Time"),
      MenuTile(
          title: widget.homeModel!.fuel == null
              ? '0'
              : '${widget.homeModel!.fuel}',
          imageData: FuelMeter(
            currentvalue: widget.homeModel!.fuelvalue,
          ),
          subtitle: "Fuel"),
      MenuTile(
          title: widget.homeModel!.temprature == null
              ? '0'
              : '${widget.homeModel!.temprature}',
          imageData: Image.asset(
            'assets/temperature.gif',
            height: 70,
            width: 70,
          ),
          subtitle: 'Temperature'),
      MenuTile(
          title: widget.homeModel!.speed == null
              ? ''
              : '${widget.homeModel!.speed}',
          imageData: SpeedMeter(currentvalue: widget.homeModel!.speedvalue),
          subtitle: "Speed"),
    ];
    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
            maxHeight: height / 1.8,
            minHeight: height * 0.2,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            panelBuilder: (sc) => _panel(sc, _menu),
            color: Colors.white.withOpacity(0.25),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            body: GoogleMap(
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: _googlemap,
              mapType: MapType.hybrid,
              polygons: Set.from(_polygons),
              polylines: Set.from(_polyline),
              onTap: (point) {
                _markers.clear();
                _googleMapPolygonPoints.add(point);
                setState(() {
                  {
                    for (int i = 0; i < _googleMapPolygonPoints.length; i++) {
                      var mk = Marker(
                        markerId: MarkerId(i.toString()),
                        position: _googleMapPolygonPoints[i],
                        icon: BitmapDescriptor.defaultMarker,
                        draggable: true,
                        onDragEnd: (newPosition) =>
                            _onPolygonDragEnd(newPosition, i),
                        consumeTapEvents: true,
                        onTap: () => _onMarkerTapped(point, i),
                      );
                      _markers.add(mk);
                    }
                  }
                  // polygonArea = calculatePolygonArea(_googleMapPolygonPoints);
                  // print(calculatePolygonArea(_googleMapPolygonPoints));
                  // print('ram');
                  var condouble = double.parse(calculatePolygonArea(_googleMapPolygonPoints))*10.7639 / widget.homeModel!.unitValue;
                  // 4046.86;
                  polygonArea = condouble.toStringAsFixed(2);
                  _refreshPolygonOnMapTapped(point);
                });
              },
              markers: _markers.toSet(),
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
              padding: const EdgeInsets.all(16),
            ),
          ),
          Positioned(
              top: height * 0.18,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Launcher.shareLocation(
                          widget.homeModel!.vehicleNo.toString(),
                          _locations.last['lattitude'],
                          _locations.last['longitude']);
                    },
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54.withOpacity(0.5),
                                spreadRadius: (0),
                                offset: const Offset(0, 2),
                                blurRadius: 2)
                          ],
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 25,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      var llet = _locations.last['lattitude'];
                      var llng = _locations.last['longitude'];
                      Launcher.launchUrl(context,
                          "https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLong&destination=$llet,$llng&travelmode=driving&dir_action=navigate");
                    },
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54.withOpacity(0.5),
                                spreadRadius: (0),
                                offset: const Offset(0, 2),
                                blurRadius: 2)
                          ],
                        ),
                        child: const Icon(
                          Icons.assistant_direction,
                          color: Colors.white,
                          size: 25,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (polygonArea.toString() == 'null' ||
                          polygonArea.toString() == '0') {
                        Utils.flushBarErrorMessage(
                            'Tap on Map and Select the area .', context);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderScreen(
                                    googleMapPolygonPoints:
                                        _googleMapPolygonPoints,
                                    acreArea: polygonArea)));
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54.withOpacity(0.5),
                              spreadRadius: (0),
                              offset: const Offset(0, 2),
                              blurRadius: 2)
                        ],
                      ),
                      child: Image.asset(
                        'assets/order.png',
                        width: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GMapScreen(
                                    homodel: widget.homeModel!,
                                  )));
                    },
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54.withOpacity(0.5),
                                spreadRadius: (0),
                                offset: const Offset(0, 2),
                                blurRadius: 2)
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 25,
                        )),
                  )
                ],
              )),
          Positioned(
            top: height * 0.06,
            left: width * 0.025,
            child: Container(
              height: height * 0.1,
              width: width * 0.95,
              decoration: BoxDecoration(
                color: status == "Running"
                    ? Colors.green.withOpacity(0.7)
                    : status == "Overspeed"
                        ? Colors.orange.withOpacity(0.7)
                        : status == "Idle"
                            ? Colors.yellow.withOpacity(0.7)
                            : Colors.red.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                boxShadow: [
                  const BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.white,
                      )),
                  Column(
                    children: [
                      widget.homeModel!.vehicleCatId == '2'
                          ? Image.asset(
                              "assets/harvest.png",
                              height: 40,
                              width: 40,
                            )
                          : Image.asset("assets/mainimg.png",
                              height: 40, width: 40),
                      Text(
                        status.toString() == 'null' || status.toString() == ''
                            ? ""
                            : status.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.homeModel!.vehicleNo!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      _buildCalendarDialogButton()
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: height * 0.16,
              left: width * 0.025,
              child: Container(
                height: height * 0.04,
                width: width * 0.3,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    color: Colors.green.withOpacity(0.7)),
                child: Text(
                  '${widget.homeModel!.today_engine_hours}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }

  _changeCameraPosition({required let, required lng}) async {
    final flet = double.parse(let);
    final flng = double.parse(lng);
    final letlng = LatLng(flet, flng);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: letlng, zoom: 20)));
  }

  Widget _panel(ScrollController sc, List<MenuTile> menu) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: height / 20,
                    width: width / 3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/Speedometer.gif",
                          width: 30,
                        ),
                        Text(
                          widget.homeModel!.speed.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Selected Area: $polygonArea ${widget.homeModel!.areaUnit}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      width: width * 0.9,
                      height: height * 0.07,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.99),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2.5,
                            blurRadius: 3,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${widget.homeModel!.lastlocation}',
                              style: GoogleFonts.oswald(
                                  fontStyle: FontStyle.normal,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.028)),
                        ],
                      ),
                    ),
                    Positioned(
                        top: -25,
                        right: 30,
                        left: 30,
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: widget.homeModel!.lastlocation == ''
                              ? const Center(child: Text('No data available'))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (choosenLanguage != '')
                                          ? languages[choosenLanguage]
                                              ['lastlocation']
                                          : "",
                                      style: GoogleFonts.oswald(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${widget.homeModel!.lastupdate}',
                                      style: GoogleFonts.oswald(
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                    ),
                                  ],
                                ),
                        ))
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 30,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(1, 1),
                              ),
                              const BoxShadow(
                                  color: Colors.transparent,
                                  offset: Offset(-5, -5),
                                  blurRadius: 5,
                                  spreadRadius: 1),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                                Colors.grey.shade500,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Text('Engine', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),),

                              Image.asset(
                                "assets/engine12.png",
                                color: widget.homeModel!.ignition == true
                                    ? Colors.green
                                    : Colors.red,
                                height: 20,
                                width: 20,
                              ),

                              widget.homeModel!.ignition == true
                                  ? const Text(
                                      ' On',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : const Text(
                                      ' Off',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    )
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(1, 1),
                              ),
                              const BoxShadow(
                                  color: Colors.transparent,
                                  offset: Offset(-5, -5),
                                  blurRadius: 5,
                                  spreadRadius: 1),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                                Colors.grey.shade500,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              widget.homeModel!.network == 'null'
                                  ? const Icon(
                                      Icons.signal_cellular_alt_2_bar,
                                      size: 15,
                                    )
                                  : const Icon(
                                      Icons.signal_cellular_alt,
                                      size: 15,
                                    ),
                              Center(
                                  child: Text(
                                widget.homeModel!.network.toString() == "null"
                                    ? "Bad"
                                    : "Good",
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(1, 1),
                              ),
                              const BoxShadow(
                                  color: Colors.transparent,
                                  offset: Offset(-5, -5),
                                  blurRadius: 5,
                                  spreadRadius: 1),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                                Colors.grey.shade500,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.satellite_alt,
                                size: 20,
                              ),
                              Center(
                                  child: Text(
                                widget.homeModel!.gNSSStatus.toString() == '1'
                                    ? 'EXCELLENT'
                                    : 'BAD',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(1, 1),
                              ),
                              const BoxShadow(
                                  color: Colors.transparent,
                                  offset: Offset(-5, -5),
                                  blurRadius: 5,
                                  spreadRadius: 1),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                                Colors.grey.shade500,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "assets/battery.png",
                                height: 20,
                                width: 20,
                                color: Colors.black,
                              ),
                              Center(
                                  child: Text(
                                widget.homeModel!.batteryLevel == ""
                                    ? ""
                                    : '${widget.homeModel!.batteryLevel} %',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(1, 1),
                              ),
                              const BoxShadow(
                                  color: Colors.transparent,
                                  offset: Offset(-5, -5),
                                  blurRadius: 5,
                                  spreadRadius: 1),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                                Colors.grey.shade500,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.battery_5_bar_sharp,
                                size: 15,
                              ),
                              Center(
                                  child: Text(
                                '${widget.homeModel!.battery} V',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.06,
                          right: MediaQuery.of(context).size.width * 0.06),
                      child: GridView.builder(
                          itemCount: menu.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 3 / 2,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 150),
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.transparent,
                              elevation: 12,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [
                                      0.1,
                                      0.9,
                                    ],
                                    colors: [
                                      Colors.lightGreen,
                                      Colors.green,
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(
                                    15,
                                  )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Text(
                                        menu[index].subtitle.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Ink(
                                        child: menu[index].imageData,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        menu[index].title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
                ],
              ),
            ),
          ],
        ));
  }

  void _onMarkerTapped(LatLng latLng, int vertexIndex) {
    if (_polygons.length == 1) {
      _polygons.removeLast();
    }
    _markers.clear();
    _googleMapPolygonPoints.clear();
    // polygonArea = calculatePolygonArea(_googleMapPolygonPoints);
    var condouble =
        double.parse(calculatePolygonArea(_googleMapPolygonPoints))*10.7639 /
            widget.homeModel!.unitValue;
    polygonArea = condouble.toStringAsFixed(2);
    setState(() {});
  }

  String calculatePolygonArea(List<LatLng> polygonPoints) {
    List<mp.LatLng> polygonPointsForArea = [];
    for (var polygonPoint in polygonPoints) {
      polygonPointsForArea
          .add(mp.LatLng(polygonPoint.latitude, polygonPoint.longitude));
    }
    var areaInSquareMeters =
        mp.SphericalUtil.computeArea(polygonPointsForArea).toStringAsFixed(2);
    return areaInSquareMeters;
  }

  void _refreshPolygonOnMapTapped(LatLng latLng) {
    _polygons.clear();
    var newStatePolygon = Polygon(
        polygonId: PolygonId(latLng.toString()),
        points: _googleMapPolygonPoints.toList(),
        fillColor: Colors.blueAccent.withOpacity(0.4),
        strokeColor: Colors.blueAccent,
        strokeWidth: 2,
        zIndex: 1);
    _polygons.add(newStatePolygon);
  }

  void _polygonBasedOnMachine() async {
    var coordinates = _locations;
    for (var coordinate in coordinates) {
      var lat = double.parse(coordinate.values.first);
      var lng = double.parse(coordinate.values.last);
      _machinePolygonPoints.add(LatLng(lat, lng));
    }

    var machinePolyLines = Polyline(
      polylineId: const PolylineId("1"),
      points: _machinePolygonPoints.toList(),
      color: Colors.yellowAccent.withOpacity(0.5),
      width: 3,
      zIndex: 0,
    );
    _addMarkers(_machinePolygonPoints.first, _machinePolygonPoints.last);
    _polyline.add(machinePolyLines);
  }

  void _onPolygonDragEnd(LatLng newPosition, int vertexIndex) {
    setState(() {
      _googleMapPolygonPoints[vertexIndex] = newPosition;
      _refreshPolygonOnMapTapped(newPosition);
      // polygonArea = calculatePolygonArea(_googleMapPolygonPoints);
      var condouble =
          double.parse(calculatePolygonArea(_googleMapPolygonPoints))*10.7639 /
              widget.homeModel!.unitValue;
      polygonArea = condouble.toStringAsFixed(2);
    });
  }

  List _locations = [];
  _fetchLocations() async {
    var imeino = widget.homeModel!.imei;
    final uri =
        "${baseUrlPhp}api/map_getonlylat_long.php?imei=$imeino&date=$orderdate";
    final response = await http.get(Uri.parse(uri));
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final resData = responseData['coordinates'];
      _locations = resData;
      _polygonBasedOnMachine();
      _changeCameraPosition(
          let: _locations.last['lattitude'], lng: _locations.last['longitude']);
    } else {
      Utils.flushBarErrorMessage(responseData['msg'], context);
    }
  }

  void _addMarkers(LatLng firstletlang, LatLng secondletlang) async {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('first'),
          position: firstletlang, // Coordinates of marker 1
          infoWindow: const InfoWindow(
            title: 'First Point',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: secondletlang, // Coordinates of marker 2
          infoWindow: const InfoWindow(
            title: 'Last Point',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        ),
      );
    });
  }

  _buildCalendarDialogButton() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);
    final anniversaryTextStyle = const TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        var eventDay = "${date.year}-${date.month}-${date.day}";
        for (var i = 0; i < calenderdateList.length; i++) {
          if (eventDay == calenderdateList[i]) {
            textStyle = anniversaryTextStyle;
          }
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        var geAllDay = "${date.year}-${date.month}-${date.day}";
        for (var i = 0; i < calenderdateList.length; i++) {
          if (geAllDay == calenderdateList[i]) {
            dayWidget = Container(
              decoration: decoration,
              child: Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Text(
                      MaterialLocalizations.of(context).formatDecimal(date.day),
                      style: textStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 27.5),
                      child: Container(
                        height: 4,
                        width: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isSelected == true
                              ? Colors.white
                              : Colors.red[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: _dialogCalendarPickerValue,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                setState(() {
                  _dialogCalendarPickerValue = values;
                  orderdate = DateFormat('yyyy-MM-dd')
                      .format(_dialogCalendarPickerValue[0]!)
                      .toString();
                  _markers.clear();
                  _polyline.clear();
                  _machinePolygonPoints.clear();
                  _googleMapPolygonPoints.clear();
                  _polygons.clear();
                  _locations.clear();
                });
                _fetchLocations();
                orderpolygons();
              }
            },
            icon: Image.asset('assets/image/calender.png')),
        Text(
          DateFormat('dd-MM-yyyy').format(_dialogCalendarPickerValue[0]!),
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }

  List calenderdateList = [];

  Future<void> fetchCalenderdate() async {
    final eimeino = widget.homeModel!.imei;
    final apiEndpoint = '${baseUrlPhp}devicedatabytime.php?imei=$eimeino';
    final response = await http.get(Uri.parse(apiEndpoint));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        calenderdateList = data;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String? status;
  Future<void> _getstatus() async {
    final eimeino = widget.homeModel!.imei;
    final apiEndpoint =
        '${baseUrlPhp}api/checkvehiclespeed.php?imei=$eimeino&date=$orderdate';
    try {
      final response = await http.get(Uri.parse(apiEndpoint));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          status = data['status'].toString();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double latitude = position.latitude;
      double longitude = position.longitude;
      setState(() {
        currentLat = latitude;
        currentLong = longitude;
      });
    } catch (e) {
      print(e);
    }
  }

  var currentLat;
  var currentLong;
  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }
}

class MenuTile {
  String title;
  String? subtitle;
  Widget? imageData;
  MenuTile({required this.title, this.subtitle, this.imageData});
}
