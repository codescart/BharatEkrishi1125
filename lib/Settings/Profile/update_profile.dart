// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:bharatekrishi/Settings/Profile/profile_View.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bharatekrishi/constant/customshape.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import '../../constant/constatnt.dart';

class update_profile extends StatefulWidget {
  final String? name;
  final String? mobile;
  final String? address;
  final String? city;
  final String? state;
  final String? tractor;
  final String? harvester;
        update_profile(
      {this.name,
      this.mobile,
      this.address,
      this.city,
      this.state,
      this.tractor,
      this.harvester});

  @override
  State<update_profile> createState() => _update_profileState();
}

class _update_profileState extends State<update_profile> {
  String? selectedState;
  List states = [];

  String? selectedCity;
  List cities = [];

  Future<String> state() async {
    final res = await http
        .get(Uri.parse('${baseUrlCi}state'));
    final resBody = json.decode(res.body);
    // print("hhhhhhhhhhhhh");
    // print(resBody);
    setState(() {
      states = resBody;
    });
    return "Sucess";
  }

  Future<String> city(String? statecode) async {
    // print(statecode);
    // print('statecode');
    final res = await http.get(
        Uri.parse('${baseUrlCi}city/$statecode'));
    final resBody = json.decode(res.body);
    // print("hhhhhhhhhhhhh");
    // print(resBody);
    setState(() {
      cities = resBody;
    });
    return "Sucess";
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _tractor = TextEditingController();
  final TextEditingController _horvestor = TextEditingController();

  @override
  void initState() {
    _percentage();
    _setdata();
    state();
    super.initState();
  }

  _setdata() {
    setState(() {
      _name.text =
          widget.name.toString() == 'null' ? '' : widget.name.toString();
      _phone.text =
          widget.mobile.toString() == 'null' ? '' : widget.mobile.toString();
      _address.text =
          widget.address.toString() == 'null' ? '' : widget.address.toString();
      _tractor.text =
          widget.tractor.toString() == 'null' ? '' : widget.tractor.toString();
      _horvestor.text = widget.harvester.toString() == 'null'
          ? ''
          : widget.harvester.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 180,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          flexibleSpace: Stack(
            children: [
              ClipPath(
                clipper: CustomShape(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: ColorConstants.secondaryDarkAppColor,
                ),
              ),
              Container(
                  height: 40,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.only(top: 10, left: 15),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Center(
                          child: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.white,
                      )))),
              Positioned(
                top: 60,
                right: 100,
                left: 100,
                child: Center(
                  child: Stack(
                    children: [
                      file == null
                          ? const CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/kisan.png')
                              // NetworkImage("https://ladli.wishufashion.com/api/uploads/"+widget.image.toString())
                              )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(
                                file!,
                              ),
                            ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.6),
                              shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () {
                              _choose();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0, color: Colors.grey),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(3, 3),
                          color: Colors.green.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 0.2)
                    ]),
                child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2500,
                  percent: percent,
                  center: (choosenLanguage != "")
                      ? Text("$data % " + languages[choosenLanguage]['of your profile is completed'])
                      : Container(),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.green,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['Name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 55,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.secondaryDarkAppColor
                                .withOpacity(0.5), //color of shadow
                            spreadRadius: -3, //spread radius
                            blurRadius: 5, // blur radius
                            offset: const Offset(8, 0),
                          ),
                        ],
                      ),
                      child: (choosenLanguage != "")
                          ? TextFormField(
                              controller: _name,
                              textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                counter: const Offstage(),
                                hintText: languages[choosenLanguage]['Name'],
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/profile.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['Phone'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.secondaryDarkAppColor
                                .withOpacity(0.5), //color of shadow
                            spreadRadius: -3, //spread radius
                            blurRadius: 5, // blur radius
                            offset: const Offset(8, 0),
                          ),
                        ],
                      ),
                      child: (choosenLanguage != "")
                          ? TextFormField(
                              controller: _phone,
                              textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                counter: const Offstage(),
                                hintText: languages[choosenLanguage]['Phone'],
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/imagesphones.jpg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['State'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.secondaryDarkAppColor
                                .withOpacity(0.5), //color of shadow
                            spreadRadius: -3, //spread radius
                            blurRadius: 5, // blur radius
                            offset: const Offset(8, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      child: (choosenLanguage != "")
                          ? DropdownButtonFormField(
                              hint: Text(widget.state.toString() == 'null'
                                  ? languages[choosenLanguage]['State']
                                  : widget.state.toString()),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.stacked_bar_chart_outlined,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              items: states.map((statestate) {
                                return DropdownMenuItem(
                                    value: statestate['s_code'].toString(),
                                    child: Text(
                                      statestate['s_name'].toString(),
                                      overflow: TextOverflow.clip,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontFamily: "Windsor",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black),
                                      textAlign: TextAlign.justify,
                                    ));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedState = newValue.toString();
                                  selectedCity =
                                      null; // Reset selected city when state changes
                                  cities
                                      .clear(); // Clear cities list when state changes
                                  city(
                                      selectedState); // Fetch cities for the selected state
                                });
                              },
                              value: selectedState,
                            )
                          : Container(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['City'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.secondaryDarkAppColor
                                .withOpacity(0.5), //color of shadow
                            spreadRadius: -3, //spread radius
                            blurRadius: 5, // blur radius
                            offset: const Offset(8, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      child: (choosenLanguage != "")
                          ? DropdownButtonFormField(
                              hint: Text(widget.city.toString() == 'null'
                                  ? languages[choosenLanguage]['City']
                                  : widget.city.toString()),
                              decoration: InputDecoration(
                                prefixIcon: Image.asset(
                                  'assets/imagesstate3.png',
                                  width: 3,
                                  height: 3,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 2),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              items: cities.map((citycity) {
                                return DropdownMenuItem(
                                    value: citycity['id'].toString(),
                                    child: Text(
                                      citycity['city'].toString(),
                                      overflow: TextOverflow.clip,
                                      // maxLines: ,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontFamily: "Windsor",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black),
                                      textAlign: TextAlign.justify,
                                    ));
                              }).toList(),
                              onChanged: (value) async {
                                setState(() {
                                  selectedCity = value.toString();
                                });
                              },
                              value: selectedCity,
                            )
                          : Container(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['Address'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.secondaryDarkAppColor
                                .withOpacity(0.5), //color of shadow
                            spreadRadius: -3, //spread radius
                            blurRadius: 5, // blur radius
                            offset: const Offset(8, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: (choosenLanguage != "")
                          ? TextFormField(
                              controller: _address,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: 5,left: 5),
                                fillColor: Colors.white,
                                counter: const Offstage(),
                                hintText: languages[choosenLanguage]['Address'],
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/house.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['howmanytractor'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    Container(
                      height: 50,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.secondaryDarkAppColor
                                .withOpacity(0.5), //color of shadow
                            spreadRadius: -3, //spread radius
                            blurRadius: 5, // blur radius
                            offset: const Offset(8, 0),
                          ),
                        ],
                      ),
                      child: (choosenLanguage != "")
                          ? TextFormField(
                              controller: _tractor,
                              textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                counter: const Offstage(),
                                hintText: languages[choosenLanguage]
                                    ['howmanytractor'],
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/tractor.jpg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (choosenLanguage != "")
                        ? Text(
                            languages[choosenLanguage]['howmanyharvester'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstants.secondaryDarkAppColor
                                .withOpacity(0.5), //color of shadow
                            spreadRadius: -3, //spread radius
                            blurRadius: 5, // blur radius
                            offset: const Offset(8, 0),
                          ),
                        ],
                      ),
                      child: (choosenLanguage != "")
                          ? TextFormField(
                              controller: _horvestor,
                              textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                counter: const Offstage(),
                                hintText: languages[choosenLanguage]
                                    ['howmanyharvester'],
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/harvestor.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                uploadImage(_name.text, _phone.text, _address.text,
                    _tractor.text, _horvestor.text);
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 8,
                        color: Colors.green,
                        inset: true,
                      ),
                      BoxShadow(
                        offset: Offset(0, -30),
                        blurRadius: 20,
                        color: Colors.green,
                        inset: true,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFE0E0E0)),
                child: Center(child: setUpButtonChild()),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  double percent = 0.0;
  int data = 0;
  _percentage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    final response = await http.get(
      Uri.parse('${baseUrlPhp}check.php?id=$userId'),
    );
    var datad = jsonDecode(response.body);
    setState(() {
      data = datad;
      percent = datad / 100;
    });
  }

  var mydata;
  File? file;
  final picker = ImagePicker();
  void _choose() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        final bytes = File(pickedFile.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        mydata = img64;
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  bool _loading = false;
  uploadImage(String _name, String _phone, String _address, String _tractor,
      String horvestor) async {
    // print(_name);
    // print(_address);
    // print(_tractor);
    // print(_horvestor);
    // print(selectedState);
    // print(selectedCity);
    // print(mydata);
    // print("object");
    setState(() {
      _loading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    final response = await http.post(
      Uri.parse("${baseUrlPhp}users_update.php"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "id": '$userId',
        "name": _name,
        "mobile": _phone,
        "address": _address,
        "tractor": _tractor,
        "harvester": horvestor,
        "state": selectedState,
        "city": selectedCity,
        "photo": mydata
      }),
    );
    // print('bbbbb');
    final data = jsonDecode(response.body);
    // print(data);
    // print('ssssss');
    if (data["success"] == "200") {
      setState(() {
        _loading = false;
      });
      Navigator.pop(context,true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Profile()));
    } else {
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: data["msg"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0);
    }
  }

  Widget setUpButtonChild() {
    if (_loading == false) {
      return Text(
          (choosenLanguage != '')
              ? languages[choosenLanguage]['Update Profile']
              : "",
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white));
    } else {
      return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    }
  }
}
