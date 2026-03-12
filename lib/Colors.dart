import 'package:intl/intl.dart';

class Colorscommon {
  static const String redcolor = '#ff0000';
  static const String whitecolor = '#FFFFFF';
  static const String greycolor = '#6b6f71';
  static const String greencolor = '#258D79';
  static const String greenverylow = '#F0FFF0';
  static const String greenlite = '#11e699';
  static const String whitelite = '#f7f8f9';
  static const String redcolorlite = '#FF4500';
  static const String redcolorlite2 = '#DC1C13';
  static const String grey_low = '#4b4b4b';
  static const String litegrey = '#F1ECEC';
  static const String button_bgcolor = '#F1F1F3';
  static const String icon_bgcolor = '#D8D8D8';
  static const String medgrey = '#B1B1B1';
  static const String blackcolor = '#000000';
  static const String greenAppcolor = '#268D79';
  static const String greenApp2color = '#3FAC97';

  static const String greendark = '#268D79';
  static const String greendark2 = '#217C6A';
  static const String greendark3 = '#358496';

  static const String greenlight = '#0AA793';
  static const String greenlight2 = '#3FAC97';
  static const String greenlight3 = "#43C4AC";
  static const String greenlight4 = '#2FAA93';
  static const String greydark = '#707070';
  static const String greydark2 = '#7B788A';
  static const String greylight = '#EAE8F1';
  static const String greylight2 = '#EDEBF3';
  static const String greylight3 = '#0000000F';
  static const String greylight4 = '#00000026';
  static const String greylight5 = '#D5D2D2';
  static const String red = '#EF4747';
  static const String darkblack = '#2B2F43';
  static const String darkblack2 = '#595A58';
  static const String blue = '#31CAD5';
  static const String backgroundcolor = '#F8F8F8';

  //  static const String greenAppcolor = '#258D79';
}

String getCurrentDateTime() {
  final String dateTime =
      DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()).toString();
  String Valdate = dateTime;
  return Valdate;
} // get current Time and date

String getCurrentDate() {
  final String dateTime =
      DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
  String Valdate = dateTime;
  return Valdate;
}
