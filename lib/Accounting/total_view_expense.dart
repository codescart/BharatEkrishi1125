import 'dart:convert';
import 'package:bharatekrishi/Accounting/update_expence.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatekrishi/Accounting/add_expense.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class total_expense extends StatefulWidget {
  @override
  State<total_expense> createState() => _total_expenseState();
}

class _total_expenseState extends State<total_expense> {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  DateTime selecteeedDate = DateTime.now();
  TextEditingController _date = TextEditingController();
  TextEditingController _dateee = TextEditingController();

  @override
  void initState() {
    _setdata();
    super.initState();
  }

  _setdata() {
    _expenceDetail();
    setState(() {
      _date.text = "${selectedDate.toLocal()}".split(' ')[0];
      _dateee.text = "${selecteeedDate.toLocal()}".split(' ')[0];
    });
  }




  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: (choosenLanguage != "")
            ? Text(
                languages[choosenLanguage]['Total expenses'],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            : Container(),
        automaticallyImplyLeading: false,
        leading: IconButton( onPressed: () {
          Navigator.pop(context,true);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
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
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => add_expense(),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
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
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black)),
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        hintText: languages[choosenLanguage]['date'],
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                ),
                Text('TO'),
                Container(
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
                            print("yyyyyyyyyyy");
                            print(pickeddate);
                            _dateee.text =
                                "${selecteeedDate.toLocal()}".split(' ')[0];
                            // _accountdata();
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
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black)),
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        hintText: languages[choosenLanguage]['date'],
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: height,
              child: FutureBuilder<List<expenceModel>>(
                  future: _expenceDetail(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 5,
                                                top: 5,
                                                right: 5,
                                                bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .person_pin,
                                                          size: 30,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          child: Text(
                                                            '${snapshot.data![index].vehiclename}',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.model_training,
                                                          size: 30,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          child: Text(
                                                            '${snapshot.data![index].vehiclemodel}',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                                        Container(
                                                          width: 100,
                                                          child: Text(
                                                            '${snapshot.data![index].vehicleno}',
                                                            maxLines: 1,
                                                            style: TextStyle(

                                                              fontSize: 12,
                                                            ),
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:100,
                                                      child: Text(
                                                        '${snapshot.data![index].expensetpye}',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text('${snapshot.data![index].date}'),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      height: 25,
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
                                                      child: Text(
                                                        '${snapshot.data![index].amount}',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) => UpdateExpense(snapshot.data![index]),
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
                                                      height: 5,
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
                                              ],
                                            )),
                                      ],
                                    ),
                                  ));
                            })
                        : Center(
                            child: Text(
                              "No Expense Found",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w400),
                            ),
                          );
                  })),
        ],
      ),
    ));
  }

  _deleatedata(String? enId) async {
    print('Nikita');
    final fenId = enId;
    print(fenId);
    final response = await http.get(
      Uri.parse(baseUrlCi+"delete_expence/$fenId"),
    );
    print('bbbbb');
    final data = jsonDecode(response.body);
    print(data);
    print('ssssss');
    if (data["error"] == "200") {
      setState(() {
        _expenceDetail();
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
  Future<List<expenceModel>> _expenceDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? 0;
    print(user_id);
    print(selectedDate);
    print(selecteeedDate);
    print("jokar");
    final response = await http.post(
        Uri.parse(baseUrlCi+"view_expence/$user_id"),
        headers: {"Content-Type": "application/json"},
        body: json
            .encode({"date1": '$selectedDate', "date2": '$selecteeedDate'}));
    var jsond = jsonDecode(response.body);
    List<expenceModel> allround = [];
    for (var a in jsond) {
      expenceModel al = expenceModel(
          a["id"],
          a["expense_type"],
          a["amount"],
          a["date"],
          a["select_vehicle"],
          a["user_id"],
          a["created_at"],
          a["updated_at"],
          a["vehiclename"],
          a["vehicleno"],
          a["vahiclecategory"],
          a["vehiclecompany"],
          a["vehiclemodel"],
          a["expensetpye"]);

      allround.add(al);
    }
    return allround;
  }
}



class expenceModel {
  int? id;
  String? expenseType;
  String? amount;
  String? date;
  String? selectVehicle;
  String? userId;
  String? createdAt;
  String? updatedAt;
  String? vehiclename;
  String? vehicleno;
  String? vahiclecategory;
  String? vehiclecompany;
  String? vehiclemodel;
  String? expensetpye;

  expenceModel(
      this.id,
      this.expenseType,
      this.amount,
      this.date,
      this.selectVehicle,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.vehiclename,
      this.vehicleno,
      this.vahiclecategory,
      this.vehiclecompany,
      this.vehiclemodel,
      this.expensetpye);
}
