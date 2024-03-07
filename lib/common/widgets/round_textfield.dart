import 'package:flutter/material.dart';

import '../colours.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final String icon;
  final Widget? rigtIcon;
  final bool obscureText;
  final EdgeInsets? margin;
  final int maxLines;
  const RoundTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.margin,
    this.keyboardType,
    this.obscureText = false,
    this.rigtIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: TColor.lightGray, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          suffixIcon: rigtIcon,
          prefixIcon: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            child: Image.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: TColor.gray,
            ),
          ),
          hintStyle: TextStyle(
            color: TColor.gray,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
