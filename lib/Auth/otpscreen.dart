import 'dart:convert';

import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/generated/assets.dart';
import 'package:bharatekrishi/widgets/jelly_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bharatekrishi/Dashbord/dashbord_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../languages/function.dart';
import '../languages/translation.dart';

class OTPScreens extends StatefulWidget {
  final String phone;
  final String otp;
  final String status;
  final String? user_id;
  final String? vehicleId;
  OTPScreens(
      {required this.phone,
      required this.otp,
      required this.status,
      this.user_id,
      this.vehicleId});

  @override
  _OTPScreensState createState() => _OTPScreensState();
}

class _OTPScreensState extends State<OTPScreens> {
  bool _isLoadingButton = false;

  Timer? _timer;
  int _resendTimer = 120;
  bool _isResendEnabled = false;
  bool _activebutton = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _isResendEnabled = true;
          _activebutton = false;
          _timer!.cancel();
        }
      });
    });
  }

  TextEditingController textEditingController =
      new TextEditingController(text: "");

  TextEditingController phoneController = TextEditingController();

  _verifyOtpCode(String phone) async {
    if (phone == widget.otp) {
      setState(() {
        _isLoadingButton = false;
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', widget.user_id!);
      prefs.setString('vehicleno', widget.vehicleId.toString());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    } else {
      Fluttertoast.showToast(
          msg: 'Wrong Otp',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 250,
              child: Center(
                child: Image.asset(Assets.assetsOtp),
              ),
            ),
            Column(
              children: [
                Text(
                  (choosenLanguage != '')
                      ? languages[choosenLanguage]['enter_code']
                      : "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (choosenLanguage != '')
                      ? languages[choosenLanguage]['otp_is']
                      : "",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Text(
                  '+91 ' + widget.phone.toString(),
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                    )),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              child: Pinput(
                controller: phoneController,
                length: 4,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _activebutton == true
                ? JellyButton(
                    loading: _isLoadingButton,
                    onTap: () {
                      _verifyOtpCode(phoneController.text);
                    },
                    title: (choosenLanguage != '')
                        ? languages[choosenLanguage]['text_verify']
                        : "")
                : JellyButton(
                    loading: _isLoadingButton,
                    color: Colors.grey,
                    onTap: () {
                      _verifyOtpCode(phoneController.text);
                    },
                    title: (choosenLanguage != '')
                        ? languages[choosenLanguage]['text_verify']
                        : ""),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (choosenLanguage != '')
                      ? languages[choosenLanguage]['otp_not']
                      : "",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                _resend()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resend() {
    if (_isResendEnabled) {
      return TextButton(
        onPressed: () {
          _resendotp();
        },
        child: Text(
          (choosenLanguage != '')
              ? languages[choosenLanguage]['text_resend_code']
              : "",
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w600, fontSize: 20),
        ),
      );
    } else {
      return Text(
        "$_resendTimer seconds",
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.w600, fontSize: 20),
      );
    }
  }

  _resendotp() async {
    setState(() {
      _resendTimer = 120;
    });
    final response = await http.post(
      Uri.parse(baseUrlPhp + "data.php"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "mobile": widget.phone,
      }),
    );
    if (response.statusCode == 200) {
      startTimer();
      setState(() {
        _activebutton = true;
        _isResendEnabled = false;
      });
    } else {
      setState(() {
        _activebutton = false;
        _isResendEnabled = true;
      });
    }
  }
}
