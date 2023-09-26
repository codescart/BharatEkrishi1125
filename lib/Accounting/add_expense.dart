import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bharatekrishi/constant/constatnt.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/Accounting/total_view_expense.dart';
import 'package:bharatekrishi/languages/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class add_expense extends StatefulWidget {
  const add_expense({Key? key}) : super(key: key);

  @override
  State<add_expense> createState() => _add_expenseState();
}

class _add_expenseState extends State<add_expense> {

  String ?expence ;
  List expence_data = [];

  Future<String> expanceList() async {
    final res = await http.get(
        Uri.parse(baseUrlCi+'expense_tpye')
    );
    final resBody = json.decode(res.body);
    print("hhhhhhhhhhhhh");
    print(resBody);
    setState(() {
      expence_data = resBody;
    });
    return "Sucess";
  }

  String ?vehicleType;
  List vehicle_data = [];

  Future<String> userVehical() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? 0;
    final res = await http.get(
        Uri.parse(baseUrlCi+'vehiclesget/$user_id')
    );
    final resBody = json.decode(res.body)['data'];

    setState(() {
      vehicle_data = resBody;
    });
    return "Sucess";
  }

  @override
  void initState() {
    expanceList();
    userVehical();
    super.initState();
  }

  TextEditingController _date=TextEditingController();
  TextEditingController _amount=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),

    );
  }
var  selectedDate;

  _buildChild(BuildContext context) =>Container(
    height: 450,
    padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [ Color(0xffeafce8),Color(0xffffffff),Color(0xffeafce8)]),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/cancel.png',
                width: 33,
              ),
            ),
          ),
          Container(
              alignment: Alignment.center,
              child: Text(
                  (choosenLanguage != "")
                      ?languages[choosenLanguage]['Add Expense']:'',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              )),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          (choosenLanguage != "")
              ? Text(
            languages[choosenLanguage]['Expense type'],
            style: TextStyle(fontWeight: FontWeight.bold),
          )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          Card(
            elevation: 3.0,
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: (choosenLanguage != "")
                      ? Text(
                    languages[choosenLanguage]['Select Expense Type'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).hintColor,
                    ),
                  )
                      : Container(),
                  items: expence_data.map((item) {
                    return DropdownMenuItem(
                        child: Text(
                          item['expense_tpye'].toString(),
                          overflow: TextOverflow.clip,
                          // maxLines: ,
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: "Windsor",
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            // color: Colors.black
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        value: item['id'].toString());
                  }).toList(),
                  onChanged: (value) async {
                    setState(() {
                      expence = value as String;
                    });
                  },
                  value: expence,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (choosenLanguage != "")? Text(
            languages[choosenLanguage]['Select Vehicle'],
            style: TextStyle(fontWeight: FontWeight.bold),
          )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          Card(
            elevation: 3.0,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white),
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: (choosenLanguage != "")
                      ? Text(
                    languages[choosenLanguage]['Select Vehicle'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).hintColor,
                    ),
                  )
                      : Container(),
                  items: vehicle_data.map((item) {
                    return DropdownMenuItem(
                        child: Text(
                          item['catname'].toString()+" "+item['vehicle_no'].toString(),
                          overflow: TextOverflow.clip,
                          // maxLines: ,
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: "Windsor",
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            // color: Colors.black
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        value: item['id'].toString());
                  }).toList(),
                  onChanged: (value) async {
                    setState(() {
                      vehicleType = value as String;
                    });
                  },
                  value: vehicleType,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            languages[choosenLanguage]['Enter Amount'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            elevation: 3.0,
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white),
              child: TextField(
                controller: _amount,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                    hintText: languages[choosenLanguage]['Enter_here'],
                    border:
                    OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            languages[choosenLanguage]['Select Date'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 3.0,
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white),
              child: TextField(
                  controller: _date,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border:
                      OutlineInputBorder(borderSide: BorderSide.none),
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                      // labelText: "Select Date"
                      hintText: languages[choosenLanguage]['date'],
                      hintStyle: TextStyle(color: Colors.black)),
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2101))
                        .then((pickeddate) {
                      if (pickeddate != null) {
                        setState(() {
                          selectedDate = pickeddate;
                          _date.text =
                          "${selectedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    });
                  }),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: InkWell(
              onTap: () {
                _addExpance(_amount.text, _date.text);
              },
              child: Container(
                  height: 40,
                  width: 150,
                  padding: EdgeInsets.all(8),
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
                  child: Center(child: setUpButtonChild())),
            ),
          ),
        ],
      ),
    ),
  );


  bool _liadingbutton = false;
  Widget setUpButtonChild() {
    if (_liadingbutton == false) {
      return Text(
          (choosenLanguage != '')
              ? languages[choosenLanguage]['save']
              : "",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
    } else {
      return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      );
    }
  }

  _addExpance(String _amount, String _date  ) async {
    setState(() {
      _liadingbutton = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final user_id = prefs.getString(key) ?? 0;

    final response = await http.post(
      Uri.parse(baseUrlCi+"expense"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'expense_type':"$expence",
        'select_vehicle':"$vehicleType",
        'amount': _amount,
        'date': _date.toString(),
        'user_id': "$user_id",
      }),
    );
    final data = jsonDecode(response.body);
    print(data);
    if (data['success'] == "200") {
      setState(() {
        _liadingbutton = false;
      });
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context,true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => total_expense()));
    }
    else {
      setState(() {
        _liadingbutton = false;
      });
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

