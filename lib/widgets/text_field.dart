import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration = const InputDecoration();
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign = TextAlign.start;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly = false;
  final int? maxLines;
  final int? minLines;
  final bool expands = false;
  final int? maxLength;
  final bool obscureText = false;
  final TextInputType? keyboardType;
  final Widget? icon;
  final Color? iconColor;
  final String? label;
  final bool? filled;
  final Color? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final void Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? hintSize;
  final double? fontSize;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? contentPadding;
  final double? cursorHeight;
  final Color? cursorColor;
  final Widget? prefix;
  final Widget? sufix;
  final BorderRadius? fieldRadius;
  final bool? enabled;
  final void Function()? onTap;
  final bool? autofocus;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? margin;

  CustomTextField({
    this.controller,
    this.style,
    this.strutStyle,
    this.textAlignVertical,
    this.textDirection,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.icon,
    this.iconColor,
    this.label,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.onChanged,
    this.height,
    this.width,
    this.hintSize,
    this.fontSize,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.contentPadding,
    this.cursorHeight,
    this.cursorColor,
    this.prefix,
    this.sufix,
    this.fieldRadius,
    this.enabled,
    this.maxLines,
    this.onTap,
    this.autofocus,
    this.onSaved,
    this.validator,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final widths=MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: height == null ? 50 : height,
        width: width == null ? MediaQuery.of(context).size.width : width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: TextFormField(
          validator: validator,
          onSaved: onSaved,
          autofocus: autofocus ?? false,
          textAlignVertical: TextAlignVertical.center,
          enabled: enabled,
          controller: controller,
          cursorColor: cursorColor,
          cursorHeight: cursorHeight,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          expands: expands,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: style == null
              ? GoogleFonts.alike(
                  textStyle: TextStyle(
                      fontSize: fontSize == null ? widths/25 : fontSize,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                      color: Colors.grey[700]),
                )
              : style,
          decoration: InputDecoration(
              counterText: "",
              prefixIcon: prefix,
              suffixIcon: sufix,
              filled: filled == null ? true : filled,
              fillColor: fillColor,
              hintText: label,
              hintStyle: GoogleFonts.alike(
                textStyle: TextStyle(
                    fontSize: hintSize == null ? widths/25 : hintSize,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    color: Colors.grey),
              ),
              contentPadding: contentPadding == null
                  ? EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0)
                  : contentPadding,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: fieldRadius == null
                      ? BorderRadius.all(Radius.circular(4.0))
                      : fieldRadius!)),
        ),
      ),
    );
  }
}
