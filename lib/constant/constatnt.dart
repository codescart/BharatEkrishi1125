import 'package:flutter/animation.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

const baseUrlCi ="https://bharatekrishi.com/admin/api/";
const baseUrlPhp ="https://bharatekrishi.com/admin/";
const String apiKey = "AIzaSyBt0XXMqrIAoo-tec72ZeRgnpQF4bkm4Tw";
// const String apiKey = "AIzaSyBsU3lgUkRatydNfZXaa46KJF0xK_4P0g0";
const imageUrlPhp ="https://bharatekrishi.com/admin/upload/";

class ColorConstants {
  static Color lightScaffoldBackgroundColor = hexToColor('#F9F9F9');
  static Color darkScaffoldBackgroundColor = hexToColor('#2F2E2E');
  static Color secondaryAppColor = hexToColor('#5E92F3');
  static Color secondaryDarkAppColor = hexToColor('#62B93F');
  static Color jellyButton =  const Color(0xFFE0E0E0);
  static Color iconsText = const Color(0xffff0000);
  static Color iconsTextBg =  const Color(0xffffffff);
  static Color detailsText = const Color(0xff000000);
  static Color detailForm = const Color(0xff706d6d);
}
