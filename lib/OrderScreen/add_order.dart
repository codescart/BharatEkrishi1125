import 'dart:convert';
import 'package:bharatekrishi/HomePage/LiveMap/singledatelivemap.dart';
import 'package:bharatekrishi/HomePage/Widget/vehical_data.dart';
import 'package:bharatekrishi/widgets/jelly_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Dashbord/dashbord_screen.dart';
import 'AddOrderWidget/address_dialog.dart';

class AddOrderScreen extends StatefulWidget {
  final List<LatLng>? googleMapPolygonPoints;
  final String? acreArea;
  const AddOrderScreen({super.key, this.googleMapPolygonPoints, this.acreArea});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  _init() {
    dateCon.text =
        widget.googleMapPolygonPoints != null ? orderdate.toString() : '';
    areaQuantaty.text =
        widget.acreArea.toString() != 'null' ? widget.acreArea.toString() : '0';
    formateDate = DateFormat('yyyy-MM-dd hh:mm a').format(selectedDateTime);
  }

  final Completer<GoogleMapController> _poygonController = Completer();
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(33.857646, 79.269046),
    zoom: 13.5,
  );
  List<Polygon> _polygons = [];

  @override
  void initState() {
    getAgent();
    getFarmer();
    getVehicle();
    _init();
    super.initState();
    if (widget.googleMapPolygonPoints != null) {
      _polygons.add(
        Polygon(
            polygonId: const PolygonId('orderPolygon'),
            points: widget.googleMapPolygonPoints!,
            fillColor: Colors.lightGreen.withOpacity(0.6),
            strokeColor: Colors.red,
            strokeWidth: 2),
      );
      _changeCameraPosition(widget.googleMapPolygonPoints!.first);
    }
  }

  DateTime selectedDate = DateTime.now();
  final areaQuantaty = TextEditingController();
  final rateCon = TextEditingController();
  final dateCon = TextEditingController();
  final totalAmount = TextEditingController();
  final advanceCon = TextEditingController(text: '0');
  final remainingAmount = TextEditingController();
  final farmerName = TextEditingController();
  final farmerNumber = TextEditingController();
  final destinationCon = TextEditingController();

  String? vehicleType;
  String? areaUnit;
  int? unitValue;

  List vehicleData = [];

  // vehial list api
  Future<String> getVehicle() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    final res = await http.get(Uri.parse('${baseUrlCi}vehiclesget/$userId'));
    final resBody = json.decode(res.body)['data'];
    setState(() {
      vehicleData = resBody;
      areaUnit = json.decode(res.body)['pref_areaname'];
      unitValue = json.decode(res.body)['pref_area_calculation'];
      vehicleType = widget.googleMapPolygonPoints == null
          ? vehicleData[0]['id'].toString()
          : vehicleidex.toString();
      if (vehicleType != null) {
        getImpliments(vehicleType);
      } else {
        getImpliments(vehicleType);
      }
    });
    return "Sucess";
  }

  String? impliment;
  List implimentData = [];

  // implement list api
  Future<String> getImpliments(String? vehicleType) async {
    final res =
        await http.get(Uri.parse('${baseUrlCi}Implementlit/$vehicleType'));
    final resBody = json.decode(res.body);

    setState(() {
      implimentData = resBody;
    });
    return "Sucess";
  }

  final berlinWallFell = DateTime.utc(1989, 11, 9);

  String? farmer;
  List farmerData = [];

  //fafmer list
  Future<String> getFarmer() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    final res = await http.get(Uri.parse('${baseUrlCi}farmer/$userId'));
    final resBody = json.decode(res.body);

    setState(() {
      farmerData = resBody;
      farmer = farmerData[0]['id'].toString();
    });
    return "Sucess";
  }

  //add agent
  _addAgent(String? name, String? mobile) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    final res = await http.post(
      Uri.parse('${baseUrlCi}agentadd'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "mobile": mobile!,
        'name': name!,
        'dealer_id': '$userId'
      }),
    );
    final resBody = json.decode(res.body);
    if (resBody["success"] == "200") {
      getAgent();
      Fluttertoast.showToast(
          msg: resBody['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: resBody['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String? agents;
  List agentData = [];

  //agents list api
  Future<String> getAgent() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    final res = await http.get(Uri.parse('${baseUrlCi}Agent/$userId'));
    final resBody = json.decode(res.body);
    setState(() {
      agentData = resBody;
      agents = agentData[0]['id'].toString();
    });
    return "Sucess";
  }

  // String? ratetypes;
  // List rate_data = [];
  // double sqft = 0;
  // Future<String> ratetype() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final user_id = prefs.getString('user_id') ?? 0;
  //   final res =
  //       await http.get(Uri.parse(BaseUrlCi + 'area_calculation/$user_id'));
  //   final resBody = json.decode(res.body);
  //   setState(() {
  //     rate_data = resBody['data'];
  //     int i = int.parse(resBody['ind'].toString());
  //     ratetypes = rate_data[i]['area_name'].toString();
  //     if (widget.acreArea.toString() != "null") {
  //       sqft = double.parse(widget.acreArea.toString()) * 43560;
  //       final data = rate_data[i]['area_calculation'].toString();
  //       _areaquantaty.text = (sqft / double.parse(data)).toStringAsFixed(2);
  //       // _areaquantaty.text=sqft.toString();
  //     }
  //   });
  //
  //   return "Sucess";
  // }
  //
  // autofill() {
  //   setState(() {
  //     _advance.text = "0";
  //   });
  // }

  _changeCameraPosition(LatLng first) async {
    final letlng = first;
    final GoogleMapController controller = await _poygonController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: letlng, zoom: 20)));
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNavBar(
                          pageIndex: 0,
                        )));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(languages[choosenLanguage]['Add order']),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.lightGreenAccent,
                  Colors.green,
                ]),
          ),
        ),
      ),
      body: Column(
        children: [
          widget.googleMapPolygonPoints != null
              ? Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  height: heights / 4, width: widths,
                  child: GoogleMap(
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: _initialCameraPosition,
                    mapType: MapType.hybrid,
                    polygons: Set.from(_polygons),
                    onMapCreated: (GoogleMapController controller) {
                      if (!_poygonController.isCompleted) {
                        _poygonController.complete(controller);
                      }
                    },
                    padding: const EdgeInsets.all(16),
                  ),
                  // child: ,
                )
              : Container(),
          widget.googleMapPolygonPoints != null
              ? SizedBox(
                  height: heights / 1.625,
                  child: orderDetails(context, heights, widths))
              : SizedBox(
                  height: heights / 1.14,
                  child: orderDetails(context, heights, widths))
        ],
      ),
    ));
  }

  Widget orderDetails(BuildContext context, heights, widths) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: heights / 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.lightGreenAccent,
                        Colors.green,
                      ]),
                ),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  languages[choosenLanguage]['Add new order'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: heights / 60,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  height: heights / 16,
                  width: widths * 0.65,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black54)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text(
                        languages[choosenLanguage]['Farmer Name'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      items: farmerData.map((item) {
                        return DropdownMenuItem(
                            value: item['id'].toString(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item['name'].toString(),
                                  overflow: TextOverflow.clip,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontFamily: "Windsor",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                Text(
                                  item['mobile'].toString(),
                                  overflow: TextOverflow.clip,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontFamily: "Windsor",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ));
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          farmer = value as String;
                        });
                      },
                      value: farmer,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _addformerpopup(context);
                  },
                  child: Container(
                      height: 40,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade600,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(1, 1),
                          ),
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5, -5),
                              blurRadius: 15,
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
                      child: const Center(
                        child: Icon(Icons.add),
                      )),
                ),
              ]),
              SizedBox(
                height: heights / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: heights / 16,
                    width: widths * 0.65,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black54)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          languages[choosenLanguage]['Agent Name'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        ),
                        items: agentData.map((item) {
                          return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'].toString(),
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                    style: const TextStyle(
                                      fontFamily: "Windsor",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    item['mobile'].toString(),
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                    style: const TextStyle(
                                      fontFamily: "Windsor",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ));
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            agents = value as String;
                          });
                        },
                        value: agents,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Contact? contact = await _contactPicker.selectContact();
                      _addAgent(contact!.fullName, contact.phoneNumbers![0]);
                    },
                    child: Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(1, 1),
                            ),
                            const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-5, -5),
                                blurRadius: 15,
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
                        child: const Center(
                          child: Icon(Icons.add),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: heights / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.only(left: 10),
                    // alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black54)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          'vehicle',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: vehicleData.map((item) {
                          return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(
                                item['vehicle_no'].toString(),
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                style: const TextStyle(
                                  fontFamily: "Windsor",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.justify,
                              ));
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            vehicleType = value as String;
                          });
                        },
                        value: vehicleType,
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black54)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          'Implements',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: implimentData.map((item) {
                          return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(
                                item['implement'].toString(),
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                style: const TextStyle(
                                  fontFamily: "Windsor",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.justify,
                              ));
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            impliment = value as String;
                          });
                        },
                        value: impliment,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heights / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 40,
                      width: widths * 0.4,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.black54)),
                      child: Text(areaUnit.toString() == 'null'
                          ? ""
                          : areaUnit.toString())),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      readOnly:
                          widget.googleMapPolygonPoints.toString() == "null"
                              ? false
                              : true,
                      controller: areaQuantaty,
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.white,
                        hintText: languages[choosenLanguage]['text_quantity'],
                        prefixIcon: const Icon(
                          Icons.compare_arrows,
                          color: Colors.blue,
                          size: 30,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heights / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: rateCon,
                      onChanged: (value) {
                        setState(() {
                          if (rateCon.text.isEmpty) {
                            totalAmount.text = '';
                          } else {
                            double tot = double.parse(areaQuantaty.text) *
                                double.parse(value);
                            totalAmount.text = tot.toString();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.white,
                        hintText: 'Rate',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      readOnly:
                          widget.googleMapPolygonPoints.toString() == "null"
                              ? false
                              : true,

                      onTap: widget.googleMapPolygonPoints.toString() != "null"
                          ? () {}
                          : () async {
                              await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2101))
                                  .then((pickeddate) {
                                if (pickeddate != null) {
                                  setState(() {
                                    selectedDate = pickeddate;
                                    dateCon.text = "${selectedDate.toLocal()}"
                                        .split(' ')[0];
                                  });
                                }
                                return null;
                              });
                            },

                      controller: dateCon,

                      // keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                        prefixIcon: const Icon(Icons.calendar_month_outlined),
                        // labelText: "Select Date"
                        hintText: languages[choosenLanguage]['date'],
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heights / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: totalAmount,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.white,
                        hintText: 'Total Amount',
                        // prefixIcon: Icon(Icons.star_rate, color: Colors.blue,size: 30,),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      onChanged: (value) {
                        double adto = 0.0;
                        setState(() {
                          if (advanceCon.text == '') {
                            adto = double.parse(totalAmount.text) - 0;
                          } else {
                            adto = double.parse(totalAmount.text) -
                                double.parse(value);
                          }
                          remainingAmount.text = adto.toString();
                        });
                      },
                      controller: advanceCon,
                      textAlignVertical: TextAlignVertical.bottom,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        counter: const Offstage(),
                        //contentPadding: EdgeInsets.all(20),
                        // labelText: 'Mobile Number',
                        hintText: languages[choosenLanguage]
                            ['Advance Received'],
                        prefixIcon: const Icon(
                          Icons.area_chart,
                          color: Colors.blue,
                          size: 30,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heights / 60,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.4,
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(),
                child: TextFormField(
                  controller: remainingAmount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    fillColor: Colors.white,
                    hintText: 'Remaining Amount',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(width: 3, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: heights / 60,
              ),
              InkWell(
                onTap: () {
                  selectAddress();
                },
                child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: heights / 60,
                        ),
                        Flexible(
                          child: Text(
                            location == null
                                ? 'Select Your Location'
                                : location.toString(),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _selectDateTime();
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      color: Colors.red,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      formateDate == 'null'
                          ? languages[choosenLanguage]['timereminder']
                          : formateDate.toString(),
                      style: TextStyle(
                          fontSize: 15, color: ColorConstants.detailForm),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              JellyButton(
                height: heights / 17,
                onTap: () {
                  Navigator.pop(context);
                },
                title: languages[choosenLanguage]['cancel'],
                color: Colors.red,
              ),
              JellyButton(
                height: heights / 17,
                onTap: () {
                  addOrder(areaQuantaty.text, rateCon.text, advanceCon.text,
                      dateCon.text, remainingAmount.text, totalAmount.text);
                },
                title: languages[choosenLanguage]['Confirm Order'],
                loading: _liadingbutton,
              ),
            ],
          ),
        )
      ],
    );
  }

  _addfarmerapi(String farmerName, String farmerNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    final response = await http.post(
      Uri.parse('${baseUrlCi}farmernew'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': farmerName,
        'mobile': farmerNumber,
        'dealer_id': '$userId',
      }),
    );
    final data = jsonDecode(response.body);
    print(data);
    if (data["success"] != false) {
      Navigator.of(context).pop();
      setState(() {
        getFarmer();
      });
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      // {success: false, message: {name: [The name field is required.], mobile: [The mobile field is required.]}}
      if (data['message'] != null && data['message'].isNotEmpty) {
        final firstErrorMessage = data['message'].values.first.first;
        Fluttertoast.showToast(
            msg: firstErrorMessage.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future<void> _addformerpopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/cancel.png',
                      width: 35,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  languages[choosenLanguage]['add_new_farmer'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.65,
                  alignment: Alignment.bottomLeft,
                  decoration: const BoxDecoration(),
                  child: TextFormField(
                    controller: farmerName,
                    textAlignVertical: TextAlignVertical.bottom,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      counter: const Offstage(),
                      hintText: languages[choosenLanguage]['Farmer Name'],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(width: 3, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.65,
                  alignment: Alignment.bottomLeft,
                  child: TextFormField(
                    controller: farmerNumber,
                    textAlignVertical: TextAlignVertical.bottom,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      counter: const Offstage(),
                      hintText: languages[choosenLanguage]['Farmer Number'],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(width: 3, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                JellyButton(
                  onTap: () {
                    _addfarmerapi(farmerName.text, farmerNumber.text);
                  },
                  title: languages[choosenLanguage]['add_new_farmer'],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime selectedDateTime = DateTime.now();
  String? formateDate;

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          formateDate =
              DateFormat('yyyy-MM-dd hh:mm a').format(selectedDateTime);
        });
      }
    }
  }

  bool _liadingbutton = false;

  addOrder(String areaQuantaty, String rateCon, String advance, String dateCon,
      String remamount, String totalamount) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    setState(() {
      _liadingbutton = true;
    });
    final response = await http.post(
      Uri.parse('${baseUrlCi}addoder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'cust_id': '$farmer',
        'agent_id': '$agents',
        'vehicles_id': '$vehicleType',
        'Implement_id': '$impliment',
        'quantity': areaQuantaty,
        'rate': rateCon,
        'date': dateCon,
        'totalamount': totalamount,
        'advance': advance,
        'remaining': remamount,
        'rate_type': areaUnit.toString(),
        'lat': '$latitude',
        'longs': '$longitude',
        'address': '$location',
        'time_reminder': formateDate,
        'owner_id': '$userId',
        'areainacre': widget.acreArea.toString(),
        'lat_long': widget.googleMapPolygonPoints.toString(),
      }),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == '200') {
      setState(() {
        _liadingbutton = false;
      });
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context, true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavBar(
                    pageIndex: 0,
                  )));
    } else {
      setState(() {
        _liadingbutton = false;
      });
      Fluttertoast.showToast(
          msg: "All Field Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String? location;
  String? latitude;
  String? longitude;
  Future<void> selectAddress() async {
    final myLocation = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return PlaceSearchExample();
        });
    if (myLocation != null && myLocation is Map<String, dynamic>) {
      setState(() {
        location = myLocation['locationName'];
        latitude = myLocation['latitude'];
        longitude = myLocation['longitude'];
      });
    }
  }
}
