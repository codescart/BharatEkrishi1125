import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:bharatekrishi/OrderScreen/unlinked_order.dart';
import 'package:bharatekrishi/constant/Utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../Model/order_history_model.dart';
import '../constant/constatnt.dart';
import '../languages/function.dart';
import '../languages/translation.dart';
import 'package:http/http.dart' as http;
import '../widgets/jelly_button.dart';
import '../widgets/sub_title_text.dart';
import 'EditArea/edit_area.dart';
import 'linked_order.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetailsScreen({Key? key, required this.orderModel})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(33.857646, 79.269046),
    zoom: 13.5,
  );
  List<Polygon> _polygons = [];

  List<LatLng> parseCoordinates(String coordinatesString) {
    final List<String> parts =
        coordinatesString.replaceAll(RegExp(r'[^0-9.,\s]+'), '').split(',');

    final List<LatLng> coordinates = [];
    for (int i = 0; i < parts.length; i += 2) {
      final double lat = double.parse(parts[i]);
      final double lng = double.parse(parts[i + 1]);
      if (lat != null && lng != null) {
        coordinates.add(LatLng(lat, lng));
      }
    }
    return coordinates;
  }

  @override
  void initState() {
    super.initState();
    final String coordinatesString = widget.orderModel.orderLatLong;
    final List<LatLng> polygonCoordinates = parseCoordinates(coordinatesString);
    if (polygonCoordinates != null) {
      _polygons.add(
        Polygon(
          polygonId: PolygonId('orderPolygon'),
          points: polygonCoordinates,
          fillColor: Colors.lightGreen.withOpacity(0.6),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );
      _changeCameraPosition(polygonCoordinates.first);
    }
  }

  _changeCameraPosition(LatLng first) async {
    final letlng = first;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: letlng, zoom: 20)));
  }

  final _totalamount = TextEditingController();
  final _totalreceiveamout = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            size: 20,
          ),
        ),
        title: Text(
          languages[choosenLanguage]['Order Details'],
          style: TextStyle(fontSize: 22),
        ),
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
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: height / 2,
            minHeight: height * 0.2,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: GoogleMap(
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              mapType: MapType.hybrid,
              polygons: Set.from(_polygons),
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
              padding: const EdgeInsets.all(16),
            ),
            panelBuilder: (sc) => _panel(sc, height, width),
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
          ),
          Positioned(
              right: height / 60,
              top: height / 60,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditArea(orderModel: widget.orderModel)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  width: height / 20,
                  height: height / 20,
                  child: Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                ),
              )),
          Positioned(
              right: height / 60,
              top: height / 13,
              child: InkWell(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(languages[choosenLanguage]['delte_message_text'],),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: SubTitleText(
                          title: languages[choosenLanguage]['cancel'],
                          textColor: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteOrder();
                        },
                        child: SubTitleText(
                          title: languages[choosenLanguage]['text_ok'],
                          textColor: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  width: height / 20,
                  height: height / 20,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc, double height, double width) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: [
            SizedBox(height: height / 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(height: height / 60),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.white.withOpacity(0.8),
                        size: 20,
                      ),
                      Text(
                        '${widget.orderModel.date}',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withOpacity(0.8),
                        size: 20,
                      ),
                      Text(
                          "${widget.orderModel.quantity} ${widget.orderModel.rateType}",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later,
                        color: Colors.white.withOpacity(0.8),
                        size: 20,
                      ),
                      Text('Hours',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: height / 60),
            Container(
              height: height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.only(right: 5),
                    height: 90,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black38),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3, 3),
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 0,
                              blurRadius: 2.5)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              child: Image.asset(
                                "assets/harvest.png",
                              ),
                            ),
                            Text(
                              widget.orderModel.vehicleNo.toString(),
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('Recent work completed'),
                            // Text('Harvestor'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/googleicon.png",
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                    height: 30,
                                    width: 150,
                                    child: Text(
                                      widget.orderModel.address.toString(),
                                      style: TextStyle(
                                          color:
                                              Colors.black54.withOpacity(0.8),
                                          fontSize: 13),
                                      maxLines: 2,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '₹ ${widget.orderModel.rate}/acre',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(
                          top: 0, left: 10, right: 10, bottom: 10),
                      height: height / 1.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2.5,
                            blurRadius: 3,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      languages[choosenLanguage]['Order id -'],
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      widget.orderModel.orderid.toString(),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Container(
                                  // margin: EdgeInsets.only(top: 10,right: 10),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.lightGreenAccent,
                                          Colors.green,
                                        ]),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        _updatepopupOrder(context,
                                            orderId: widget.orderModel.orderid
                                                .toString());
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 15,
                                      )),
                                ),
                              ]),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(
                                    width: 1, color: Colors.black54)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.blueGrey
                                                .withOpacity(0.15)),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.orderModel.custname}",
                                            style: TextStyle(
                                                color:
                                                    ColorConstants.detailsText,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "${widget.orderModel.custmobile}",
                                            style: TextStyle(
                                              color:
                                                  ColorConstants.detailsText,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      languages[choosenLanguage]['Land owner'],
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(
                                    width: 1, color: Colors.black54)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  // color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.blueGrey
                                                .withOpacity(0.15)),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.support_agent_rounded,
                                            size: 30, color: Colors.pink),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 110,
                                            child: Text(
                                              "${widget.orderModel.agentname}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: ColorConstants
                                                      .detailsText,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            widget.orderModel.agentmobile
                                                .toString(),
                                            style: TextStyle(
                                              color:
                                                  ColorConstants.detailsText,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      languages[choosenLanguage]['Agent'],
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text("edit", style: TextStyle(color: Colors.red, fontSize: 12, decoration: TextDecoration.underline),),
                                    //     Icon(Icons.edit,size:18, color: Colors.red,),
                                    //   ],
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.black54)),
                                child: Center(
                                    child: Text(widget.orderModel.implement
                                        .toString())),
                              ),
                              Container(
                                height: height / 16,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.black54)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      languages[choosenLanguage]
                                          ['Amount remain'],
                                      style: TextStyle(
                                          color: ColorConstants.detailForm,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "₹${widget.orderModel.remaining}",
                                      style: TextStyle(
                                          color: ColorConstants.detailsText,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    languages[choosenLanguage]
                                        ['text_total_amount'],
                                    style: TextStyle(
                                        color: ColorConstants.detailForm,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1, color: Colors.black54)),
                                    child: Text(
                                      widget.orderModel.advance == null
                                          ? languages[choosenLanguage]
                                              ['text_total_amount']
                                          : "₹ ${widget.orderModel.totalamount}",
                                      style: TextStyle(
                                          color: ColorConstants.detailsText,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    languages[choosenLanguage]['Due Date:'],
                                    style: TextStyle(
                                        color: ColorConstants.detailForm,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1, color: Colors.black54)),
                                    child: Center(
                                      child: Text(
                                        widget.orderModel.time_reminder
                                            .toString(),
                                        style: TextStyle(
                                            color: ColorConstants.detailsText,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          Container(
                            height: height / 16,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(
                                    width: 1, color: Colors.black54)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  languages[choosenLanguage]
                                      ['Amount received:'],
                                  style: TextStyle(
                                      color: ColorConstants.detailForm,
                                      fontSize: 18),
                                ),
                                Text(
                                  "₹${widget.orderModel.advance}",
                                  style: TextStyle(
                                      color: ColorConstants.detailsText,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height / 60),
                          JellyButton(
                            height: height/20,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            title: languages[choosenLanguage]['cancel'],
                            color: Colors.red,
                            iconData: Icons.cancel_outlined,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  _updateorder(
    String orderId,
    String _totalamount,
    String _totalreceiveamout,
  ) async {
    final response = await http.post(
      Uri.parse("${baseUrlPhp}orders_update.php"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "id": '$orderId',
        "totalamount": _totalamount,
        "advance": _totalreceiveamout,
        "remaining": '',
        "address": '',
        "date": '',
        "lat": '',
        "quantity": '',
        "rate": '',
        "longs": '',
        "rate_type": '',
      }),
    );
    final data = jsonDecode(response.body);
    if (data["success"] == '200') {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OrderScreen()));
    } else {}
  }

  Future<void> _updatepopupOrder(BuildContext context,
      {required String orderId}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (choosenLanguage != '')
                  ? Text(
                      languages[choosenLanguage]['text_order_update'],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    )
                  : Text(''),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (choosenLanguage != "")
                      ? Text(
                          languages[choosenLanguage]['text_total_amount'],
                          style: TextStyle(fontSize: 16),
                        )
                      : Text(''),
                  TextFormField(
                    controller: _totalamount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Total Amount',
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
                  (choosenLanguage != "")
                      ? Text(
                          languages[choosenLanguage]['text_amount_received'],
                          style: TextStyle(fontSize: 16),
                        )
                      : Text(''),
                  TextFormField(
                    controller: _totalreceiveamout,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Received Amount',
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
                  Center(
                    child: JellyButton(
                      onTap: () {
                        _updateorder(orderId, _totalamount.text,
                            _totalreceiveamout.text);
                      },
                      title: choosenLanguage != ""?languages[choosenLanguage]['update_text']:'',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  deleteOrder() async {
    final response = await http.post(
      Uri.parse('https://kkisan.sethstore.com/public/api/deleteselectarea'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'order_id': widget.orderModel.orderid}),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == '200') {
      var msg=data['message'];
      Utils.flushBarErrorMessage(msg, context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UnlinkedOrder()));
    } else {
      var msg=data['message'];
      Utils.flushBarErrorMessage(msg, context);
    }
  }
}
