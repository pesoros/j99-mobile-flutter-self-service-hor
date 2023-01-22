// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:j99_mobile_flutter_self_service/utility/color.dart';
import 'package:j99_mobile_flutter_self_service/utility/dimension.dart';

class CustomStyle {
  static var textStyle = TextStyle(
      color: CustomColor.greyColor, fontSize: Dimensions.defaultTextSize);

  static var hintTextStyle = TextStyle(
      color: Colors.grey.withOpacity(0.5),
      fontSize: Dimensions.defaultTextSize);

  static var listStyle =
      TextStyle(color: Colors.black, fontSize: Dimensions.defaultTextSize);

  static var defaultStyle =
      TextStyle(color: Colors.black, fontSize: Dimensions.defaultTextSize);

  static var focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 2.0),
  );

  static var focusErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 1.0),
  );

  static var searchBox = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 1.0),
  );

  static var bgColor = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [CustomColor.red, CustomColor.darkGrey]);
}
