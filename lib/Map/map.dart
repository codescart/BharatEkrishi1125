import 'dart:async';
import 'dart:convert';

import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Marker> markers = [];
  final List<CustomMarker> markerPoints = [];
  final Completer<GoogleMapController> _controller = Completer();
  final CameraPosition googleMap = const CameraPosition(
      target: LatLng(
        33.857646,
        797.269046,
      ),
      zoom: 13.5);

  @override
  void initState() {
    super.initState();
    getAllVehicalLocation();
  }

  String? vehicalCount;
  Future<void> getAllVehicalLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    var url =
        Uri.parse('${baseUrlPhp}total_live_tracking_latlng.php?userid=$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['data'];
      vehicalCount = jsonDecode(response.body)['count'];
      for (var coordinate in responseData) {
        var latitude = double.parse(coordinate['latitude']);
        var longitude = double.parse(coordinate['longitude']);
        var vehicleName = coordinate['vehicle_name'];
        var customMarker = CustomMarker(
          position: LatLng(latitude, longitude),
          vehicleName: vehicleName,
        );
        markerPoints.add(customMarker);
      }
      setState(() {
        for (int i = 0; i < markerPoints.length; i++) {
          var customMarker = markerPoints[i];
          var mk = Marker(
            markerId: MarkerId(i.toString()),
            position: customMarker.position,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title:customMarker.vehicleName
            )
          );
          markers.add(mk);
        }
      });
      if (markerPoints.isNotEmpty) {
        changeCameraPosition(markerPoints.first.position);
      }
    } else {
      if (kDebugMode) {
        print('Server error');
      }
    }
  }

  changeCameraPosition(LatLng firstPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: firstPosition, zoom: 13.5)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: googleMap,
            mapType: MapType.hybrid,
            markers: markers.toSet(),
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            padding: const EdgeInsets.all(16),
          ),
          Positioned(
              top: 50,
              left: 15,
              child: Container(
                height: 45,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Total : ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    Text(
                        vehicalCount.toString() == 'null'
                            ? '0'
                            : vehicalCount.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}


class CustomMarker {
  final LatLng position;
  final String vehicleName;

  CustomMarker({
    required this.position,
    required this.vehicleName,
  });
}