import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:dolfin_flutter/shared/styles/colours.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      backgroundColor: AppColours.white,
      fontFamily: "Montserrat",
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColours.black,
        ),
        subtitle1: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ));

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      backgroundColor: AppColours.black,
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColours.white,
        ),
        subtitle1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: AppColours.white,
        ),
      ));
}
