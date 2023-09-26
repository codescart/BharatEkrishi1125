import 'dart:convert';
import 'package:bharatekrishi/Settings/User/update_user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bharatekrishi/Settings/User/add_user_screen.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/assign_user_model.dart';

class UserListData extends StatefulWidget {
  const UserListData({Key? key}) : super(key: key);

  @override
  State<UserListData> createState() => _UserListDataState();
}

class _UserListDataState extends State<UserListData> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text(
              (choosenLanguage != "")
                  ? languages[choosenLanguage]['Assigned Users']
                  : "",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>adduser()));
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
            )),
        body: FutureBuilder<List<UserModel>>(
          future: getUserList(),
          builder: (BuildContext context,
              AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasData) {
              // Data loaded successfully
              List<UserModel> data = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 0),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
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
                                  offset: Offset(0, 2),
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 3)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.supervised_user_circle_outlined,
                                        size: 60,
                                        color: Colors.blueGrey,
                                      ),
                                      Text(
                                        '${snapshot.data![index].name}',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.03,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.63,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.call,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.05,
                                            color: Colors.blueGrey,
                                          ),
                                          Text(
                                            '${snapshot.data![index].mobile}',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.04,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.car_rental,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                            color: Colors.blueGrey,
                                          ),
                                          Text(
                                            '${snapshot.data![index].address}',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.04,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // _updateBuilder(context,
                                        //     enId:
                                        //     snapshot.data![index].id.toString());
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) => UpdateUser(
                                            snapshot.data![index],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            border: Border.all(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            // SizedBox(height: 10,),
                            Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _deleatBuilder(context,
                                        enId:
                                        snapshot.data![index].id.toString());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1, color: Colors.green)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                        ),
                                        (choosenLanguage != "")
                                            ? Text(
                                          languages[choosenLanguage]
                                          ['Delete'],
                                          style: TextStyle(fontSize: 15),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1, color: Colors.green)),
                                  child: Row(
                                    children: [
                                      (choosenLanguage != "")
                                          ? Text(
                                        languages[choosenLanguage]
                                        ['Vehicle'],
                                        style: TextStyle(fontSize: 15),
                                      )
                                          : Container(),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      (choosenLanguage != "")
                                          ? ToggleSwitch(
                                        customWidths: [80.0, 80.0],
                                        minHeight: 25,
                                        cornerRadius: 20.0,
                                        activeBgColors: [
                                          [Colors.blue],
                                          [Colors.redAccent]
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        totalSwitches: 2,
                                        labels: [
                                          languages[choosenLanguage]
                                          ['Enable'],
                                          languages[choosenLanguage]
                                          ['Disable']
                                        ],
                                        onToggle: (index) {
                                          print('switched to: $index');
                                        },
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              // Error occurred while loading data
              return Text('Error: ${snapshot.error}');
            } else {
              // Data is still loading
              return Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ));
            }
          },
        )
      ),
    );
  }

  _deleatedata(String? enId) async {
    print('Nikita');
    final fenId = enId;
    print(fenId);
    final response = await http.get(
      Uri.parse(baseUrlCi + "assign_delete/$fenId"),
    );
    print('bbbbb');
    final data = jsonDecode(response.body);
    print(data);
    print('ssssss');
    if (data["success"] == "200") {
      setState(() {
        getUserList();
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'].toString())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'].toString())),
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
}


Future<List<UserModel>> getUserList() async {
  final prefs = await SharedPreferences.getInstance();
  final user_id = prefs.getString('user_id') ?? 0;
  final response = await http
      .get(Uri.parse(baseUrlCi+'Agent/$user_id'));
  if (response.statusCode == 200) {
    print(response);
    print('rama');
    final jsonData = json.decode(response.body) as List<dynamic>;
    return jsonData.map((item) => UserModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
