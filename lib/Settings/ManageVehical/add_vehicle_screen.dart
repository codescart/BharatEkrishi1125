import 'dart:convert';

import 'package:bharatekrishi/Settings/ManageVehical/vehicle_list_screen.dart';
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../constant/constatnt.dart';

class add_vehicle extends StatefulWidget {
  const add_vehicle({Key? key}) : super(key: key);

  @override
  State<add_vehicle> createState() => _add_vehicleState();
}

class _add_vehicleState extends State<add_vehicle> {
  String _scanBarcode = '';

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
      _qr.text=_scanBarcode.toString();
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  String? vehicleType;
  List vehicle_data = [];

  String? company;
  List company_data = [];

  String? model;
  List Model_data = [];

  String? Asign;
  List asign_data = [];


  Future<String> Vehicle() async {
    final res = await http
        .get(Uri.parse(baseUrlCi+'vehiclecat'));
    final resBody = json.decode(res.body);

    setState(() {
      vehicle_data = resBody;
    });
    return "Sucess";
  }

  Future<String> Company(String? vehicleType) async {
    final res = await http.get(Uri.parse(
        baseUrlCi+'vehicle_get/$vehicleType'));
    final resBody = json.decode(res.body);

    setState(() {
      company_data = resBody;
    });
    return "Sucess";
  }

  ///@ Model type api
  Future<String> Model(String? company) async {
    final res = await http.get(
        Uri.parse(baseUrlCi+'model/$company'));
    final resBody = json.decode(res.body);

    setState(() {
      Model_data = resBody;
    });
    return "Sucess";
  }

  ///@ AsignUser api
  Future<String> Asigndat() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? 0;
    print(user_id);
    final res = await http.get(
        Uri.parse(baseUrlCi+'getassins/$user_id'));
    final resBody = json.decode(res.body);

