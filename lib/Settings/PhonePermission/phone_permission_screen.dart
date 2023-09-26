import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:permission_handler/permission_handler.dart';

class phone_permission extends StatefulWidget {
  const phone_permission({Key? key}) : super(key: key);

  @override
  State<phone_permission> createState() => _phone_permissionState();
}

class _phone_permissionState extends State<phone_permission> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios_new),),
        title: (choosenLanguage !="") ? Text(languages[choosenLanguage]['Phone permission'], style: TextStyle( fontSize: 20,
            fontWeight: FontWeight.bold),):Container(),
        // centerTitle: true,
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.green,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightGreenAccent, Colors.green,]),
          ),
          padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '',
                  style: GoogleFonts.lato(fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                ],
              )
            ],
          ),
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(8 ,8, 8, 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [ Color(0xffeafce8),Color(0xffffffff),Color(0xffeafce8)]),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,2),
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 3
                  )
                ]
            ),
            child: Column(
              children: [
                (choosenLanguage !="") ? Text(languages[choosenLanguage]['Enable/Disable Permissions'], style: TextStyle(fontSize: 20,color: Colors.grey, fontWeight: FontWeight.w700),):Container(),
                Divider(thickness: 1, color: Colors.black26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications, size: 30, color: Colors.blue,),
                        SizedBox(width: 10,),
                        (choosenLanguage !="") ? Text(
                            languages[choosenLanguage]['Notifications'],
                            style: GoogleFonts.lato(fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)):Container(),
                      ],
                    ),
                    // Icon(Icons.arrow_forward_ios, size: 18,color: Colors.grey,)
                    ToggleSwitch(
                      customWidths: [40.0, 40.0],
                      cornerRadius: 15,
                      activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      icons: [Icons.notifications, Icons.notifications_off],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
                Divider(thickness: 1, color: Colors.black26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storage, size: 30, color: Colors.blue,),
                        SizedBox(width: 10,),
                        (choosenLanguage !="") ? Text(
                            languages[choosenLanguage]['Storage'],
                            style: GoogleFonts.lato(fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)):Container(),
                      ],
                    ),
                    // Icon(Icons.arrow_forward_ios, size: 18,color: Colors.grey,)
                    ToggleSwitch(
                      customWidths: [40.0, 40.0],
                      cornerRadius: 15,
                      activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      icons: [Icons.storage, Icons.close],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
                Divider(thickness: 1, color: Colors.black26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.call, size: 30, color: Colors.blue,),
                        SizedBox(width: 10,),
                        (choosenLanguage !="") ?  Text(
                            languages[choosenLanguage]['Calling'],
                            style: GoogleFonts.lato(fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)):Container(),
                      ],
                    ),
                    // Icon(Icons.arrow_forward_ios, size: 18,color: Colors.grey,)
                    ToggleSwitch(
                      customWidths: [40.0, 40.0],
                      cornerRadius: 15,
                      activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      icons: [Icons.call, Icons.close],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
                Divider(thickness: 1, color: Colors.black26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.contact_phone, size: 30, color: Colors.blue,),
                        SizedBox(width: 10,),
                        (choosenLanguage !="") ?  Text(
                            languages[choosenLanguage]['PhoneBook'],
                            style: GoogleFonts.lato(fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)):Container(),
                      ],
                    ),
                    // Icon(Icons.arrow_forward_ios, size: 18,color: Colors.grey,)
                    ToggleSwitch(
                      customWidths: [40.0, 40.0],
                      cornerRadius: 15,
                      activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      icons: [Icons.contact_phone, Icons.close],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
                Divider(thickness: 1, color: Colors.black26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_alt, size: 30, color: Colors.blue,),
                        SizedBox(width: 10,),
                        (choosenLanguage !="") ? Text(
                            languages[choosenLanguage]['Camera'],
                            style: GoogleFonts.lato(fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)):Container(),
                      ],
                    ),
                    // Icon(Icons.arrow_forward_ios, size: 18,color: Colors.grey,)
                    ToggleSwitch(
                      customWidths: [40.0, 40.0],
                      cornerRadius: 15,
                      activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      icons: [Icons.camera_alt, Icons.close],
                      onToggle: (index) {
                        requestCameraPermission();
                        print('switched to: $index');
                      },

                    ),
                  ],
                ),
                Divider(thickness: 1, color: Colors.black26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.whats, size: 30, color: Colors.blue,),
                        SizedBox(width: 10,),
                        (choosenLanguage !="") ?  Text(
                            languages[choosenLanguage]['Whatsapp'],
                            style: GoogleFonts.lato(fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)):Container(),
                      ],
                    ),
                    // Icon(Icons.arrow_forward_ios, size: 18,color: Colors.grey,)
                    ToggleSwitch(
                      customWidths: [40.0, 40.0],
                      cornerRadius: 15,
                      activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      icons: [Icons.close, Icons.close],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
                Divider(thickness: 1, color: Colors.black26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sms, size: 30, color: Colors.blue,),
                        SizedBox(width: 10,),
                        (choosenLanguage !="") ? Text(
                            languages[choosenLanguage]['Text Message'],
                            style: GoogleFonts.lato(fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)):Container(),
                      ],
                    ),
                    // Icon(Icons.arrow_forward_ios, size: 18,color: Colors.grey,)
                    ToggleSwitch(
                      customWidths: [40.0, 40.0],
                      cornerRadius: 15,
                      activeBgColors: [[Color(0xff00ff00),Color(0xff009900)], [Color(0xffff9966),Color(0xffff0000)]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      icons: [Icons.sms, Icons.close],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}


void requestCameraPermission() async {
  /// status can either be: granted, denied, restricted or permanentlyDenied
  var status = await Permission.camera.status;
  if (status.isGranted) {
    print("Permission is granted");
  }
  else if (status.isDenied) {
    print("Permission was granted");
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    // if (await Permission.camera.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    //   print("Permission was granted");
    // }
  }
}