import 'package:bharatekrishi/constant/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher {
  static launchWhatsApp(BuildContext context, String phone) async {
    var whatsappURl_android = "whatsapp://send?phone=" + '91$phone' + "&text=hello";
    if (await canLaunch(whatsappURl_android)) {
      await launch(whatsappURl_android);
    } else {
      Utils.flushBarErrorMessage("whatsapp not installed", context);
    }
  }

  static launchDialPad(BuildContext context, String phone) async {
    var phoneCall = "tel:$phone";
    if (await canLaunch(phoneCall)) {
      await launch(phoneCall);
    } else {
      Utils.flushBarErrorMessage("Number Busy", context);
    }
  }

  static launchEmail(BuildContext context, String email) async {
    var callEmail = "mailto:$email";
    if (await canLaunch(callEmail)) {
      await launch(callEmail);
    } else {
      Utils.flushBarErrorMessage("email not login", context);
    }
  }

  static launchUrl(BuildContext context, String url) async {
    var launchurl = url;
    if (await canLaunch(launchurl)) {
      await launch(launchurl);
    } else {
      Utils.flushBarErrorMessage("url not found", context);
    }
  }


  static shareLocation(String vehicleNo,String latitude,String langitude) async {
    await FlutterShare.share(
      title: 'Vehicle Location & Details',
      text: 'Vehicle no $vehicleNo',
      linkUrl: 'https://maps.google.com/?q=$latitude,$langitude',
    );
  }
}
