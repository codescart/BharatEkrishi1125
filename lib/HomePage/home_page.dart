import 'dart:async';
import 'dart:convert';
import 'package:bharatekrishi/HomePage/Widget/banner.dart';
import 'package:bharatekrishi/Settings/Profile/profile_View.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/filter_screen.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/HomePage/notification_screen.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Widget/vehical_data.dart';

class HomePage extends StatefulWidget {
  // HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _percentage();
    showbottomsheet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
              onPressed: () {}, icon: Image.asset('assets/srch.png')),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => notification_screen()));
              },
              child: Image.asset(
                'assets/notify.png',
                width: width*0.05,
                height: height*0.05,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => filter_screen()));
              },
              child: Image.asset(
                'assets/filter.png',
                width: width*0.03,
                height: height*0.03,
              ),
            ),
            SizedBox(
              width: width * 0.01,
            )
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    Colors.lightGreenAccent,
                    Colors.green,
                  ]),
            ),
          ),
        ),
        body: ListView(
          children: const [VehicalDataWiget(), BannerWidget()],
        ));
  }

  int datam = 0;
  _percentage() async {
    final prefs = await SharedPreferences.getInstance();
    final user_id = prefs.getString('user_id') ?? 0;
    final response = await http.get(
      Uri.parse(baseUrlPhp + 'check.php?id=$user_id'),
    );
    var datad = jsonDecode(response.body);
    setState(() {
      datam = datad;
    });
  }

  Future<void> showbottomsheet() async {
    await Future.delayed(Duration(seconds: 5));
    final prefs = await SharedPreferences.getInstance();
    final fshow = prefs.getBool('opendialog') ?? false;
    if (datam < 100 && fshow == false) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.height;
          return Container(
            height:  height* 0.25,
            width: width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (choosenLanguage != '')
                    ? Text(languages[choosenLanguage]['delay_text'],
                        style: GoogleFonts.lato(
                          fontStyle: FontStyle.normal,
                          color: Colors.black87,
                          fontSize: 16,
                        ))
                    : Text(''),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('opendialog', true);
                          Navigator.of(context).pop();
                        },
                        child: (choosenLanguage != '')
                            ? Text(languages[choosenLanguage]['skip&continue'],
                                style: GoogleFonts.lato(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                  fontSize: 16,
                                ))
                            : Text('')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
                        },
                        child: (choosenLanguage != '')
                            ? Text(
                                languages[choosenLanguage]['text_editprofile'],
                                style: GoogleFonts.lato(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                  fontSize: 16,
                                ))
                            : Text('')),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
