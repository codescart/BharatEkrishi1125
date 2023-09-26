import 'dart:convert';
import 'package:bharatekrishi/Model/order_history_model.dart';
import 'package:bharatekrishi/widgets/jelly_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../linked_order.dart';

class SaveAreaScreen extends StatefulWidget {
  final List<LatLng>? googleMapPolygonPoints;
  final String? acreArea;
  final OrderModel? ordeModel;

  SaveAreaScreen({
    this.googleMapPolygonPoints,
    this.acreArea,
    this.ordeModel,
  });

  @override
  State<SaveAreaScreen> createState() => _SaveAreaScreenState();
}

class _SaveAreaScreenState extends State<SaveAreaScreen> {
  Completer<GoogleMapController> _poygonController = Completer();
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(33.857646, 79.269046),
    zoom: 13.5,
  );
  List<Polygon> _polygons = [];

  @override
  void initState() {
    ratetype();
    _rate.text = widget.ordeModel!.rate.toString();
    _datecontrol.text = widget.ordeModel!.date.toString();
    _advance.text = widget.ordeModel!.advance.toString();
    super.initState();
    if (widget.googleMapPolygonPoints != null) {
      _polygons.add(
        Polygon(
            polygonId: const PolygonId('orderPolygon'),
            points: widget.googleMapPolygonPoints!,
            fillColor: Colors.lightGreen.withOpacity(0.6),
            strokeColor: Colors.red,
            strokeWidth: 2),
      );
      _changeCameraPosition(widget.googleMapPolygonPoints!.first);
    }
    //
    print("hiii"+_areaquantaty.toString());
    if(_rate.text.isNotEmpty  ){
      // calculatePrice();
    }
  }



  final _areaquantaty = TextEditingController();
  final _rate = TextEditingController();
  final _datecontrol = TextEditingController();
  final _totalamount = TextEditingController();
  final _advance = TextEditingController(text: '0');
  final _remainingamount = TextEditingController();

  String? ratetypes;
  List rate_data = [];
  double sqft = 0;
  Future<String> ratetype() async {
    final prefs = await SharedPreferences.getInstance();
    final user_id = prefs.getString('user_id') ?? 0;
    final res =
        await http.get(Uri.parse(baseUrlCi + 'area_calculation/$user_id'));
    final resBody = json.decode(res.body);
    setState(() {
      rate_data = resBody['data'];
      int i = int.parse(resBody['ind'].toString());
      ratetypes = rate_data[i]['area_name'].toString();
      if (widget.acreArea.toString() != "null") {
        sqft = double.parse(widget.acreArea.toString()) * 43560;
        final data = rate_data[i]['area_calculation'].toString();
        _areaquantaty.text = (sqft / double.parse(data)).toStringAsFixed(2);
        // _areaquantaty.text=sqft.toString();
        if(_areaquantaty.text.isNotEmpty){
          calculatePrice();
        }
      }
    });
    return "Sucess";
  }
  void calculatePrice(){
    print("hii");
    setState(() {
      double tot = double.parse(_areaquantaty.text) *
          double.parse(_rate.text);
      _totalamount.text = tot.toString();
      double adv= double.parse(_advance.text);
      final remaining = tot-adv;
      _remainingamount.text = remaining.toString();

    });
  }

  _changeCameraPosition(LatLng first) async {
    final letlng = first;
    final GoogleMapController controller = await _poygonController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: letlng, zoom: 20)));
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(languages[choosenLanguage]['Add order']),
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
        ),
      ),
      body: Column(
        children: [
          widget.googleMapPolygonPoints != null
              ? Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  height: heights / 4, width: widths,
                  child: GoogleMap(
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: _initialCameraPosition,
                    mapType: MapType.hybrid,
                    polygons: Set.from(_polygons),
                    onMapCreated: (GoogleMapController controller) {
                      if (!_poygonController.isCompleted) {
                        _poygonController.complete(controller);
                      }
                    },
                    padding: const EdgeInsets.all(16),
                  ),
                  // child: ,
                )
              : Container(),
          widget.googleMapPolygonPoints != null
              ? Container(
                  height: heights / 1.625,
                  child: OrderDetails(context, heights, widths))
              : Container(
                  height: heights / 1.14,
                  child: OrderDetails(context, heights, widths))
        ],
      ),
    ));
  }

  Widget OrderDetails(BuildContext, heights, widths) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: heights / 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.lightGreenAccent,
                        Colors.green,
                      ]),
                ),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  languages[choosenLanguage]['Add new order'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: heights / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black54)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Row(
                          children: [
                            const Icon(
                              Icons.area_chart,
                              color: Colors.blue,
                              size: 25,
                            ),
                            Text(
                              'AreaType',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                        items: rate_data.map((item) {
                          return DropdownMenuItem(
                              child: Text(
                                item['area_name'].toString(),
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                style: const TextStyle(
                                  fontFamily: "Windsor",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              value: item['area_name'].toString());
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            ratetypes = value as String;
                          });
                          // areameasure(ratetypes);
                        },
                        value: ratetypes,
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      readOnly: true,
                      controller: _areaquantaty,
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.white,
                        hintText: languages[choosenLanguage]['text_quantity'],
                        prefixIcon: const Icon(
                          Icons.compare_arrows,
                          color: Colors.blue,
                          size: 30,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heights / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _rate,
                      onChanged: (value) {
                        setState(() {
                          if (_rate.text.isEmpty) {
                            _totalamount.text = '';
                          } else {
                            double tot = double.parse(_areaquantaty.text) *
                                double.parse(value);
                            _totalamount.text = tot.toString();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.white,
                        hintText: 'Rate',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      readOnly: true,
                      controller: _datecontrol,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                        prefixIcon: const Icon(Icons.calendar_month_outlined),
                        hintText: languages[choosenLanguage]['date'],
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heights / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _totalamount,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.white,
                        hintText: 'Total Amount',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(),
                    child: TextFormField(
                      onChanged: (value) {
                        double adto = 0.0;
                        setState(() {
                          if (_advance.text == '') {
                            adto = double.parse(_totalamount.text) - 0;
                          } else {
                            adto = double.parse(_totalamount.text) -
                                double.parse(value);
                          }
                          _remainingamount.text = adto.toString();
                        });
                      },
                      controller: _advance,
                      textAlignVertical: TextAlignVertical.bottom,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        counter: const Offstage(),
                        hintText: languages[choosenLanguage]
                            ['Advance Received'],
                        prefixIcon: const Icon(
                          Icons.area_chart,
                          color: Colors.blue,
                          size: 30,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heights / 60,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.4,
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(),
                child: TextFormField(
                  controller: _remainingamount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    fillColor: Colors.white,
                    hintText: 'Remaining Amount',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(width: 3, color: Colors.black54),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              JellyButton(
                height: heights / 17,
                onTap: () {
                  Navigator.pop(context);
                },
                title: languages[choosenLanguage]['cancel'],
                color: Colors.red,
              ),
              JellyButton(
                height: heights / 17,
                onTap: () {
                  updateOrder(
                      _areaquantaty.text,
                      _advance.text,
                      _datecontrol.text,
                      _rate.text,
                      _remainingamount.text,
                      _totalamount.text);
                },
                title: languages[choosenLanguage]['Confirm Order'],
                loading: _liadingbutton,
              ),
            ],
          ),
        )
      ],
    );
  }

  bool _liadingbutton = false;

  updateOrder(String _area, String _advance, String date, String rate,
      String remamount, String totalamount) async {
    setState(() {
      _liadingbutton = true;
    });
    final response = await http.post(
      Uri.parse('https://kkisan.sethstore.com/public/api/updateoder'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'quantity': _area,
        'advance': _advance,
        'date': '$date',
        'rate': '$rate',
        'remaining': '$remamount',
        'totalamount': '$totalamount',
        'rate_type': ratetypes.toString(),
        'lat_long': widget.googleMapPolygonPoints.toString(),
        'areainacre': widget.acreArea.toString(),
        'owner_id': widget.ordeModel!.ownerId,
        'order_id': widget.ordeModel!.orderid
      }),
    );
    final data = jsonDecode(response.body);
    print(data);
    print('data');
    if (data['success'] == '200') {
      setState(() {
        _liadingbutton = false;
      });
      Navigator.pop(context, true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OrderScreen()));
    } else {
      setState(() {
        _liadingbutton = false;
      });
    }
  }
}
