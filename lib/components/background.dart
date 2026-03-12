import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/top1.png",
              width: size.width,
              color: HexColor(Colorscommon.greenlite),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/top2.png",
              width: size.width,
              color: HexColor(Colorscommon.greencolor),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/bottom1.png",
              width: size.width,
              color: HexColor(Colorscommon.greencolor),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/bottom2.png",
              width: size.width,
              color: HexColor(Colorscommon.greenlite),
            ),
          ),
          child
        ],
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: Colors.purple.shade800,
    //     toolbarHeight: 0,
    //   ),
    //   body: Container(
    //     width: double.infinity,
    //     height: size.height,
    //     child: Stack(
    //       alignment: Alignment.center,
    //       children: <Widget>[
    //         Positioned(
    //           top: 0,
    //           right: 0,
    //           child: Image.asset("assets/top1.png", width: size.width),
    //         ),
    //         Positioned(
    //           top: 0,
    //           right: 0,
    //           child: Image.asset("assets/top2.png", width: size.width),
    //         ),
    //         Positioned(
    //           bottom: 0,
    //           right: 0,
    //           child: Image.asset("assets/bottom1.png", width: size.width),
    //         ),
    //         Positioned(
    //           bottom: 0,
    //           right: 0,
    //           child: Image.asset("assets/bottom2.png", width: size.width),
    //         ),
    //         child
    //       ],
    //     ),
    //   ),
    // );
  }
}
