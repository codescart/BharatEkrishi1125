import 'package:bharatekrishi/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:bharatekrishi/OrderScreen/linked_order.dart';
import 'package:bharatekrishi/Accounting/accoiunting.dart';
import 'package:bharatekrishi/HomePage/home_page.dart';
import 'package:bharatekrishi/Settings/setting_screen.dart';
import 'package:bharatekrishi/Map/map.dart';
import 'package:flutter/services.dart';

class BottomNavBar extends StatefulWidget {
  final int? pageIndex;
  BottomNavBar({this.pageIndex});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int? _page;
  final _tabs = [
    OrderScreen(),
    MapScreen(),
    HomePage(),
    accounting(),
    setting_screen(),
  ];
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    setState(() {
      _page = widget.pageIndex ?? 2;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.black,
              title: Text('Are you sure?'),
              content: Text('Do you want to exit from App'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page!,
          height: MediaQuery.of(context).size.height * 0.07,
          items: [
            Image.asset(
              Assets.assetsOrder,
              width: 40,
            ),
            Image.asset(
              Assets.assetsGoogleicon,
              width: 20,
            ),
            Image.asset(
              Assets.assetsHouse,
              width: 35,
            ),
            Image.asset(
              Assets.assetsWaletim,
              width: 35,
            ),
            Image.asset(
              Assets.assetsSetting,
              width: 35,
            ),
          ],
          color: Color(0xff26bf11).withOpacity(0.3),
          buttonBackgroundColor: Colors.green,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 800),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _tabs[_page!],
      ),
    );
  }
}
