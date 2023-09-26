import 'dart:convert';
import 'package:bharatekrishi/Settings/ManageVehical/add_vehicle_screen.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatekrishi/Settings/ManageVehical/update_vehicle.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:bharatekrishi/Settings/ManageVehical/vehicle_detail_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class manageVehicle_setting extends StatefulWidget {
  const manageVehicle_setting({Key? key}) : super(key: key);

  @override
  State<manageVehicle_setting> createState() => _manageVehicle_settingState();
}

class _manageVehicle_settingState extends State<manageVehicle_setting> {
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
                      languages[choosenLanguage]['Manage Vehicle'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : Container(),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => add_vehicle()));
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ))
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
              ),
            ),
            body: FutureBuilder<List<vehicle>>(
                future: vehicle_list(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          VehicalDetails(
                                              snapshot.data![index]),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xffeafce8),
                                              Color(0xffffffff),
                                              Color(0xffeafce8)
                                            ]),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 2.5,
                                            blurRadius: 3,
                                          )
                                        ],
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 5,
                                                top: 5,
                                                right: 5,
                                                bottom: 5),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          .vehicle_no
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    CircleAvatar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        radius: 20,
                                                        child: Image.asset(
                                                          "assets/harvest.png",
                                                          width: 40,
                                                        )),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .agriculture_rounded,
                                                          size: 30,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          snapshot.data![index]
                                                                      .initial_engine ==
                                                                  null
                                                              ? "Assign Time"
                                                              : '${snapshot.data![index].initial_engine} h',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        // Icon(Icons.call, size: 25,color: Colors.blue,),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.person_rounded,
                                                          size: 30,
                                                          color: Colors.blue,
                                                        ),
                                                        Text(
                                                          snapshot.data![index]
                                                                      .Managername ==
                                                                  null
                                                              ? "user Name"
                                                              : snapshot
                                                                  .data![index]
                                                                  .Managername
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        // Icon(Icons.call, size: 25,color: Colors.blue,),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        var url =
                                                            "${snapshot.data![index].Managermobile}";
                                                        if (await canLaunch(
                                                            url)) {
                                                          await launch(url);
                                                        } else {
                                                          throw 'Could not launch $url';
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        width: 70,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.call,
                                                              size: 18,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            Text(
                                                              " Call",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UpdateVehical(
                                                                snapshot.data![
                                                                    index],
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Icon(
                                                              Icons.edit,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            _deleatBuilder(
                                                                context,
                                                                enId: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .red),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Icon(
                                                              Icons
                                                                  .delete_forever_rounded,
                                                              size: 20,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                    ),
                                                    Text(
                                                      'View >',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ));
                          })
                      : Center(
                          child: Text(
                            "No Vehical Added",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w400),
                          ),
                        );
                })));
  }

  _deleatedata(String? enId) async {
    print('Nikita');
    final fenId = enId;
    print(fenId);
    final response = await http.get(
      Uri.parse(baseUrlCi + "vehicle_delete/$fenId"),
    );
    print('bbbbb');
    final data = jsonDecode(response.body);
    print(data);
    print('ssssss');
    if (data["error"] == "200") {
      setState(() {
        vehicle_list();
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['msg'].toString())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['msg'].toString())),
      );
    }
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

  Future<List<vehicle>> vehicle_list() async {
    final prefs = await SharedPreferences.getInstance();
    final user_id = prefs.getString('user_id') ?? 0;
    final response = await http.get(
      Uri.parse("${baseUrlCi}vehiclesget/$user_id"),
    );
    var jsond = json.decode(response.body)['data'];
    List<vehicle> allround = [];
    for (var a in jsond) {
      vehicle al = vehicle(
        a['id'],
        a['vehicle_cat_id'],
        a['vehicle_company_id'],
        a['vehicle_model_id'],
        a['status'],
        a['created_at'],
        a['updated_at'],
        a['overspeeding'],
        a['overheathing'],
        a['initial_engine'],
        a['users_id'],
        a['vehicle_no'],
        a['assignuser'],
        a['vehicle_name'],
        a['devices_id'],
        a['dealer_id'],
        a['catname'],
        a['modelname'],
        a['companyname'],
        a['Managername'],
        a['Managermobile'],
        a['passcode'],
      );
      allround.add(al);
    }
    return allround;
  }
}

class vehicle {
  int id;
  String? vehicle_cat_id;
  String? vehicle_company_id;
  String? vehicle_model_id;
  String? status;
  String? created_at;
  String? updated_at;
  String? overspeeding;
  String? overheathing;
  String? initial_engine;
  String? users_id;
  String? vehicle_no;
  String? assignuser;
  String? vehicle_name;
  String? devices_id;
  String? dealer_id;
  String? catname;
  String? modelname;
  String? companyname;
  String? Managername;
  String? Managermobile;
  String? passcode;

  vehicle(
    this.id,
    this.vehicle_cat_id,
    this.vehicle_company_id,
    this.vehicle_model_id,
    this.status,
    this.created_at,
    this.updated_at,
    this.overspeeding,
    this.overheathing,
    this.initial_engine,
    this.users_id,
    this.vehicle_no,
    this.assignuser,
    this.vehicle_name,
    this.devices_id,
    this.dealer_id,
    this.catname,
    this.modelname,
    this.companyname,
    this.Managername,
    this.Managermobile,
    this.passcode,
  );
}
