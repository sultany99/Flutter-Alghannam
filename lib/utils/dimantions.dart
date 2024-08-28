import 'package:flutter/material.dart';

class Dimantions {
  Size s;
  late double screenHeight;
  late double screenWidth;

  Dimantions({required this.s}) {
    screenHeight = s.height;
    screenWidth = s.width;
  }
  /*I/flutter (18035): height = 843.4285714285714
    I/flutter (18035): width = 411.42857142857144*/

  late double fontSize21 = screenHeight / 36.33;
  late double fontSize18 = screenHeight / 42.38;

  late double height25 = screenHeight / 30.52;
  late double height20 = screenHeight / 38.15;
  late double height50 = screenHeight / 15.26;
  late double height100 = screenHeight / 7.63;
  late double height200 = screenHeight / 3.82;

  late double width20 = screenWidth / 16.55;
  late double width30 = screenWidth / 11.03;
  late double width50 = screenWidth / 6.62;

  late double width100 = screenWidth / 3.31;
}
