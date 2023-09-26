// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bharatekrishi/Settings/ManageVehical/vehicle_list_screen.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;

class UpdateVehical extends StatefulWidget {
  final vehicle vehicledata;
  const UpdateVehical(this.vehicledata, {super.key});

  @override
  State<UpdateVehical> createState() => _UpdateVehicalState();
}

class _UpdateVehicalState extends State<UpdateVehical> {
  String? vehicleType;
  List vehicle_data = [];

  String? company;
  List company_data = [];

  String? model;
  List Model_data = [];

  String? Asign;
  List asign_data = [];

  ///@ vehial type api
  Future<String> Vehicle() async {
    final res = await http
        .get(Uri.parse(baseUrlCi+'vehiclecat'));
    final resBody = json.decode(res.body);

    setState(() {
      vehicle_data = resBody;
    });
    return "Sucess";
  }

  ///@ company type api
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
    final userId = prefs.getString(key) ?? 0;
    print(userId);
    final res = await http.get(
        Uri.parse(baseUrlCi+'getassins/$userId'));
    final resBody = json.decode(res.body);

    setState(() {
      asign_data = resBody;
    });
    return "Sucess";
  }

  @override
  void initState() {
    Vehicle();
    Company(widget.vehicledata.vehicle_company_id);
    Model(widget.vehicledata.vehicle_model_id);
    Asigndat();
    _setdata();
    super.initState();
  }

  _setdata() {
    setState(() {
      _vehiclenumber.text = widget.vehicledata.vehicle_no.toString() == 'null'
          ? ''
          : widget.vehicledata.vehicle_no.toString();
      _vehiclename.text = widget.vehicledata.vehicle_name.toString() == 'null'
          ? ''
          : widget.vehicledata.vehicle_name.toString();
      _overspeed.text = widget.vehicledata.overspeeding.toString() == 'null'
          ? ''
          : widget.vehicledata.overspeeding.toString();
      _overheat.text = widget.vehicledata.overheathing.toString() == 'null'
          ? ''
          : widget.vehicledata.overheathing.toString();
      _initialengine.text =
          widget.vehicledata.initial_engine.toString() == 'null'
              ? ''
              : widget.vehicledata.initial_engine.toString();
      _qr.text = widget.vehicledata.passcode.toString() == 'null'
          ? ''
          : widget.vehicledata.passcode.toString();
    });
  }

  final TextEditingController _vehiclename = TextEditingController();
  final TextEditingController _vehiclenumber = TextEditingController();
  final TextEditingController _overspeed = TextEditingController();
  final TextEditingController _overheat = TextEditingController();
  final TextEditingController _initialengine = TextEditingController();
  final TextEditingController _qr = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  final bool _loading = false;

  _buildChild(BuildContext context) => Container(
        height: 430,
        padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vehicle Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 28, width: 28,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(20)),
                    // child: Image.asset('assets/cancel.png', width: 35,),
                    child: const Icon(
                      Icons.cancel_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  (choosenLanguage != "")
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            languages[choosenLanguage]['Vehicle Type'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
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
                          '${widget.vehicledata.catname}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: vehicle_data.map((item) {
                          return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(
                                item['name'].toString(),
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
                          Company(vehicleType);
                        },
                        value: vehicleType,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (choosenLanguage != "")
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            languages[choosenLanguage]['Company'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
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
                          '${widget.vehicledata.companyname}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
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
                            company = value as String;
                          });
                          Model(company);
                        },

                        // buttonHeight: 40,
                        // buttonWidth: 140,
                        // itemHeight: 40,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (choosenLanguage != "")
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            languages[choosenLanguage]['Model'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
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
                          '${widget.vehicledata.modelname}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: Model_data.map((item) {
                          return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(
                                item['model'].toString(),
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
                            model = value as String;
                          });
                        },
                        value: model,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (choosenLanguage != "")
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            languages[choosenLanguage]['Vehicle number'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
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
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(top: 6, left: 5),
                                hintText: languages[choosenLanguage]
                                    ['Enter_here'],
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (choosenLanguage != "")
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            languages[choosenLanguage]['Vehicle name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    // alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
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
                                contentPadding:
                                    const EdgeInsets.only(top: 6, left: 5),
                                hintText: languages[choosenLanguage]
                                    ['Enter_here'],
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          )
                        : Container(),
                  ),
                  const SizedBox(
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            // alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2.5,
                                    blurRadius: 3,
                                  )
                                ],
                                color: Colors.white),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: (choosenLanguage != "")
                                ? TextField(
                                    controller: _overspeed,
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    decoration: InputDecoration(
                                        counter: const Offstage(),
                                        hintText: languages[choosenLanguage]
                                            ['Enter_here'],
                                        hintStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                        border: const OutlineInputBorder(
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            // alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2.5,
                                    blurRadius: 3,
                                  )
                                ],
                                color: Colors.white),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: (choosenLanguage != "")
                                ? TextField(
                                    controller: _overheat,
                                    maxLength: 3,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        counter: const Offstage(),
                                        hintText: languages[choosenLanguage]
                                            ['Enter_here'],
                                        hintStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2.5,
                                    blurRadius: 3,
                                  )
                                ],
                                color: Colors.white),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: (choosenLanguage != "")
                                ? TextField(
                                    controller: _initialengine,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: languages[choosenLanguage]
                                            ['Enter_here'],
                                        hintStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                        border: const OutlineInputBorder(
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2.5,
                                    blurRadius: 3,
                                  )
                                ],
                                color: Colors.white),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                  widget.vehicledata.assignuser == null
                                      ? "Add"
                                      : '${widget.vehicledata.assignuser}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: asign_data
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item['id'].toString(),
                                          child: Text(
                                            item['name'].toString(),
                                            style: const TextStyle(
                                              fontSize: 10,
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
                  const SizedBox(
                    height: 10,
                  ),
                  (choosenLanguage != "")
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            languages[choosenLanguage]['pass_code'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2.5,
                            blurRadius: 3,
                          )
                        ],
                        color: Colors.white),
                    child: (choosenLanguage != "")
                        ? TextField(
                            controller: _qr,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: languages[choosenLanguage]
                                    ['pass_code'],
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      updateVehicle(_vehiclenumber.text, _vehiclename.text,
                          _overspeed.text, _overheat.text, _initialengine.text,
                          _qr.text
                          );
                    },
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFFE0E0E0),
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
                            Colors.green.shade200,
                            Colors.green.shade300,
                            Colors.green.shade400,
                            Colors.green.shade500,
                          ],
                        ),
                      ),
                      child: Center(
                          child: _loading == false
                              ? Text(
                                  (choosenLanguage != '')
                                      ? languages[choosenLanguage]['save']
                                      : "",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                              : const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  updateVehicle(String vehiclenumber, String vehiclename, String overspeed,
      String overheat, String initialengine,String qr) async {
    final response = await http.post(
      Uri.parse('${baseUrlPhp}v_update.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': widget.vehicledata.id.toString(),
        "userid":widget.vehicledata.users_id.toString(),
        'vehicle_type': "$vehicleType",
        'company': "$company",
        'modal': "$model",
        'overspeeding': overspeed,
        'overheathing': overheat,
        'initialengine': initialengine,
        'vehicle_no': vehiclenumber,
        'vehicle_name': vehiclename,
        'assignuser': "$Asign",
        'passcode': qr,
      }),
    );
    final data = jsonDecode(response.body);
    print(data);
    print('data');
    if (data['status'] == "200") {
      Fluttertoast.showToast(
          msg: data['massege'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context,true);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const manageVehicle_setting()));
    } else {
      Fluttertoast.showToast(
          msg: data['massege'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
