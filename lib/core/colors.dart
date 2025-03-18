import 'package:flutter/material.dart';

const whiteColor = Color.fromARGB(255, 255, 255, 255);
const blackColor = Colors.black;
const darkYellowColor = Color(0xFFFEBD1F);
const transparentColor = Colors.transparent;
const redColor = Colors.red;
const primaryColor = Color(0xFF2A2263);

class LightThemeColors {
  static const backgroundGradient = LinearGradient(
    colors: [Colors.white, Colors.red],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
