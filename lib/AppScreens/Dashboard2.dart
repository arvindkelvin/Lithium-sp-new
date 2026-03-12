import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';

// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/ApplyEos.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Earningmain.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Extratriplist.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Grivancelistmain.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/ReferaFriend.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/Login.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/CancelEos.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/ExtraTrip.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/FeeInvoices.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';


import '../SessionManager.dart';
import '../l10n/app_localizations.dart';
import 'ChargingCar.dart';
import 'Grievancelist.dart';
import 'Grivancelist2.dart';

class Dashboard2 extends StatefulWidget {
  const Dashboard2({Key? key}) : super(key: key);

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2>
    with SingleTickerProviderStateMixin {
  Utility utility = Utility();
  late AnimationController _controller;
  var username = "";
  var spusername = "";
  var total_count = "0";
  bool isConnected = true;
  Timer? connectivityTimer;
  final SessionManager _sessionManager = SessionManager();

  int playCount = 0; // Tracks the number of times the audio has been played
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false; // Flag to track if audio is playing


  //Function to play music
  //Function to play music
  // import 'package:audioplayers/audioplayers.dart';
  // import 'package:flutter/services.dart' as rootBundle;
  // import 'dart:typed_data'; // For Uint8List


  void playAudio(BuildContext context, String language, {required VoidCallback onComplete}) async {
    final AudioPlayer _audioPlayer = AudioPlayer();
    String audioPath;

    // Set the file path based on the selected language
    if (language == 'hindi') {
      audioPath = 'assets/Safety_VO_HINDI.mp3';
    } else {
      audioPath = 'assets/Safety_VO_English.mp3';
    }

    try {
      // Load the audio file from assets
      ByteData audioData = await rootBundle.load(audioPath);
      Uint8List bytes = audioData.buffer.asUint8List(audioData.offsetInBytes, audioData.lengthInBytes);

      // Play the audio
      await _audioPlayer.setSourceBytes(bytes);
      await _audioPlayer.resume();
      print('Playing $language audio');

      // Wait for the audio to finish playing
      _audioPlayer.onPlayerComplete.listen((_) {
        onComplete();
      });
    } catch (e) {
      print('Error playing $language audio: $e');
      onComplete();
    }
  }

  String extractFirstTwoWords(String fullName) {
    // Clean and normalize whitespace
    final cleaned = fullName.trim().replaceAll(RegExp(r'\s+'), ' ');

    // Match first two "words" using RegExp
    final match = RegExp(r'^([A-Za-z]+(?:\s+[A-Za-z]+)?)').firstMatch(cleaned);

    return match != null ? match.group(0)! : '';
  }

  //use name 3 words
  // String extractFirstThreeWords(String fullName) {
  //   // Normalize whitespace
  //   final cleaned = fullName.trim().replaceAll(RegExp(r'\s+'), ' ');
  //
  //   // Split into words
  //   final words = cleaned.split(' ');
  //
  //   // Take first 3 and join
  //   return words.take(3).join(' ');
  // }





  @override
  void initState() {
    super.initState();
    startConnectivityCheck();

    _controller = AnimationController(vsync: this);
    requestNotificationPermissions();
    utility.GetUserdata().then((value) => {
          print(utility.lithiumid.toString()),
          username = utility.lithiumid,
          spusername = utility.mobileuser,
          getnoficationlist(username),
          setState(() {}),
        });
  }

  @override
  void dispose() {
    getnoficationlist(username);
    _controller.dispose();
    connectivityTimer?.cancel();
    //_audioPlayer.dispose();
    super.dispose();
  }

  backnotification() async {
    utility.GetUserdata().then((value) => {
          print(utility.lithiumid.toString()),
          username = utility.lithiumid,
          spusername = utility.mobileuser,
          getnoficationlist(username),
          setState(() {}),
        });
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status == PermissionStatus.granted) {
      // Notification permissions granted
    } else if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      // Permission is denied or permanently denied, show an alert dialog.
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Avenirtextblack(
                  customfontweight: FontWeight.normal,
                  fontsize: 20,
                  textcolor: HexColor(Colorscommon.greendark),
                  text: 'Notification Permission Required'),
              content: Avenirtextmedium(
                  customfontweight: FontWeight.w500,
                  fontsize: 18,
                  textcolor: HexColor(Colorscommon.greycolor),
                  text:
                      'To receive notifications, please enable notification permissions in the app settings.'),
              actions: <Widget>[
                TextButton(
                  child: Avenirtextblack(
                      customfontweight: FontWeight.normal,
                      fontsize: 18,
                      textcolor: HexColor(Colorscommon.greendark),
                      text: 'OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the alert dialog
                    openAppSettings(); // Open app settings for the user to enable permissions
                  },
                ),
              ],
            );
          });
    }
  }

  void startConnectivityCheck() {
    connectivityTimer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => checkConnectivity());
  }

  void checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: HexColor(Colorscommon.greenAppcolor),
            toolbarHeight: 0,
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: HexColor('#F8F8F8'),
            child: Column(children: [
              ClipPath(
                clipper: CurveImage(),
                child: Container(
                    height: 115,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        HexColor(Colorscommon.greencolor),
                        HexColor(Colorscommon.greencolor)
                      ],
                    ))),
              ),
              Expanded(
                flex: 5,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      //color: Colors.grey.shade200,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 25, right: 15, left: 15),
                        child: ListView(
                          shrinkWrap: true, //just set this property
                          padding: const EdgeInsets.all(8.0),
                          children: [
                            // GestureDetector(
                            //     onTap: isConnected ? () {
                            //       Navigator.push(
                            //         context,
                            //         PageTransition(
                            //           alignment: Alignment.bottomCenter,
                            //           // curve: Curves.fastLinearToSlowEaseIn,
                            //           type: PageTransitionType.leftToRight,
                            //           child: ApplyEos(),
                            //         ),
                            //       );
                            //       // Navigator.of(context)
                            //       //     .push(MaterialPageRoute(
                            //       //   builder: (context) => ApplyEos(),
                            //       // ));
                            //     }
                            //   : null,
                            //     child: Card(
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10.0),
                            //       ),
                            //       child: Row(
                            //         children: [
                            //           Padding(
                            //             padding: const EdgeInsets.all(10),
                            //             child: Container(
                            //               width: 26,
                            //               height: 26,
                            //               decoration: const BoxDecoration(
                            //                 image: DecorationImage(
                            //                   image: AssetImage(
                            //                       "assets/ApplyEOS.png"),
                            //                   fit: BoxFit.fitHeight,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //           const SizedBox(
                            //             height: 10,
                            //           ),
                            //           Avenirtextmedium(
                            //             customfontweight: FontWeight.normal,
                            //             fontsize: (AppLocalizations.of(context)!
                            //                 .id ==
                            //                 "ஐடி" ||
                            //                 AppLocalizations.of(context)!
                            //                     .id ==
                            //                     "आयडी" ||
                            //                 AppLocalizations.of(context)!
                            //                     .id ==
                            //                     "ಐಡಿ")
                            //                 ? 14
                            //                 : 17,
                            //             text: AppLocalizations.of(context)!
                            //                 .apply_EOS,
                            //             textcolor:
                            //             HexColor(Colorscommon.greendark2),
                            //           ),
                            //           Expanded(
                            //             flex: 1,
                            //             child: Align(
                            //               alignment: Alignment.centerRight,
                            //               child: Icon(
                            //                 Icons.arrow_forward_ios_sharp,
                            //                 size: 20,
                            //                 color: HexColor(
                            //                     Colorscommon.greencolor),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     )),
                            GestureDetector(
                              onTap: isConnected
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          type: PageTransitionType.leftToRight,
                                          child: ApplyEos(),
                                        ),
                                      );
                                    }
                                  : () {
                                // Handle offline action, such as showing a snackbar
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    // icon: Icon(Icons.interests),
                                    message: "Your Internet Connection is Very Slow",
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'AvenirLTStd-Black',
                                        color: HexColor(Colorscommon.whitecolor)),

                                    backgroundColor: HexColor(Colorscommon.grey_low),
                                    // textStyle: TextStyle(color: Colors.red),
                                  ),
                                  displayDuration: const Duration(seconds: 30),
                                );
                              },
                              child: AnimatedOpacity(
                                opacity: isConnected ? 1.0 : 0.2,
                                duration: Duration(milliseconds: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/ApplyEOS.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Avenirtextmedium(
                                        customfontweight: FontWeight.normal,
                                        fontsize: (AppLocalizations.of(context)!
                                                        .id ==
                                                    "ஐடி" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "आयडी" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "ಐಡಿ")
                                            ? 14
                                            : 17,
                                        text: AppLocalizations.of(context)!
                                            .apply_EOS,
                                        textcolor:
                                            HexColor(Colorscommon.greendark2),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 20,
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: isConnected
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          type: PageTransitionType.leftToRight,
                                          child: const CancelEos(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: AnimatedOpacity(
                                opacity: isConnected ? 1.0 : 0.2,
                                duration: Duration(milliseconds: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/CancelEOS.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Avenirtextmedium(
                                        customfontweight: FontWeight.normal,
                                        fontsize: (AppLocalizations.of(context)!
                                                        .id ==
                                                    "ஐடி" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "आयडी" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "ಐಡಿ")
                                            ? 14
                                            : 17,
                                        text: AppLocalizations.of(context)!
                                            .cancel_EOS,
                                        textcolor:
                                            HexColor(Colorscommon.greendark2),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 20,
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: isConnected
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          type: PageTransitionType.leftToRight,
                                          child: const ExtraTrip(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: AnimatedOpacity(
                                opacity: isConnected ? 1.0 : 0.2,
                                duration: Duration(milliseconds: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/ExtraTrip.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Avenirtextmedium(
                                        customfontweight: FontWeight.normal,
                                        fontsize: (AppLocalizations.of(context)!
                                                        .id ==
                                                    "ஐடி" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "आयडी" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "ಐಡಿ")
                                            ? 14
                                            : 17,
                                        text: AppLocalizations.of(context)!
                                            .extra_Trip,
                                        textcolor:
                                            HexColor(Colorscommon.greendark2),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 20,
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: isConnected
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          type: PageTransitionType.leftToRight,
                                          child: const EarningMain(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: AnimatedOpacity(
                                opacity: isConnected ? 1.0 : 0.2,
                                duration: Duration(milliseconds: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/Earnings.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Avenirtextmedium(
                                        customfontweight: FontWeight.normal,
                                        fontsize: (AppLocalizations.of(context)!
                                                        .id ==
                                                    "ஐடி" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "आयडी" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "ಐಡಿ")
                                            ? 14
                                            : 17,
                                        text: AppLocalizations.of(context)!
                                            .earnings,
                                        textcolor:
                                            HexColor(Colorscommon.greendark2),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 20,
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: isConnected
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          type: PageTransitionType.leftToRight,
                                          child: FeeInvoices(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: AnimatedOpacity(
                                opacity: isConnected ? 1.0 : 0.2,
                                duration: Duration(milliseconds: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/FeeInvoices.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Avenirtextmedium(
                                        customfontweight: FontWeight.normal,
                                        fontsize: (AppLocalizations.of(context)!
                                                        .id ==
                                                    "ஐடி" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "आयडी" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "ಐಡಿ")
                                            ? 14
                                            : 17,
                                        text: AppLocalizations.of(context)!
                                            .fee_Invoices,
                                        textcolor:
                                            HexColor(Colorscommon.greendark2),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 20,
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: isConnected
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          type: PageTransitionType.leftToRight,
                                          child: const ReferaFriend(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: AnimatedOpacity(
                                opacity: isConnected ? 1.0 : 0.2,
                                duration: Duration(milliseconds: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/Referafriend.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Avenirtextmedium(
                                        customfontweight: FontWeight.normal,
                                        fontsize: (AppLocalizations.of(context)!
                                                        .id ==
                                                    "ஐடி" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "आयडी" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "ಐಡಿ")
                                            ? 14
                                            : 17,
                                        text: AppLocalizations.of(context)!
                                            .refer_a_Friend,
                                        textcolor:
                                            HexColor(Colorscommon.greendark2),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 20,
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: isConnected
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          type: PageTransitionType.leftToRight,
                                          child: const GrievanceMain(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: AnimatedOpacity(
                                opacity: isConnected ? 1.0 : 0.2,
                                duration: Duration(milliseconds: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/Grievances.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Avenirtextmedium(
                                        customfontweight: FontWeight.normal,
                                        fontsize: (AppLocalizations.of(context)!
                                                        .id ==
                                                    "ஐடி" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "आयडी" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "ಐಡಿ")
                                            ? 14
                                            : 17,
                                        text: AppLocalizations.of(context)!
                                            .grievance_List,
                                        textcolor:
                                            HexColor(Colorscommon.greendark2),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 20,
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: isConnected
                                  ? () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          type: PageTransitionType.leftToRight,
                                          child: const Extratriplist(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: AnimatedOpacity(
                                opacity: isConnected ? 1.0 : 0.2,
                                duration: Duration(milliseconds: 500),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/ExtraTrip.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Avenirtextmedium(
                                        customfontweight: FontWeight.normal,
                                        fontsize: (AppLocalizations.of(context)!
                                                        .id ==
                                                    "ஐடி" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "आयडी" ||
                                                AppLocalizations.of(context)!
                                                        .id ==
                                                    "ಐಡಿ")
                                            ? 14
                                            : 17,
                                        text: AppLocalizations.of(context)!
                                            .extra_hours_List,
                                        textcolor:
                                            HexColor(Colorscommon.greendark2),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 20,
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      // curve: Curves.fastLinearToSlowEaseIn,
                                      type: PageTransitionType.leftToRight,
                                      child: const ChargingCar(),
                                    ),
                                  );
                                },

                                  child:Row(
                                    children: [
                                      Expanded(
                                        flex: 3, // Adjust the flex value as needed
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                alignment: Alignment.bottomCenter,
                                                type: PageTransitionType.leftToRight,
                                                child: const ChargingCar(),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Container(
                                                    width: 28,
                                                    height: 25,
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage("assets/charging-station.png"),
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10), // Add spacing between image and text
                                                Avenirtextmedium(
                                                  customfontweight: FontWeight.normal,
                                                  fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                      AppLocalizations.of(context)!.id == "आयडी" ||
                                                      AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                      ? 14
                                                      : 17,
                                                  text: "Car Charge",
                                                  textcolor: HexColor(Colorscommon.greendark2),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Icon(
                                                      Icons.arrow_forward_ios_sharp,
                                                      size: 20,
                                                      color: HexColor(Colorscommon.greencolor),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10), // Add spacing between card and icon
                                      GestureDetector(
                                        onTap: () {
                                          _showLanguageDialog(context); // Show dialog when icon is tapped
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                HexColor(Colorscommon.blackcolor),HexColor(Colorscommon.greendark),
                                                HexColor(Colorscommon.blackcolor),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.music_note,
                                              color: Colors.white,
                                              size: 30, // Slightly larger icon for better visibility
                                            ),
                                          ),
                                          width: 50, // Increased touchable area
                                          height: 50, // Increased touchable area
                                        ),
                                      ),
                                    ],
                                  ),


                                ),

                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  //style: DefaultTextStyle.of(context).style,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor(Colorscommon.greendark),
                                    // Add any additional styling properties as needed
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                              .help_Line_Number +
                                          " : ",
                                      // Use the localized text here
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '08069457979',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: HexColor(Colorscommon.red),
                                        // Add any additional styling properties as needed
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Stack(
                    //   children: [
                    //     Positioned(
                    //       right: 15,
                    //       bottom: 0, // Adjust bottom margin for better visibility
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           _showLanguageDialog(context); // Show dialog when icon is tapped
                    //         },
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             gradient: LinearGradient(
                    //               colors: [
                    //                 HexColor(Colorscommon.blackcolor),
                    //                 HexColor(Colorscommon.greendark),
                    //               ],
                    //               begin: Alignment.topLeft,
                    //               end: Alignment.bottomRight,
                    //             ),
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 color: Colors.black.withOpacity(0.2),
                    //                 spreadRadius: 2,
                    //                 blurRadius: 5,
                    //                 offset: Offset(0, 3), // Shadow position
                    //               ),
                    //             ],
                    //           ),
                    //           child: Center(
                    //             child: Icon(
                    //               Icons.music_note,
                    //               color: Colors.white,
                    //               size: 30, // Slightly larger icon for better visibility
                    //             ),
                    //           ),
                    //           width: 50, // Increased touchable area
                    //           height: 50, // Increased touchable area
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Positioned(
                      top: -90,
                      right: 0,
                      left: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                HexColor("#358496"),
                                HexColor("#43C4AC"),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Profile Image without GestureDetector
                                // Material(
                                //   color: Colors.transparent, // Makes sure the background is transparent
                                //   child: ClipOval(
                                //     child: SizedBox(
                                //       width: 80, // Size of the profile image
                                //       height: 80,
                                //       child: FutureBuilder<String?>(
                                //         future: _sessionManager.getImage(),
                                //         builder: (context, snapshot) {
                                //           if (snapshot.hasData && snapshot.data != null) {
                                //             return Image.network(
                                //               snapshot.data!,
                                //               fit: BoxFit.cover,
                                //               errorBuilder: (context, error, stackTrace) {
                                //                 return Icon(Icons.person, size: 50, color: Colors.white);
                                //               },
                                //             );
                                //           } else {
                                //             return Container(
                                //               color: Colors.white.withOpacity(0.3),
                                //               child: Icon(Icons.person, size: 50, color: Colors.white),
                                //             );
                                //           }
                                //         },
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(width: 20),
                                // Service Provider Details
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Avenirtextblack(
                                          text: extractFirstTwoWords(spusername).toUpperCase(),
                                          fontsize: 22,
                                          textcolor: Colors.white,
                                          customfontweight: FontWeight.w700,
                                        ),
                                        const SizedBox(height: 8),
                                        Avenirtextbook(
                                          text: "Service Provider".toUpperCase(),
                                          fontsize: 16,
                                          textcolor: Colors.white.withOpacity(0.8),
                                          customfontweight: FontWeight.w500,
                                        ),
                                        const SizedBox(height: 8),
                                        Avenirtextbook(
                                          text: username.toUpperCase(),
                                          fontsize: 16,
                                          textcolor: Colors.white.withOpacity(0.8),
                                          customfontweight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          height: 120,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    )








                    // Positioned(
                    //   top: -95,
                    //   right: 0,
                    //   left: 0,
                    //   child: Align(
                    //     alignment: Alignment.topCenter,
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       decoration: BoxDecoration(
                    //         // image:  DecorationImage(
                    //         //   image: AssetImage("assets/bottom2.png"),
                    //         //   fit: BoxFit.cover,
                    //         // ),
                    //         borderRadius: BorderRadius.circular(20.0),
                    //         gradient: LinearGradient(
                    //           begin: Alignment.centerRight,
                    //           end: Alignment.centerLeft,
                    //           colors: [
                    //             HexColor("##358496"),
                    //             HexColor("#43C4AC"),
                    //           ],
                    //         ),
                    //         // color: HexColor(Colorscommon.greenApp2color),
                    //         // ignore: prefer__literals_to_create_immutables
                    //         boxShadow: [
                    //           // ignore: prefer__ructors
                    //           BoxShadow(
                    //             color: HexColor(Colorscommon.greenApp2color),
                    //             blurRadius: 1.0,
                    //             spreadRadius: 0.0,
                    //             offset: const Offset(
                    //                 1.0, 1.0), // shadow direction: bottom right
                    //           )
                    //         ],
                    //       ),
                    //       child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             const SizedBox(
                    //               height: 10,
                    //             ),
                    //             Avenirtextblack(
                    //                 text: spusername.toUpperCase(),
                    //                 fontsize: 20,
                    //                 textcolor: Colors.white,
                    //                 customfontweight: FontWeight.w500),
                    //             const SizedBox(
                    //               height: 10,
                    //             ),
                    //             Avenirtextbook(
                    //                 text: "Service Provider".toUpperCase(),
                    //                 fontsize: 14,
                    //                 textcolor: Colors.white,
                    //                 customfontweight: FontWeight.w500),
                    //             Expanded(
                    //                 child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 const SizedBox(
                    //                   height: 10,
                    //                 ),
                    //                 Center(
                    //                   child: Avenirtextbook(
                    //                       text: username.toUpperCase(),
                    //                       fontsize: 15,
                    //                       textcolor: Colors.white,
                    //                       customfontweight: FontWeight.w500),
                    //                 ),
                    //                 const SizedBox(
                    //                   height: 10,
                    //                 )
                    //               ],
                    //             ))
                    //           ]),
                    //       height: 100,
                    //       margin: const EdgeInsets.all(20),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Safety Message',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text('Please choose a language for the safety message audio.',
                style: TextStyle(
                  fontSize: 18,

                ),),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _LanguageButton(
                      color: Colors.green,
                      text: 'EN',
                      onTap: () {
                        _playAudio(context, 'english');
                      },
                    ),
                    _LanguageButton(
                      color: Colors.orange,
                      text: 'हिंदी',
                      onTap: () {
                        _playAudio(context, 'hindi');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _playAudio(BuildContext context, String language) {
    if (_isPlaying) return; // Prevent playing if audio is already playing

    setState(() {
      _isPlaying = true; // Set flag to true when audio starts playing
    });

    // Call the HTTP request before playing audio
    _sendAudioPlayRequest(context, language).then((_) {
      playAudio(context, language, onComplete: () {
        setState(() {
          _isPlaying = false; // Reset flag when audio completes
        });
        Navigator.of(context).pop(); // Close dialog when audio is done
      });
    });
  }

  Future<void> _sendAudioPlayRequest(BuildContext context, String language) async {

    // Get current location
    Location location = Location();
    LocationData? currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print('Error fetching location: $e');
      Fluttertoast.showToast(msg: "Error fetching location.");
    }

    String url = CommonURL.localone;
   // const url = 'http://10.10.14.14:8092/webservice';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Added Accept header
      },

      body: jsonEncode({
        'from': 'sfdcmusiccount',
        'sfdc_id': utility.lithiumid,
        'latitude': currentLocation?.latitude.toString() ?? '0.0',
        'longitude': currentLocation?.longitude.toString() ?? '0.0',
        'languageType': language,



      }),
    );

    if (response.statusCode == 200||response.statusCode == 201) {
      final responseBody = response.body;
      final responseData = jsonDecode(responseBody);

      if (responseData['success'] == '1' && responseData['status'] == true) {
        print(responseData['message']); // Print success message
      } else {
        print('Error: ${responseData['message']}'); // Handle error message
      }
    } else {
      print('Failed to send request: ${response.statusCode}');
    }
  }






  void getnoficationlist(String userid) async {
    String url = CommonURL.URL;
    Map<String, String> postdata = {
      "from": "getNotificationListBySP",
      "lithiumID": userid,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };
    debugPrint('fetchdata $url');

    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(postdata), headers: requestHeaders);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);
        print("jsonInput$jsonInput");

        String status = jsonInput['status'].toString();

        if (status == 'true') {
          if (mounted) {
            setState(() {
              total_count = jsonInput['totalUnreadCount'].toString();
            });
          }

          // Save the data locally for offline access
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('notificationData', response.body);
        }
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching data: $e');

      // Attempt to load data from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('notificationData');

      if (cachedData != null) {
        Map<String, dynamic> jsonInput = jsonDecode(cachedData);

        if (jsonInput['status'].toString() == 'true') {
          if (mounted) {
            setState(() {
              total_count = jsonInput['totalUnreadCount'].toString();
            });
          }
          print('Loaded notifications from cache');
        }
      } else {
        print('No cached data available');
      }
    }
  }

  // void getnoficationlist(String userid) async {
  //   String url = CommonURL.URL;
  //   // print("userid$userid");
  //   Map<String, String> postdata = {
  //     "from": "getNotificationListBySP",
  //     "lithiumID": userid,
  //   };
  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/hal+json',
  //     'Accept': 'application/json',
  //   };
  //   debugPrint('fetchdata $url');
  //
  //   final response = await http.post(Uri.parse(url),
  //       body: jsonEncode(postdata), headers: requestHeaders);
  //   print(response.statusCode);
  //   // isloading = false;
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     print("jsonInput$jsonInput");
  //
  //     String status = jsonInput['status'].toString();
  //     // List statuslist = jsonInput["data"];
  //     // String message = jsonInput['message'];
  //     // debugPrint('Location_success $success');
  //     // debugPrint('Location_message $message');
  //
  //     // /Navigator.pop(context);
  //
  //     if (status == 'true') {
  //       if(mounted) {
  //         setState(() {
  //           total_count = jsonInput['totalUnreadCount'].toString();
  //         });
  //       }
  //
  //       // print("statuslist$statuslist");
  //       // noitificationlistarray = jsonInput["data"];
  //       // print("noitificationlistarray$noitificationlistarray");
  //
  //       // print("noitificationlistarray$noitificationlistarray");
  //
  //       // Navigator.pop(context);
  //
  //       // Codec<String, String> stringToBase64 = utf8.fuse(base64);
  //
  //       // String encoded = stringToBase64.encode(newpasswordcontroller.text);
  //       // debugPrint("newpassword " + encoded);
  //
  //       // Navigator.of(context).pushAndRemoveUntil(
  //       //     MaterialPageRoute(builder: (context) => Login()),
  //       //     (Route<dynamic> route) => false);
  //     }
  //
  //     // Fluttertoast.showToast(
  //     //   msg: message,
  //     //   toastLength: Toast.LENGTH_SHORT,
  //     //   gravity: ToastGravity.CENTER,
  //     // );
  //   } else {
  //     // print("noitificationlistarray$noitificationlistarray");
  //     // debugPrint('SERVER=FAILED');
  //
  //     // Fluttertoast.showToast(
  //     //   msg: "Something Went Wrong Please Try Again",
  //     //   toastLength: Toast.LENGTH_SHORT,
  //     //   gravity: ToastGravity.CENTER,
  //     // );
  //   }
  // }

  void logoutapi(String id, String accesstoken, String email) async {
    String url = CommonURL.URL;
    Map<String, String> postdata = {
      "from": "driverLogout",
      "id": id,
      "access_token": accesstoken,
      "username": email,
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    debugPrint('fetchdata $url');
    debugPrint('fetchdata $postdata');

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);

    print("${response.statusCode}");
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      String success = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (success == 'true') {
        String idDriverr = jsonInput['id_driver'].toString();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Login()),
            (Route<dynamic> route) => false);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        setState(() {});
       // Restart.restartApp();
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.somethingwentwrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void showTopSnackBar(BuildContext context, customSnackBar, {required Duration displayDuration}) {

  }
}

class CurveImage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 30);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class _LanguageButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.color,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: color,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
