import 'dart:convert';
import 'package:bharatekrishi/Settings/Profile/update_profile.dart';
import 'package:bharatekrishi/Dashbord/dashbord_screen.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/constant/customshape.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _percentage();
    _profile();
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: const [
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  right: 20,
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            toolbarHeight: 200,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            flexibleSpace: Stack(
              children: [
                ClipPath(
                  clipper: CustomShapeprofile(),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/vegetable.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                    height: 40,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(top: 10, left: 15),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavBar(pageIndex: 4)));
                        },
                        icon: const Center(
                            child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: Colors.white,
                        )))),
                Container(
                  margin: const EdgeInsets.only(right: 10, top: 10),
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    backgroundColor: ColorConstants.secondaryDarkAppColor,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => update_profile(
                                  name: data['name'].toString(),
                                  mobile: data['mobile'].toString(),
                                  address: data['address'].toString(),
                                  city: data['Cityname'].toString(),
                                  state: data['state'].toString(),
                                  tractor: data['tractor'].toString(),
                                  harvester: data['harvester'].toString()),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: data == null
                            ? ClipOval(
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset('assets/kisan.png'),
                                ),
                              )
                            : data['photo'] == null
                                ? ClipOval(
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image.asset('assets/kisan.png'),
                                    ),
                                  )
                                : ClipOval(
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                        imageUrlPhp+data['photo'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: _isLoading
                ? const CircularProgressIndicator() // Circular progress indicator
                : ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 15,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 0, color: Colors.grey),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(3, 3),
                                    color: Colors.green.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 0.2)
                              ]),
                          child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2500,
                            percent: percent,
                            center: (choosenLanguage != "")
                                ? Text(datam.toString() +
                                    " % " +
                                    languages[choosenLanguage]
                                        ['of your profile is completed'])
                                : Container(),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 15, top: 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 215, 215, 215),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorConstants
                                              .secondaryDarkAppColor
                                              .withOpacity(
                                                  0.4), //color of shadow
                                          spreadRadius: -1, //spread radius
                                          blurRadius: 5, // blur radius
                                          offset: const Offset(5,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/profile.png',
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            // top: 12,
                                            left: 30,
                                          ),
                                          child: (choosenLanguage != "")
                                              ? Text(
                                                  data == null
                                                      ? languages[
                                                              choosenLanguage]
                                                          ['pleaseupdate']
                                                      : data['name'] == null
                                                          ? languages[
                                                                  choosenLanguage]
                                                              ['pleaseupdate']
                                                          : data['name']
                                                              .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const Text(''),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 215, 215, 215),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorConstants
                                              .secondaryDarkAppColor
                                              .withOpacity(
                                                  0.4), //color of shadow
                                          spreadRadius: -1, //spread radius
                                          blurRadius: 5, // blur radius
                                          offset: const Offset(5, 5),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/imagesphones.jpg',
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            // top: 12,
                                            left: 30,
                                          ),
                                          child: (choosenLanguage != "")
                                              ? Text(
                                                  data == null
                                                      ? languages[
                                                              choosenLanguage]
                                                          ['pleaseupdate']
                                                      : data['mobile'] == null
                                                          ? languages[
                                                                  choosenLanguage]
                                                              ['pleaseupdate']
                                                          : data['mobile']
                                                              .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const Text(''),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                            255,
                                            215,
                                            215,
                                            215,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: ColorConstants
                                                  .secondaryDarkAppColor
                                                  .withOpacity(
                                                      0.4), //color of shadow
                                              spreadRadius: -1, //spread radius
                                              blurRadius: 5, // blur radius
                                              offset: const Offset(5, 5)),
                                        ],
                                        color: Colors.white),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/house.png'),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: (choosenLanguage != "")
                                                ? Text(
                                                    data == null
                                                        ? languages[
                                                                choosenLanguage]
                                                            ['pleaseupdate']
                                                        : data['address'] == null
                                                            ? languages[
                                                                    choosenLanguage]
                                                                ['pleaseupdate']
                                                            : data['address']
                                                                .toString(),
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 19,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                : const Text(''),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 215, 215, 215),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorConstants
                                                .secondaryDarkAppColor
                                                .withOpacity(
                                                    0.4), //color of shadow
                                            spreadRadius: -1, //spread radius
                                            blurRadius: 5, // blur radius
                                            offset: const Offset(5, 5),
                                          ),
                                        ],
                                        color: Colors.white),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/imagesstate3.png',
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            // top: 12,
                                            left: 20,
                                          ),
                                          child: (choosenLanguage != "")
                                              ? Text(
                                                  data == null
                                                      ? languages[
                                                              choosenLanguage]
                                                          ['pleaseupdate']
                                                      : data['state'] == null
                                                          ? languages[
                                                                  choosenLanguage]
                                                              ['pleaseupdate']
                                                          : data['state']
                                                              .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const Text(''),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 215, 215, 215),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorConstants
                                                .secondaryDarkAppColor
                                                .withOpacity(
                                                    0.4), //color of shadow
                                            spreadRadius: -1, //spread radius
                                            blurRadius: 5, // blur radius
                                            offset: const Offset(5, 5),
                                          ),
                                        ],
                                        color: Colors.white),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/imagescity2.png',
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            // top: 12,
                                            left: 40,
                                          ),
                                          child: (choosenLanguage != "")
                                              ? Text(
                                                  data == null
                                                      ? languages[
                                                              choosenLanguage]
                                                          ['pleaseupdate']
                                                      : data['Cityname'] == null
                                                          ? languages[
                                                                  choosenLanguage]
                                                              ['pleaseupdate']
                                                          : data['Cityname']
                                                              .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const Text(''),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 215, 215, 215),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorConstants
                                                .secondaryDarkAppColor
                                                .withOpacity(
                                                    0.4), //color of shadow
                                            spreadRadius: -1, //spread radius
                                            blurRadius: 5, // blur radius
                                            offset: const Offset(5,
                                                5), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/tractor.jpg',
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            // top: 12,
                                            left: 20,
                                          ),
                                          child: (choosenLanguage != "")
                                              ? Text(
                                                  data == null
                                                      ? languages[
                                                              choosenLanguage]
                                                          ['pleaseupdate']
                                                      : data['tractor'] == null
                                                          ? languages[
                                                                  choosenLanguage]
                                                              ['pleaseupdate']
                                                          : data['tractor']
                                                              .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const Text(''),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 215, 215, 215),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorConstants
                                                .secondaryDarkAppColor
                                                .withOpacity(
                                                    0.4), //color of shadow
                                            spreadRadius: -1, //spread radius
                                            blurRadius: 5, // blur radius
                                            offset: const Offset(5,
                                                5), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/harvestor.png',
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            // top: 12,
                                            left: 20,
                                          ),
                                          child: (choosenLanguage != "")
                                              ? Text(
                                                  data == null
                                                      ? languages[
                                                              choosenLanguage]
                                                          ['pleaseupdate']
                                                      : data['harvester'] ==
                                                              null
                                                          ? languages[
                                                                  choosenLanguage]
                                                              ['pleaseupdate']
                                                          : data['harvester']
                                                              .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const Text(''),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => update_profile(
                                              name: data['name'].toString(),
                                              mobile: data['mobile'].toString(),
                                              address:
                                                  data['address'].toString(),
                                              city: data['Cityname'].toString(),
                                              state: data['state'].toString(),
                                              tractor:
                                                  data['tractor'].toString(),
                                              harvester: data['harvester']
                                                  .toString())));
                                },
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(0xFFE0E0E0),
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 5),
                                        blurRadius: 8,
                                        color: Colors.green,
                                        inset: true,
                                      ),
                                      BoxShadow(
                                        offset: Offset(0, -30),
                                        blurRadius: 20,
                                        color: Colors.green,
                                        inset: true,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                  child: (choosenLanguage != "")
                                      ? Text(
                                      languages[choosenLanguage]
                                      ['Edit profile'],
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))
                                      : Container(),
                                  ),
                                ),


                                // Container(
                                //   margin: EdgeInsets.only(left: 60, right: 60),
                                //   height: 50,
                                //   width: 300,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(5),
                                //     color: Colors.white,
                                //     boxShadow: const [
                                //       BoxShadow(
                                //         offset: Offset(0, 5),
                                //         blurRadius: 8,
                                //         color: Colors.green,
                                //         inset: true,
                                //       ),
                                //       BoxShadow(
                                //         offset: Offset(0, -30),
                                //         blurRadius: 20,
                                //         color: Colors.green,
                                //         inset: true,
                                //       ),
                                //     ],
                                //   ),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Center(
                                //         child: (choosenLanguage != "")
                                //             ? Text(
                                //                 languages[choosenLanguage]
                                //                     ['Edit profile'],
                                //                 style: TextStyle(
                                //                     fontSize: 20,
                                //                     color: Colors.white,
                                //                     fontWeight:
                                //                         FontWeight.bold))
                                //             : Container(),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }

  double percent = 0.0;
  int datam = 0;
  _percentage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? 0;
    final response = await http.get(
      Uri.parse('${baseUrlPhp}check.php?id=$userId'),
    );
    var datad = jsonDecode(response.body);
    setState(() {
      datam = datad;
      percent = datad / 100;
    });
  }

  var data;
  _profile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '0';
    final response = await http.get(
      Uri.parse("${baseUrlPhp}profileget.php?user_id=$userId"),
    );
    var datad = jsonDecode(response.body);
    if (datad['error'] == "200") {
      setState(() {
        data = datad['data'];
      });
    }
  }
}
