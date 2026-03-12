import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/Forgotpassword.dart';
import 'package:flutter_application_sfdc_idp/GradientText.dart';
import 'package:flutter_application_sfdc_idp/Localnotification.dart';
import 'package:flutter_application_sfdc_idp/Login.dart';
import 'package:flutter_application_sfdc_idp/Networkconnection.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// var uuid = Uuid();

SessionManager sessionManager = SessionManager();

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  late String loadURL;
  late BuildContext dialogContext_password;
  TextEditingController emailorphonecontroller = TextEditingController();
  final Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize(context);

    /// Internet check
    sessionManager.internetcheck().then((internet) {
      if (!internet && mounted) {
        final overlay = Overlay.of(context);
        if (overlay != null) {
          showTopSnackBar(
            overlay,
            const CustomSnackBar.error(
              message: "Please Check Your Internet Connection",
            ),
          );
        }
      }
    });

    /// WebView setup (NEW API)
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'messageHandler',
        onMessageReceived: (JavaScriptMessage message) {
          print("message from webview = ${message.message}");

          final Map valueMap = json.decode(message.message);
          final String mapstr = valueMap["login"];
          final String uuidserver = valueMap["uuid"];
          final String serverstate = valueMap["state"];

          if (mapstr == "login") {
            sessionManager.setuuid(uuidserver);
            sessionManager.setserverstate(serverstate);

            Timer(const Duration(seconds: 3), () {
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              );
            });
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("progress $progress");
          },
          onPageStarted: (String url) {
            print("started $url");
          },
          onPageFinished: (String url) {
            print("finished $url");
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://epuat-sp-lithium.cs114.force.com/SPUATTestCommunity/services/auth/sso/SP_App_Mapping_v1',
        ),
      );
  }

  // void initState() {
  //   super.initState();
  //
  //   LocalNotificationService.initialize(context);
  //   // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  //   sessionManager.internetcheck().then((intenet) async {
  //     if (intenet) {
  //     } else {
  //     //  WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (!mounted) return;
  //
  //         final overlay = Overlay.of(context);
  //         if (overlay == null) return;
  //
  //         showTopSnackBar(
  //           overlay,
  //           const CustomSnackBar.error(
  //             message: "Please Check Your Internet Connection",
  //           ),
  //         );
  //      // });
  //     }
  //   });
  // }

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

  void ForgotPassword() {
    emailorphonecontroller.text = "";
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  child: GradientText(
                    "Forgot Password",
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
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: HexColor(Colorscommon.greencolor)),
                    child: TextField(
                      controller: emailorphonecontroller,
                      maxLength: 10,
                      keyboardType: TextInputType.number,

                      // obscureText: true,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'AvenirLTStd',
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,

                      //  controller: usernameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter registered phone number'),
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
                                ForgotpasswordAPI();
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Please check your internet connection",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please enter valid phone number",
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
                                HexColor(Colorscommon.greencolor),
                                HexColor(Colorscommon.greenlite),
                              ])),
                          child: const Center(
                              child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          )),
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
                                  color: HexColor(Colorscommon.greencolor))),
                          child: const Center(
                              child: Text(
                            "Close",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Montserrat',
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

  // void updatefcmtoken(String username) async {
  //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //   String url = CommonURL.URL;
  //   String? token;
  //   token = await _firebaseMessaging.getToken();
  //   print("fcmtoken$token");
  //   Map<String, String> postdata = {
  //     "from": "updateDriversFCMCode",
  //     "username": username,
  //     "idFCM": "$token",
  //     "mobileType": "1",
  //   };

  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/hal+json',
  //     'Accept': 'application/json',
  //   };

  //   final response = await http.post(url,
  //       body: jsonEncode(postdata), headers: requestHeaders);

  //   // print("${response.statusCode}");
  //   // print("${response.body}");

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     // print("jsonInput$jsonInput");

  //     String status = jsonInput['status'].toString();
  //     // String message = jsonInput['message'];
  //     if (status == 'true') {
  //       // Navigator.push(
  //       //     context, MaterialPageRoute(builder: (context) => Login()));
  //       // Fluttertoast.showToast(
  //       //   msg: message,
  //       //   toastLength: Toast.LENGTH_SHORT,
  //       //   gravity: ToastGravity.CENTER,
  //       // );
  //     }
  //   } else {}
  // }

  // void getuserdetailsbuuuid(String uuid) async {
  //   String url = CommonURL.URL;
  //   Map<String, String> postdata = {
  //     "from": "getCurrentLoginDriver",
  //     "uuid": uuid,
  //   };

  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/hal+json',
  //     'Accept': 'application/json',
  //   };

  //   final response = await http.post(url,
  //       body: jsonEncode(postdata), headers: requestHeaders);

  //   print("${response.statusCode}");
  //   print("${response.body}");

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     print("jsonInput$jsonInput");

  //     String status = jsonInput['status'].toString();
  //     String message = jsonInput['message'];
  //     if (status == 'true') {
  //       String username = jsonInput['data']['lithium_id'].toString();
  //       String password = jsonInput['data']['password'].toString();
  //       String mobile_no = jsonInput['data']['mobile_no'].toString();
  //       String access_token = jsonInput['data']['access_token'].toString();
  //       String refresh_token = jsonInput['data']['refresh_token'].toString();
  //       print("username==$username");
  //       print("username==$username");
  //       print("username==$username");
  //       print("username==$username");
  //       print("username==$username");
  //       // updatefcmtoken(username);
  //     }
  //   } else {}
  // }

  void ForgotpasswordAPI() async {
    String url = CommonURL.URL;
    Map<String, String> postdata = {
      "from": "driversGetVerificationCode",
      "emailOrMobile": emailorphonecontroller.text,
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

      // debugPrint('Passwordchnageresponse $jsonInput');

      String success = jsonInput['success'].toString();
      String message = jsonInput['message'];
      // debugPrint('Location_success $success');
      // debugPrint('Location_message $message');

      // Navigator.pop(dialogContext);

      if (success == '1') {
        String idDriverr = jsonInput['id_driver'].toString();
        String lithiumId = jsonInput['lithium_id'].toString();
        String idSupervisor = jsonInput['id_supervisor'].toString();
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
        // return Future.value(true);
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      debugPrint('SERVER=FAILED');

      Fluttertoast.showToast(
        msg: "Something went wrong please try again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

// }
  late WebViewController controller;

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
        home: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                SizedBox(
                  width: 0,
                  height: 0,
                  // color: Colors.red,
                  child: WebViewWidget(controller: controller),
                ),
                Expanded(
                    child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  // color: HexColor(Colorscommon.greencolor),
                  // decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight,
                  //         colors: [
                  //       // HexColor(Colorscommon.grey_low),
                  //       HexColor(Colorscommon.grey_low),
                  //       HexColor(Colorscommon.greencolor),
                  //       // HexColor(Colorscommon.grey_low),
                  //       // Colors.purpleAccent,
                  //       // Colors.amber,
                  //       // Colors.blue,
                  //     ])),
                  child: Lottie.asset('assets/newcar.json'),
                )),
                Image.asset(
                  'assets/lithiugif.gif',
                  width: 50,
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            )
            // body: Builder(builder: (context) {
            //   return WebView(
            //     initialUrl: 'http://192.168.1.21/Paul/SFDC-salesforce',
            //     // initialUrl: 'https://project-lithium--epuat.my.salesforce.com/',
            //     // initialUrl:
            //     //     "https://project-lithium--epuat.my.salesforce.com/services/auth/sso/SP_App_Mapping_v1?startURL=%2F",
            //     javascriptMode: JavascriptMode.unrestricted,
            //     javascriptChannels: <JavascriptChannel>{
            //       JavascriptChannel(
            //         name: 'messageHandler',
            //         onMessageReceived: (JavascriptMessage message) {
            //           print("message from the web view=\"${message.message}\"");
            //           print(message.message);
            //           Map valueMap = json.decode(message.message);
            //           String mapstr = valueMap["login"];
            //           String uuidserver = valueMap["uuid"];
            //           String serverstate = valueMap["state"];
            //           print("uuidserver$uuidserver");
            //           print("serverstate$serverstate");
            //           // String mapstr = valueMap["uuid"];
            //           print("mapstr$mapstr");
            //           if (mapstr == "login") {
            //             sessionManager.setuuid(uuidserver).then((value) => {});
            //             sessionManager.setserverstate(serverstate).then((value) =>
            //                 {
            //                   Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => const Login()))
            //                 });
            //           } else {
            //             // getuserdetailsbuuuid(uuidserver);
            //           }
            //         },
            //       )
            //     },

            //     // backgroundColor: Colors.green,
            //     onWebViewCreated: (WebViewController webviewcontroller) {
            //       // _controller.complete
            //       controller = webviewcontroller;
            //     },
            //     // onWebResourceError: (url) {
            //     //   print('errorurl$url');
            //     // },
            //     onProgress: (int val) {
            //       print("val$val");
            //     },
            //     onPageStarted: (url) async {
            //       print('staredurl$url');
            //       // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            //       // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            //       // // String? datastrid = androidInfo.androidId.toString();
            //       // print("datastrid$datastrid");
            //     },
            //     onPageFinished: (url) {
            //       // setState(() {
            //       print("getredurl$url");
            //       // });
            //     },
            //   );
            // }),
            ),
      ),
    );
  }
}

// 
