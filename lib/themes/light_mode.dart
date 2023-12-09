import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    background: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800,
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.grey[800],
        displayColor: Colors.black,
      ),
);
