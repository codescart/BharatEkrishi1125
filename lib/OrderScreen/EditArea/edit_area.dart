import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:bharatekrishi/Model/order_history_model.dart';
import 'package:bharatekrishi/OrderScreen/EditArea/save_area.dart';
import 'package:bharatekrishi/constant/Utils.dart';
import 'package:bharatekrishi/generated/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:http/http.dart' as http;
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../constant/constatnt.dart';

class EditArea extends StatefulWidget {
  final OrderModel? orderModel;
  EditArea({Key? key,this.orderModel,}) : super(key: key);

  @override
  State<EditArea> createState() => _EditAreaState();
}

class _EditAreaState extends State<EditArea> {
  final List<Polygon> _polygons = [];
  final List<Polyline> _polyline = [];
  final List<Marker> _markers = [];
  final List<LatLng> _googleMapPolygonPoints = [];
  final List<LatLng> _machinePolygonPoints = [];
  String polygonArea = '0';

  Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _googlemap = CameraPosition(
      target: LatLng(
        33.857646,
        797.269046,
      ),
      zoom: 13.5);

  List<LatLng> parseCoordinates(String coordinatesString) {
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

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    final String coordinatesString = widget.orderModel!.orderLatLong;
    final List<LatLng> polygonCoordinates = parseCoordinates(coordinatesString);
    if (polygonCoordinates != null) {
      _polygons.add(
        Polygon(
          polygonId: PolygonId('orderPolygon'),
          points: polygonCoordinates,
          fillColor: Colors.lightGreen.withOpacity(0.6),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );
      _changeCameraPosition(polygonCoordinates.first);
    }
  }

  _changeCameraPosition(LatLng first) async {
    final letlng = first;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: letlng, zoom: 20)));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
            maxHeight: height /20,
            minHeight: height/20,
            parallaxEnabled: true,
            parallaxOffset: .5,
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
                  var condouble = double.parse(
                      calculatePolygonArea(_googleMapPolygonPoints)) /
                      4046.86;
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
            panelBuilder: (sc) => _panel(sc, height, width),
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
          ),
          Positioned(
              top: height * 0.18,
              right: 10,
              child: InkWell(
                onTap: () {
                  if (polygonArea.toString() == 'null' ||
                      polygonArea.toString() == '0') {
                    Utils.flushBarErrorMessage(
                        'Tap on Map and Select the area .', context);
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaveAreaScreen(
                              ordeModel:widget.orderModel,
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
                          offset: Offset(0, 2),
                          blurRadius: 2)
                    ],
                  ),
                  child: Image.asset(
                    'assets/order.png',
                    width: 20,
                  ),
                ),
              ),
          ),
          Positioned(
            top: height * 0.06,
            left: width * 0.025,
            child: Container(
              height: height * 0.1,
              width: width * 0.95,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
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
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.white,
                      )),
                  SizedBox(width: height/20,),
                  Row(
                    children: [
                      widget.orderModel!.vehicalId == '2'
                          ? Image.asset(
                        "assets/harvest.png",
                        height: 40,
                        width: 40,
                      )
                          : Image.asset("assets/mainimg.png",
                          height: 40, width: 40),
                      SizedBox(width: height/20,),
                      Text(
                        widget.orderModel!.vehicleNo!,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _panel(ScrollController sc, double height, double width) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: [
            SizedBox(height: height / 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text(
                  'Selected Area: $polygonArea'+' acre',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
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
        double.parse(calculatePolygonArea(_googleMapPolygonPoints)) / 4046.86;
    polygonArea = condouble.toStringAsFixed(2);
    print(polygonArea);
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
          double.parse(calculatePolygonArea(_googleMapPolygonPoints)) / 4046.86;
      polygonArea = condouble.toStringAsFixed(2);
      print(polygonArea);
    });
  }

  List _locations = [];

  void _fetchLocations() async {
    var imeino = widget.orderModel!.imei;
    var date = widget.orderModel!.date;
    final uri =
        "${baseUrlPhp}api/map_getonlylat_long.php?imei=$imeino&date=$date";
    if (kDebugMode) {
      print(uri);
    }
    final response = await http.get(Uri.parse(uri));
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      final resData = responseData['coordinates'];
      setState(() {
        _locations = resData;
        if (kDebugMode) {
          print(_locations);
          print('_locations');
        }
      });
      _polygonBasedOnMachine();
    } else {
      Utils.flushBarErrorMessage(responseData['msg'], context);
    }
  }

  void _addMarkers(LatLng firstletlang, LatLng secondletlang) async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('first'),
          position: firstletlang, // Coordinates of marker 1
          infoWindow: InfoWindow(
            title: 'First Point',
          ),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('end'),
          position: secondletlang, // Coordinates of marker 2
          infoWindow: InfoWindow(
            title: 'Last Point',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }
}

