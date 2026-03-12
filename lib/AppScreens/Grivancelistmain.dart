import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Grievancelist.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Grivancelist2.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';

import '../l10n/app_localizations.dart';

class GrievanceMain extends StatefulWidget {
  const GrievanceMain({Key? key}) : super(key: key);

  @override
  State<GrievanceMain> createState() => _GrievanceMainState();
}

class _GrievanceMainState extends State<GrievanceMain> {
  _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(

          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            iconSize: 24.0,
            onPressed: () {
              _goBack(context);
            },
          ),
          backgroundColor: HexColor(Colorscommon.greencolor),
          title: Text(
            AppLocalizations.of(context)!.grievance_List,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          bottom: const TabBar(

            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            tabs: [
              Tab(text: 'Open'),
              Tab(text: 'Resolved'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Grievancelist(),
            Grievancelist2(),
          ],
        ),
      ),
    );
  }
}
