import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Dashboard2.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/PlannedTrip.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/Notofications.dart';
import 'package:flutter_application_sfdc_idp/Settings.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

import '../../ChatScreens/AuthScreen.dart';
import '../ChargingCar.dart';
import '../DashboardPageNew.dart';
import '../MessageDashboard.dart';
import '../Pre-Trip-Sp-Check-in.dart';

class MyTabPage extends StatefulWidget {

  final String title;
  final int selectedtab;
  const MyTabPage({Key? key, required this.title, required this.selectedtab}) : super(key: key);

  @override
  State<MyTabPage> createState() => _MyTabPageState();
}

class _MyTabPageState extends State<MyTabPage>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late String selectTab;

  List<Widget> tabPages = [
    const Dashboard2(),
    const Settings(),
    AuthScreen(),
    const Localnotifications(),
    const PlannedTrip(),
   // DriverPledgeScreen(),
     DashboardPageNew(),

   // MessageDashboard(),

  ];

  @override
  void initState() {
    super.initState();

    // Set default selected tab
    tabIndex = 0;
    selectTab = "Home";

   // Navigate to 'Message Board' tab if selectedtab == 2
    if (widget.selectedtab == 2) {
      tabIndex = 2; // Index of "Message Board" in labels
      selectTab = "chat"; // Must match the label exactly
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: selectTab, // now it will be either "Home" or "Message Board"
        labels: const [
          "Home",
          "Settings",
         "chat",
          "Planned Trips",
          "DashboardPageNew",
          "Message Board",

        ],          //"Conformation"

        icons: const [
          Icons.home_filled,
          Icons.settings,
          Icons.message,
          Icons.notifications,
          Icons.car_crash_sharp,
          Icons.emoji_events,

        ],


        // optional badges, length must be same with labels
        badges: const [
          null,
          null,
          null,
          null,
         null,
         null,
         // null,

        ],
        tabSize: 60,
        tabBarHeight: 40,

        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.transparent,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: HexColor(Colorscommon.greenlight2),
        tabIconSize: 28.0,
        tabIconSelectedSize: 30.0,
        tabSelectedColor: HexColor(Colorscommon.greenlight2),
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            tabIndex = value;
          });
        },
      ),
      body: tabPages[tabIndex],
    );
  }
}
