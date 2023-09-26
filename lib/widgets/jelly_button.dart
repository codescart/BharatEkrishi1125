import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class JellyButton extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final double? width;
  final double? height;
  final IconData? iconData;
  final Color color;
  final bool? loading;
  const JellyButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.width,
    this.height,
    this.iconData,
    this.color = Colors.green,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widths = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
          height: height ?? 50,
          width: width ?? widths * 0.2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 8,
                color: color,
                inset: true,
              ),
              BoxShadow(
                offset: Offset(0, -30),
                blurRadius: 20,
                color: color,
                inset: true,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconData == null
                  ? Container()
                  : Icon(
                      iconData,
                      size: 20,
                      color: Colors.white,
                    ),
              iconData == null
                  ? Container()
                  : SizedBox(
                      width: widths / 50,
                    ),
              loading == true
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
            ],
          )),
    );
  }
}
