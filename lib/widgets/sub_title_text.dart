import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubTitleText extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? width;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;
  final EdgeInsetsGeometry? padding;
  const SubTitleText(
      {super.key,
      this.title,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.width,
      this.textAlign,
      this.maxLines,
      this.softWrap,
      this.overflow,
      this.padding});

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Text(
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textAlign: textAlign,
        title ?? "",
        style: GoogleFonts.alike(
          textStyle: TextStyle(
              fontSize: fontSize ?? widths / 100,
              fontWeight: fontWeight ?? FontWeight.normal,
              fontStyle: FontStyle.normal,
              color: textColor ?? Colors.black),
        ));
  }
}
