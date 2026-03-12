import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cron/cron.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Dashboardtabbar.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/Forgotpassword.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/Settings.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:flutter_application_sfdc_idp/webview_idp.dart';
import 'package:flutter_application_sfdc_idp/widget/language_picker_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppScreens/Dashboard2.dart';
import 'DB-Helper/Db-helper.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permissionHandler;

import 'l10n/app_localizations.dart';


SessionManager sessionManager = SessionManager();

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var currentBackPressTime;
  var utility = Utility();
  bool _obscureText = true;
  late BuildContext dialogContext_password;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailorphonecontroller = TextEditingController();
  late StreamSubscription _locationSubscription;
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool _fingerValue = false;
  String newUserdata = '';
  bool showfinger = true;
  String latitude = '00.00000';
  String longitude = '00.00000';
  final String _30minstr = "";
  Location location = Location();
  String validate30min = "";
  String username = "";
  String password = "";
  String serveruuid = "";
  String serverstate = "";
  late bool fromnotify;
  late bool _serviceEnabled;
  String appversionstatus = "0";

  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  var db = DBHelper();
  String? PlaystoreVersion;
  String? Playstoreurl;
  String? currentBuildVersion;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // HmsFido2Client fido2Client = new HmsFido2Client();
    // bool? isSupported = await fido2Client.isSupported();
    // print("isSupported$isSupported");

    //LITHBNG0002
    //pass@123

    //nameController.text = 'LITHBNG0002';
    //passwordController.text = 'pass@123';

    //_checkVersion();
    VersionChecker versionChecker = VersionChecker();
    DateTime scheduledTime = DateTime(2025, 7, 25, 06, 30);// September 21, 2024, 1:15 PM
    //DateTime scheduledTime = DateTime(2025, 3, 21, 18, 30); // September 21, 2024, 1:15 PM
    versionChecker.scheduleVersionCheck(context, scheduledTime, isLoginPage: true);



    sessionManager.internetcheck().then((hasInternet) async {
      if (hasInternet) {
        Offlinedatacheck();
      }
    });



    getlocation();
    requestBluetoothPermission();
    // appupdate().then((value) {
    getdata().then((_) {
      // appupdate();
      if (appversionstatus == "0") {
        if (_fingerValue == true) {
          validfinger();
        }
      }
      // });
    });
  }

  // Future getVersion() async {
  //
  //   print("version");
  //
  //   PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
  //
  //     currentBuildVersion = packageInfo.version;
  //
  //   });
  //
  // }
  // _checkVersion() async {
  //   getVersion();
  //   print("_checkVersion");
  //   if (Platform.isAndroid) {
  //     _checkPlayStore("com.thinksynq.lithiumsp");
  //   } else if (Platform.isIOS) {
  //     //_checkAppStore("com.thinksynq.lithiumsp");
  //   }
  //
  //   //Getdata();
  // }
  //
  // _checkPlayStore(String packageName) async {
  //   String errorMsg;
  //
  //   final uri = Uri.https(
  //       "play.google.com", "/store/apps/details", {"id": packageName});
  //   try {
  //     final response = await http.get(uri);
  //     print("responsecode${response.statusCode}");
  //     if (response.statusCode != 200) {
  //       errorMsg =
  //       "Can't find an app in the Google Play Store with the id: $packageName";
  //     } else {
  //       PlaystoreVersion = RegExp(r',\[\[\["([0-9,\.]*)"]],')
  //           .firstMatch(response.body)
  //           ?.group(1);
  //       Playstoreurl = uri.toString();
  //       //  newVersionAlert(context!, newVersion!, url);
  //       if (PlaystoreVersion != null) {
  //         if (PlaystoreVersion != currentBuildVersion) {
  //           newVersionAlert(context);
  //         }
  //       }
  //       print(
  //           "PlaystoreVersion = $PlaystoreVersion,\ncurrentBuildVersion = $currentBuildVersion");
  //     }
  //   } catch (e) {
  //     errorMsg = "$e";
  //   }
  // }
  //
  //
  // void newVersionAlert(BuildContext context, {bool isLoginPage = true}) {
  //   showDialog(
  //     barrierDismissible: !isLoginPage, // Allow dismissal only if not on the login page
  //     context: context,
  //     builder: (context) => WillPopScope(
  //       onWillPop: () async => !isLoginPage, // Prevent back navigation on login page
  //       child: AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(20)),
  //         ),
  //         title: Row(
  //           children: [
  //             Icon(
  //               Icons.system_update,
  //               color: HexColor(Colorscommon.greendark),
  //               size: 30,
  //             ),
  //             SizedBox(width: 10),
  //             Text(
  //               'Update Available!',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 22,
  //                 color: HexColor(Colorscommon.greendark),
  //               ),
  //             ),
  //           ],
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Image.asset(
  //                 'assets/lithium123.png',
  //                 width: 175,
  //                 height: 175,
  //               ),
  //               SizedBox(height: 10),
  //           Text(
  //             'For a better experience, please download the latest version of the app!',
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //
  //             ],
  //           ),
  //         ),
  //         actionsAlignment: MainAxisAlignment.center,
  //         actions: <Widget>[
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               backgroundColor: HexColor(Colorscommon.redcolor),
  //             ),
  //             child: Text(
  //               'Update Now',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             onPressed: () async {
  //               openAnyUrl();
  //               //Navigator.pop(context); // Close the dialog after update
  //             },
  //           ),
  //           if (isLoginPage)
  //             TextButton(
  //               style: TextButton.styleFrom(
  //                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 backgroundColor: Colors.grey[300],
  //               ),
  //               child: Text(
  //                 'Later',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog without updating
  //               },
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  //
  // Future<void> openAnyUrl() async {
  //   String url = "https://play.google.com/store/apps/details?id=com.thinksynq.lithiumsp";
  //   if (!await launchUrl(
  //     Uri.parse(url),
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future <void> Offlinedatacheck() async{
    var db = DBHelper();

    List charginlist = await db.getChargingList();

    print('checkvalue${charginlist.isNotEmpty}');
    if(charginlist.isNotEmpty){
      print('inside the value');
      String list = jsonEncode(charginlist);
      print('dat--$list');
      sessionManager.internetcheck().then((intenet) async {
        sendBulkchargingdata(list);
      });
    }
  }


  Future<void> sendBulkchargingdata(String list) async {
    String url = CommonURL.localone; // Your URL as a string

    try {
      // Convert the JSON string to List<dynamic>
      List<dynamic> jsonList = jsonDecode(list);

      // Ensure jsonList is List<Map<String, dynamic>>
      List<Map<String, dynamic>> dataList = jsonList
          .map((item) => item as Map<String, dynamic>) // Ensure each item is Map<String, dynamic>
          .toList();

      Map<String, String> postData = {
        "from": "vechilechargingbulk",
        "data": jsonEncode(dataList),
      };

      Map<String, String> requestHeaders = {
        'Content-type': 'application/hal+json',
        'Accept': 'application/json',
      };

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(postData),
        headers: requestHeaders,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);

        String success = jsonInput['status'].toString();
        String message = jsonInput['message'];

        if (success == 'true') {
          print('Data message: $message');
          db.deletechargetTable();
        } else {
          print('Message: $message');
        }
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Exception: ${e.message}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }



  Future _checkGps() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Can't Get Current Location"),
            content: const Text('Please Make Sure You Enable GPS & Try Again'),
            actions: <Widget>[
              TextButton(
                child: const Text('ok'),
                onPressed: () {
                  // const AndroidIntent intent = AndroidIntent(
                  //     action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                  // intent.launch();
                  // Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Future<void> main(String id) async {
  //   print("kjcblkwhf");
  //   final cron = Cron()
  //     ..schedule(Schedule.parse('*/30 * * * *'), () {
  //       sessionManager.set30mins(getCurrentDateTime().toString());
  //       getlocation().then((value) => {
  //             locationupdate(_locationData.latitude.toString(),
  //                 _locationData.longitude.toString(), id)
  //           });
  //     });
  //   await Future.delayed(const Duration(seconds: 20));
  //   // await cron.close();
  // }

  Future<void> main(String id) async {
    print("kjcblkwhf");
    final cron = Cron()
      ..schedule(Schedule.parse('*/30 * * * *'), () {
        sessionManager.set30mins(getCurrentDateTime().toString());
        getlocation().then((value) => {
          locationupdate(_locationData.latitude.toString(),
              _locationData.longitude.toString(), id)
        });
      });
    await Future.delayed(const Duration(seconds: 20));
    // await cron.close();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Touch your finger on the sensor to login',
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      // Fluttertoast.showToast(msg:"$e");
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';

        if (e.message == "Authentication in progress") {
          print(e.message);
        } else {
          Fluttertoast.showToast(msg: e.message.toString());
        }
      });
      return;
    }

    if (authenticated == true) {
      nameController.text = username;
      passwordController.text = password;
      sessionManager.internetcheck().then((hasInternet) async {
        if (hasInternet) {
          checkupdate(_30minstr);
          loading();
          Loginapi(serveruuid, serverstate);
        } else {
          showTopSnackBar(
            Overlay.of(context), // get OverlayState from context
            const CustomSnackBar.error(
              message: "Please Check Your Internet Connection",
            ),
            displayDuration: const Duration(seconds: 3), // optional
            animationDuration: const Duration(milliseconds: 700), // optional
          );
        }
      });
      // loading();
      // Loginapi(serveruuid, serverstate);
    }
    if (!mounted) {
      return;
    }

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.pleaseclickback);
      return Future.value(false);
    }
    exit(0);
    return Future.value(true);
  }

  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // dialogContext = context;
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*  new CircularProgressIndicator(
                 valueColor: new AlwaysStoppedAnimation(Colors.red),
               ),*/

                Image.asset(
                  'assets/lithiugif.gif',
                  width: 50,
                  // color: HexColor(Colorscommon.greencolor),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text("Loading")),
              ],
            ),
          ),
        );
      },
    );
  }

  // appupdate() async {
  //   String url = CommonURL.URL;
  //
  //   Map<String, String> postdata = {
  //     "from": "getAppVersion",
  //
  //     // "dateTime": "15-03-2022 13:04:15"
  //   };
  //
  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/hal+json',
  //     'Accept': 'application/json',
  //   };
  //
  //   final response = await http.post(Uri.parse(url),
  //       body: jsonEncode(postdata), headers: requestHeaders);
  //   // print(response.statusCode.toString());
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //
  //     print('playstore update version =$jsonInput');
  //
  //     String status = jsonInput['status'].toString();
  //
  //     if (status == 'true') {
  //       String andriodVersion =
  //       jsonInput["result"][0]['andriod_version'].toString();
  //       print('andriodVersion =$andriodVersion');
  //
  //       if (andriodVersion == "2.0.4") { //1.26 //1.9//2.0.4
  //         appversionstatus = "0";
  //       } else {
  //         appversionstatus = "1";
  //         setState(() {});
  //         _showMyDialog();
  //       }
  //
  //       // setState(() {
  //       //   print(" app need to update");
  //       // });
  //     } else {}
  //   }
  // }

  // Future<void> _showMyDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //         onWillPop: () async => false,
  //         child: AlertDialog(
  //           title: const Text('UPDATE!!!'),
  //           content: const SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text('For Better Experience please download latest version!'),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text(
  //                 'Update',
  //                 style: TextStyle(color: HexColor(Colorscommon.redcolor)),
  //               ),
  //               onPressed: () async {
  //                 // Navigator.of(context).pop();
  //                 String Url = CommonURL.APP_UPDATE_PATH;
  //                 print('Url$Url');
  //                 _launchURL(Url);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _launchURL(String Uri) async {
    launch(Uri);

    // if(await can)
  }

  void checkupdate(String min) async {
    String url = CommonURL.URL;
    //print("_30minqwfac$_30min");
    Map<String, String> postdata = {
      "from": "validateTimeSlot",
      "dateTime": min,
      "languageType":AppLocalizations.of(context)!.languagecode.toString(),
      // "dateTime": "15-03-2022 13:04:15"
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);
    //print(response.statusCode.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      //print('Passwordchnageresponse$jsonInput');

      String status = jsonInput['status'].toString();

      if (status == 'true') {
        setState(() {
          validate30min = "true";
        });

        // Fetchdata2();
      } else {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Login(),
        //     ));
      }
    }
  }

  String getCurrentDateTime() {
    final String dateTime =
    DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()).toString();
    String Valdate = dateTime;
    return Valdate;
  }

  @override
  void dispose() {
    // if (_locationSubscription != null) {
    //   _locationSubscription.cancel();
    // }
    super.dispose();
  }

  Future<void> requestBluetoothPermission() async {
    // Check and request Bluetooth permission using the `permission_handler` package
    if (await permissionHandler.Permission.bluetooth.status.isDenied) {
      final bluetoothStatus = await permissionHandler.Permission.bluetooth.request();
      if (!bluetoothStatus.isGranted) {
        print("Bluetooth permission denied.");
        return;
      }
    }

    print("Bluetooth permission granted.");
    // You can add any Bluetooth-related functionality here if permissions are granted.
  }


  Future<void> getlocation() async {
    _serviceEnabled = await location.serviceEnabled();
    print("_serviceEnabled$_serviceEnabled");
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  // __30minlocationToUser() async {
  //   location.changeSettings(interval: 1, distanceFilter: 0);
  //   // //print(_locationSubscription);
  //   location.onLocationChanged().listen((newData) {
  //     //print("locationdatas$newData");
  //     LocationData locationdata = newData;
  //     //print(locationdata.latitude);
  //     //print(locationdata.longitude);

  //     // //print("locationdatas$_locationSubscription");
  //     // __30minlocationToUser();
  //   });
  // }

  void ForgotPassword() {
    emailorphonecontroller.text = "";
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 20),
      builder: (BuildContext context) {
        dialogContext_password = context;

        return Dialog(
          insetPadding: const EdgeInsets.all(5),

          // padding: const EdgeInsets.all(5.0),
          child: Container(
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Avenirtextblack(
                    customfontweight: FontWeight.normal,
                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                        ? 12
                        : 14,
                    text: AppLocalizations.of(context)!.forgot_Password,
                    textcolor: HexColor(Colorscommon.greendark2),
                  ),
                  // child: GradientText(
                  //   "Forgot Password",
                  //   18,
                  //   gradient: LinearGradient(colors: [
                  //     HexColor(Colorscommon.greendark2),
                  //     HexColor(Colorscommon.greendark2),
                  //   ]),
                  // ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 0, right: 0),
                  decoration: const BoxDecoration(
                    // border: Border(bottom: BorderSide(color: Colors.grey))
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: HexColor(Colorscommon.greencolor)),
                    child: TextField(
                      controller: emailorphonecontroller,
                      maxLength: 10,
                      keyboardType: TextInputType.number,

                      // obscureText: true,
                      style: TextStyle(
                          color: HexColor(Colorscommon.greydark2),
                          fontFamily: 'TomaSans-Regular',
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.start,

                      //  controller: usernameController,
                      decoration: InputDecoration(
                        counterText: "",
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!
                            .enter_registered_phone_number,
                        labelStyle: TextStyle(
                          fontFamily: 'AvenirLTStd-Book',
                          fontSize: (AppLocalizations.of(context)!.id ==
                              "ஐடி" ||
                              AppLocalizations.of(context)!.id == "आयडी" ||
                              AppLocalizations.of(context)!.id == "ಐಡಿ")
                              ? 12
                              : 14,
                          color: HexColor(Colorscommon.greydark2),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Bouncing(
                        onPress: () {
                          if (emailorphonecontroller.text.isNotEmpty) {
                            sessionManager
                                .internetcheck()
                                .then((intenet) async {
                              if (intenet) {
                                //utility.showYourpopupinternetstatus(context);
                                loading();
                                ForgotpasswordAPI(context);
                              } else {
                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)!
                                      .pleasecheckinternetconnection,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)!
                                  .enter_vaildphone,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          }
                        },
                        child: Container(
                          margin:
                          const EdgeInsets.only(top: 20, left: 0, right: 0),
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [
                                HexColor(Colorscommon.greenlight2),
                                HexColor(Colorscommon.greenlight2)
                              ])),
                          child: Center(
                            child: Avenirtextblack(
                                text: AppLocalizations.of(context)!.confirm,
                                fontsize: (AppLocalizations.of(context)!.id ==
                                    "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ")
                                    ? 10
                                    : 14,
                                textcolor: Colors.white,
                                customfontweight: FontWeight.bold),

                            //     child: Text(
                            //   "Confirm",
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontFamily: 'Lato',
                            //       fontWeight: FontWeight.bold),
                            // )
                          ),
                        ),
                      ),
                      Bouncing(
                        onPress: () {
                          Navigator.pop(dialogContext_password);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 10, right: 0),
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: HexColor(Colorscommon.greenlight2))),
                          child: Center(
                            child: Avenirtextblack(
                                text: AppLocalizations.of(context)!.close,
                                fontsize: (AppLocalizations.of(context)!.id ==
                                    "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ")
                                    ? 10
                                    : 14,
                                textcolor: HexColor(Colorscommon.greenlight2),
                                customfontweight: FontWeight.bold),
                            //     child: Text(
                            //   "Close",
                            //   style: TextStyle(
                            //       color: HexColor(Colorscommon.greenlight2),
                            //       fontFamily: 'Lato',
                            //       fontWeight: FontWeight.bold),
                            // )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  validfinger() {
    String number = username;

    newUserdata = number;
    // print('newUserdata$newUserdata');

    String replaceCharAt(String oldString, int index, String newChar) {
      return oldString.substring(0, index) +
          newChar +
          oldString.substring(index + 1);
    }

    for (int i = 4; i < number.length; i++) {
      newUserdata = replaceCharAt(newUserdata, i, "*");
      print("User name with * =$newUserdata");
    }
    if (newUserdata != '') {
      _showBottomsheet();
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.employeeidpassword);
    }
  }

  void ForgotpasswordAPI(BuildContext context) async {
    String url = CommonURL.URL;
    Map<String, String> postdata = {
      "from": "driversGetVerificationCode",
      "emailOrMobile": emailorphonecontroller.text,
      "languageType":AppLocalizations.of(context)!.languagecode.toString(),
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    debugPrint('fetchdata $url');
    debugPrint('fetchdata $postdata');

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);

    //print("${response.statusCode}");
    //print("${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      debugPrint('jsoninput $jsonInput');

      String success = jsonInput['success'].toString();
      String message = jsonInput['message'];
      // debugPrint('Location_success $success');
      // debugPrint('Location_message $message');

      Navigator.pop(context);

      if (success == '1') {
        String idDriverr = jsonInput['id_user'].toString();
        // String lithiumId = jsonInput['lithium_id'].toString();
        // String idSupervisor = jsonInput['id_supervisor'].toString();

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgotPasswordClass(
                text: emailorphonecontroller.text,
                id_driver: idDriverr,
              ),
            ));
        return Future.value(true);
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      debugPrint('SERVER=FAILED');

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.somethingwentwrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  // void click() {}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   // title: Text(MyApp.title),
      //   centerTitle: true,
      //   actions: [
      //     LanguagePickerWidget(),
      //     const SizedBox(width: 12),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: onWillPop,
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LanguagePickerWidget(
                        fontsizeprefeerd: 15,
                      ),
                      Icon(Icons.language_sharp),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),

                // Padding(
                //   padding: EdgeInsets.only(top: 8, left: 0),
                //   child: Container(width: 100, child: LanguagePickerWidget()),
                // ),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Center(
                        child: Image(
                          width: size.width / 1.8,
                          image: const AssetImage("assets/lithium123.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // margin: const EdgeInsets.all(30),
                      // decoration: const BoxDecoration(
                      //   color: Colors.white,
                      //   image: DecorationImage(
                      //     image: AssetImage("assets/lithiumimg.png"),
                      //     fit: BoxFit.cover,
                      //     // scale: 30,
                      //   ),
                      // ),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: ClipPath(
                      clipper: CurvedBottomClipper(),
                      child: Container(
                        color: HexColor(Colorscommon.greendark),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, bottom: 5),
                                child: Row(children: [
                                  Avenirtextblack(
                                    text: AppLocalizations.of(context)!.id,
                                    fontsize: (AppLocalizations.of(context)!
                                        .id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ")
                                        ? 12
                                        : 14,
                                    textcolor: HexColor(Colorscommon.greylight),
                                    customfontweight: FontWeight.bold,
                                  )
                                  // Text(
                                  //   AppLocalizations.of(context)!.id,
                                  //   style: TextStyle(
                                  //       color: HexColor(Colorscommon.greylight),
                                  //       fontWeight: FontWeight.bold),
                                  // )
                                ])),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 5),
                              child: TextFormField(
                                controller: nameController,
                                textCapitalization:
                                TextCapitalization.characters,
                                style: TextStyle(
                                  fontFamily: 'AvenirLTStd-Book',
                                  fontSize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                      AppLocalizations.of(context)!.id ==
                                          "आयडी" ||
                                      AppLocalizations.of(context)!.id ==
                                          "ಐಡಿ")
                                      ? 12
                                      : 14,
                                  color: HexColor(Colorscommon.greydark2),
                                ),
                                cursorColor: HexColor(Colorscommon.greenlight), // Set the cursor color here

                                decoration: InputDecoration(
                                  hintText:
                                  AppLocalizations.of(context)!.your_ID,
                                  hintStyle: TextStyle(
                                    fontFamily: 'AvenirLTStd-Book',
                                    fontSize: (AppLocalizations.of(context)!
                                        .id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ")
                                        ? 12
                                        : 14,
                                    color: HexColor(Colorscommon.greydark2),
                                  ),

                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: HexColor(Colorscommon.greenlight),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 20, bottom: 5, top: 5, right: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: HexColor(Colorscommon.greydark2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: HexColor(Colorscommon.blackcolor),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: HexColor(Colorscommon.greendark2),
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 15, bottom: 5),
                                child: Row(children: [
                                  Avenirtextblack(
                                    text:
                                    AppLocalizations.of(context)!.password,
                                    fontsize: (AppLocalizations.of(context)!
                                        .id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ")
                                        ? 12
                                        : 14,
                                    textcolor: HexColor(Colorscommon.greylight),
                                    customfontweight: FontWeight.bold,
                                  )
                                  // Text(
                                  //   "Password",
                                  //   style: TextStyle(
                                  //       color:
                                  //           HexColor(Colorscommon.greylight2),
                                  //       fontFamily: "Avenir",
                                  //       fontWeight: FontWeight.bold),
                                  // )
                                ])),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 10),
                              child: TextFormField(
                                controller: passwordController,
                                style: TextStyle(
                                  fontFamily: 'AvenirLTStd-Book',
                                  fontSize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                      AppLocalizations.of(context)!.id ==
                                          "आयडी" ||
                                      AppLocalizations.of(context)!.id ==
                                          "ಐಡಿ")
                                      ? 12
                                      : 14,
                                  color: HexColor(Colorscommon.greydark2),
                                ),
                                obscureText: _obscureText,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .yourPassword,
                                  hintStyle: TextStyle(
                                    fontFamily: 'AvenirLTStd-Book',
                                    fontSize: (AppLocalizations.of(context)!
                                        .id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ")
                                        ? 12
                                        : 14,
                                    color: HexColor(Colorscommon.greydark2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: HexColor(Colorscommon.greenlight),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: HexColor(Colorscommon.greylight),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 20, bottom: 5, top: 5, right: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: HexColor(Colorscommon.greydark2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: HexColor(Colorscommon.blackcolor),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: HexColor(Colorscommon.greendark2),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Container(
                            //   alignment: Alignment.center,
                            //   margin: const EdgeInsets.symmetric(horizontal: 40),
                            //   child: TextField(
                            //     controller: nameController,
                            //     decoration: InputDecoration(
                            //       labelText: "Username",
                            //       labelStyle:
                            //           TextStyle(color: HexColor(Colorscommon.greencolor)),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: size.height * 0.03),
                            // Visibility(
                            //   visible: showfinger,
                            //   child: Container(
                            //     // width: 260,
                            //     height: 70,
                            //     padding: const EdgeInsets.all(10),
                            //     child: TextField(
                            //       controller: passwordController,
                            //       obscureText: true,
                            //       decoration: InputDecoration(
                            //           suffixIcon: IconButton(
                            // onPressed: () {
                            //   setState(() {
                            //     if (_fingerValue == false) {
                            //       Fluttertoast.showToast(
                            //           msg: "Please enable fingerprint");
                            //       Navigator.of(context).push(MaterialPageRoute(
                            //           builder: (context) => Settings()));
                            //     } else {
                            //       // _authenticate();
                            //       // utility.GetUserdata();
                            //       // String username =
                            //       //     utility.Username;
                            //       String number = username;

                            //       newUserdata = number;
                            //       // print('newUserdata$newUserdata');

                            //       String replaceCharAt(String oldString,
                            //           int index, String newChar) {
                            //         return oldString.substring(0, index) +
                            //             newChar +
                            //             oldString.substring(index + 1);
                            //       }

                            //       for (int i = 4; i < number.length; i++) {
                            //         newUserdata =
                            //             replaceCharAt(newUserdata, i, "*");
                            //         print("User name with * =$newUserdata");
                            //       }
                            //       if (newUserdata != '' &&
                            //           newUserdata != null) {
                            //         _showBottomsheet();
                            //       } else {
                            //         Fluttertoast.showToast(
                            //             msg:
                            //                 "Please enter EMPLOYEE ID and PASSWORD");
                            //       }
                            //     }
                            //   });
                            // },
                            //               icon: Icon(
                            //                 Icons.fingerprint,
                            //                 color: HexColor(Colorscommon.greycolor),
                            //               )),

                            //           // suffix: GestureDetector(
                            //           //   onTap: () {},
                            //           //   child: Icon(
                            //           //     FontAwesomeIcons.eyeSlash,
                            //           //     color: HexColor(Colorscommon.greencolor),
                            //           //   ),
                            //           // ),
                            //           // labelStyle: TextStyle(fontFamily: "Lato"),
                            //           labelText: "Password",
                            //           border: OutlineInputBorder(
                            //             borderRadius: BorderRadius.all(Radius.circular(8)),
                            //           )),
                            //     ),
                            //   ),
                            // ),
                            // Visibility(
                            //   visible: showfinger,
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     margin: const EdgeInsets.symmetric(horizontal: 40),
                            //     child: TextField(
                            //       controller: passwordController,
                            //       obscureText: true,
                            //       decoration: InputDecoration(
                            //         suffixIcon: IconButton(
                            //             onPressed: () {
                            //               setState(() async {
                            //                 if (_fingerValue == false) {
                            //                   SharedPreferences prefs =
                            //                       await SharedPreferences.getInstance();
                            //                   setState(() {
                            //                     prefs.setString('Fingershow', "");
                            //                     print('set-fp = $_fingerValue');
                            //                   });
                            //                   Fluttertoast.showToast(
                            //                       msg: "Please Enable Fingerprint");
                            //                   Navigator.of(context).push(MaterialPageRoute(
                            //                       builder: (context) => const Settings()));
                            //                 } else {
                            //                   SharedPreferences prefs =
                            //                       await SharedPreferences.getInstance();
                            //                   setState(() {
                            //                     prefs.setString('Fingershow', "1234");
                            //                     print('set-fp = $_fingerValue');
                            //                   });
                            //                   // _authenticate();
                            //                   // utility.GetUserdata();
                            //                   // String username =
                            //                   //     utility.Username;
                            //                   String number = username;

                            //                   newUserdata = number;
                            //                   // print('newUserdata$newUserdata');

                            //                   String replaceCharAt(String oldString,
                            //                       int index, String newChar) {
                            //                     return oldString.substring(0, index) +
                            //                         newChar +
                            //                         oldString.substring(index + 1);
                            //                   }

                            //                   for (int i = 4; i < number.length; i++) {
                            //                     newUserdata =
                            //                         replaceCharAt(newUserdata, i, "*");
                            //                     print("User name with * =$newUserdata");
                            //                   }
                            //                   if (newUserdata != '') {
                            //                     _showBottomsheet();
                            //                   } else {
                            //                     Fluttertoast.showToast(
                            //                         msg:
                            //                             "Please Enter EMPLOYEE ID & PASSWORD");
                            //                   }
                            //                 }
                            //               });
                            //             },
                            //             icon: Icon(
                            //               Icons.fingerprint,
                            //               color: HexColor(Colorscommon.greycolor),
                            //             )),

                            //         // suffix: GestureDetector(
                            //         //   onTap: () {},
                            //         //   child: Icon(
                            //         //     FontAwesomeIcons.eyeSlash,
                            //         //     color: HexColor(Colorscommon.greencolor),
                            //         //   ),
                            //         // ),
                            //         // labelStyle: TextStyle(fontFamily: "Lato"),
                            //         labelStyle:
                            //             TextStyle(color: HexColor(Colorscommon.greencolor)),
                            //         labelText: "Password",
                            //       ),
                            //       // decoration: InputDecoration(
                            //       //     labelText: "Password",
                            //       //     labelStyle: TextStyle(color: HexColor(Colorscommon.greencolor))),
                            //       // obscureText: true,
                            //     ),
                            //   ),
                            // ),
                            // Visibility(
                            //   visible: !showfinger,
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     margin: const EdgeInsets.symmetric(horizontal: 40),
                            //     child: TextField(
                            //       controller: passwordController,
                            //       decoration: InputDecoration(
                            //           labelText: "Password",
                            //           labelStyle: TextStyle(
                            //               color: HexColor(Colorscommon.greencolor))),
                            //       obscureText: true,
                            //     ),
                            //   ),
                            // ),
                            // Bouncing(
                            //   onPress: () {
                            //     ForgotPassword();
                            //   },
                            //   child: Container(
                            //     alignment: Alignment.centerRight,
                            //     margin:
                            //         const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            //     child: Text(
                            //       "Forgot your password?",
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //         fontWeight: FontWeight.w600,
                            //         color: HexColor(Colorscommon.greencolor),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: size.height * 0.05),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      ForgotPassword();
                                    },
                                    child: Avenirtextbook(
                                      customfontweight: FontWeight.normal,
                                      fontsize: 12,
                                      text: AppLocalizations.of(context)!
                                          .forgot_Password +
                                          " ?",
                                      textcolor:
                                      HexColor(Colorscommon.whitecolor),
                                    ),
                                    // child: Text(
                                    //   "Forgot Password ?",
                                    //   style: TextStyle(
                                    //       fontFamily: 'TomaSans-Regular',
                                    //       fontWeight: FontWeight.w300,
                                    //       color: HexColor(
                                    //           Colorscommon.whitecolor)),
                                    // ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              // ignore: deprecated_member_use
                              child: Row(
                                children: [
                                  Bouncing(
                                    onPress: () async {
                                      final SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                      String serveruuid =
                                          pref.getString("serveruuid") ?? "";
                                      String serverstate =
                                          pref.getString("state") ?? "";
                                      //print("uuiddata$serveruuid");
                                      //print("serverstatedata$serverstate");
                                      if (nameController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: AppLocalizations.of(context)!
                                              .pleaseentername,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      } else if (passwordController
                                          .text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: AppLocalizations.of(context)!
                                              .pleaseenterpassword,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      } else {
                                        sessionManager
                                            .internetcheck()
                                            .then((intenet) async {
                                          if (intenet) {
                                            //utility.showYourpopupinternetstatus(context);
                                            checkupdate(_30minstr);
                                            print('online');

                                            loading();
                                            Loginapi(serveruuid, serverstate);
                                          } else {
                                            print('offline check');
                                            offlineLogin();
                                            /*showTopSnackBar(
                                             context,
                                             const CustomSnackBar.error(
                                               // icon: Icon(Icons.interests),
                                               message:
                                               "Please Check Your Internet Connection",
                                               // backgroundColor: Colors.white,
                                               // textStyle: TextStyle(color: Colors.red),
                                             ),
                                           );*/
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40.0,
                                      width: size.width * 0.7,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          gradient: LinearGradient(colors: [
                                            HexColor(Colorscommon.greenlight2),
                                            HexColor(Colorscommon.greenlight2)
                                          ])),
                                      padding: const EdgeInsets.all(0),
                                      child: Avenirtextblack(
                                          text: AppLocalizations.of(context)!
                                              .sign_in,
                                          fontsize: (AppLocalizations.of(
                                              context)!
                                              .id ==
                                              "ஐடி" ||
                                              AppLocalizations.of(context)!
                                                  .id ==
                                                  "आयडी" ||
                                              AppLocalizations.of(context)!
                                                  .id ==
                                                  "ಐಡಿ")
                                              ? 12
                                              : 14,
                                          textcolor: Colors.white,
                                          customfontweight: FontWeight.bold),
                                      // child: const Text(
                                      //   "Sign in",
                                      //   textAlign: TextAlign.center,
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.bold,
                                      //       color: Colors.white),
                                      // ),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   width: 20,
                                  // ),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent),
                                      onPressed: () {
                                        if (_fingerValue == false) {
                                          Fluttertoast.showToast(
                                              msg: AppLocalizations.of(context)!
                                                  .pleaseenablefingerprint);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const Settings()));
                                        } else {
                                          // _authenticate();
                                          // utility.GetUserdata();
                                          // String username =
                                          //     utility.Username;
                                          String number = username;

                                          newUserdata = number;
                                          // print('newUserdata$newUserdata');

                                          String replaceCharAt(String oldString,
                                              int index, String newChar) {
                                            return oldString.substring(
                                                0, index) +
                                                newChar +
                                                oldString.substring(index + 1);
                                          }

                                          for (int i = 4;
                                          i < number.length;
                                          i++) {
                                            newUserdata = replaceCharAt(
                                                newUserdata, i, "*");
                                            print(
                                                "User name with * =$newUserdata");
                                          }
                                          if (newUserdata != '') {
                                            _showBottomsheet();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(
                                                    context)!
                                                    .employeeidpassword);
                                          }
                                        }
                                      },
                                      child: Center(
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/Biometric.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // child: IconButton(
                                      // icon:
                                      //     Image.asset('assets/Biometric.png'),
                                      //      size: 50.0,

                                      // tooltip: 'Closes application',
                                      //   onPressed: () => exit(0),
                                      //   // child: Icon(
                                      //   //   Icons.fingerprint,
                                      //   //   color:
                                      //   //       HexColor(Colorscommon.whitecolor),
                                      //   //   size: 40,
                                      //   // ),
                                      // ),
                                    ),
                                  )
                                  // Bouncing(
                                  //   onPress: () {
                                  //     print("value12345");
                                  //     // setState(() {

                                  //     // });
                                  //   },
                                  //   child: Container(
                                  //     padding:
                                  //         const EdgeInsets.only(right: 25, top: 0),
                                  //     alignment: Alignment.center,
                                  //     height: 40,
                                  //     width: 40,
                                  //     child: Icon(
                                  //       Icons.fingerprint,
                                  //       color: HexColor(Colorscommon.whitecolor),
                                  //       size: 40,
                                  //     ),
                                  //     // decoration: BoxDecoration(
                                  //     //     borderRadius: BorderRadius.circular(5.0),
                                  //     //     gradient: LinearGradient(colors: [
                                  //     //       HexColor(Colorscommon.greenApp2color),
                                  //     //       HexColor(Colorscommon.greenApp2color)
                                  //     //     ])),
                                  //     // padding: const EdgeInsets.all(0),
                                  //     // child: const Text(
                                  //     //   "LOGIN",
                                  //     //   textAlign: TextAlign.center,
                                  //     //   style: TextStyle(
                                  //     //       fontWeight: FontWeight.bold,
                                  //     //       color: Colors.white),
                                  //   ),
                                  // ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // child: SingleChildScrollView(
          //   child: Container(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //             begin: Alignment.topLeft,
          //             end: Alignment.bottomRight,
          //             colors: [
          //           // HexColor(Colorscommon.grey_low),
          //           HexColor(Colorscommon.grey_low),
          //           HexColor(Colorscommon.greencolor),
          //           // HexColor(Colorscommon.grey_low),
          //           // Colors.purpleAccent,
          //           // Colors.amber,
          //           // Colors.blue,
          //         ])),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         // const SizedBox(
          //         //   height: 50,
          //         // ),
          //         // SizedBox(
          //         //   height: 200,
          //         //   // child: LottieBuilder.asset("assets/lottie/login2.json"),
          //         // ),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         Container(
          //           width: 325,
          //           height: 400,
          //           decoration: const BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.all(Radius.circular(15)),
          //           ),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               // const SizedBox(
          //               //   height: 30,
          //               // ),
          //               Container(
          //                   width: 100,
          //                   height: 100,
          //                   child: Image.asset('assets/lith.png')),
          //               // Text(
          //               //   "SFDC IDP",
          //               //   style: TextStyle(
          //               //       color: HexColor(Colorscommon.greencolor),
          //               //       fontSize: 28,
          //               //       fontWeight: FontWeight.bold),
          //               // ),
          //               // const SizedBox(
          //               //   height: 10,
          //               // ),
          //               // Container(
          //               //     width: 100,
          //               //     height: 100,
          //               //     decoration: const BoxDecoration(
          //               //         shape: BoxShape.circle,
          //               //         image: DecorationImage(
          //               //             fit: BoxFit.fill,
          //               //             image: NetworkImage(
          //               //                 "https://i.imgur.com/BoN9kdC.png")))),
          //               // const Text(
          //               //   "Please Login to Your Account",
          //               //   style: TextStyle(
          //               //     color: Colors.grey,
          //               //     fontSize: 15,
          //               //   ),
          //               // ),
          //               const SizedBox(
          //                 height: 30,
          //               ),
          //               Container(
          //                 padding: EdgeInsets.all(10),
          //                 // width: 260,
          //                 height: 70,
          //                 child: TextField(
          //                   controller: nameController,
          //                   decoration: const InputDecoration(
          //                       labelText: "User Name",
          //                       border: OutlineInputBorder(
          //                         borderRadius:
          //                             BorderRadius.all(Radius.circular(8)),
          //                       )),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 height: 12,
          //               ),
          // Visibility(
          //   visible: showfinger,
          //   child: Container(
          //     // width: 260,
          //     height: 70,
          //     padding: const EdgeInsets.all(10),
          //     child: TextField(
          //       controller: passwordController,
          //       obscureText: true,
          //       decoration: InputDecoration(
          //           suffixIcon: IconButton(
          //               onPressed: () {
          //                 setState(() {
          //                   if (_fingerValue == false) {
          //                     Fluttertoast.showToast(
          //                         msg: "Please enable fingerprint");
          //                     Navigator.of(context).push(
          //                         MaterialPageRoute(
          //                             builder: (context) =>
          //                                 Settings()));
          //                   } else {
          //                     // _authenticate();
          //                     // utility.GetUserdata();
          //                     // String username =
          //                     //     utility.Username;
          //                     String number = username;

          //                     newUserdata = number;
          //                     // print('newUserdata$newUserdata');

          //                     String replaceCharAt(String oldString,
          //                         int index, String newChar) {
          //                       return oldString.substring(
          //                               0, index) +
          //                           newChar +
          //                           oldString.substring(index + 1);
          //                     }

          //                     for (int i = 4;
          //                         i < number.length;
          //                         i++) {
          //                       newUserdata = replaceCharAt(
          //                           newUserdata, i, "*");
          //                       print(
          //                           "User name with * =$newUserdata");
          //                     }
          //                     if (newUserdata != '' &&
          //                         newUserdata != null) {
          //                       _showBottomsheet();
          //                     } else {
          //                       Fluttertoast.showToast(
          //                           msg:
          //                               "Please enter EMPLOYEE ID and PASSWORD");
          //                     }
          //                   }
          //                 });
          //               },
          //               icon: Icon(
          //                 Icons.fingerprint,
          //                 color: HexColor(Colorscommon.greycolor),
          //               )),

          //           // suffix: GestureDetector(
          //           //   onTap: () {},
          //           //   child: Icon(
          //           //     FontAwesomeIcons.eyeSlash,
          //           //     color: HexColor(Colorscommon.greencolor),
          //           //   ),
          //           // ),
          //           // labelStyle: TextStyle(fontFamily: "Lato"),
          //           labelText: "Password",
          //           border: OutlineInputBorder(
          //             borderRadius:
          //                 BorderRadius.all(Radius.circular(8)),
          //           )),
          //     ),
          //   ),
          // ),
          //               Visibility(
          //                 visible: !showfinger,
          //                 child: Container(
          //                   // width: 260,
          //                   height: 70,
          //                   padding: const EdgeInsets.all(10),
          //                   child: TextField(
          //                     controller: passwordController,
          //                     obscureText: true,
          //                     decoration: const InputDecoration(

          //                         // suffix: GestureDetector(
          //                         //   onTap: () {},
          //                         //   child: Icon(
          //                         //     FontAwesomeIcons.eyeSlash,
          //                         //     color: HexColor(Colorscommon.greencolor),
          //                         //   ),
          //                         // ),
          //                         // labelStyle: TextStyle(fontFamily: "Lato"),
          //                         labelText: "Password",
          //                         border: OutlineInputBorder(
          //                           borderRadius:
          //                               BorderRadius.all(Radius.circular(8)),
          //                         )),
          //                   ),
          //                 ),
          //               ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       TextButton(
          //         onPressed: () {
          //           ForgotPassword();
          //         },
          //         child: Text(
          //           "Forgot Password",
          //           style: TextStyle(
          //               fontFamily: 'TomaSans-Regular',
          //               fontWeight: FontWeight.bold,
          //               color: HexColor(Colorscommon.greencolor)),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          //               Bouncing(
          //                   child: Container(
          //                     alignment: Alignment.center,
          //                     width: 250,
          //                     decoration: BoxDecoration(
          //                         borderRadius:
          //                             const BorderRadius.all(Radius.circular(50)),
          //                         gradient: LinearGradient(
          //                             begin: Alignment.centerLeft,
          //                             end: Alignment.centerRight,
          //                             colors: [
          //                               HexColor(Colorscommon.greencolor),
          //                               HexColor(Colorscommon.greencolor),
          //                               // Color(0xFF8A2387),
          //                               // Color(0xFFE94057),
          //                               // Color(0xFFF27121),
          //                             ])),
          //                     child: const Padding(
          //                       padding: EdgeInsets.all(12.0),
          //                       child: Text(
          //                         'Login',
          //                         style: TextStyle(
          //                             color: Colors.white,
          //                             fontSize: 17,
          //                             fontFamily: 'TomaSans-Regular',
          //                             fontWeight: FontWeight.bold),
          //                       ),
          //                     ),
          //                   ),
          // onPress: () async {
          // final SharedPreferences pref =
          //     await SharedPreferences.getInstance();
          // String serveruuid =
          //     pref.getString("serveruuid") ?? "";
          // String serverstate = pref.getString("state") ?? "";
          // //print("uuiddata$serveruuid");
          // //print("serverstatedata$serverstate");
          // if (nameController.text.isEmpty) {
          //   Fluttertoast.showToast(
          //     msg: "Please enter username",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //   );
          // } else if (passwordController.text.isEmpty) {
          //   Fluttertoast.showToast(
          //     msg: "Please enter password",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //   );
          // } else {
          //   sessionManager
          //       .internetcheck()
          //       .then((intenet) async {
          //     if (intenet != null && intenet) {
          //       checkupdate(_30minstr);

          //       loading();
          //       Loginapi(serveruuid, serverstate);
          //     } else {
          //       showTopSnackBar(
          //         context,
          //         const CustomSnackBar.error(
          //           // icon: Icon(Icons.interests),
          //           message:
          //               "Please check your internet connection",
          //           // backgroundColor: Colors.white,
          //           // textStyle: TextStyle(color: Colors.red),
          //         ),
          //       );
          //     }
          //   });

          //                       // Loginapi(serveruuid, serverstate);
          //                     }
          //                   }),
          //               // GestureDetector(
          //               //   onTap: () async {
          //               //     //  Future<String> getLoginUserdetails() async {
          //               //     final SharedPreferences pref =
          //               //         await SharedPreferences.getInstance();
          //               //     String data = pref.getString("serveruuid") ?? "";
          //               //     String state = pref.getString("state") ?? "";
          //               //     //print("uuiddata$data");
          //               //     //print("serverstatedata$state");

          //               //     // }
          //               //   },
          //               //   child: Container(
          //               //     alignment: Alignment.center,
          //               //     width: 250,
          //               //     decoration: BoxDecoration(
          //               //         borderRadius: BorderRadius.all(Radius.circular(50)),
          //               //         gradient: LinearGradient(
          //               //             begin: Alignment.centerLeft,
          //               //             end: Alignment.centerRight,
          //               //             colors: [
          //               //               HexColor(Colorscommon.greencolor),
          //               //               HexColor(Colorscommon.greencolor),
          //               //               // Color(0xFF8A2387),
          //               //               // Color(0xFFE94057),
          //               //               // Color(0xFFF27121),
          //               //             ])),
          //               //     child: const Padding(
          //               //       padding: EdgeInsets.all(12.0),
          //               //       child: Text(
          //               //         'Login',
          //               //         style: TextStyle(
          //               //             color: Colors.white,
          //               //             fontSize: 20,
          //               //             fontWeight: FontWeight.bold),
          //               //       ),
          //               //     ),
          //               //   ),
          //               // ),
          //               const SizedBox(
          //                 height: 17,
          //               ),
          //               // const Text(
          //               //   "Or Login using Social Media Account",
          //               //   style: TextStyle(fontWeight: FontWeight.bold),
          //               // ),
          //               // const SizedBox(
          //               //   height: 15,
          //               // ),
          //               // Row(
          //               //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               //   children: [
          //               //     IconButton(
          //               //         onPressed: click,
          //               //         icon: const Icon(FontAwesomeIcons.facebook,
          //               //             color: Colors.blue)),
          //               //     IconButton(
          //               //         onPressed: click,
          //               //         icon: const Icon(
          //               //           FontAwesomeIcons.google,
          //               //           color: Colors.redAccent,
          //               //         )),
          //               //     IconButton(
          //               //         onPressed: click,
          //               //         icon: const Icon(
          //               //           FontAwesomeIcons.twitter,
          //               //           color: Colors.orangeAccent,
          //               //         )),
          //               //     IconButton(
          //               //         onPressed: click,
          //               //         icon: const Icon(
          //               //           FontAwesomeIcons.linkedinIn,
          //               //           color: Colors.green,
          //               //         ))
          //               //   ],
          //               // )
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fingerValue = prefs.getBool('fprint') ?? false;
    username = prefs.getString('lithiumid') ?? "";
    password = prefs.getString('password') ?? "";
    serveruuid = prefs.getString("serveruuid") ?? "";
    serverstate = prefs.getString("state") ?? "";
    fromnotify = prefs.getBool("fromnotify") ?? false;
    // String lat;
    // getlocation().then((value) => {
    //       lat = _locationData.latitude.toString(),
    //       // locationupdate(_locationData.latitude.toString(),
    //       //     _locationData.longitude.toString(), id)
    //     });
    // _biometricbool = prefs.getBool('biometric') ?? false;
    if (username == "") {
      showfinger = false;
    } else {
      setState(() {
        showfinger = true;
      });
    }

    if(mounted) setState(() {});
  }

/*
 setdata() async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString("firsttimelogin", "");
   prefs.setBool('fprint', false);
   setState(() {
     Navigator.pop(dialogContext_password);
     Navigator.of(context).push(
         MaterialPageRoute(builder: (context) => const WebViewExample()));
   });
 }
*/

  void locationupdate(String lat, String lang, String id) async {
    String url = CommonURL.URL;
    Map<String, String> postdata = {
      "from": "driverLatLongCapture",
      "id": id,
      "lattitude": lat,
      "longtitude": lang,
      "languageType":AppLocalizations.of(context)!.languagecode.toString(),
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);

    //print("${response.statusCode}");
    //print("${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("loc jsonInput = $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      if (status == 'true') {}
    } else {}
  }

  // _showBottomsheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  //     builder: (context) {
  //       return SizedBox(
  //         height: 310,
  //         width: double.infinity,
  //         //color: Colors.grey.shade200,
  //         //alignment: Alignment.center,
  //         child: Column(
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.all(10.0),
  //               child: Text(
  //                 'Biometric Authentication',
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Text("Login as $newUserdata",
  //                   style: const TextStyle(
  //                       fontSize: 16, fontWeight: FontWeight.w400)),
  //             ),
  //             const Padding(
  //               padding: EdgeInsets.all(8.0),
  //               child: Text(
  //                 'Login using Biometric Authentication',
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 _authenticate();
  //               },
  //               icon: const Icon(Icons.fingerprint),
  //               iconSize: 50,
  //               color: Colors.blue,
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             const Padding(
  //               padding: EdgeInsets.all(8.0),
  //               child: Text(
  //                 'Touch the fingerprint sensor',
  //                 style: TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.normal,
  //                     color: Colors.black26),
  //               ),
  //             ),
  //             // Row(mainAxisAlignment: MainAxisAlignment.start, children: [
  //             //   const SizedBox(
  //             //     width: 20,
  //             //   ),
  //             //   TextButton(
  //             //       onPressed: () {
  //             //         Navigator.of(context).pop();
  //             //       },
  //             //       child: const Text(
  //             //         'Change user ?',
  //             //         style: TextStyle(
  //             //             color: Colors.black54, fontWeight: FontWeight.w500),
  //             //         textAlign: TextAlign.left,
  //             //       ))
  //             // ])
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

//  showDialog(
//                   context: this.context,
//                   child:new AlertDialog(
//                     content: new FlatButton(
//                       child: new Text("update home"),
//                       onPressed: () => Navigator.pop(context, true),
//                     ),
//                   ),
//                 );
  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 240,
            child: const SizedBox.expand(child: FlutterLogo()),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  _showBottomsheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SizedBox(
          height: 310,
          width: double.infinity,
          //color: Colors.grey.shade200,
          //alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avenirtextblack(
                    text: AppLocalizations.of(context)!.biometricauthentication,
                    fontsize: 18,
                    textcolor: HexColor(Colorscommon.greendark2),
                    customfontweight: FontWeight.bold),
                // child: Text(
                //   'Fingerprint Authentication',
                //   style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //       color: HexColor(Colorscommon.greenAppcolor)),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avenirtextbook(
                    text: AppLocalizations.of(context)!
                        .please_use_your_fingerprint_to_login_as,
                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                        ? 12
                        : 15,
                    textcolor: HexColor(Colorscommon.greydark2),
                    customfontweight: FontWeight.bold),
                // child: Text(
                //   "Please use Your fingerprint to login",
                //   style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w400,
                //       color: Colors.black26),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avenirtextbook(
                    text: 'as $newUserdata',
                    fontsize: 15,
                    textcolor: HexColor(Colorscommon.greydark2),
                    customfontweight: FontWeight.bold),
                // child: Text("as $newUserdata",
                //     style: const TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w400,
                //         color: Colors.black26)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Avenirtextbook(
                    text: AppLocalizations.of(context)!
                        .login_using_Biometric_Authentication,
                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                        ? 12
                        : 15,
                    textcolor: HexColor(Colorscommon.greydark2),
                    customfontweight: FontWeight.bold),
                // child: Text(
                //   'Login using Biometric Authentication',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                // ),
              ),
              const SizedBox(
                height: 10,
              ),
              Bouncing(
                onPress: () {
                  _authenticate();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Biometriccolor.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              // IconButton(
              //   onPressed: () {
              // _authenticate();
              //   },
              //   icon: const Icon(Icons.fingerprint),
              //   iconSize: 60,
              //   color: HexColor(Colorscommon.greenApp2color),
              // ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Avenirtextbook(
                    text: AppLocalizations.of(context)!
                        .touch_the_fingerprint_sensor,
                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                        ? 12
                        : 14,
                    textcolor: HexColor(Colorscommon.greydark2),
                    customfontweight: FontWeight.normal),
                // child: Text(
                //   'Touch the fingerprint sensor',
                //   style: TextStyle(
                //       fontSize: 14,
                //       fontWeight: FontWeight.normal,
                //       color: Colors.black26),
                // ),
              ),
              // Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              //   const SizedBox(
              //     width: 20,
              //   ),
              //   TextButton(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: const Text(
              //         'Change user ?',
              //         style: TextStyle(
              //             color: Colors.black54, fontWeight: FontWeight.w500),
              //         textAlign: TextAlign.left,
              //       ))
              // ])
            ],
          ),
        );
      },
    );
  }


  // Future<void> scheduleVersionCheck(BuildContext context) async {
  //   // Calculate the delay until 20th September 2024, 3:40 PM
  //   DateTime scheduledTime = DateTime(2024, 9, 20, 15, 46);
  //   DateTime now = DateTime.now();
  //   Duration difference = scheduledTime.difference(now);
  //
  //   // Schedule the task using android_alarm_manager_plus
  //   await AndroidAlarmManager.oneShot(
  //     difference,
  //     // A unique ID for the alarm
  //     0,
  //         () => checkVersionAtScheduledTime(context),
  //     exact: true,
  //     wakeup: true,
  //   );
  // }
  //
  //
  // void checkVersionAtScheduledTime(BuildContext context) {
  //   VersionChecker().checkVersion(context, isLoginPage: true);
  // }

  void Loginapi(String uuid, String serverstate) async {
    // await scheduleVersionCheck(context);

    String url = CommonURL.URL;
    Map<String, String> postdata = {
      "from": "mobileLoginDrivers",
      "uuid": uuid,
      "sfdcState": serverstate,
      "username": nameController.text,
      "password": passwordController.text,
      "languageType":AppLocalizations.of(context)!.languagecode.toString(),
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);

    print("login api = ${response.statusCode} postdata = $postdata");
    print("login api =  ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      log("login response = $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      if (status == 'true') {
        String callbackURL = jsonInput['callbackURL'];
        String lithiumId = jsonInput['userData']['lithium_id'];
        String spUsername = jsonInput['userData']['sp_username'];
        String id = jsonInput['userData']['id'].toString();
        String password = jsonInput['userData']['password'];
        String pswEncrypt = jsonInput['userData']['psw_encrypt'];
        String mobileNo = jsonInput['userData']['mobile_no'];
        String emailId = jsonInput['userData']['email_id'];
        String city = jsonInput['userData']['city'];
        String campus = jsonInput['userData']['campus'];

        print("city =  ${city}");
        print("campus =  ${campus}");

        String accessToken = jsonInput['token']['access_token'];
        String refreshToken = jsonInput['token']['refresh_token'];
        String clientid = jsonInput['token']['refresh_token'];

        //final String lithiumid = "lithiumid";
        // final String clientid = "clientid";
        // final String refreshtokken = "refreshtokken";
        // final String accesstokken = "accesstokken";
        // final String weburl = "weburl";
        // final String password = "password";
        // final String state = "state";
        // final String sp_username = "sp_username";
        // final String psw_encrypt = "psw_encrypt";
        // final String mobile_no = "mobile_no";
        // final String email_id = "email_id";

        sessionManager.setpassword(passwordController.text);
        sessionManager.setemail_id(emailId);
        sessionManager.setcity(city);
        sessionManager.setcampus(campus);

        sessionManager.setuserid(id);
        sessionManager.settoken(accessToken);
        sessionManager.setrefreshtoken(refreshToken);
        sessionManager.setlithiumid(lithiumId);
        sessionManager.setsp_username(spUsername);
        sessionManager.setpsw_encrypt(pswEncrypt);
        sessionManager.setmobile_no(mobileNo);
        WidgetsBinding.instance?.addPostFrameCallback((_) => main(id));
        main(id);
        if (validate30min == "true" || validate30min == "_30minqwfac") {
          print("validate30min = $validate30min");
        }
        if (validate30min == "true") {
          //print("validate30min$validate30min");

          getlocation().then((value) => {
            locationupdate(_locationData.latitude.toString(),
                _locationData.longitude.toString(), id)
          });
        }

        updatefcmtoken(lithiumId, callbackURL, uuid);

        var searchquery = await db.GetUserdata();

        if(searchquery != null){
          print('searchquery--$searchquery');
        }

        Map<String, dynamic> newrow= {
          db.lithiumId:lithiumId,
          db.callbackURL:callbackURL,
          db.spUsername:spUsername,
          db.id:id,
          db.password:password,
          db.pswEncrypt:pswEncrypt,
          db.mobileNo:mobileNo,
          db.emailId:emailId,
          db.accessToken:accessToken,
          db.refreshToken:refreshToken,
        };
        await db.saveUserdetails(newrow);

      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
  }

  offlineLogin() async {


    String? password = await sessionManager.getpassword();
    print('password--$password');

    await utility.GetUserdata();
    print("utility.username = ${utility.lithiumid}");

    if (utility.lithiumid! != null && utility.lithiumid!.isNotEmpty) {
      if (utility.lithiumid! == nameController.text) {
        if (utility.password == passwordController.text) {

          print('verified user');

          Fluttertoast.showToast(
            msg: "Offline Login successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyTabPage(
                    title: '', selectedtab: 0,
                  )));
          // Perform login
        }else {
          Fluttertoast.showToast(
            msg: "Invalid Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Invalid Username",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }else{
      Fluttertoast.showToast(
        msg: "No data found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void updatefcmtoken(String username, String callbackurl, String uuid) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String url = CommonURL.URL;
    String? token;
    token = await _firebaseMessaging.getToken();
    print("fcmtoken = $token");
    Map<String, String> postdata = {
      "from": "updateDriversFCMCode",
      "username": username,
      "idFCM": "$token",
      "mobileType": "1",
      "uuid": uuid,
      "languageType":AppLocalizations.of(context)!.languagecode.toString(),
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);

    // //print("${response.statusCode}");
    // //print("${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      // //print("jsonInput$jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      if (status == 'true') {
        getspuniqueid();
      }
    } else {}
  }


  // Future<void> getspuniqueid() async {
  //   var url = Uri.parse(CommonURL.localone);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   // Use a JSON-encoded string for the data field
  //   String dataJson = jsonEncode([
  //     {
  //       "lithiumid": nameController.text
  //     }
  //   ]);
  //
  //   var request = http.MultipartRequest("POST", url)
  //     ..headers.addAll(headers)
  //     ..fields['from'] = "getSPUniqueIDBYLeithiumId"
  //     ..fields['data'] = dataJson
  //     ..fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();
  //
  //   try {
  //     var streamResponse = await request.send();
  //     var response = await http.Response.fromStream(streamResponse);
  //
  //     print("getspuniqueid status code = ${response.statusCode}");
  //     print("getspuniqueid response body = ${response.body}");
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //
  //       bool status = jsonInput['status'] ?? false;
  //
  //       if (status) {
  //         setState(() {});
  //
  //         List<dynamic> data = jsonInput['data'] ?? [];
  //         if (data.isNotEmpty) {
  //           var serviceProviderData = data[0];
  //           String serviceProviderC = serviceProviderData['service_provider'].toString();
  //           String name = serviceProviderData['name'].toString();
  //           String city = serviceProviderData['city'].toString();
  //           String image = serviceProviderData['image'].toString();
  //
  //           print("image$image");
  //
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //           prefs.setString("service_provider_c", serviceProviderC);
  //           prefs.setString("city", city);
  //           prefs.setString("image", image);
  //
  //           sessionManager.setspiod(serviceProviderC);
  //           sessionManager.setmobileuser(name);
  //           sessionManager.setImage("base64_or_url_of_image");
  //
  //           Fluttertoast.showToast(
  //             msg: AppLocalizations.of(context)!.logoinsuccessfully,
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.CENTER,
  //           );
  //
  //           Navigator.pop(context);
  //           Timer mytimer =
  //           Timer.periodic(const Duration(minutes: 2, seconds: 5), (timer) {
  //             //code to run on every 2 minutes 5 seconds
  //           });
  //
  //           setState(() {
  //             prefs.setString('Fingershow', "1234");
  //           });
  //
  //           nameController.clear();
  //           passwordController.clear();
  //
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => const MyTabPage(
  //                     title: '',
  //                     selectedtab: 0,
  //                   )));
  //         } else {
  //           Fluttertoast.showToast(
  //             msg: "No data available",
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.CENTER,
  //           );
  //         }
  //       } else {
  //         String message = jsonInput['message'].toString();
  //
  //         Fluttertoast.showToast(
  //           msg: message,
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //         );
  //       }
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: "Error: ${response.statusCode}",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //   } on Exception catch (e) {
  //     Fluttertoast.showToast(
  //       msg: "An error occurred: ${e.toString()}",
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.CENTER,
  //     );
  //   }
  // }

  Future<void> getspuniqueid() async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    String dataJson = jsonEncode([
      {
        "lithiumid": nameController.text,
      }
    ]);

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(headers)
      ..fields['from'] = "getSPUniqueIDBYLeithiumId"
      ..fields['data'] = dataJson
      ..fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      print("getspuniqueid status code = ${response.statusCode}");
      print("getspuniqueid response body = ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);

        bool status = jsonInput['status'] ?? false;

        if (status) {
          setState(() {});

          List<dynamic> data = jsonInput['data'] ?? [];
          if (data.isNotEmpty) {
            var serviceProviderData = data[0];
            String serviceProviderC = serviceProviderData['service_provider'].toString();
            String name = serviceProviderData['name'].toString();
            String city = serviceProviderData['city'].toString();
            String imageUrl = serviceProviderData['image'].toString();

            print("Image URL: $imageUrl");


            SharedPreferences prefs = await SharedPreferences.getInstance();

            // Store values in SharedPreferences
            prefs.setString("service_provider_c", serviceProviderC);
            prefs.setString("city", city);
            prefs.setString("image", imageUrl);

            // Update session manager with relevant values
            sessionManager.setspiod(serviceProviderC);
            sessionManager.setmobileuser(name);
            sessionManager.setImage(imageUrl);



            Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.logoinsuccessfully,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );

            Navigator.pop(context);

            // Example of periodic task
            Timer.periodic(const Duration(minutes: 2, seconds: 5), (timer) {
              // Periodic task logic here
            });

            setState(() {
              prefs.setString('Fingershow', "1234");
            });

            // Clear input controllers
            nameController.clear();
            passwordController.clear();

            // Navigate to the next page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyTabPage(
                  title: '',
                  selectedtab: 0,
                ),
              ),
            );
          } else {
            Fluttertoast.showToast(
              msg: "No data available",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          }
        } else {
          String message = jsonInput['message'].toString();

          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }





// getspuniqueid() async {
//   var url = Uri.parse(CommonURL.localone);
//
//   Map<String, String> headers = {
//     "Accept": "application/json",
//     "Content-Type": "application/x-www-form-urlencoded"
//   };
//   // var uri = Uri.parse(url);
//   var request = http.MultipartRequest("POST", url);
//   request.headers.addAll(headers);
//   request.fields['from'] = "getSPUniqueIDBYLeithiumId";
//   request.fields['lithiumID'] = nameController.text;
//   request.fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();
//
//   // request.files.add(await http.MultipartFile.fromPath('file', _image.path));
//   print("getspuniqueid post =$url, ${request.fields}");
//
//   var streamResponse = await request.send();
//   var response = await http.Response.fromStream(streamResponse);
//   print("getspuniqueid status code = ${response.statusCode}");
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     Map<String, dynamic> jsonInput = jsonDecode(response.body);
//     print("getspuniqueid = $jsonInput");
//
//     String status = jsonInput['status'].toString();
//
//     if (status == 'true') {
//       setState(() {});
//
//       String serviceProviderC =
//       jsonInput['data']['service_provider_c'].toString();
//       String name = jsonInput['data']['name'].toString();
//       String city = jsonInput['data']['city'].toString();
//
//       print("serviceProviderC$serviceProviderC");
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       prefs.setString("service_provider_c", serviceProviderC);
//       print("service_provider_c = $serviceProviderC");
//       prefs.setString("city", city);
//       print("city = $city");
//       //        final String lithiumid = "lithiumid";
//       // final String clientid = "clientid";
//       // final String refreshtokken = "refreshtokken";
//       // final String accesstokken = "accesstokken";
//       // final String weburl = "weburl";
//       // final String password = "password";
//       // final String state = "state";
//       // final String sp_username = "sp_username";
//       // final String psw_encrypt = "psw_encrypt";
//       // final String mobile_no = "mobile_no";
//       // final String email_id = "email_id";
//       sessionManager.setspiod(serviceProviderC);
//       sessionManager.setmobileuser(name);
//       Fluttertoast.showToast(
//         msg: AppLocalizations.of(context)!.logoinsuccessfully,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//       //        setdata() async {
//       //   SharedPreferences prefs = await SharedPreferences.getInstance();
//       //   setState(() {
//       //     prefs.setBool('fprint', _fingerValue);
//       //     print('set-fp = $_fingerValue');
//       //     Navigator.of(context)
//       //         .push(MaterialPageRoute(builder: (context) => const Login()));
//       //   });
//       // }
//       Navigator.pop(context);
//       Timer mytimer =
//       Timer.periodic(const Duration(minutes: 2, seconds: 5), (timer) {
//         //code to run on every 2 minutes 5 seconds
//       });
//       // SharedPreferences prefs = await SharedPreferences.getInstance();
//       setState(() {
//         prefs.setString('Fingershow', "1234");
//         print('set-fp = $_fingerValue');
//       });
//       nameController.clear();
//       passwordController.clear();
//       // utility.showYourpopupinternetstatus(context);
//       /* if(fromnotify == true) {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => const MyTabPage(
//                  title: '', selectedtab: 2,
//                )));
//      }
//      else {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => const MyTabPage(
//                  title: '', selectedtab: 0,
//                )));
//      }*/
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const MyTabPage(
//                 title: '', selectedtab: 0,
//               )));
//       // reasonnamearray
//       //        final String lithiumid = "lithiumid";
//       // final String clientid = "clientid";
//       // final String refreshtokken = "refreshtokken";
//       // final String accesstokken = "accesstokken";
//       // final String weburl = "weburl";
//       // final String password = "password";
//       // final String state = "state";
//       // final String sp_username = "sp_username";
//       // final String psw_encrypt = "psw_encrypt";
//       // final String mobile_no = "mobile_no";
//       // final String email_id = "email_id";
//
//       // updatefcmtoken(lithiumId, callbackURL, uuid);
//
//     } else {
//       // Navigator.pop(context);
//       String message = jsonInput['message'].toString();
//
//       Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//     }
//   } else {}
// }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, 20);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 4, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }
  // Path getClip(Size size) {
  //   var path = Path();
  //   path.lineTo(0, size.height - 30);
  //   path.quadraticBezierTo(
  //       size.width / 2, size.height, size.width, size.height - 30);
  //   path.lineTo(size.width, 0);

  //   path.close();
  //   return path;
  // }
  // Path getClip(Size size) {
  //   var path = Path();
  //   path.moveTo(size.width, 0);
  //   path.lineTo(size.width, size.height - 50);
  //   var controllPoint = Offset(size.width - 50, size.height);
  //   var endPoint = Offset(size.width / 2, size.height);
  //   path.quadraticBezierTo(
  //       controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);
  //   path.lineTo(0, size.height);
  //   path.lineTo(0, 0);

  //   return path;
  // }
  // Path getClip(Size size) {
  //   // I've taken approximate height of curved part of view
  //   // Change it if you have exact spec for it
  //   final roundingHeight = size.height * 3 / 5;

  //   // this is top part of path, rectangle without any rounding
  //   final filledRectangle =
  //       Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);

  //   // this is rectangle that will be used to draw arc
  //   // arc is drawn from center of this rectangle, so it's height has to be twice roundingHeight
  //   // also I made it to go 5 units out of screen on left and right, so curve will have some incline there
  //   final roundingRectangle = Rect.fromLTRB(
  //       -5, size.height - roundingHeight * 2, size.width + 5, size.height);

  //   final path = Path();
  //   path.addRect(filledRectangle);

  //   // so as I wrote before: arc is drawn from center of roundingRectangle
  //   // 2nd and 3rd arguments are angles from center to arc start and end points
  //   // 4th argument is set to true to move path to rectangle center, so we don't have to move it manually
  //   path.arcTo(roundingRectangle, pi, -pi, true);
  //   path.close();

  //   return path;
  // }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // returning fixed 'true' value here for simplicity, it's not the part of actual question, please read docs if you want to dig into it
    // basically that means that clipping will be redrawn on any changes
    return true;
  }
}







class VersionChecker {
  String? currentBuildVersion;
  String? playstoreVersion;
  String playstoreUrl = "";

  // Method to fetch the current version of the app
  Future<void> getVersion() async {
    print("Fetching current app version");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentBuildVersion = packageInfo.version;
    print("Current version: $currentBuildVersion");
  }

  // Method to check the version depending on the platform (Android or iOS)
  Future<void> checkVersion(BuildContext context, {bool isLoginPage = true}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool? hasUpdated = prefs.getBool('hasUpdated');
    //
    //  if (hasUpdated == true) {
    //    print("App is already updated, skipping version check.");
    //    return; // Skip version check if app has already been updated
    //  }

    await getVersion();
    print("Checking version for platform");

    if (Platform.isAndroid) {
      await _checkPlayStore(context, "com.thinksynq.lithiumsp", isLoginPage: isLoginPage);
    } else if (Platform.isIOS) {
      // iOS version checking logic can be added here
      print("iOS platform detected, add logic to check App Store.");
    }
  }

  // Method to check for the latest version on the Play Store
  Future<void> _checkPlayStore(BuildContext context, String packageName, {bool isLoginPage = true}) async {
    String errorMsg;
    final uri = Uri.https("play.google.com", "/store/apps/details", {"id": packageName});

    try {
      final response = await http.get(uri);
      print("Response code: ${response.statusCode}");

      if (response.statusCode != 200) {
        errorMsg = "Can't find an app in the Google Play Store with the id: $packageName";
        print(errorMsg);
      } else {
        playstoreVersion = RegExp(r',\[\[\["([0-9,\.]*)"]],').firstMatch(response.body)?.group(1);
        playstoreUrl = uri.toString();

        if (playstoreVersion != null) {
          print("Playstore version: $playstoreVersion, Current version: $currentBuildVersion");
          if (playstoreVersion != currentBuildVersion) {
            _showUpdateDialog(context, playstoreVersion!, playstoreUrl, isLoginPage: isLoginPage);
          }
        }
      }
    } catch (e) {
      errorMsg = "Error: $e";
      print(errorMsg);
    }
  }

  // Method to open the app's Play Store page and mark as updated
  Future<void> openPlayStore() async {
    final Uri playStoreUrl = Uri.parse("https://play.google.com/store/apps/details?id=com.thinksynq.lithiumsp");

    if (await canLaunchUrl(playStoreUrl)) {
      try {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);

        // After the user goes to the Play Store, assume they will update
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasUpdated', true); // Mark the app as updated

      } catch (e) {
        // Handle error if Play Store cannot be launched
        print('Failed to launch Play Store: $e');
      }
    } else {
      // Redirect to browser if Play Store is not available
      final Uri browserUrl = Uri.parse("https://play.google.com/store");
      if (await canLaunchUrl(browserUrl)) {
        await launchUrl(browserUrl);
      } else {
        throw Exception('Could not launch Play Store or browser');
      }
    }
  }

  // Method to show the version update dialog
  void _showUpdateDialog(BuildContext context, String newVersion, String url, {bool isLoginPage = true}) {
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside the dialog
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return isLoginPage ? false : true; // Prevent back navigation on login page
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Row(
            children: [
              Icon(
                Icons.system_update,
                color: HexColor(Colorscommon.greendark), // Use your color
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Update Available!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: HexColor(Colorscommon.greendark),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/lithium123.png',
                  width: 175,
                  height: 175,
                ),
                SizedBox(height: 10),
                Text(
                  'For a better experience, please download the latest version of the app!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.red, // Use your color
              ),
              child: Text(
                'Update Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                openPlayStore(); // Mark app as updated after opening Play Store
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to schedule the version check at a specific date and time
  void scheduleVersionCheck(BuildContext context, DateTime scheduledTime, {bool isLoginPage = true}) {
    DateTime now = DateTime.now();
    Duration difference = scheduledTime.difference(now);

    if (difference.isNegative) {
      print('Scheduled time has already passed');
      checkVersion(context, isLoginPage: isLoginPage); // Show update if the time has passed
    } else {
      print('Scheduled version check for: $scheduledTime');
      Timer(difference, () => checkVersion(context, isLoginPage: isLoginPage));
    }
  }
}








