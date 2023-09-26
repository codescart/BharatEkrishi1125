import 'dart:convert';
import 'package:bharatekrishi/Settings/User/user_list_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class adduser extends StatefulWidget {
  const   adduser({Key? key}) : super(key: key);

  @override
  State<adduser> createState() => _adduserState();
}

class _adduserState extends State<adduser> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();

  String? selectedState;
  List states = [];

  String? selectedCity;
  List cities = [];

  Future<String> state() async {
    final res = await http
        .get(Uri.parse(baseUrlCi+'state'));
    final resBody = json.decode(res.body);
    print("hhhhhhhhhhhhh");
    print(resBody);
    setState(() {
      states = resBody;
    });

    return "Sucess";
  }

  //@ city api
  Future<String> _city(String? selectedState) async {
    final res = await http.get(Uri.parse(
        baseUrlCi+'city/$selectedState'));
    final resBody = json.decode(res.body);
    print("hhhhhhhhhhhhh");
    print(resBody);
    setState(() {
      cities = resBody;
    });
    return "Sucess";
  }

  @override
  void initState() {
    state();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            (choosenLanguage != "")
                ? languages[choosenLanguage]['Add User']
                : "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            (choosenLanguage != "")
                ? Text(
              languages[choosenLanguage]['User Name'],
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
                : Container(),
            const SizedBox(
              height: 5,
            ),
            (choosenLanguage != "")
                ? Container(
              height: 50,
              child: TextFormField(
                controller: _username,
                textAlignVertical: TextAlignVertical.bottom,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counter: Offstage(),
                  //contentPadding: EdgeInsets.all(20),
                  // labelText: 'Mobile Number',
                  hintText: languages[choosenLanguage]['Name'],
                  prefixIcon: Icon(
                    Icons.call,
                    color: Colors.blue,
                    size: 20,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                    const BorderSide(width: 1, color: Colors.black),
                  ),
                ),
              ),
            )
                : Container(),
            SizedBox(
              height: 5,
            ),
            (choosenLanguage != "")
                ? Text(
              languages[choosenLanguage]['Mobile Number'],
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
                : Container(),
            SizedBox(
              height: 5,
            ),
            (choosenLanguage != "")
                ? Container(
              height: 50,
              child: TextFormField(
                controller: _phone,
                textAlignVertical: TextAlignVertical.bottom,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counter: Offstage(),
                  //contentPadding: EdgeInsets.all(20),
                  // labelText: 'Mobile Number',
                  hintText: languages[choosenLanguage]['Phone'],
                  prefixIcon: Icon(
                    Icons.car_rental_outlined,
                    color: Colors.blue,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                    BorderSide(width: 1, color: Colors.black),
                  ),
                ),
              ),
            )
                : Container(),
            SizedBox(
              height: 10,
            ),
            (choosenLanguage != "")
                ? Text(
              languages[choosenLanguage]['State'],
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
                : Container(),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white),
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: (choosenLanguage != "")
                      ? Text(
                    languages[choosenLanguage]['State'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).hintColor,
                    ),
                  )
                      : Container(),
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
                      print(selectedState);
                      print('selectedState');
                      selectedCity =
                      null; // Reset selected city when state changes
                      cities.clear(); // Clear cities list when state changes
                      _city(
                          selectedState); // Fetch cities for the selected state
                    });
                  },
                  value: selectedState,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            (choosenLanguage != "")
                ? Text(
              languages[choosenLanguage]['City'],
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
                : Container(),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white),
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: (choosenLanguage != "")
                      ? Text(
                    languages[choosenLanguage]['City'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).hintColor,
                    ),
                  )
                      : Container(),
                  items: cities.map((item) {
                    return DropdownMenuItem(
                        child: Text(
                          item['city'].toString(),
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
                      selectedCity = value.toString();
                    });
                  },
                  value: selectedCity,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            (choosenLanguage != "")
                ? Text(
              languages[choosenLanguage]['Address'],
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
                : Container(),
            SizedBox(
              height: 5,
            ),
            (choosenLanguage != "")
                ? Container(
              height: 50,
              child: TextFormField(
                controller: _address,
                textAlignVertical: TextAlignVertical.bottom,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counter: Offstage(),
                  //contentPadding: EdgeInsets.all(20),
                  // labelText: 'Mobile Number',
                  hintText: languages[choosenLanguage]['Address'],
                  prefixIcon: Icon(
                    Icons.car_rental_outlined,
                    color: Colors.blue,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                    BorderSide(width: 1, color: Colors.black),
                  ),
                ),
              ),
            )
                : Container(),


            InkWell(
              onTap: () {
                adddUser(
                    _username.text, _phone.text, _address.text);
              },
              child: Container(
                height: 45,
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFFE0E0E0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(1, 1),
                    ),
                    BoxShadow(
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
                    child: Text(
                        (choosenLanguage != '')
                            ? languages[choosenLanguage]['save']
                            : "",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                ),
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  adddUser(String _username, String _phone, String _address) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? 0;
    print(user_id);
    print('yyyyyyyyyyyyyyy');
    final response = await http.post(
      Uri.parse(baseUrlCi+"assignuser"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          {
            "dealer_id":"$user_id",
            "name":_username,
            "mobile":_phone,
            "state":"$selectedState",
            "city":"$selectedCity",
            "address":_address
          }
      ),
    );
    final data = jsonDecode(response.body);
    print(data);
    print('meranam');
    if (data['success'] == '200') {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserListData()));
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
