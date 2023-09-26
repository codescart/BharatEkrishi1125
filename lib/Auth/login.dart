import 'dart:convert';
import 'package:bharatekrishi/constant/Utils.dart';
import 'package:bharatekrishi/generated/assets.dart';
import 'package:bharatekrishi/widgets/jelly_button.dart';
import 'package:bharatekrishi/widgets/launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bharatekrishi/Auth/otpscreen.dart';
import 'package:bharatekrishi/Auth/registered.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:http/http.dart' as http;
import '../widgets/text_field.dart';

class Login extends StatefulWidget {
  Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool checked = true;
  bool? valuefirst = false;

  final TextEditingController _login = TextEditingController();

  int showButton=0;
  var fcm;
  @override
  void initState() {
    _getContactnumber();
    FirebaseMessaging.instance.getToken().then((newToken) {
      fcm = newToken;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    "1",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(
                    "2",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 0,
              right: 0,
              top: 10,
            ),
            child: Container(
              child: Center(
                child: Image.asset(Assets.assetsLogin),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              bottom: 10,
            ),
            child: SizedBox(
              child: (choosenLanguage != "")
                  ? Text(
                      languages[choosenLanguage]['Enter Your Mobile Number'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  : Container(),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 0,
              ),
              child: CustomTextField(
                controller: _login,
                boxShadow: [
                  BoxShadow(
                    color:
                        ColorConstants.secondaryDarkAppColor.withOpacity(0.5),
                    spreadRadius: -3,
                    blurRadius: 5,
                    offset: const Offset(8, 8),
                  ),
                ],
                onChanged: (v){
                  setState(() {
                    showButton=v.length;
                  });
                },
                fillColor: Colors.white,
                label: "000-00-000-00",
                maxLength: 10,
                keyboardType: TextInputType.number,
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: widths/100),
                    Image.asset(Assets.assetsFlag,scale: 1.5,),
                    SizedBox(width: widths/100),
                    Text('+91'),
                    SizedBox(width: widths/80),
                  ],
                ),
              )
              ),
          const SizedBox(
            height: 10,
          ),
          (choosenLanguage != "")
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      languages[choosenLanguage]['i_have_read'],
                      style: TextStyle(fontSize: 12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Launcher.launchUrl(context,
                                'https://bharatekrishi.com/policy/privacy.html');
                          },
                          child: Text(
                            languages[choosenLanguage]
                                ['text_termsandconditions'],
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                        Text(
                          languages[choosenLanguage]['kisaan_app'],
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          showButton == 10
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: JellyButton(
                    loading: _loading,
                    onTap: () {
                      if(_login.text.isNotEmpty){
                        login(_login.text);
                      }
                    },
                    title: (choosenLanguage != '')
                        ? languages[choosenLanguage]['text_next']
                        : "",
                  ))
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: JellyButton(
                    loading: _loading,
                    onTap: () {
                      Utils.flushBarErrorMessage(
                          'Please enter valid number .', context);
                    },
                    title: (choosenLanguage != '')
                        ? languages[choosenLanguage]['text_next']
                        : "",
                    color: Colors.grey,
                  )),
          SizedBox(
            height: 30,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          (choosenLanguage != "")
              ? Center(
                  child: Text(
                  languages[choosenLanguage]['Contact Us'],
                  style: TextStyle(color: Colors.black54),
                ))
              : Container(),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Launcher.launchDialPad(context, data['phone']);
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2, color: Color(0xff042a66)),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3, 3),
                              color: Color(0xffa1d567).withOpacity(0.9),
                              spreadRadius: 0,
                              blurRadius: 5)
                        ]),
                    child: Image.asset(
                      Assets.assetsIconphone,
                      width: 35,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Launcher.launchWhatsApp(context, data['whatsapp']);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2, color: Color(0xff042a66)),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3, 3),
                              color: Color(0xffa1d567).withOpacity(0.9),
                              spreadRadius: 0,
                              blurRadius: 5)
                        ]),
                    child: Image.asset(
                      Assets.assetsWhtsicon,
                      width: 30,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Launcher.launchEmail(context, data['email']);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2, color: Color(0xff042a66)),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3, 3),
                              color: Color(0xffa1d567).withOpacity(0.9),
                              spreadRadius: 0,
                              blurRadius: 5)
                        ]),
                    child: Image.asset(
                      Assets.assetsLeter,
                      width: 31,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _loading = false;

  login(
    String _login,
  ) async {
    setState(() {
      _loading = true;
    });
    final response = await http.post(
      Uri.parse(baseUrlPhp + "login.php"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "mobile": _login,
        "fcm_key": fcm.toString(),
      }),
    );
    final data = jsonDecode(response.body);
    // print(data);
    if (data['status'] == "400") {
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (data['status'] == "200") {
        setState(() {
          _loading = false;
        });
        final otp = data['otp'];
        final status = data['status'];
        final user_id = data['data']['id'];
        final vehicleId = data['data']['vehicle_id'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPScreens(
                    phone: _login,
                    otp: otp,
                    status: status,
                    user_id: user_id,
                    vehicleId: vehicleId)));
      } else {
        setState(() {
          _loading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Registration(
                      phone: _login,
                    )));
      }
    }
  }

  var data;
  _getContactnumber() async {
    final response = await http.get(
      Uri.parse(baseUrlCi + 'contoct'),
    );
    var datad = jsonDecode(response.body);
    setState(() {
      data = datad[0];
    });
  }
}
