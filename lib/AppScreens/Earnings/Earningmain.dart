import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Dailyearmingsnew.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Monthearnings.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earningsnewdesign.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';

import '../../l10n/app_localizations.dart';

class EarningMain extends StatefulWidget {
  const EarningMain({Key? key}) : super(key: key);

  @override
  State<EarningMain> createState() => _EarningMainState();
}

class _EarningMainState extends State<EarningMain> {
  _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              _goBack(context);
            },
          ),
          backgroundColor: HexColor(Colorscommon.greencolor),
          title: Text(AppLocalizations.of(context)!.earnings),
          titleTextStyle: TextStyle(
            fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                    AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                    AppLocalizations.of(context)!.id == "आयडी")
                ? 15
                : 18,
          ),

          // bottom: const
        ),
        body: Column(
          children: [
            Container(
              color: HexColor('#30BCA1'),
              child: TabBar(
                labelStyle: TextStyle(fontSize: 13),
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.daily),
                 // Tab(text: AppLocalizations.of(context)!.weekly),//cmnt for priya ka instruction
                  Tab(text: AppLocalizations.of(context)!.monthly)
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                // children: [Dailyearnings(), Earningsnew(), Monthearnings()],
                //children: [Dailyearningsnew(), Earningsnew(), Monthearnings()],
                children: [Dailyearningsnew(), Monthearnings()],
              ),
            ),
          ],
        ),
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     brightness: Brightness.light,
    //     // add tabBarTheme
    //     tabBarTheme: TabBarTheme(
    //         labelColor: Colors.white,
    //         labelStyle: const TextStyle(color: Colors.white), // color for text
    //         indicatorSize: TabBarIndicatorSize.tab,
    //         indicator: UnderlineTabIndicator(

    //             // insets:
    //             //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
    //             // color for indicator (underline)
    //             borderSide: BorderSide(
    //                 color: HexColor(Colorscommon.greenAppcolor), width: 5))),
    //     primaryColor: Colors.white,
    //   ),
    //   home: DefaultTabController(
    //     length: 3,
    //     child: Scaffold(
    //       appBar: AppBar(
    //         elevation: 0,
    //         leading: IconButton(
    //           icon: const Icon(Icons.arrow_back_ios),
    //           iconSize: 20.0,
    //           onPressed: () {
    //             _goBack(context);
    //           },
    //         ),
    //         backgroundColor: HexColor(Colorscommon.greencolor),
    //         title: Text(AppLocalizations.of(context)!.earnings),
    //         // bottom: const
    //       ),
    //       body: Column(
    //         children: [
    //           Container(
    //             color: HexColor('#30BCA1'),
    //             child: TabBar(
    //               tabs: [
    //                 Tab(text: AppLocalizations.of(context)!.daily),
    //                 Tab(text: AppLocalizations.of(context)!.weekly),
    //                 Tab(text: AppLocalizations.of(context)!.monthly)
    //               ],
    //             ),
    //           ),
    //           const Expanded(
    //             flex: 1,
    //             child: TabBarView(
    //               physics: NeverScrollableScrollPhysics(),
    //               // children: [Dailyearnings(), Earningsnew(), Monthearnings()],
    //               children: [
    //                 Dailyearningsnew(),
    //                 Earningsnew(),
    //                 Monthearnings()
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
