import 'package:bharatekrishi/Settings/Profile/profile_View.dart';
import 'package:bharatekrishi/SplashScreen/splash_screen.dart';
import 'package:bharatekrishi/widgets/launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatekrishi/languages/changelanguage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/Settings/ManageVehical/vehicle_list_screen.dart';
import 'package:bharatekrishi/Settings/PhonePermission/phone_permission_screen.dart';
import 'package:bharatekrishi/Settings/User/user_list_screen.dart';
import 'package:bharatekrishi/Settings/AreaCalculation/area_calculation.dart';
import 'package:bharatekrishi/languages/translation.dart';

class setting_screen extends StatefulWidget {
  const setting_screen({Key? key}) : super(key: key);

  @override
  State<setting_screen> createState() => _setting_screenState();
}

class _setting_screenState extends State<setting_screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: (choosenLanguage != "")
            ? Text(
                languages[choosenLanguage]['Settings'],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            : Container(),
        automaticallyImplyLeading: false,
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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //   width: 0.5, color: Colors.black,
                      // ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (choosenLanguage != "")
                              ? Text(languages[choosenLanguage]['Profile'],
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AreaCalculation()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //   width: 0.5, color: Colors.black,
                      // ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (choosenLanguage != "")
                              ? Text(
                                  languages[choosenLanguage]
                                      ['Area Calculation'],
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => manageVehicle_setting()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //   width: 0.5, color: Colors.black,
                      // ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.car_repair,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (choosenLanguage != "")
                              ? Text(
                                  languages[choosenLanguage]['Manage Vehicle'],
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserListData()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //   width: 0.5, color: Colors.black,
                      // ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.supervised_user_circle_sharp,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (choosenLanguage != "")
                              ? Text(languages[choosenLanguage]['User'],
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangeLanguage()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 50,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (choosenLanguage != "")
                              ? Text(
                                  languages[choosenLanguage]['ChangeLanguage'],
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => phone_permission()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 50,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.perm_device_info,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (choosenLanguage != "")
                              ? Text(
                                  languages[choosenLanguage]
                                      ['Phone permission'],
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Launcher.launchUrl(
                    context, 'https://bharatekrishi.com/policy/privacy.html');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 50,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          (choosenLanguage != "")
                              ? Text(languages[choosenLanguage]['text_privacy'],
                                  style: GoogleFonts.lato(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadowColor: Colors.black,
                          title: Text('Are you sure?'),
                          content: Text('Do you want to Logout'),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('user_id');
                                // Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SplashScreen()));
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  icon: Icon(
                    // <-- Icon
                    Icons.logout,
                    size: 24.0,
                  ),
                  label: (choosenLanguage != "")
                      ? Text(languages[choosenLanguage]['logout'])
                      : Container(), // <-- Text
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
