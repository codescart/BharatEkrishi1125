import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../constant/constatnt.dart';

class AreaCalculation extends StatefulWidget {
  const AreaCalculation({Key? key}) : super(key: key);

  @override
  State<AreaCalculation> createState() => _AreaCalculationState();
}

class _AreaCalculationState extends State<AreaCalculation> {
  final aname = TextEditingController();
  final aft = TextEditingController();
  final _updatename = TextEditingController();
  final _updatarea = TextEditingController();
  // int selectedIndex = 0;

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
                  languages[choosenLanguage]['Area Calculation'],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )
              : Container(),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
                onTap: () => _addareaBuilder(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                )),
          ],
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
            padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 16),
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
                  children: [],
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text('Select your preferred unit for area measurement'),
              SizedBox(height: 20),
              Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: FutureBuilder<List<order>>(
                      future: _viewaddedarea(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error occurred while fetching data.'),
                          );
                        } else if (!snapshot.hasData) {
                          return Center(
                            child: Text('No data found.'),
                          );
                        } else {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 70,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.9,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 3.0,
                                              color: snapshot.data![index]
                                                  .preferred ==
                                                  'Y'
                                                  ? Colors.green
                                                  : Colors.white),
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xffeafce8),
                                                Color(0xffffffff),
                                                Color(0xffeafce8)
                                              ]),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 4),
                                                blurRadius: 2,
                                                spreadRadius: 0,
                                                color: Colors.black
                                                    .withOpacity(0.3))
                                          ]),
                                      child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('1  ' +
                                                '${snapshot.data![index].area_name}' +
                                                ' = '),
                                            Text(
                                                '${snapshot.data![index].area_calculation}' +
                                                    '  sqft'),
                                            snapshot.data![index].user_id !=
                                                9999999
                                                ? Row(children: [
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _updatename
                                                          .text =
                                                          snapshot
                                                              .data![
                                                          index]
                                                              .area_name
                                                              .toString();
                                                      _updatarea.text = snapshot
                                                          .data![
                                                      index]
                                                          .area_calculation
                                                          .toString();
                                                    });
                                                    _editareaBuilder(
                                                        context,
                                                        enId: snapshot
                                                            .data![
                                                        index]
                                                            .id
                                                            .toString());
                                                  },
                                                  icon: Icon(
                                                      Icons.edit)),
                                              IconButton(
                                                  onPressed: () {
                                                    _deleatBuilder(
                                                        context,
                                                        enId: snapshot
                                                            .data![
                                                        index]
                                                            .id
                                                            .toString());
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ))
                                            ])
                                                : Container(),
                                            snapshot.data![index]
                                                .preferred ==
                                                'Y'
                                                ? Text(
                                              'Default',
                                              style: TextStyle(
                                                  color:
                                                  Colors.grey),
                                            )
                                                : TextButton(
                                                onPressed: () {
                                                  _sesadefaultcon(
                                                      context,
                                                      enId: snapshot
                                                          .data![index]
                                                          .id
                                                          .toString(),
                                                      setasd: snapshot
                                                          .data![index]
                                                          .user_id
                                                          .toString());
                                                },
                                                child: Text(
                                                  'Default',
                                                  style: TextStyle(
                                                      color:
                                                      Colors.green),
                                                ))
                                          ])),
                                );
                                //   Column(children: [
                                //   SizedBox(
                                //     height: 20,
                                //   ),
                                //   GestureDetector(
                                //       onTap: () {
                                //         setState(() {
                                //           selectedIndex = index;
                                //         });
                                //       },
                                //       child: Container(
                                //           alignment: Alignment.center,
                                //           height: 70,
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width *
                                //               0.9,
                                //           decoration: BoxDecoration(
                                //               border: Border.all(
                                //                   width: 3.0,
                                //                   color: snapshot.data![index]
                                //                       .preferred ==
                                //                       'Y'
                                //                       ? Colors.green
                                //                       : Colors.white),
                                //               borderRadius:
                                //                   BorderRadius.circular(15),
                                //               gradient: LinearGradient(
                                //                   begin: Alignment.centerLeft,
                                //                   end: Alignment.centerRight,
                                //                   colors: [
                                //                     Color(0xffeafce8),
                                //                     Color(0xffffffff),
                                //                     Color(0xffeafce8)
                                //                   ]),
                                //               boxShadow: [
                                //                 BoxShadow(
                                //                     offset: Offset(0, 4),
                                //                     blurRadius: 2,
                                //                     spreadRadius: 0,
                                //                     color: Colors.black
                                //                         .withOpacity(0.3))
                                //               ]),
                                //           child: Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.spaceAround,
                                //               children: [
                                //                 Text('1  ' +
                                //                     '${snapshot.data![index].area_name}' +
                                //                     ' = '),
                                //                 Text(
                                //                     '${snapshot.data![index].area_calculation}' +
                                //                         '  sqft'),
                                //                 snapshot.data![index].user_id !=
                                //                         9999999
                                //                     ? Row(children: [
                                //                         IconButton(
                                //                             onPressed: () {
                                //                               setState(() {
                                //                                 _updatename
                                //                                         .text =
                                //                                     snapshot
                                //                                         .data![
                                //                                             index]
                                //                                         .area_name
                                //                                         .toString();
                                //                                 _updatarea.text = snapshot
                                //                                     .data![
                                //                                         index]
                                //                                     .area_calculation
                                //                                     .toString();
                                //                               });
                                //                               _editareaBuilder(
                                //                                   context,
                                //                                   enId: snapshot
                                //                                       .data![
                                //                                           index]
                                //                                       .id
                                //                                       .toString());
                                //                             },
                                //                             icon: Icon(
                                //                                 Icons.edit)),
                                //                         IconButton(
                                //                             onPressed: () {
                                //                               _deleatBuilder(
                                //                                   context,
                                //                                   enId: snapshot
                                //                                       .data![
                                //                                           index]
                                //                                       .id
                                //                                       .toString());
                                //                             },
                                //                             icon: Icon(
                                //                               Icons.delete,
                                //                               color: Colors.red,
                                //                             ))
                                //                       ])
                                //                     : Container(),
                                //                 snapshot.data![index]
                                //                             .preferred ==
                                //                         'Y'
                                //                     ? Text(
                                //                         'Default',
                                //                         style: TextStyle(
                                //                             color:
                                //                                 Colors.grey),
                                //                       )
                                //                     : TextButton(
                                //                         onPressed: () {
                                //                           _sesadefaultcon(
                                //                               context,
                                //                               enId: snapshot
                                //                                   .data![index]
                                //                                   .id
                                //                                   .toString(),
                                //                               setasd: snapshot
                                //                                   .data![index]
                                //                                   .user_id
                                //                                   .toString());
                                //                         },
                                //                         child: Text(
                                //                           'Default',
                                //                           style: TextStyle(
                                //                               color:
                                //                                   Colors.green),
                                //                         ))
                                //               ]))
                                //   )
                                // ]);
                              });
                          // : Center(child: Text('Wait For your Areas'));
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }

  // https://kkisan.sethstore.com/public/api/area_update_calculation
  // https://kkisan.sethstore.com/public/api/area_calculation_deletee/1

  _setdefauld({String? enId, required String setasd}) async {
    print('Nikita');
    final fenId = enId;
    print(fenId);
    final response = await http.post(
      Uri.parse(baseUrlCi+"update_n"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": '$enId', "userid": '$setasd'}),
    );
    print('bbbbb');
    final data = jsonDecode(response.body);
    print(data);
    print('ssssss');
    if (data["success"] == "200") {
      setState(() {
        _viewaddedarea();
      });
      Navigator.pop(context);
    } else {}
  }

  Future<void> _sesadefaultcon(BuildContext context,
      {String? enId, required String setasd}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are You Sure ?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                        Colors.red.shade200,
                        Colors.red.shade300,
                        Colors.red.shade400,
                        Colors.red.shade500,
                      ],
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'No',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
              ),
              InkWell(
                onTap: () {
                  _setdefauld(enId: enId, setasd: setasd);
                },
                child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                      'Yes',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))),
              ),
            ],
          ),
        );
      },
    );
  }

  _updatearea(String _updatename, String _updatarea, String enId) async {
    print('ggggggggggggg');
    final response = await http.post(
      Uri.parse(
          baseUrlCi+"area_update_calculation"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "id": '$enId',
        "area_name": _updatename,
        "area_calculation": _updatarea,
      }),
    );
    print('bbbbb');
    final data = jsonDecode(response.body);
    print(data);
    print('ssssss');
    if (data["success"] == '200') {
      Navigator.pop(context);
    } else {}
  }

  Future<void> _editareaBuilder(BuildContext context, {String? enId}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Area'),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextFormField(
                  controller: _updatename,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Area Name',
                    counter: Offstage(),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 15),
                  ),
                ),
                Text(
                  'Area in the particular calculation',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _updatarea,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '   sqf',
                    hintStyle: TextStyle(color: Colors.black12),
                    counter: Offstage(),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 15),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _updatearea(_updatename.text, _updatarea.text, enId!);
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                      'Update',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _deleatedata(String? enId) async {
    print('Nikita');
    final fenId = enId;
    print(fenId);
    final response = await http.get(
      Uri.parse(
          baseUrlCi+"area_calculation_deletee/$fenId"),
    );
    print('bbbbb');
    final data = jsonDecode(response.body);
    print(data);
    print('ssssss');
    if (data["success"] == "200") {
      setState(() {
        _viewaddedarea();
      });
      Navigator.pop(context);
    } else {}
  }

  Future<void> _deleatBuilder(BuildContext context, {String? enId}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are You Sure ?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                        Colors.red.shade200,
                        Colors.red.shade300,
                        Colors.red.shade400,
                        Colors.red.shade500,
                      ],
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'No',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
              ),
              InkWell(
                onTap: () {
                  _deleatedata(enId);
                },
                child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                      'Yes',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))),
              ),
            ],
          ),
        );
      },
    );
  }

  addprefferdarea(String aname, String aft) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? 0;
    print(user_id);
    final response = await http.post(
      Uri.parse(baseUrlCi+'area_calculation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'area_name': aname,
        'area_calculation': aft,
        'user_id': "$user_id"
      }),
    );
    var jsond = json.decode(response.body);
    print(jsond);
    print('====');
    if (jsond['success'] == '200') {
      Fluttertoast.showToast(
          msg: "Area Added Sucesfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      _viewaddedarea();
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "Data Not Added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _addareaBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Area'),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextFormField(
                  controller: aname,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Area Name',
                    counter: Offstage(),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 15),
                  ),
                ),
                Text(
                  'Area in the particular calculation',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        controller: aname,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        decoration: InputDecoration(
                          prefix: Text('1 '),
                          suffix: Text('='),
                          hintText: 'Area',
                          // hintStyle: TextStyle(color: Colors.black12),
                          counter: Offstage(),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 15),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        controller: aft,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '   sqf',
                          hintStyle: TextStyle(color: Colors.black12),
                          counter: Offstage(),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    addprefferdarea(aname.text, aft.text);
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                      'Submit',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<order>> _viewaddedarea() async {
    print('Radhe');
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? 0;
    print(user_id);
    final response = await http.get(Uri.parse(
        baseUrlCi+"area_calculation/$user_id"));
    var jsond = json.decode(response.body)['data'];
    print(jsond);

    List<order> allround = [];
    for (var a in jsond) {
      order al = order(a["id"], a["area_calculation"], a["area_name"],
          a['user_id'], a['preferred']);
      allround.add(al);
    }
    return allround;
  }
}

class order {
  int? id;
  String? area_calculation;
  String? area_name;
  int? user_id;
  String? preferred;
  order(this.id, this.area_calculation, this.area_name, this.user_id,
      this.preferred);
}
