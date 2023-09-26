import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bharatekrishi/Auth/login.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Languages extends StatefulWidget {
  Languages({Key? key,}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  void initState() {
    choosenLanguage = 'hi';
    languageDirection = 'ltr';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
        color: Colors.white,
        child: Directionality(
          textDirection:
          (languageDirection == 'rtl')
              ?TextDirection.rtl
              :TextDirection.ltr,
          child: Container(
            padding: EdgeInsets.fromLTRB(media.width * 0.05, media.width * 0.05,
                media.width * 0.05, media.width * 0.05),
            height: media.height * 1,
            width: media.width * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: media.width * 0.11 + MediaQuery.of(context).padding.top,
                  width: media.width * 1,
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),

                  child: Stack(
                    children: [
                      Container(
                        height:60,
                        width: media.width * 1,
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          (choosenLanguage.isEmpty)
                              ? 'Select Language'
                              : languages[choosenLanguage]['text_choose_language'],
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize:20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                Expanded(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: languages
                              .map((i, value) => MapEntry(
                              i,
                              InkWell(
                                onTap: () async{
                                  setState(() {
                                    choosenLanguage = i;
                                    if (choosenLanguage == 'ar' ||
                                        choosenLanguage == 'ur' ||
                                        choosenLanguage == 'iw') {
                                      languageDirection = 'rtl';
                                    } else {
                                      languageDirection = 'ltr';
                                    }
                                  });
                                },
                                child:  InkWell(
                                  child: Container(
                                    width:MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(media.width * 0.025),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 10,
                                          child: Container(
                                            width:MediaQuery.of(context).size.width*0.8,
                                            height:80,
                                            padding: EdgeInsets.only(top: 15, left: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 8,
                                                  color: choosenLanguage==i?Colors.green:Colors.white,
                                                )
                                            ),
                                            child: Center(
                                              child: Text(
                                                languagesCode
                                                    .firstWhere(
                                                        (e) => e['code'] == i)['name']
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )))
                              .values
                              .toList(),
                        ),
                      )
                  ),
                ),
                const SizedBox(height: 20),
                //button
                (choosenLanguage != '')
                    ?  Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async{
                      final prefs= await SharedPreferences.getInstance();
                      prefs.setString('choosenlan', choosenLanguage);
                      prefs.setString('choosendirection', 'rtl');
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) =>Login()));
                    },
                    child: Text(
                      languages[choosenLanguage]['text_next'],
                      style: TextStyle(fontSize: 25))),
                ): Container(),
              ],
            ),
          ),
        ));
  }
}