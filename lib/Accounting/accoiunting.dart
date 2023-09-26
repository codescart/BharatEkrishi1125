import 'dart:convert';

import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatekrishi/filter_screen.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:bharatekrishi/Accounting/total_view_expense.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class accounting extends StatefulWidget {
  const accounting({Key? key}) : super(key: key);

  @override
  State<accounting> createState() => _accountingState();
}

class _accountingState extends State<accounting> {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  DateTime selecteeedDate = DateTime.now();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _dateee = TextEditingController();

  @override
  void initState() {
    _accountdata();
    _setdata();
    super.initState();
  }

  _setdata() {
    setState(() {
      _date.text = "${selectedDate.toLocal()}".split(' ')[0];
      _dateee.text = "${selecteeedDate.toLocal()}".split(' ')[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (choosenLanguage != "")
                  ? Text(languages[choosenLanguage]['Accounting'],
                      style: GoogleFonts.lato(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold))
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const filter_screen()));
                    },
                    child: Image.asset(
                      'assets/filter.png',
                      width: 30,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () async {
                          await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101))
                              .then((pickeddate) {
                            if (pickeddate != null) {
                              setState(() {
                                selectedDate = pickeddate;
                                _date.text =
                                    "${selectedDate.toLocal()}".split(' ')[0];
                              });
                            }
                            return null;
                          });
                        },
                        controller: _date,
                        style: const TextStyle(fontSize: 10),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.black)),
                            prefixIcon: const Icon(Icons.calendar_month_outlined),
                            hintText: languages[choosenLanguage]['date'],
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                    ),
                    const Text('TO'),
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () async {
                          await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime(2101))
                              .then((pickeddate) {
                            if (pickeddate != null) {
                              setState(() {
                                selecteeedDate = pickeddate;
                                _dateee.text = "${selecteeedDate.toLocal()}"
                                    .split(' ')[0];
                                _accountdata();
                              });
                            }
                            return null;
                          });
                          // add();
                        },
                        controller: _dateee,
                        style: const TextStyle(fontSize: 10),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.black)),
                            prefixIcon: const Icon(Icons.calendar_month_outlined),
                            hintText: languages[choosenLanguage]['date'],
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 1.5,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xffeafce8),
                            Color(0xffffffff),
                            Color(0xffeafce8)
                          ]),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 2,
                            spreadRadius: 0,
                            color: Colors.black.withOpacity(0.3))
                      ]),
                  child: (choosenLanguage != "")
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              languages[choosenLanguage]['Total Orders'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              data == null
                                  ? ""
                                  : data['totolorder'] == null
                                      ? ""
                                      : ' - ${data['totolorder']}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      : Container(),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xffeafce8),
                            Color(0xffffffff),
                            Color(0xffeafce8)
                          ]),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 2,
                            spreadRadius: 0,
                            color: Colors.black.withOpacity(0.3))
                      ]),
                  child: (choosenLanguage != "")
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              languages[choosenLanguage]['Total Recived'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              data == null
                                  ? ""
                                  : data['totalrecieved'] == null
                                      ? ""
                                      : ' - ${data['totalrecieved']}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      : Container(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.44,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xffeafce8),
                                Color(0xffffffff),
                                Color(0xffeafce8)
                              ]),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 2,
                                spreadRadius: 0,
                                color: Colors.black.withOpacity(0.3))
                          ]),
                      child: (choosenLanguage != "")
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image(
                                        image: AssetImage(
                                          'assets/image/totslpending.png',
                                        ))),
                                Text(
                                  languages[choosenLanguage]['Total Pending'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  data == null
                                      ? ""
                                      : data['totalpending'] == null
                                          ? ""
                                          : '${data['totalpending']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.44,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xffeafce8),
                                Color(0xffffffff),
                                Color(0xffeafce8)
                              ]),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 2,
                                spreadRadius: 0,
                                color: Colors.black.withOpacity(0.3))
                          ]),
                      child: (choosenLanguage != "")
                          ? Column(
                              children: [
                                InkWell(
                                  onTap:(){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => total_expense()));
                                  },
                                  child: const SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image(
                                          image: AssetImage(
                                        'assets/image/totalexpences.png',
                                      ))),
                                ),
                                Text(
                                  languages[choosenLanguage]['Total Expences'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => total_expense()));
                    //   },
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     height: 100,
                    //     width: MediaQuery.of(context).size.width * 0.44,
                    //     decoration: BoxDecoration(
                    //         border: Border.all(width: 0.5, color: Colors.black),
                    //         borderRadius: BorderRadius.circular(15),
                    //         gradient: LinearGradient(
                    //             begin: Alignment.centerLeft,
                    //             end: Alignment.centerRight,
                    //             colors: [
                    //               Color(0xffeafce8),
                    //               Color(0xffffffff),
                    //               Color(0xffeafce8)
                    //             ]),
                    //         boxShadow: [
                    //           BoxShadow(
                    //               offset: Offset(0, 4),
                    //               blurRadius: 2,
                    //               spreadRadius: 0,
                    //               color: Colors.black.withOpacity(0.3))
                    //         ]),
                    //     child: (choosenLanguage != "")
                    //         ? Column(
                    //             children: [
                    //               SizedBox(
                    //                   height: 50,
                    //                   width: 50,
                    //                   child: Image(
                    //                       image: AssetImage(
                    //                     'assets/image/totalexpences.png',
                    //                   ))),
                    //               Text(
                    //                 languages[choosenLanguage]
                    //                     ['Total Expences'],
                    //                 style: TextStyle(fontSize: 16),
                    //               ),
                    //             ],
                    //           )
                    //         : Container(),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          )),
    ));
  }

  var data;
  _accountdata() async {
    final prefs = await SharedPreferences.getInstance();
    final user_id = prefs.getString('user_id') ?? 0;
    final response = await http.post(
        Uri.parse("${baseUrlCi}order_totaldata/$user_id"),
        headers: {"Content-Type": "application/json"},
        body: json
            .encode({"date1": '$selectedDate', "date2": '$selecteeedDate'}));
    var datad = jsonDecode(response.body);
    if (datad['error'] == "200") {
      setState(() {
        data = datad['data'];
      });
    }
  }
}
