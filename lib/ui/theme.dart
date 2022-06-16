import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static ThemeData light = ThemeData(
    primaryColor: primaryClr,
    backgroundColor: white,
    brightness: Brightness.light,
  );

  static ThemeData dark = ThemeData(
      primaryColor: darkGreyClr,
      backgroundColor: darkGreyClr,
      brightness: Brightness.dark);

  TextStyle get headStyle {
    return GoogleFonts.abhayaLibre(
      textStyle:TextStyle(
        fontSize: 35,
        color: Get.isDarkMode ? Colors.white : darkGreyClr,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get subHeadStyle {
    return GoogleFonts.lato(
      textStyle:TextStyle(
        fontSize: 25,
        color: Get.isDarkMode ? Colors.white70 : darkGreyClr,
    ),
    );
  }
  TextStyle get titleStyle {
    return GoogleFonts.lato(
      textStyle:TextStyle(
        fontSize: 18,
        color: Get.isDarkMode ? Colors.white70 : darkGreyClr,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  TextStyle get subTitleStyle {
    return GoogleFonts.lato(
      textStyle:TextStyle(
        fontSize: 15,
        color: Get.isDarkMode ? Colors.white70 : darkGreyClr,
        fontWeight: FontWeight.w600,
      ),
    );
  }

}
