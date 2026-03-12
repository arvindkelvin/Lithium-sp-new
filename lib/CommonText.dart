import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';

class CommonText extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CommonText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'TomaSans-Regular',
          fontSize: 15,
          color: HexColor(Colorscommon.greydark2)),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class CommonText2 extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CommonText2({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'TomaSans-Regular',
          fontSize: 15,
          color: HexColor(Colorscommon.greendark)),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class Avenirtextbook extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final double fontsize;
  final Color textcolor;
  final FontWeight customfontweight;

  const Avenirtextbook(
      {Key? key,
      required this.text,
      required this.fontsize,
      required this.textcolor,
      required this.customfontweight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'AvenirLTStd-Book',
          fontSize: fontsize,
          color: textcolor,
          fontWeight: FontWeight.w500),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class Avenirtextblack extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final double fontsize;
  final Color textcolor;
  final FontWeight customfontweight;

  const Avenirtextblack(
      {Key? key,
      required this.text,
      required this.fontsize,
      required this.textcolor,
      required this.customfontweight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'AvenirLTStd-Black',
          fontSize: fontsize,
          color: textcolor,
          fontWeight: FontWeight.w500),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class Avenirtextmedium extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final double fontsize;
  final Color textcolor;
  final FontWeight customfontweight;

  const Avenirtextmedium(
      {Key? key,
      required this.text,
      required this.fontsize,
      required this.textcolor,
      required this.customfontweight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Avenir LT Std 65 Medium',
          fontSize: fontsize,
          color: textcolor,
          fontWeight: FontWeight.w500),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
