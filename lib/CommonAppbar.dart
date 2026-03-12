import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'Colors.dart';
import 'l10n/app_localizations.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.red;
  final String title;
  final AppBar appBar;
  final List<Widget> widgets;
  final Tabbar;

  const CommonAppbar(
      {Key? key,
      required this.title,
      required this.appBar,
      required this.widgets,
      this.Tabbar})
      : super(key: key);

  /// you can add more fields that meet your needs

  @override
  Widget build(BuildContext context) {
    return AppBar(
      excludeHeaderSemantics: true,
      leading: BackButton(color: HexColor(Colorscommon.whitecolor)),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                    AppLocalizations.of(context)!.id == "आयडी" ||
                    AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                    AppLocalizations.of(context)!.id == "ಐಡಿ")
                ? 15
                : 18,
            color: HexColor(Colorscommon.whitecolor)),
      ),
      backgroundColor: HexColor(Colorscommon.greendark),
      actions: widgets,
      bottom: Tabbar,
      shape: CustomAppBarShape(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class CustomAppBarShape extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double h = rect.height;
    double w = rect.width;
    //  double height = size.height;
    // double width = size.width;
    double curveHeight = rect.height / 2;
    var p = Path();
    p.lineTo(0, h - 20);
    p.quadraticBezierTo(w / 2, h, w, h - 20);
    p.lineTo(w, 0);
    p.close();
    return p;
    // var path = Path();
    // path.lineTo(0, height + width * 0.1);
    // path.arcToPoint(
    //   Offset(width * 0.1, height),
    //   radius: Radius.circular(width * 0.1),
    // );
    // path.lineTo(width * 0.9, height);
    // path.arcToPoint(
    //   Offset(width, height + width * 0.1),
    //   radius: Radius.circular(width * 0.1),
    // );
    // path.lineTo(width, 0);
    // path.close();

    // return path;
  }
}