    setState(() {
      asign_data = resBody;
    });
    return "Sucess";
  }

  @override
  void initState() {
    Vehicle();
    Asigndat();
    autofill();
    super.initState();
  }

  final TextEditingController _vehiclename = TextEditingController();
  final TextEditingController _vehiclenumber = TextEditingController();
  final TextEditingController _overspeed = TextEditingController();
  final TextEditingController _overheat = TextEditingController();
  final TextEditingController _initialengine = TextEditingController();
  final TextEditingController _qr = TextEditingController();

  autofill(){
    setState(() {
      _overspeed.text="20";
      _overheat.text="90";
      _initialengine.text="0";
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: (choosenLanguage != "")
            ? Text(
                languages[choosenLanguage]['Add Vehicles'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            : Container(),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.lightGreenAccent,
                  Colors.green,
                ]),
          ),
          padding: EdgeInsets.only(top: 10, left: 5, right: 20, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('',
                  style: GoogleFonts.lato(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // IconButton(onPressed: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>addUser_setting()));
                  // }, icon: Icon(Icons.add, color: Colors.white, size: 30,))
                ],
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              (choosenLanguage != "")
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        languages[choosenLanguage]['Vehicle Type'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2.5,
                        blurRadius: 3,
                      )
                    ],
                    color: Colors.white),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.9,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      'Select your vehicle type',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: vehicle_data.map((item) {
                      return DropdownMenuItem(
                          child: Text(
                            item['name'].toString(),
                            overflow: TextOverflow.clip,
                            // maxLines: ,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: "Windsor",
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              // color: Colors.black
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          value: item['id'].toString());
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        vehicleType = value!;
                      });
                      Company(vehicleType);
                    },
                    value: vehicleType,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (choosenLanguage != "")
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        languages[choosenLanguage]['Company'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2.5,
                        blurRadius: 3,
                      )
                    ],
                    color: Colors.white),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.9,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['Select Company'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).hintColor,
                            ),
                          )
                        : Container(),
                    items: company_data
                        .map((item) => DropdownMenuItem<String>(
                              value: item['id'].toString(),
                              child: Text(
                                item['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: company,
                    onChanged: (value) {
                      setState(() {
                        company = value!;
                        Model(company);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (choosenLanguage != "")
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        languages[choosenLanguage]['Model'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2.5,
                        blurRadius: 3,
                      )
                    ],
                    color: Colors.white),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.9,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['Select Model'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).hintColor,
                            ),
                          )
                        : Container(),
                    items: Model_data.map((item) {
                      return DropdownMenuItem(
                          child: Text(
                            item['model'].toString(),
                            overflow: TextOverflow.clip,
                            // maxLines: ,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: "Windsor",
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              // color: Colors.black
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          value: item['id'].toString());
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        model = value!;
                      });
                    },
                    value: model,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (choosenLanguage != "")
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        languages[choosenLanguage]['Vehicle number'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 5,
              ),
              Container(
                // alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2.5,
                        blurRadius: 3,
                      )
                    ],
                    color: Colors.white),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.9,
                child: (choosenLanguage != "")
                    ? TextField(
                        controller: _vehiclenumber,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5,left: 5),
                            hintText: languages[choosenLanguage]
                                ['Enter_here'],
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                        )
                    : Container(),
              ),
              SizedBox(
                height: 10,
              ),
              (choosenLanguage != "")
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        languages[choosenLanguage]['Vehicle name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2.5,
                        blurRadius: 3,
                      )
                    ],
                    color: Colors.white),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.9,
                child: (choosenLanguage != "")
                    ? TextField(
                        controller: _vehiclename,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5,left: 5),
                            hintText: languages[choosenLanguage]
                                ['Enter_here'],
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      )
                    : Container(),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (choosenLanguage != "")
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                languages[choosenLanguage]['Overspeeding'] +
                                    '(10-40)km/h',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2.5,
                                blurRadius: 3,
                              )
                            ],
                            color: Colors.white),
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: (choosenLanguage != "")
                            ? TextField(
                                controller: _overspeed,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 5,left: 5),
                                    hintText: languages[choosenLanguage]
                                    ['Enter_here'],
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (choosenLanguage != "")
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                languages[choosenLanguage]['Overheating'] +
                                    '(60-115)/C',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2.5,
                                blurRadius: 3,
                              )
                            ],
                            color: Colors.white),
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: (choosenLanguage != "")
                            ? TextField(
                                controller: _overheat,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 5,left: 5),
                                    hintText: languages[choosenLanguage]
                                    ['Enter_here'],
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (choosenLanguage != "")
                          ? Text(
                              languages[choosenLanguage]['Initial engine'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2.5,
                                blurRadius: 3,
                              )
                            ],
                            color: Colors.white),
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: (choosenLanguage != "")
                            ? TextField(
                                controller: _initialengine,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 5,left: 5),
                                    hintText: languages[choosenLanguage]
                                        ['Enter_here'],
                                    hintStyle: TextStyle(color: Colors.black26),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                        )
                            : Container(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (choosenLanguage != "")
                          ? Text(
                              languages[choosenLanguage]['Assign User'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2.5,
                                blurRadius: 3,
                              )
                            ],
                            color: Colors.white),
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: (choosenLanguage != "")
                                ? Text(
                                    languages[choosenLanguage]['Assign User'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  )
                                : Container(),
                            items: asign_data
                                .map((item) => DropdownMenuItem<String>(
                                      value: item['id'].toString(),
                                      child: Text(
                                        item['name'].toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: Asign,
                            onChanged: (value) {
                              setState(() {
                                Asign = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan QR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: scanQR,
                        child: Container(
                          height: 40,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 5,
                                color: Colors.greenAccent,
                                inset: true,
                              ),
                              BoxShadow(
                                offset: Offset(0, -30),
                                blurRadius: 22,
                                color: Colors.greenAccent,
                                inset: true,
                              ),
                            ],
                          ),
                          child: Center(
                              child: Icon(
                            Icons.document_scanner_outlined,
                            size: 25,
                          )),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '-OR-',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Pass Code',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2.5,
                                blurRadius: 3,
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _qr,
                            decoration: InputDecoration(
                                hintText: "   Pass Code",
                                hintStyle: TextStyle(color: Colors.black26),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(top: 5,left: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          )),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 5,
                            color: Colors.red,
                            inset: true,
                          ),
                          BoxShadow(
                            offset: Offset(0, -30),
                            blurRadius: 22,
                            color: Colors.red,
                            inset: true,
                          ),
                        ],
                      ),
                      child: Center(
                        child: (choosenLanguage != "")
                            ? Text(
                                languages[choosenLanguage]['cancel'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            : Container(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      add_vehicle(
                          _vehiclenumber.text,
                          _vehiclename.text,
                          _overspeed.text,
                          _overheat.text,
                          _initialengine.text,
                          _qr.text);
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 5,
                            color: Colors.green,
                            inset: true,
                          ),
                          BoxShadow(
                            offset: Offset(0, -30),
                            blurRadius: 22,
                            color: Colors.green,
                            inset: true,
                          ),
                        ],
                      ),
                      child: Center(
                        child: (choosenLanguage != "")
                            ? Text(
                                languages[choosenLanguage]['save'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            : Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  add_vehicle(String _vehiclenumber,String _vehiclename,String _overspeed, String _overheat,
       String _initialengine, String _qr) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? 0;
    print(user_id);
    print("$vehicleType");
    print("$company");
    print("$model");
    print(_vehiclenumber);
    print(_vehiclename);
    print(_overspeed);
    print(_overheat);
    print(_initialengine);
    print("$Asign");
    print(_qr);
    print("aaaaaaaaa");
    final response = await http.post(
      Uri.parse(baseUrlCi+'Vehicle_add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'users_id': "$user_id",
        'vehicle_type': "$vehicleType",
        'company': "$company",
        'modal': "$model",
        'vehicale_no': _vehiclenumber,
        'vehicle_name': _vehiclename,
        'overspeeding': _overspeed,
        'overheathing': _overheat,
        'initialengine': _initialengine,
        'assignuser': "$Asign",
        'passcode': _qr,
      }),
    );
    final data = jsonDecode(response.body);
    print(data);
    print('rrrrrrrrrrrrrrrr');
    if (data['error'] == "200") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['msg'].toString())),
      );
      Navigator.pop(context,true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => manageVehicle_setting()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['msg'].toString())),
      );
    }
  }
}
