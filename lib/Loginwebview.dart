import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/GradientText.dart';
import 'package:flutter_application_sfdc_idp/Notofications.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Settings.dart';
import 'package:flutter_application_sfdc_idp/webview_idp.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:restart_app/restart_app.dart';
// var uuid = Uuid();

SessionManager sessionManager = SessionManager();

class Loginwebview extends StatefulWidget {
  final String loadURL;
  const Loginwebview({Key? key, required this.loadURL}) : super(key: key);

  @override
  LoginwebviewState createState() => LoginwebviewState();
}

class LoginwebviewState extends State<Loginwebview> {
  late BuildContext dialogContext_password;
  var position = 1;
  String firsttimeloginbool = "";
  bool _fingerValue = false;
  TextEditingController emailorphonecontroller = TextEditingController();


  @override
  void initState() {
    super.initState();
    Getdata(); // your existing method

    // Initialize WebViewController
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            setState(() {
              position = 1;
            });
            print('Page started: $url');

            final pref = await SharedPreferences.getInstance();
            if (url ==
                "https://epuat-sp-lithium.cs114.force.com/SPUATTestCommunity/s/login/?sfdcIFrameOrigin=null") {
              String id = pref.getString("userid") ?? "";
              String accesstoken = pref.getString("accesstokken") ?? "";
              String email = pref.getString("email_id") ?? "";
              logoutapi(id, accesstoken, email); // your method
            } else if (url ==
                "https://epuat-sp-lithium.cs114.force.com/SPUATTestCommunity/s/") {
              controller.loadRequest(Uri.parse(
                  "https://epuat-sp-lithium.cs114.force.com/SPUATTestCommunity/s/sp-app-page"));
            }
          },
          onPageFinished: (String url) {
            setState(() {
              position = 0;
            });
            print('Page finished: $url');
          },
          onProgress: (int progress) {
            print("Loading: $progress%");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loadURL));
  }

  setdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('fprint', _fingerValue);
      print('set-fp = $_fingerValue');
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const WebViewExample()));
    });
  }

  Getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fingerValue = prefs.getBool('fprint') ?? false;
    // _biometricbool = prefs.getBool('biometric') ?? false;
    firsttimeloginbool = prefs.getString('firsttimelogin') ?? "";
    if (firsttimeloginbool != 'true') {
      Confirm_fingerprint_alert(context);
    }

    print('get-fp = $_fingerValue');
    setState(() {});
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Change password',
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
          // backgroundColor: Colors.green,
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                TextField(),
                TextField(),
                TextField(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Submit',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void logoutapi(String id, String accesstoken, String email) async {
    //print("id$id");
    //print("accesstoken$accesstoken");
    //print("email$email");
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

    //print("${response.statusCode}");
    //print("${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      // debugPrint('Passwordchnageresponse $jsonInput');

      String success = jsonInput['success'].toString();
      String message = jsonInput['message'];
      // debugPrint('Location_success $success');
      // debugPrint('Location_message $message');

      Navigator.pop(context);

      if (success == '1') {
        // String idDriverr = jsonInput['id_driver'].toString();
        // Navigator.of(context).pushAndRemoveUntil(
        //     '/WebViewExample', (Route<dynamic> route) => false);
        // Navigator.pushNamedAndRemoveUntil(
        //     context, MaterialPageRoute(builder: (context) => const WebViewExample()));
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
       // Restart.restartApp();

        // Fluttertoast.showToast(
        //   msg: message,
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        // );
        // return Future.value(true);
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
       // Restart.restartApp();
      }

      // Fluttertoast.showToast(
      //   msg: message,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
    } else {
      debugPrint('SERVER=FAILED');

      Fluttertoast.showToast(
        msg: "Something went wrong please try again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late WebViewController controller;
  TextEditingController oldpasswordcontroller = TextEditingController();
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
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

  void Confirm_fingerprint_alert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            title: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Confirmation",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Lato",
                        color: HexColor(Colorscommon.greycolor)),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Container(
                      child: Divider(
                    color: HexColor(Colorscommon.greycolor),
                    height: 20,
                  )),
                ),
              ],
            ),
            titleTextStyle: TextStyle(color: Colors.grey[700]),
            titlePadding: const EdgeInsets.only(left: 5, top: 5),
            content: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 5),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Do you want to enable fingerprint?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: HexColor(Colorscommon.greycolor),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Divider(
                          color: HexColor(Colorscommon.greycolor),
                          height: 20,
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Bouncing(
                      onPress: () async {
                        firsttimeloginbool = 'true';
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('firsttimelogin', firsttimeloginbool);
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Settings()));
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 10, right: 0),
                        padding: const EdgeInsets.all(5),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(colors: [
                              HexColor(Colorscommon.greycolor),
                              HexColor(Colorscommon.greycolor),
                            ])),
                        child: const Center(
                            child: Text(
                          "Yes",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Bouncing(
                      onPress: () async {
                        firsttimeloginbool = 'true';
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('firsttimelogin', firsttimeloginbool);
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 10, right: 0),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: HexColor(Colorscommon.greycolor))),
                        child: Center(
                            child: Text(
                          "No",
                          style: TextStyle(
                              color: HexColor(Colorscommon.greycolor),
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void chagepasswordapirequest(String userid, clientid, accesstokken,
      refreshtokken, lithiumid, oldPassword) async {
    loading();
    String url = CommonURL.URL;
    Map<String, String> postdata = {
      "from": "changeDriversPassword",
      "oldPassword": oldpasswordcontroller.text,
      "newPassword": newpasswordcontroller.text,
      "confirmPassword": confirmpasswordcontroller.text,
      "clientID": clientid,
      "userId": userid,
      "access_token": accesstokken,
      "username": lithiumid,
      "refresh_token": refreshtokken,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };
    debugPrint('fetchdata $url');

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      Navigator.pop(context);

      String success = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (success == 'true') {
        Codec<String, String> stringToBase64 = utf8.fuse(base64);

        // String encoded = stringToBase64.encode(newpasswordcontroller.text);
        // debugPrint("newpassword " + encoded);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Timer(const Duration(milliseconds: 100), () {
         // Restart.restartApp();
          print(" This line is execute after 5 seconds");
        });

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => Login()),
        //     (Route<dynamic> route) => false);

      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      debugPrint('SERVER=FAILED');
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Something went wrong please try again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  validateInputs() async {
    if (oldpasswordcontroller.text.isNotEmpty) {
      if (newpasswordcontroller.text.isNotEmpty) {
        if (newpasswordcontroller.text == confirmpasswordcontroller.text) {
          final SharedPreferences pref = await SharedPreferences.getInstance();
          String userid = pref.getString("userid") ?? "";
          // String clientid = pref.getString("clientid") ?? "";
          // clientID:222
          String clientid = '222';
          String refreshtokken = pref.getString("refreshtokken") ?? "";
          String accesstokken = pref.getString("accesstokken") ?? "";
          String lithiumid = pref.getString("lithiumid") ?? "";

          // String oldPassword = pref.getString("password") ?? "";
          // print("userid$userid");
          // print("clientid$clientid");
          // print("refreshtokken$refreshtokken");
          // print("accesstokken$accesstokken");
          // //print("mobile$lithiumid");
          // //print("oldPassword$oldPassword");

          // if (oldPassword == oldpasswordcontroller.text) {
          sessionManager.internetcheck().then((intenet) async {
            if (intenet) {
              chagepasswordapirequest(userid, clientid, accesstokken,
                  refreshtokken, lithiumid, oldpasswordcontroller.text);
            } else {
              //WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              final overlay = Overlay.of(context);
              if (overlay == null) return;

              showTopSnackBar(
                overlay,
                const CustomSnackBar.error(
                  message: "Please Check Your Internet Connection",
                ),
              );
              // });
              // Fluttertoast.showToast(
              //   msg: "No Internet",
              //   toastLength: Toast.LENGTH_SHORT,
              //   gravity: ToastGravity.CENTER,
              // );
            }
          });
          // } else {
          //   Fluttertoast.showToast(
          //     msg: "incorrect old password",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //   );
          // }
//  void Chagepasswordapirequest(String userid, clientid, accesstokken,
//       refreshtokken, mobile, oldPassword) async {

        } else {
          Fluttertoast.showToast(
            msg: "New password and confirm password doesn't match",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Please enter new password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please enter old password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void ChangePassword() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // dialogContext = context;

        return Dialog(
          insetPadding: const EdgeInsets.all(5),

          // padding: const EdgeInsets.all(5.0),
          child: Container(
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GradientText(
                    "Change Password",
                    18,
                    gradient: LinearGradient(colors: [
                      HexColor(Colorscommon.greencolor),
                      HexColor(Colorscommon.greenlite),
                    ]),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 0, right: 0),
                  decoration: const BoxDecoration(
                      // border: Border(bottom: BorderSide(color: Colors.grey)
                      // )
                      ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: HexColor(Colorscommon.greencolor)),
                    child: TextField(
                      controller: oldpasswordcontroller,
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'TomaSans-Regular',
                        // fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.start,

                      //  controller: usernameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Old Password'),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 0, right: 0),
                  decoration: const BoxDecoration(
                      // border: Border(bottom: BorderSide(color: Colors.grey))
                      ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: HexColor(Colorscommon.greencolor)),
                    child: TextField(
                      controller: newpasswordcontroller,
                      obscureText: true,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'TomaSans-Regular',
                        // fontWeight: FontWeight.bold
                      ),
                      // controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter New Password",
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 0, right: 0),
                  decoration: const BoxDecoration(
                      // border: Border(bottom: BorderSide(color: Colors.grey))
                      ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: HexColor(Colorscommon.greencolor)),
                    child: TextField(
                      controller: confirmpasswordcontroller,
                      obscureText: true,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'TomaSans-Regular',
                        // fontWeight: FontWeight.bold
                      ),
                      // controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Confirm New Password",
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Bouncing(
                        onPress: () {
                          validateInputs();
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.only(top: 20, left: 0, right: 0),
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [
                                HexColor(Colorscommon.greencolor),
                                HexColor(Colorscommon.greenlite),
                              ])),
                          child: const Center(
                              child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      Bouncing(
                        onPress: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 10, right: 0),
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: HexColor(Colorscommon.greencolor))),
                          child: const Center(
                              child: Text(
                            "Close",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold),
                          )),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: SafeArea(
          child: Scaffold(

            resizeToAvoidBottomInset: true,

            body: Builder(builder: (context) {
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 30,
                    child: IndexedStack(
                      index: position,
                      children: [
                        Expanded(
                          child:WebViewWidget(controller: controller),
                        ),

                        Container(
                          color: Colors.green[50],
                          height: 60, // Set fixed height for GIF container
                          child: Center(
                            child: Image.asset(
                              'assets/lithiugif.gif',
                              width: 50,
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Expanded(
                      flex: 1,
                      child: Container(

                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(9, 9),
                              blurRadius: 12,
                              color: Colors.black,
                            )
                          ],
                          // border: Border(
                          //   top: BorderSide(
                          //       width: 2.0, color: HexColor("#7393B3")),
                          //   // bottom:
                          //   //     BorderSide(width: 16.0, color: Colors.lightBlue),
                          // ),
                          color: HexColor("#CCCCCC"),
                        ),
                        // color: HexColor(Colorscommon.whitelite),
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // FadeAnimation(
                              // 1.2,
                              GestureDetector(
                                // onTap: () {
                                //   ForgotPassword();
                                // },
                                onTap: () {
                                  // ForgotPassword();
                                  sessionManager
                                      .internetcheck()
                                      .then((intenet) async {
                                    if (intenet) {
                                      ChangePassword();
                                      //               final SharedPreferences pref = await SharedPreferences.getInstance();
                                      // String userid = pref.getString("userid") ?? "";
                                    } else {
                                      //WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (!mounted) return;

                                      final overlay = Overlay.of(context);
                                      if (overlay == null) return;

                                      showTopSnackBar(
                                        overlay,
                                        const CustomSnackBar.error(
                                          message: "Please Check Your Internet Connection",
                                        ),
                                      );
                                      // });
                                      // Fluttertoast.showToast(
                                      //   msg: "No Internet",
                                      //   toastLength: Toast.LENGTH_SHORT,
                                      //   gravity: ToastGravity.CENTER,
                                      // );
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Icon(
                                      Icons.lock,
                                      color: HexColor("#F6F6F6"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                        'Change Password',
                                        style: TextStyle(
                                            shadows: const <Shadow>[
                                              Shadow(
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 3.0,
                                                color: Color.fromARGB(
                                                    255, 240, 238, 238),
                                              ),
                                              Shadow(
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 8.0,
                                                color: Color.fromARGB(
                                                    124, 247, 247, 248),
                                              ),
                                            ],
                                            fontFamily: 'TomaSans-Regular',
                                            fontWeight: FontWeight.bold,
                                            color: HexColor(
                                                Colorscommon.greycolor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                // onTap: () {
                                //   ForgotPassword();
                                // },
                                onTap: () {
                                  // ForgotPassword();
                                  sessionManager
                                      .internetcheck()
                                      .then((intenet) async {
                                    if (intenet) {
                                      final SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      String userid =
                                          pref.getString("userid") ?? "";
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Localnotifications()));
                                      // ChangePassword();
                                    } else {
                                      //WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (!mounted) return;

                                      final overlay = Overlay.of(context);
                                      if (overlay == null) return;

                                      showTopSnackBar(
                                        overlay,
                                        const CustomSnackBar.error(
                                          message: "Please Check Your Internet Connection",
                                        ),
                                      );
                                      // });
                                      // Fluttertoast.showToast(
                                      //   msg: "No Internet",
                                      //   toastLength: Toast.LENGTH_SHORT,
                                      //   gravity: ToastGravity.CENTER,
                                      // );
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Icon(
                                      Icons.notifications,
                                      color: HexColor("#F6F6F6"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                        'Messages',
                                        style: TextStyle(
                                            shadows: const <Shadow>[
                                              Shadow(
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 3.0,
                                                color: Color.fromARGB(
                                                    255, 240, 238, 238),
                                              ),
                                              Shadow(
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 8.0,
                                                color: Color.fromARGB(
                                                    124, 247, 247, 248),
                                              ),
                                            ],
                                            fontFamily: 'TomaSans-Regular',
                                            fontWeight: FontWeight.bold,
                                            color: HexColor(
                                                Colorscommon.greycolor)),
                                      ),
                                    ),
                                  ],
                                ),
                                // child: Card(
                                //   elevation: 2,
                                //   margin: const EdgeInsets.all(10),
                                //   child: Container(
                                //     padding: const EdgeInsets.all(10),
                                //     decoration: BoxDecoration(
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(10)),
                                //         gradient: LinearGradient(colors: [
                                //           HexColor(Colorscommon.whitecolor),
                                //           HexColor(Colorscommon.whitelite)
                                //         ])),
                                //     child: Row(
                                //       children: [
                                //         Icon(
                                //           Icons.notifications,
                                //           color: HexColor(Colorscommon.greencolor),
                                //         ),
                                //         Container(
                                //           margin: const EdgeInsets.all(10),
                                //           child: Text(
                                //             'Notifications',
                                //             style: TextStyle(
                                //                 fontFamily: 'TomaSans-Regular',
                                //                 fontWeight: FontWeight.bold,
                                //                 color:
                                //                     HexColor(Colorscommon.greycolor)),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ),
                              // ),
                              // FadeAnimation(
                              //   1.2,
                              GestureDetector(
                                onTap: () async {
                                  final SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  String id = pref.getString("userid") ?? "";
                                  String accesstoken =
                                      pref.getString("accesstokken") ?? "";
                                  String email =
                                      pref.getString("email_id") ?? "";
                                  //print("id$id");
                                  //print("accesstoken$accesstoken");
                                  //print("email$email");

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          insetPadding:
                                              const EdgeInsets.all(10),
                                          contentPadding: EdgeInsets.zero,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          titlePadding: EdgeInsets.zero,
                                          title: Container(
                                            height: 50,
                                            // margin: const EdgeInsets.all(0),
                                            color: HexColor(
                                                Colorscommon.greencolor),
                                            // decoration: BoxDecoration(
                                            //     borderRadius: BorderRadius.circular(0),
                                            //     gradient: LinearGradient(colors: [
                                            //       HexColor(Colorscommon.greencolor),
                                            //       HexColor(Colorscommon.greenlite),
                                            //     ])),
                                            child: Center(
                                              child: Text(
                                                "Confirmation",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: "Lato",
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor(Colorscommon
                                                        .whitecolor)),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          titleTextStyle: TextStyle(
                                              color: Colors.grey[700]),
                                          // titlePadding: const EdgeInsets.only(left: 5, top: 5),
                                          content: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20,
                                                  bottom: 10,
                                                  left: 10,
                                                  right: 10),
                                              child: Text(
                                                "Are you sure want to logout ?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      'TomaSans-Regular',
                                                  fontSize: 18,
                                                  color: HexColor(
                                                      Colorscommon.greycolor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: const Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'Lato',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Bouncing(
                                                    onPress: () async {
                                                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      // Loginbool = 'false';
                                                      // prefs.setString('loginbool', Loginbool);
                                                      logoutapi(id, accesstoken,
                                                          email);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20,
                                                              left: 0,
                                                              right: 0),
                                                      height: 40,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                                HexColor(
                                                                    Colorscommon
                                                                        .greencolor),
                                                                HexColor(
                                                                    Colorscommon
                                                                        .greenlite),
                                                              ])),
                                                      child: const Center(
                                                          child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ),
                                                    // child: Container(
                                                    //   margin: const EdgeInsets.only(
                                                    //       top: 20, left: 10, right: 0),
                                                    //   padding: const EdgeInsets.all(5),
                                                    //   height: 30,
                                                    //   decoration: BoxDecoration(
                                                    //       borderRadius:
                                                    //           BorderRadius.circular(5),
                                                    //       gradient: LinearGradient(colors: [
                                                    //         HexColor(Colorscommon.greycolor),
                                                    //         HexColor(Colorscommon.greycolor),
                                                    //       ])),
                                                    //   child: const Center(
                                                    //       child: Text(
                                                    //     "Yes",
                                                    //     style: TextStyle(
                                                    //         color: Colors.white,
                                                    //         fontFamily: 'Lato',
                                                    //         fontWeight: FontWeight.bold),
                                                    //   )),
                                                    // ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Bouncing(
                                                    onPress: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20,
                                                              left: 10,
                                                              right: 0),
                                                      height: 40,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: HexColor(
                                                                  Colorscommon
                                                                      .greencolor))),
                                                      child: const Center(
                                                          child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ),
                                                    // child: Container(
                                                    //   margin: EdgeInsets.only(
                                                    //       top: 20, left: 10, right: 0),
                                                    //   height: 30,
                                                    //   decoration: BoxDecoration(
                                                    //       borderRadius:
                                                    //           BorderRadius.circular(5),
                                                    //       border: Border.all(
                                                    //           color: HexColor(
                                                    //               Colorscommon.greycolor))),
                                                    //   child: Center(
                                                    //       child: Text(
                                                    //     "No",
                                                    //     style: TextStyle(
                                                    //         color: HexColor(
                                                    //             Colorscommon.greycolor),
                                                    //         fontFamily: 'Lato',
                                                    //         fontWeight: FontWeight.bold),
                                                    //   )),
                                                    // ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      });
                                },
                                // onTap: () {
                                //   // Navigator.of(context).pushAndRemoveUntil(
                                //   //     MaterialPageRoute(builder: (context) => Login()),
                                //   //     (Route<dynamic> route) => false);
                                // },
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Icon(
                                      Icons.logout,
                                      color: HexColor("#F6F6F6"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                            shadows: const <Shadow>[
                                              Shadow(
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 3.0,
                                                color: Color.fromARGB(
                                                    255, 240, 238, 238),
                                              ),
                                              Shadow(
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 8.0,
                                                color: Color.fromARGB(
                                                    124, 247, 247, 248),
                                              ),
                                            ],
                                            fontFamily: 'TomaSans-Regular',
                                            fontWeight: FontWeight.bold,
                                            color: HexColor(
                                                Colorscommon.greycolor)),
                                      ),
                                    ),
                                  ],
                                ),

                              ),

                              Column(
                                children: [
                                  CupertinoSwitch(
                                    activeColor:
                                        HexColor(Colorscommon.greencolor),
                                    value: _fingerValue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _fingerValue = value;
                                        setdata();
                                      });
                                    },
                                  ),
                                  Text(
                                    'Use Biometric',
                                    style: TextStyle(
                                        shadows: const <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(
                                                255, 240, 238, 238),
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 8.0,
                                            color: Color.fromARGB(
                                                124, 247, 247, 248),
                                          ),
                                        ],
                                        fontFamily: 'TomaSans-Regular',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            HexColor(Colorscommon.greycolor)),
                                  ),
                                ],
                              ),
                              // Card(
                              //   elevation: 2,
                              //   margin: const EdgeInsets.all(10),
                              //   child: Container(
                              //     padding: const EdgeInsets.all(10),
                              //     decoration: BoxDecoration(
                              //         borderRadius:
                              //             const BorderRadius.all(Radius.circular(10)),
                              //         gradient: LinearGradient(colors: [
                              //           HexColor(Colorscommon.whitecolor),
                              //           HexColor(Colorscommon.whitelite)
                              //         ])),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text(
                              //           'Use Fingerprint',
                              //           style: TextStyle(
                              //               fontFamily: 'Lato',
                              //               color: HexColor(Colorscommon.greycolor)),
                              //         ),
                              //         CupertinoSwitch(
                              //           activeColor: HexColor(Colorscommon.redcolor),
                              //           value: _fingerValue,
                              //           onChanged: (bool value) {
                              //             setState(() {
                              //               _fingerValue = value;
                              //               setdata();
                              //             });
                              //             // setState(() {
                              //             //   _fingerValue = value;
                              //             //   setdata();
                              //             // });
                              //           },
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // ),
                            ]),
                      ),
                    ),
                  )
                ],
              );
            }),
            floatingActionButton: SpeedDial(
              // icon: const Icon(Icons.settings),

              icon: Icons.abc,
              animatedIcon: AnimatedIcons.menu_home,
              openCloseDial: isDialOpen,
              backgroundColor: HexColor(Colorscommon.grey_low),
              overlayColor: Colors.grey,
              overlayOpacity: 0.5,
              spacing: 15,
              spaceBetweenChildren: 15,
              closeManually: true,
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.logout),
                    label: 'Logout',
                    backgroundColor: HexColor(Colorscommon.whitecolor),
                    onTap: () async {
                      final SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      String id = pref.getString("userid") ?? "";
                      String accesstoken = pref.getString("accesstokken") ?? "";
                      String email = pref.getString("email_id") ?? "";
                      //print("id$id");
                      //print("accesstoken$accesstoken");
                      //print("email$email");

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: const EdgeInsets.all(10),
                              contentPadding: EdgeInsets.zero,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              titlePadding: EdgeInsets.zero,
                              title: Container(
                                height: 50,
                                // margin: const EdgeInsets.all(0),
                                color: HexColor(Colorscommon.greencolor),
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(0),
                                //     gradient: LinearGradient(colors: [
                                //       HexColor(Colorscommon.greencolor),
                                //       HexColor(Colorscommon.greenlite),
                                //     ])),
                                child: Center(
                                  child: Text(
                                    "Confirmation",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: "Lato",
                                        fontWeight: FontWeight.bold,
                                        color:
                                            HexColor(Colorscommon.whitecolor)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              titleTextStyle:
                                  TextStyle(color: Colors.grey[700]),
                              // titlePadding: const EdgeInsets.only(left: 5, top: 5),
                              content: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 5),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10, left: 10, right: 10),
                                  child: Text(
                                    "Are you sure want to logout ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'TomaSans-Regular',
                                      fontSize: 18,
                                      color: HexColor(Colorscommon.greycolor),
                                    ),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Bouncing(
                                        onPress: () async {
                                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                                          // Loginbool = 'false';
                                          // prefs.setString('loginbool', Loginbool);
                                          logoutapi(id, accesstoken, email);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 20, left: 0, right: 0),
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient: LinearGradient(colors: [
                                                HexColor(
                                                    Colorscommon.greencolor),
                                                HexColor(
                                                    Colorscommon.greenlite),
                                              ])),
                                          child: const Center(
                                              child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                        // child: Container(
                                        //   margin: const EdgeInsets.only(
                                        //       top: 20, left: 10, right: 0),
                                        //   padding: const EdgeInsets.all(5),
                                        //   height: 30,
                                        //   decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(5),
                                        //       gradient: LinearGradient(colors: [
                                        //         HexColor(Colorscommon.greycolor),
                                        //         HexColor(Colorscommon.greycolor),
                                        //       ])),
                                        //   child: const Center(
                                        //       child: Text(
                                        //     "Yes",
                                        //     style: TextStyle(
                                        //         color: Colors.white,
                                        //         fontFamily: 'Lato',
                                        //         fontWeight: FontWeight.bold),
                                        //   )),
                                        // ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Bouncing(
                                        onPress: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 20, left: 10, right: 0),
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: HexColor(Colorscommon
                                                      .greencolor))),
                                          child: const Center(
                                              child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                        // child: Container(
                                        //   margin: EdgeInsets.only(
                                        //       top: 20, left: 10, right: 0),
                                        //   height: 30,
                                        //   decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(5),
                                        //       border: Border.all(
                                        //           color: HexColor(
                                        //               Colorscommon.greycolor))),
                                        //   child: Center(
                                        //       child: Text(
                                        //     "No",
                                        //     style: TextStyle(
                                        //         color: HexColor(
                                        //             Colorscommon.greycolor),
                                        //         fontFamily: 'Lato',
                                        //         fontWeight: FontWeight.bold),
                                        //   )),
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    }),
                SpeedDialChild(
                    child: const Icon(Icons.lock),
                    label: 'Change Password',
                    backgroundColor: HexColor(Colorscommon.whitecolor),
                    onTap: () {
                      sessionManager.internetcheck().then((intenet) async {
                        if (intenet) {
                          ChangePassword();
                          //               final SharedPreferences pref = await SharedPreferences.getInstance();
                          // String userid = pref.getString("userid") ?? "";
                        } else {
                          //WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;

                          final overlay = Overlay.of(context);
                          if (overlay == null) return;

                          showTopSnackBar(
                            overlay,
                            const CustomSnackBar.error(
                              message: "Please Check Your Internet Connection",
                            ),
                          );
                          // });
                          // Fluttertoast.showToast(
                          //   msg: "No Internet",
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.CENTER,
                          // );
                        }
                      });
                    }),
                SpeedDialChild(
                    child: const Icon(Icons.notifications),
                    label: 'Messages',
                    backgroundColor: HexColor(Colorscommon.whitecolor),
                    onTap: () {
                      sessionManager.internetcheck().then((intenet) async {
                        if (intenet) {
                          final SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          String userid = pref.getString("userid") ?? "";
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const Localnotifications()));
                          // ChangePassword();
                        } else {
                          //WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;

                          final overlay = Overlay.of(context);
                          if (overlay == null) return;

                          showTopSnackBar(
                            overlay,
                            const CustomSnackBar.error(
                              message: "Please Check Your Internet Connection",
                            ),
                          );
                          // });
                          // Fluttertoast.showToast(
                          //   msg: "No Internet",
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.CENTER,
                          // );
                        }
                      });
                    }),

                SpeedDialChild(
                    child: CupertinoSwitch(
                      activeColor: HexColor(Colorscommon.greencolor),
                      value: _fingerValue,
                      onChanged: (bool value) {
                        setState(() {
                          _fingerValue = value;
                          setdata();
                        });
                        // setState(() {
                        //   _fingerValue = value;
                        //   setdata();
                        // });
                      },
                    ),
                    label: 'Use Biometric',
                    backgroundColor: Colors.transparent,
                    onTap: () {
                      sessionManager.internetcheck().then((intenet) async {
                        if (intenet) {
                          ChangePassword();
                          //               final SharedPreferences pref = await SharedPreferences.getInstance();
                          // String userid = pref.getString("userid") ?? "";
                        } else {
                          //WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;

                          final overlay = Overlay.of(context);
                          if (overlay == null) return;

                          showTopSnackBar(
                            overlay,
                            const CustomSnackBar.error(
                              message: "Please Check Your Internet Connection",
                            ),
                          );
                          // });
                          // Fluttertoast.showToast(
                          //   msg: "No Internet",
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.CENTER,
                          // );
                        }
                      });
                    }),

                // SpeedDialChild(
                //     child: Icon(Icons.mail),
                //     label: 'Mail',
                //     onTap: () {
                //       print('Mail Tapped');
                //     }),
                // SpeedDialChild(
                //     child: Icon(Icons.copy),
                //     label: 'Copy',
                //     onTap: () {
                //       print('Copy Tapped');
                //     }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
