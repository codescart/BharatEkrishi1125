
import 'dart:convert';
import 'package:bharatekrishi/Settings/User/user_list_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';

import '../../Model/assign_user_model.dart';

class UpdateUser extends StatefulWidget {
  final UserModel userdata;
  UpdateUser(this.userdata);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
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
    setState(() {
      cities = resBody;
    });
    return "Sucess";
  }

  @override
  void initState() {
    state();
    _setdata();
    _city(widget.userdata.state.toString());
    super.initState();
  }



  _setdata() {
    setState(() {
      _username.text = widget.userdata.name.toString() == 'null'
          ? ''
          : widget.userdata.name.toString();
      _phone.text = widget.userdata.mobile.toString() == 'null'
          ? ''
          : widget.userdata.mobile.toString();
      _address.text = widget.userdata.address.toString() == 'null'
          ? ''
          : widget.userdata.address.toString();
    });
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
                ? languages[choosenLanguage]['update_user']
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
                    widget.userdata.sname == 'null'
                        ? "Add"
                        : '${widget.userdata.sname}',
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
                        widget.userdata.city == 'null'
                        ? "Add"
                        : '${widget.userdata.city}',
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
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: "Windsor",
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
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
                updateUser(
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

  updateUser(String _username, String _phone, String _address) async {
    final response = await http.post(
      Uri.parse(baseUrlCi+"update_assignuser"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          {
            "userid":widget.userdata.id,
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
