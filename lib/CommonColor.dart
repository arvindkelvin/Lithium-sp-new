import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static String _convertdate(String inputdate) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(inputdate); // <-- Incoming date

    var outputFormat = DateFormat('dd MM');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }
}
