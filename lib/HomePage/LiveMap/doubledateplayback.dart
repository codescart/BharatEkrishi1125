import 'dart:async';
import 'dart:convert';

import 'package:bharatekrishi/Model/home_model.dart';
import 'package:bharatekrishi/constant/Utils.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../constant/constatnt.dart';

class GMapScreen extends StatefulWidget {
  final HomeModel homodel;
  const GMapScreen({
    Key? key,
    required this.homodel,
  }) : super(key: key);

  @override
  State<GMapScreen> createState() => _GMapScreenState();
}

class _GMapScreenState extends State<GMapScreen> {
  final List<Polyline> _polyline = [];
  final List<Marker> _markers = [];
  final List<LatLng> _machinePolylinePoints = [];
  final List _machinearkerPoints = [];

  @override
  void initState() {
    super.initState();
    fetchCalenderdate();
    _fetchLocations();
  }

  final Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _googlemap = const CameraPosition(
      target: LatLng(
        33.857646,
        797.269046,
      ),
      zoom: 20);

  int jumpspeed = 10;
  int overSeeed = 10;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: _googlemap,
            mapType: MapType.hybrid,
            polylines: Set.from(_polyline),
            markers: _markers.toSet(),
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            padding: const EdgeInsets.all(16),
          ),
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
                boxShadow: const [
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
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.white,
                      )),
                  Column(
                    children: [
                      widget.homodel.vehicleCatId == '2'
                          ? Image.asset(
                              "assets/harvest.png",
                              height: 40,
                              width: 40,
                            )
                          : Image.asset("assets/mainimg.png",
                              height: 40, width: 40),
                      Text(
                        status == null ? "" : status.toString(),
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
                        widget.homodel.vehicleNo!,
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
                  '${widget.homodel.today_engine_hours}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              )),
          Positioned(
            right: width * 0.01,
            bottom: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  isOpen = true;
                });
              },
              child: isOpen == false
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.green,
                        child: Text(
                          "${buttonValues[selectedButtonIndex]}x",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(buttonValues.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedButtonIndex = index;
                              jumpspeed = buttonValues[selectedButtonIndex];
                              isOpen = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: selectedButtonIndex == index
                                  ? Colors.green
                                  : Colors.grey,
                              child: Text(
                                '${buttonValues[index]}x',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
            ),
          ),
          Positioned(
            right: width * 0.15,
            bottom: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  speedisOpen = true;
                });
              },
              child: speedisOpen == false
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${speedbuttonValues[speedselectedButtonIndex]}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            const Text(
                              "km/h",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:
                          List.generate(speedbuttonValues.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _machinearkerPoints.clear();
                              _polyline.clear();
                              _markers.clear();
                              speedselectedButtonIndex = index;
                              overSeeed =
                                  speedbuttonValues[speedselectedButtonIndex];
                              speedisOpen = false;
                            });
                            _polylineBasedOnMachine();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: speedselectedButtonIndex == index
                                  ? Colors.green
                                  : Colors.grey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${speedbuttonValues[index]}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                  const Text(
                                    'km/h',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
            ),
          ),
          Positioned(
            right: width * 0.29,
            bottom: 0,
            child: InkWell(
              onTap: () {
                _markers.clear();
                liveiconplay(prv: false);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.play_arrow),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _polylineBasedOnMachine() async {
    var coordinates = _locations;
    for (var coordinate in coordinates) {
      double speed = double.parse(coordinate['speed']);
      var lat = double.parse(coordinate['latitude']);
      var lng = double.parse(coordinate['longitude']);
      _machinePolylinePoints.add(LatLng(lat, lng));
      if (speed > overSeeed) {
        _machinearkerPoints.add(LatLng(lat, lng));
      }
    }
    // print(_machinearkerPoints);
    _changeCameraPosition(_machinePolylinePoints.last);
    _addmarker(_machinearkerPoints);
    var machinePolyLines = Polyline(
      polylineId: const PolylineId("1"),
      points: _machinePolylinePoints.toList(),
      color: Colors.yellowAccent.withOpacity(0.5),
      width: 3,
      zIndex: 0,
    );
    _polyline.add(machinePolyLines);
  }

  _addmarker(List machinearkerPoints) async {
    for (int i = 0; i < machinearkerPoints.length; i++) {
      var mk = Marker(
        markerId: MarkerId(i.toString()),
        position: machinearkerPoints[i],
        icon: BitmapDescriptor.defaultMarkerWithHue(1.0),
        // BitmapDescriptor.defaultMarker,
      );
      _markers.add(mk);
    }
  }

  List _locations = [];
  Future<void> _fetchLocations() async {
    final eimeino = widget.homodel.imei;
    final datefirst =
        DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
    final datesecond =
        DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[1]!);
    var uri =
        "${baseUrlPhp}mapget_copy.php?predate=$datefirst&nextdate=$datesecond&imei=$eimeino";
    final response =
        await http.get(Uri.parse(uri)); // Replace with your API URL
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _locations = responseData;
      });
      _polylineBasedOnMachine();
    } else {
      Utils.flushBarErrorMessage(
          'No data Available on selected Date.', context);
    }
  }

  _changeCameraPosition(LatLng last) async {
    final letlng = last;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: letlng, zoom: 18)));
  }

  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now().add(const Duration(days: -2)),
    DateTime.now()
  ];

  List calenderdateList = [];

  Future<void> fetchCalenderdate() async {
    final eimeino = widget.homodel.imei;
    final apiEndpoint = '${baseUrlPhp}devicedatabytime.php?imei=$eimeino';
    try {
      final response = await http.get(Uri.parse(apiEndpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          calenderdateList = data;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  _buildCalendarDialogButton() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
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
        // index
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
                          color:
                              isSelected == true ? Colors.white : Colors.green,
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
                          shape: BoxShape.circle,
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
                _markers.clear();
                _polyline.clear();
                _locations.clear();
                _machinearkerPoints.clear();
                _machinePolylinePoints.clear();
              });
              _fetchLocations();
            }
          },
          icon: Image.asset('assets/image/calender.png'),
        ),
        Text(
          "${DateFormat('dd-MM-yyyy').format(_dialogCalendarPickerValue[0]!)} to ${DateFormat('dd-MM-yyyy').format(_dialogCalendarPickerValue[1]!)}",
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }

  List<int> buttonValues = [6, 5, 4, 3, 2, 1];
  int selectedButtonIndex = 5;
  bool isOpen = false;

  List<int> speedbuttonValues = [35, 30, 25, 20, 15, 10, 5];
  int speedselectedButtonIndex = 5;
  bool speedisOpen = false;

  Timer? countdownTimer;

  bool play = false;
  int countl = 1;
  int count = 1;
  var inplay = 1;
  bool prv = false;

  liveiconplay({required bool prv}) {
    setState(() {
      play = true;
    });
    countdownTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
              prv == false ? countl++ : countl--;
              inplay = countl * jumpspeed;
              liveicon(countl * jumpspeed);
            }));
  }

  liveicon(int count) async {
    BitmapDescriptor livmovementicon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 50),
      "assets/livem/tractoriconm.png",
    );
    _markers.add(Marker(
      markerId: const MarkerId('Gaddis'),
      position: _machinePolylinePoints[count],
      infoWindow: const InfoWindow(
        title: 'Gadi',
      ),
      icon: livmovementicon,
    ));
  }

  String? status;
  Future<void> getstatus() async {
    final eimeino = widget.homodel.imei;
    final datefirst =
        DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[0]!);
    final datesecond =
        DateFormat('yyyy-MM-dd').format(_dialogCalendarPickerValue[1]!);
    final apiEndpoint =
        '${baseUrlPhp}api/checkvehiclespeed.php?imei=$eimeino&predate=$datefirst&nextdate=$datesecond';
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
}
