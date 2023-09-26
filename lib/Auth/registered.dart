import 'dart:convert';
import 'dart:io';
import 'package:bharatekrishi/generated/assets.dart';
import 'package:bharatekrishi/widgets/jelly_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bharatekrishi/Auth/otpscreen.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:http/http.dart' as http;
import 'package:bharatekrishi/languages/translation.dart';

class Registration extends StatefulWidget {
  final String? phone;
  Registration({
    this.phone,
  });

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String? selectedState;
  List states = [];

  String? selectedCity;
  List cities = [];

  final _formKey = GlobalKey<FormState>();

  Future<String> state() async {
    final res = await http.get(Uri.parse(baseUrlCi + 'state'));
    final resBody = json.decode(res.body);
    setState(() {
      states = resBody;
    });
    return "Sucess";
  }

  Future<String> city(String? statecode) async {
    final res = await http.get(Uri.parse(baseUrlCi + 'city/$statecode'));
    final resBody = json.decode(res.body);
    setState(() {
      cities = resBody;
    });
    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    state();
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _tractor = TextEditingController();
  final TextEditingController _horvestor = TextEditingController();
  String _currentAddress = '';
  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                ),
                Stack(
                  children: [
                    file == null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(Assets.assetsKisan))
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
                        SizedBox(
                          height: 15,
                        ),
                        (choosenLanguage != "")
                            ? Text(
                                languages[choosenLanguage]['Name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                offset:
                                    Offset(8, 0), // changes position of shadow
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
                                    counter: Offstage(),
                                    hintText: languages[choosenLanguage]
                                        ['Name'],
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        Assets.assetsProfile,
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
                                style: TextStyle(
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
                                offset:
                                    Offset(8, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: (choosenLanguage != "")
                              ? TextFormField(
                                  readOnly: true,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    counter: Offstage(),
                                    hintText: widget.phone,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        Assets.assetsImagesphones,
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
                        SizedBox(
                          height: 15,
                        ),
                        (choosenLanguage != "")
                            ? Text(
                                languages[choosenLanguage]['State'],
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                offset:
                                    Offset(8, 8), // changes position of shadow
                              ),
                            ],
                          ),
                          child: (choosenLanguage != "")
                              ? DropdownButtonFormField(
                                  hint:
                                      Text(languages[choosenLanguage]['State']),
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.stacked_bar_chart_outlined,
                                      color: Colors.red,
                                      size: 40,
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
                                        child: Text(
                                          statestate['s_name'].toString(),
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontFamily: "Windsor",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black),
                                          textAlign: TextAlign.justify,
                                        ),
                                        value: statestate['s_code'].toString());
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                offset:
                                    Offset(8, 8), // changes position of shadow
                              ),
                            ],
                          ),
                          child: (choosenLanguage != "")
                              ? DropdownButtonFormField(
                                  hint:
                                      Text(languages[choosenLanguage]['City']),
                                  decoration: InputDecoration(
                                    prefixIcon: Image.asset(
                                      Assets.assetsImagesstate3,
                                      width: 10,
                                      height: 10,
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
                                  items: cities.map((citycity) {
                                    return DropdownMenuItem(
                                        child: Text(
                                          citycity['city'].toString(),
                                          overflow: TextOverflow.clip,
                                          // maxLines: ,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontFamily: "Windsor",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black),
                                          textAlign: TextAlign.justify,
                                        ),
                                        value: citycity['id'].toString());
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                offset:
                                    Offset(8, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: (choosenLanguage != "")
                              ? TextFormField(
                                  controller: _address,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    counter: Offstage(),
                                    hintText: languages[choosenLanguage]
                                        ['Address'],
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        Assets.assetsHouse,
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                offset: Offset(8, 0),
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
                                    counter: Offstage(),
                                    hintText: languages[choosenLanguage]
                                        ['howmanytractor'],
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        Assets.assetsBartractor,
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                offset: Offset(8, 0),
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
                                    counter: Offstage(),
                                    hintText: languages[choosenLanguage]
                                        ['howmanyharvester'],
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        Assets.assetsHarvestor,
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
                JellyButton(
                  width: widths / 1.1,
                  loading: _loading,
                  onTap: () {
                    _register(_name.text, _address.text, _tractor.text,
                        _horvestor.text);
                  },
                  title: (choosenLanguage != '')
                      ? languages[choosenLanguage]['Register']
                      : "",
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
            Positioned(
                top: 50.0,
                right: 0.0,
                child: JellyButton(
                  onTap: () {
                    _skipandContinue();
                  },
                  title: (choosenLanguage != '')
                      ? languages[choosenLanguage]['skip&continue']
                      : "",
                )),
          ],
        ),
      ),
    );
    ;
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
        print('No image selected.');
      }
    });
  }

  bool _loading = false;
  _register(
    String _name,
    String _address,
    String _tractor,
    String _horvestor,
  ) async {
    setState(() {
      _loading = true;
    });
    final response = await http.post(
      Uri.parse(baseUrlPhp + "reg.php"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": _name,
        "mobile": widget.phone,
        "address": _address,
        "tractor": _tractor,
        "harvester": _horvestor,
        "state": selectedState,
        "city": selectedCity,
        "photo": mydata,
        "lat": flat,
        "long": flat
      }),
    );
    final data = jsonDecode(response.body);
    if (data["success"] == "200") {
      setState(() {
        _loading = false;
      });
      final otp = data['OTP'];
      final status = data['success'];
      final user_id = data['data']['id'];
      final mobile = data['data']['mobile'];
      final vehicleId = data['data']['vehicle_id'];
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreens(
                  phone: mobile,
                  otp: otp,
                  status: status,
                  user_id: user_id,
                  vehicleId: vehicleId)));
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

  _skipandContinue() async {
    final response = await http.post(
      Uri.parse(baseUrlPhp + "reg.php"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "mobile": widget.phone,
        "address": _currentAddress,
        "lat": flat,
        "long": flong
      }),
    );
    final data = jsonDecode(response.body);
    if (data["success"] == "200") {
      final otp = data['OTP'];
      final status = data['success'];
      final userId = data['data']['id'];
      final mobile = data['data']['mobile'];
      final vehicleId = data['data']['vehicle_id'];
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreens(
                  phone: mobile,
                  otp: otp,
                  status: status,
                  user_id: userId,
                  vehicleId: vehicleId)));
    } else {}
  }

  var flat;
  var flong;
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = 'Location services are disabled.';
      });
      return;
    }

    // Request permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = 'Location permissions are permanently denied.';
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _currentAddress =
              'Location permissions are denied (actual value: $permission).';
        });
        return;
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert coordinates to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String? address =
          '${placemark.street}, ${placemark.postalCode}, ${placemark.subLocality},${placemark.locality},${placemark.administrativeArea} ,${placemark.country}'; // Extract the desired address component here

      setState(() {
        flat = position.latitude;
        flong = position.longitude;
        _currentAddress = address;
      });
    } else {
      setState(() {
        _currentAddress = 'No address found.';
      });
    }
  }
}
