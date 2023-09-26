import 'package:flutter/material.dart';
import 'package:bharatekrishi/languages/function.dart';
import 'package:bharatekrishi/languages/translation.dart';

class filter_screen extends StatefulWidget {
  const filter_screen({Key? key}) : super(key: key);

  @override
  State<filter_screen> createState() => _filter_screenState();
}

class _filter_screenState extends State<filter_screen> {
  final List<String> items = [
    'Customer',
    'client',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        title: Text(languages[choosenLanguage]['Filter'],
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2.5,
                      blurRadius: 3,
                    )
                  ],
                  color: Colors.white),
              height: 50,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text(
                    languages[choosenLanguage]['Select user type'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
