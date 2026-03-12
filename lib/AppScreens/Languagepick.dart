import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/Login.dart';
import 'package:flutter_application_sfdc_idp/widget/language_picker_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;


class languagepicker extends StatefulWidget {
  @override
  State<languagepicker> createState() => _languagepickerState();
}

class _languagepickerState extends State<languagepicker> {



  String? currentBuildVersion;
  String? playstoreVersion;
  String playstoreUrl = "";
  String? PlaystoreVersion;
  String? Playstoreurl;


  void initState() {
    super.initState();
    // VersionChecker versionChecker = VersionChecker();
    // DateTime scheduledTime = DateTime(2025, 3, 26, 05, 30); // September 21, 2024, 1:15 PM
    // //DateTime scheduledTime = DateTime(2024, 9, 21, 15, 09); // September 21, 2024, 1:15 PM
    // versionChecker.scheduleVersionCheck(context, scheduledTime, isLoginPage: true);

  }

// // Method to fetch the current version of the app
//   Future<void> getVersion() async {
//     print("Fetching current app version");
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     currentBuildVersion = packageInfo.version;
//     print("Current version: $currentBuildVersion");
//   }
//
// // Method to check the version depending on the platform (Android or iOS)
//   Future<void> checkVersion(BuildContext context, {bool isLoginPage = true}) async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // bool? hasUpdated = prefs.getBool('hasUpdated');
//     //
//     //  if (hasUpdated == true) {
//     //    print("App is already updated, skipping version check.");
//     //    return; // Skip version check if app has already been updated
//     //  }
//
//     await getVersion();
//     print("Checking version for platform");
//
//     if (Platform.isAndroid) {
//       await _checkPlayStore(context, "com.thinksynq.lithiumsp", isLoginPage: isLoginPage);
//     } else if (Platform.isIOS) {
//       // iOS version checking logic can be added here
//       print("iOS platform detected, add logic to check App Store.");
//     }
//   }
//
// // Method to check for the latest version on the Play Store
//   Future<void> _checkPlayStore(BuildContext context, String packageName, {bool isLoginPage = true}) async {
//     String errorMsg;
//     final uri = Uri.https("play.google.com", "/store/apps/details", {"id": packageName});
//
//     try {
//       final response = await http.get(uri);
//       print("Response code: ${response.statusCode}");
//
//       if (response.statusCode != 200) {
//         errorMsg = "Can't find an app in the Google Play Store with the id: $packageName";
//         print(errorMsg);
//       } else {
//         playstoreVersion = RegExp(r',\[\[\["([0-9,\.]*)"]],').firstMatch(response.body)?.group(1);
//         playstoreUrl = uri.toString();
//
//         if (playstoreVersion != null) {
//           print("Playstore version: $playstoreVersion, Current version: $currentBuildVersion");
//           if (playstoreVersion != currentBuildVersion) {
//             _showUpdateDialog(context, playstoreVersion!, playstoreUrl, isLoginPage: isLoginPage);
//           }
//         }
//       }
//     } catch (e) {
//       errorMsg = "Error: $e";
//       print(errorMsg);
//     }
//   }
//
// // Method to open the app's Play Store page and mark as updated
//   Future<void> openPlayStore() async {
//     final Uri playStoreUrl = Uri.parse("https://play.google.com/store/apps/details?id=com.thinksynq.lithiumsp");
//
//     if (await canLaunchUrl(playStoreUrl)) {
//       try {
//         await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
//
//         // After the user goes to the Play Store, assume they will update
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('hasUpdated', true); // Mark the app as updated
//
//       } catch (e) {
//         // Handle error if Play Store cannot be launched
//         print('Failed to launch Play Store: $e');
//       }
//     } else {
//       // Redirect to browser if Play Store is not available
//       final Uri browserUrl = Uri.parse("https://play.google.com/store");
//       if (await canLaunchUrl(browserUrl)) {
//         await launchUrl(browserUrl);
//       } else {
//         throw Exception('Could not launch Play Store or browser');
//       }
//     }
//   }
//
// // Method to show the version update dialog
//   void _showUpdateDialog(BuildContext context, String newVersion, String url, {bool isLoginPage = true}) {
//     showDialog(
//       barrierDismissible: false, // Prevent dismissal by tapping outside the dialog
//       context: context,
//       builder: (context) => WillPopScope(
//         onWillPop: () async {
//           return isLoginPage ? false : true; // Prevent back navigation on login page
//         },
//         child: AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//           ),
//           title: Row(
//             children: [
//               Icon(
//                 Icons.system_update,
//                 color: HexColor(Colorscommon.greendark), // Use your color
//                 size: 30,
//               ),
//               SizedBox(width: 10),
//               Text(
//                 'Update Available!',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                   color: HexColor(Colorscommon.greendark),
//                 ),
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/lithium123.png',
//                   width: 175,
//                   height: 175,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'For a better experience, please download the latest version of the app!',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//           actionsAlignment: MainAxisAlignment.center,
//           actions: <Widget>[
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 backgroundColor: Colors.red, // Use your color
//               ),
//               child: Text(
//                 'Update Now',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               onPressed: () async {
//                 openPlayStore(); // Mark app as updated after opening Play Store
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// Method to schedule the version check at a specific date and time
//   void scheduleVersionCheck(BuildContext context, DateTime scheduledTime, {bool isLoginPage = true}) {
//     DateTime now = DateTime.now();
//     Duration difference = scheduledTime.difference(now);
//
//     if (difference.isNegative) {
//       print('Scheduled time has already passed');
//       checkVersion(context, isLoginPage: isLoginPage); // Show update if the time has passed
//     } else {
//       print('Scheduled version check for: $scheduledTime');
//       Timer(difference, () => checkVersion(context, isLoginPage: isLoginPage));
//     }
//   }





  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: HexColor(Colorscommon.whitecolor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Avenirtextblack(
              text: "Choose Language",
              fontsize: 22,
              textcolor: HexColor(Colorscommon.greenAppcolor),
              customfontweight: FontWeight.bold,
            ),
            // Text(
            //   "Choose Language",
            //   style: TextStyle(
            //       color: HexColor(
            //         Colorscommon.whitecolor,
            //       ),
            //       fontSize: 17),
            // ),
            Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.language_sharp),
              SizedBox(
                width: 10,
              ),
              LanguagePickerWidget(fontsizeprefeerd: 18),
            ])),
            IconButton(
              onPressed: () {
                setdata();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: Icon(
                Icons.arrow_circle_right_outlined,
                color: HexColor(Colorscommon.greendark),
                size: 40,
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     // padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            //     backgroundColor: Colors.deepPurpleAccent,
            //     shape: StadiumBorder(),
            //   ),
            //   child: Icon(
            //     Icons.arrow_right_sharp,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  setdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('selectlanguagestatus', true);
  }
}
