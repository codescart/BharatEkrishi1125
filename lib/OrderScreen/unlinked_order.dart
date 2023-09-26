import 'dart:convert';

import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:flutter/material.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:bharatekrishi/OrderScreen/link_order.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Dashbord/dashbord_screen.dart';
import '../Model/order_history_model.dart';

class UnlinkedOrder extends StatefulWidget {
  final List<LatLng>? googleMapPolygonPoints;
  final String? acreArea;
  const UnlinkedOrder({
    Key? key,
    this.googleMapPolygonPoints,
    this.acreArea,
  }) : super(key: key);

  @override
  State<UnlinkedOrder> createState() => _UnlinkedOrderState();
}

class _UnlinkedOrderState extends State<UnlinkedOrder> {
  @override
  void initState() {
    super.initState();
    _totalincome();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          height: 100,
          padding: EdgeInsets.only(top: 13, left: 10, right: 5, bottom: 13),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.lightGreenAccent,
                  Colors.green,
                ]),
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavBar(pageIndex: 0,)));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.white,
                    )),
                Text(
                  languages[choosenLanguage]['Unlinked orders'],
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 0, left: 5),
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.lightGreenAccent,
                          Colors.green,
                        ]),
                    border: Border(
                        bottom: BorderSide(width: 8, color: Colors.blueGrey)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/tractoricon.png',
                        height: 75,
                      ),
                      Container(
                          height: 30,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.6),
                            border:
                                Border.all(color: Colors.black54, width: 0.5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                languages[choosenLanguage]['Total Income'],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                data == null ? '' : '- ₹${data['totalamount']}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ))),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(),
                child: FutureBuilder<List<OrderModel>>(
                    future: unlinkorderhistory(),
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
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width *
                                      0.9,
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
                                      borderRadius:
                                      BorderRadius.circular(5),
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
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.black38),
                                                )),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.25,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              Image.asset(
                                                                'assets/tagimg.png',
                                                                width: 25,
                                                              ),
                                                              Container(
                                                                  width: 40,
                                                                  alignment:
                                                                  Alignment
                                                                      .center,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                        begin:
                                                                        Alignment.centerLeft,
                                                                        end: Alignment.centerRight,
                                                                        colors: [
                                                                          Colors.red,
                                                                          Colors.orange,
                                                                        ]),
                                                                    border: Border.all(
                                                                        width:
                                                                        1,
                                                                        color:
                                                                        Colors.black54),
                                                                  ),
                                                                  child:
                                                                  Text(
                                                                    "${snapshot.data![index].id}",
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.black,
                                                                        fontSize: 15),
                                                                  ))
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Center(
                                                              child: Image
                                                                  .asset(
                                                                'assets/harvestor.png',
                                                                height: 55,
                                                              )),
                                                          Text(
                                                            snapshot
                                                                .data![
                                                            index]
                                                                .vehiclename
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                12),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.542,
                                            padding:
                                            EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.black38),
                                                )),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .end,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .person_rounded,
                                                          size: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.04,
                                                          color: Colors
                                                              .blueAccent,
                                                        ),
                                                        Text(
                                                          "   " +
                                                              snapshot
                                                                  .data![
                                                              index]
                                                                  .custname
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width *
                                                                  0.03),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_month,
                                                      size: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.04,
                                                      color: Colors.blue,
                                                    ),
                                                    Text(
                                                      "   " +
                                                          snapshot
                                                              .data![index]
                                                              .date
                                                              .toString(),
                                                      style: TextStyle(
                                                          color:
                                                          Colors.black,
                                                          fontSize: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.03),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 5),
                                                        child: Image.asset(
                                                          'assets/googleicon.png',
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.03,
                                                        )),
                                                    Container(
                                                      height: 30,
                                                      width: 160,
                                                      child: Text(
                                                        "  " +
                                                            snapshot
                                                                .data![
                                                            index]
                                                                .address
                                                                .toString(),
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontSize: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width *
                                                                0.03),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.15,
                                            height: 100,
                                            padding: EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                  // right: BorderSide(width: 0.5, color: Colors.black38),
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.black38),
                                                )),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  alignment:
                                                  Alignment.topRight,
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                      bottomLeft:
                                                      Radius.circular(
                                                          30),
                                                    ),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: [
                                                          Colors
                                                              .lightGreenAccent,
                                                          Colors.green,
                                                        ]),
                                                  ),
                                                  child: Image.asset(
                                                    "assets/forward.png",
                                                    width: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 50,
                                        padding: EdgeInsets.only(
                                            left: 0, right: 10),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 110,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                // border: Border(
                                                //   right: BorderSide(width: 0.5, color: Colors.black)
                                                // )
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  (choosenLanguage != '')
                                                      ? Text(
                                                    languages[
                                                    choosenLanguage]
                                                    [
                                                    'Order status:'],
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black54,
                                                        fontSize: 12),
                                                  )
                                                      : Text(''),
                                                  (choosenLanguage != '')
                                                      ? Text(
                                                    languages[
                                                    choosenLanguage]
                                                    [
                                                    'Progress...'],
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green,
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700),
                                                  )
                                                      : Text(''),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => LinkOrder(
                                                            orderModel:
                                                            snapshot.data![
                                                            index],
                                                            googleMapPolygonPoints:
                                                            widget
                                                                .googleMapPolygonPoints,
                                                            acreArea: widget
                                                                .acreArea)));
                                              },
                                              child: Container(
                                                height: 35,
                                                width: 100,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(5),
                                                    border: Border.all(
                                                        width: 1.5,
                                                        color: Color(
                                                            0xffff6600))),
                                                child:
                                                (choosenLanguage != '')
                                                    ? Text(
                                                  languages[
                                                  choosenLanguage]
                                                  [
                                                  'View Details'],
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xffff6600)),
                                                )
                                                    : Text(''),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          })
                          : Center(
                              child: Text(
                              'No Data Available',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ));
                    }),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  var data;
  _totalincome() async {
    final prefs = await SharedPreferences.getInstance();
    final user_id = prefs.getString('user_id') ?? '0';
    final response = await http.get(
      Uri.parse(baseUrlCi + "order_total/$user_id"),
    );
    var datad = jsonDecode(response.body);
    if (datad['error'] == "200") {
      setState(() {
        data = datad['data'];
      });
    }
  }
}

Future<List<OrderModel>> unlinkorderhistory() async {
  final prefs = await SharedPreferences.getInstance();
  final user_id = prefs.getString('user_id') ?? 0;
  final response = await http
      .get(Uri.parse('${baseUrlPhp}ordersget.php?ownerid=$user_id&status=0'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as List<dynamic>;
    return jsonData.map((item) => OrderModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
