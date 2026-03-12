// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_sfdc_idp/Bouncing.dart';
// import 'package:flutter_application_sfdc_idp/Colors.dart';
// import 'package:flutter_application_sfdc_idp/CommonColor.dart';
// import 'package:flutter_application_sfdc_idp/CommonText.dart';
// import 'package:flutter_application_sfdc_idp/Login.dart';
// import 'package:flutter_application_sfdc_idp/SessionManager.dart';
// import 'package:flutter_application_sfdc_idp/URL.dart';
// import 'package:flutter_application_sfdc_idp/Utility.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:restart_app/restart_app.dart';
// // var uuid = Uuid();

// SessionManager sessionManager = SessionManager();

// class Settings extends StatefulWidget {
//   const Settings({Key? key}) : super(key: key);

//   @override
//   SettingsState createState() => SettingsState();
// }

// class SettingsState extends State<Settings> {
//   late BuildContext dialogContext_password;
//   bool _fingerValue = false;
//   TextEditingController emailorphonecontroller = TextEditingController();
//   Utility utility = Utility();
//   String? _fingerValuestr;
//   var username = "";
//   var emailshow = "";
//   @override
//   void initState() {
//     super.initState();
//     // LocalNotificationService.initialize(context);
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//     utility.GetUserdata().then((value) => {
//           print(utility.lithiumid.toString()),
//           username = utility.lithiumid,
//           emailshow = utility.emailId,
//           Getdata(),
//           setState(() {}),
//         });
//   }

//   Future<void> _showMyDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Change password',
//             style: TextStyle(color: Colors.green, fontSize: 20),
//           ),
//           // backgroundColor: Colors.green,
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: const <Widget>[
//                 TextField(),
//                 TextField(),
//                 TextField(),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 'Submit',
//                 style: TextStyle(
//                     color: Colors.green,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {},
//             ),
//             TextButton(
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(
//                     color: Colors.green,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // void ForgotPassword() {
//   //   emailorphonecontroller.text = "";
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (BuildContext context) {
//   //       dialogContext_password = context;

//   //       return Dialog(
//   //         insetPadding: EdgeInsets.all(5),

//   //         // padding: const EdgeInsets.all(5.0),
//   //         child: Container(
//   //           margin: EdgeInsets.all(15),
//   //           width: double.infinity,
//   //           padding: EdgeInsets.all(5),
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Align(
//   //                 alignment: Alignment.centerLeft,
//   //                 child: GradientText(
//   //                   "Forgot Password",
//   //                   18,
//   //                   gradient: LinearGradient(colors: [
//   //                     HexColor(Colorscommon.greencolor),
//   //                     HexColor(Colorscommon.greenlite),
//   //                   ]),
//   //                 ),
//   //               ),
//   //               Container(
//   //                 margin: EdgeInsets.only(top: 30, left: 0, right: 0),
//   //                 decoration: BoxDecoration(
//   //                     border: Border(bottom: BorderSide(color: Colors.grey))),
//   //                 child: Theme(
//   //                   data: Theme.of(context).copyWith(
//   //                       primaryColor: HexColor(Colorscommon.greencolor)),
//   //                   child: TextField(
//   //                     controller: emailorphonecontroller,
//   //                     maxLength: 10,
//   //                     keyboardType: TextInputType.number,

//   //                     // obscureText: true,
//   //                     style: TextStyle(
//   //                         color: Colors.grey,
//   //                         fontFamily: 'AvenirLTStd',
//   //                         fontWeight: FontWeight.bold),
//   //                     textAlign: TextAlign.start,

//   //                     //  controller: usernameController,
//   //                     decoration: InputDecoration(
//   //                         border: OutlineInputBorder(),
//   //                         labelText: 'Enter registered phone number'),
//   //                   ),
//   //                 ),
//   //               ),
//   //               Center(
//   //                 child: Row(
//   //                   children: [
//   //                     Bouncing(
//   //                       onPress: () {
//   //                         if (emailorphonecontroller.text.isNotEmpty) {
//   //                           sessionManager
//   //                               .internetcheck()
//   //                               .then((intenet) async {
//   //                             if (intenet != null && intenet) {
//   //                               ForgotpasswordAPI();
//   //                             } else {
//   //                               Fluttertoast.showToast(
//   //                                 msg: "Please check your internet connection",
//   //                                 toastLength: Toast.LENGTH_SHORT,
//   //                                 gravity: ToastGravity.CENTER,
//   //                               );
//   //                             }
//   //                           });
//   //                         } else {
//   //                           Fluttertoast.showToast(
//   //                             msg: "Please enter valid phone number",
//   //                             toastLength: Toast.LENGTH_SHORT,
//   //                             gravity: ToastGravity.CENTER,
//   //                           );
//   //                         }
//   //                       },
//   //                       child: Container(
//   //                         margin: EdgeInsets.only(top: 20, left: 0, right: 0),
//   //                         height: 40,
//   //                         width: 100,
//   //                         decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(5),
//   //                             gradient: LinearGradient(colors: [
//   //                               HexColor(Colorscommon.greencolor),
//   //                               HexColor(Colorscommon.greenlite),
//   //                             ])),
//   //                         child: Center(
//   //                             child: Text(
//   //                           "Confirm",
//   //                           style: TextStyle(
//   //                               color: Colors.white,
//   //                               fontFamily: 'Montserrat',
//   //                               fontWeight: FontWeight.bold),
//   //                         )),
//   //                       ),
//   //                     ),
//   //                     Bouncing(
//   //                       onPress: () {
//   //                         Navigator.pop(dialogContext_password);
//   //                       },
//   //                       child: Container(
//   //                         margin: EdgeInsets.only(top: 20, left: 10, right: 0),
//   //                         height: 40,
//   //                         width: 100,
//   //                         decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(5),
//   //                             border: Border.all(
//   //                                 color: HexColor(Colorscommon.greencolor))),
//   //                         child: Center(
//   //                             child: Text(
//   //                           "Close",
//   //                           style: TextStyle(
//   //                               color: Colors.grey,
//   //                               fontFamily: 'Montserrat',
//   //                               fontWeight: FontWeight.bold),
//   //                         )),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   // void updatefcmtoken(String username) async {
//   //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   //   String url = CommonURL.URL;
//   //   String? token;
//   //   token = await _firebaseMessaging.getToken();
//   //   print("fcmtoken$token");
//   //   Map<String, String> postdata = {
//   //     "from": "updateDriversFCMCode",
//   //     "username": username,
//   //     "idFCM": "$token",
//   //     "mobileType": "1",
//   //   };

//   //   Map<String, String> requestHeaders = {
//   //     'Content-type': 'application/hal+json',
//   //     'Accept': 'application/json',
//   //   };

//   //   final response = await http.post(url,
//   //       body: jsonEncode(postdata), headers: requestHeaders);

//   //   // print("${response.statusCode}");
//   //   // print("${response.body}");

//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
//   //     // print("jsonInput$jsonInput");

//   //     String status = jsonInput['status'].toString();
//   //     // String message = jsonInput['message'];
//   //     if (status == 'true') {
//   //       // Navigator.push(
//   //       //     context, MaterialPageRoute(builder: (context) => Login()));
//   //       // Fluttertoast.showToast(
//   //       //   msg: message,
//   //       //   toastLength: Toast.LENGTH_SHORT,
//   //       //   gravity: ToastGravity.CENTER,
//   //       // );
//   //     }
//   //   } else {}
//   // }

//   // void getuserdetailsbuuuid(String uuid) async {
//   //   String url = CommonURL.URL;
//   //   Map<String, String> postdata = {
//   //     "from": "getCurrentLoginDriver",
//   //     "uuid": uuid,
//   //   };

//   //   Map<String, String> requestHeaders = {
//   //     'Content-type': 'application/hal+json',
//   //     'Accept': 'application/json',
//   //   };

//   //   final response = await http.post(url,
//   //       body: jsonEncode(postdata), headers: requestHeaders);

//   //   print("${response.statusCode}");
//   //   print("${response.body}");

//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
//   //     print("jsonInput$jsonInput");

//   //     String status = jsonInput['status'].toString();
//   //     String message = jsonInput['message'];
//   //     if (status == 'true') {
//   //       String username = jsonInput['data']['lithium_id'].toString();
//   //       String password = jsonInput['data']['password'].toString();
//   //       String mobile_no = jsonInput['data']['mobile_no'].toString();
//   //       String access_token = jsonInput['data']['access_token'].toString();
//   //       String refresh_token = jsonInput['data']['refresh_token'].toString();
//   //       print("username==$username");
//   //       print("username==$username");
//   //       print("username==$username");
//   //       print("username==$username");
//   //       print("username==$username");
//   //       // updatefcmtoken(username);
//   //     }
//   //   } else {}
//   // }

//   void logoutapi(String id, String accesstoken, String email) async {
//     print("id$id");
//     print("accesstoken$accesstoken");
//     print("email$email");
//     String url = CommonURL.URL;
//     Map<String, String> postdata = {
//       "from": "driverLogout",
//       "id": id,
//       "access_token": accesstoken,
//       "username": email,
//     };

//     Map<String, String> requestHeaders = {
//       'Content-type': 'application/hal+json',
//       'Accept': 'application/json',
//     };

//     debugPrint('fetchdata $url');
//     debugPrint('fetchdata $postdata');

//     final response = await http.post(Uri.parse(url),
//         body: jsonEncode(postdata), headers: requestHeaders);

//     print("${response.statusCode}");
//     print(response.body);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);

//       // debugPrint('Passwordchnageresponse $jsonInput');

//       String success = jsonInput['success'].toString();
//       String message = jsonInput['message'];
//       // debugPrint('Location_success $success');
//       // debugPrint('Location_message $message');

//       Navigator.pop(context);

//       if (success == '1') {
//         // String idDriverr = jsonInput['id_driver'].toString();
//         // Navigator.of(context).pushAndRemoveUntil(
//         //     '/WebViewExample', (Route<dynamic> route) => false);
//         // Navigator.pushNamedAndRemoveUntil(
//         //     context, MaterialPageRoute(builder: (context) => const WebViewExample()));
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Restart.restartApp();

//         // Fluttertoast.showToast(
//         //   msg: message,
//         //   toastLength: Toast.LENGTH_SHORT,
//         //   gravity: ToastGravity.CENTER,
//         // );
//         // return Future.value(true);
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Restart.restartApp();
//       }

//       // Fluttertoast.showToast(
//       //   msg: message,
//       //   toastLength: Toast.LENGTH_SHORT,
//       //   gravity: ToastGravity.CENTER,
//       // );
//     } else {
//       debugPrint('SERVER=FAILED');

//       Fluttertoast.showToast(
//         msg: "Something Went Wrong Please Try Again",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//     }
//   }

//   // void ForgotpasswordAPI() async {
//   //   String url = CommonURL.URL;
//   //   Map<String, String> postdata = {
//   //     "from": "driversGetVerificationCode",
//   //     "emailOrMobile": emailorphonecontroller.text,
//   //   };

//   //   Map<String, String> requestHeaders = {
//   //     'Content-type': 'application/hal+json',
//   //     'Accept': 'application/json',
//   //   };

//   //   debugPrint('fetchdata $url');
//   //   debugPrint('fetchdata $postdata');

//   //   final response = await http.post(url,
//   //       body: jsonEncode(postdata), headers: requestHeaders);

//   //   print("${response.statusCode}");
//   //   print("${response.body}");

//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);

//   //     // debugPrint('Passwordchnageresponse $jsonInput');

//   //     String success = jsonInput['success'].toString();
//   //     String message = jsonInput['message'];
//   //     // debugPrint('Location_success $success');
//   //     // debugPrint('Location_message $message');

//   //     // Navigator.pop(dialogContext);

//   //     if (success == '1') {
//   //       String idDriverr = jsonInput['id_driver'].toString();

//   //       Fluttertoast.showToast(
//   //         msg: message,
//   //         toastLength: Toast.LENGTH_SHORT,
//   //         gravity: ToastGravity.CENTER,
//   //       );
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => ForgotPasswordClass(
//   //               text: emailorphonecontroller.text,
//   //               id_driver: idDriverr,
//   //             ),
//   //           ));
//   //       // return Future.value(true);
//   //     }

//   //     Fluttertoast.showToast(
//   //       msg: message,
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       gravity: ToastGravity.CENTER,
//   //     );
//   //   } else {
//   //     debugPrint('SERVER=FAILED');

//   //     Fluttertoast.showToast(
//   //       msg: "Something went wrong please try again",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       gravity: ToastGravity.CENTER,
//   //     );
//   //   }
//   // }

// // }
//   late WebViewController controller;
//   TextEditingController oldpasswordcontroller = TextEditingController();
//   TextEditingController newpasswordcontroller = TextEditingController();
//   TextEditingController confirmpasswordcontroller = TextEditingController();

//   void chagepasswordapirequest(String userid, clientid, accesstokken,
//       refreshtokken, mobile, oldPassword) async {
//     String url = CommonURL.URL;
//     // print(oldpasswordcontroller.text);
//     // print(newpasswordcontroller.text);
//     // print(confirmpasswordcontroller.text);
//     // print(clientid);
//     // print(userid);
//     // print(accesstokken);
//     // print(mobile);
//     // print(refreshtokken);
//     Map<String, String> postdata = {
//       "from": "changeDriversPassword",
//       "oldPassword": oldpasswordcontroller.text,
//       "newPassword": newpasswordcontroller.text,
//       "confirmPassword": confirmpasswordcontroller.text,
//       "clientID": clientid,
//       "userId": userid,
//       "access_token": accesstokken,
//       "username": utility.lithiumid,
//       "refresh_token": refreshtokken,
//     };
//     Map<String, String> requestHeaders = {
//       'Content-type': 'application/hal+json',
//       'Accept': 'application/json',
//     };
//     debugPrint('fetchdata $url');

//     final response = await http.post(Uri.parse(url),
//         body: jsonEncode(postdata), headers: requestHeaders);

//     print("${response.statusCode}");
//     print(response.body);

//     debugPrint('Passwordchnageresponse $response.statusCode');

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);

//       debugPrint('Passwordchnageresponse $jsonInput');

//       String success = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//       debugPrint('Location_success $success');
//       debugPrint('Location_message $message');

//       Navigator.pop(context);

//       if (success == 'true') {
//         // Navigator.pop(context);
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Timer(const Duration(milliseconds: 100), () {
//           // Restart.restartApp();
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const Login(),
//               ));
//           print(" This line is execute after 5 seconds");
//         });
//       }
//       if (success == 'false') {
//         // Navigator.pop(context);
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         // Timer(const Duration(milliseconds: 100), () {
//         //   // Restart.restartApp();
//         //   Navigator.push(
//         //       context,
//         //       MaterialPageRoute(
//         //         builder: (context) => const Login(),
//         //       ));
//         //   print(" This line is execute after 5 seconds");
//         // });
//       }
//     } else {
//       debugPrint('SERVER=FAILED');

//       Fluttertoast.showToast(
//         msg: "Something Went Wrong Please Try Again",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//     }
//   }

//   void loading() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         // dialogContext = context;
//         return Dialog(
//           child: Padding(
//             padding: const EdgeInsets.all(25.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 /*  new CircularProgressIndicator(
//                   valueColor: new AlwaysStoppedAnimation(Colors.red),
//                 ),*/

//                 Image.asset(
//                   'assets/lithiugif.gif',
//                   width: 50,
//                   // color: Colors.purple.shade800,
//                 ),
//                 Container(
//                     margin: const EdgeInsets.only(left: 10),
//                     child: const Text("Loading")),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   validateInputs() async {
//     if (oldpasswordcontroller.text.isNotEmpty) {
//       if (newpasswordcontroller.text.isNotEmpty) {
//         if (newpasswordcontroller.text == confirmpasswordcontroller.text) {
//           final SharedPreferences pref = await SharedPreferences.getInstance();
//           String userid = pref.getString("userid") ?? "";
//           // String clientid = pref.getString("clientid") ?? "";
//           // clientID:222
//           String clientid = '222';
//           String refreshtokken = pref.getString("refreshtokken") ?? "";
//           String accesstokken = pref.getString("accesstokken") ?? "";
//           String mobile = pref.getString("mobile_no") ?? "";

//           String oldPassword = pref.getString("password") ?? "";
//           print("userid$userid");
//           print("clientid$clientid");
//           print("refreshtokken$refreshtokken");
//           print("accesstokken$accesstokken");
//           print("mobile$mobile");
//           print("oldPassword$oldPassword");

//           // if (oldPassword == oldpasswordcontroller.text) {
//           sessionManager.internetcheck().then((intenet) async {
//             if (intenet) {
//               FocusScope.of(context).unfocus();
//               loading();
//               utility.GetUserdata().then((value) => {
//                     chagepasswordapirequest(userid, clientid, accesstokken,
//                         refreshtokken, mobile, oldPassword)
//                   });
//             } else {
//               showTopSnackBar(
//                 context,
//                 const CustomSnackBar.error(
//                   // icon: Icon(Icons.interests),
//                   message: "Please Check Your Internet Connection",
//                   // backgroundColor: Colors.white,
//                   // textStyle: TextStyle(color: Colors.red),
//                 ),
//               );
//               // Fluttertoast.showToast(
//               //   msg: "No Internet",
//               //   toastLength: Toast.LENGTH_SHORT,
//               //   gravity: ToastGravity.CENTER,
//               // );
//             }
//           });

//           // } else {
//           //   Fluttertoast.showToast(
//           //     msg: "incorrect old password",
//           //     toastLength: Toast.LENGTH_SHORT,
//           //     gravity: ToastGravity.CENTER,
//           //   );
//           // }
// //  void Chagepasswordapirequest(String userid, clientid, accesstokken,
// //       refreshtokken, mobile, oldPassword) async {

//         } else {
//           Fluttertoast.showToast(
//             msg: "New Password & Confirm Password Doesn't Match",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//           );
//         }
//       } else {
//         Fluttertoast.showToast(
//           msg: "Please Enter New Password",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Please Enter Old Password",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//     }
//   }

//   void ChangePassword() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         // dialogContext = context;

//         return Dialog(
//           insetPadding: const EdgeInsets.all(5),

//           // padding: const EdgeInsets.all(5.0),
//           child: Container(
//             margin: const EdgeInsets.all(15),
//             width: double.infinity,
//             padding: const EdgeInsets.all(5),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Avenirtextblack(
//                     customfontweight: FontWeight.normal,
//                     fontsize: 14,
//                     text: 'Change Password',
//                     textcolor: HexColor(Colorscommon.greendark2),
//                     // customfontweight: FontWeight.w500,
//                     // fontsize: 15,
//                     // text: 'Change Password',
//                     // textcolor: HexColor(Colorscommon.greencolor),
//                   ),
//                   // child: GradientText(
//                   //   "Change Password",
//                   //   18,
//                   //   gradient: LinearGradient(colors: [
//                   //     HexColor(Colorscommon.greencolor),
//                   //     HexColor(Colorscommon.greencolor),
//                   //   ]),
//                   // ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 30, left: 0, right: 0),
//                   decoration: const BoxDecoration(
//                       // border: Border(bottom: BorderSide(color: Colors.grey))
//                       ),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                         primaryColor: HexColor(Colorscommon.greencolor)),
//                     child: TextField(
//                       controller: oldpasswordcontroller,
//                       obscureText: true,
//                       style: TextStyle(
//                         fontFamily: 'AvenirLTStd-Book',
//                         fontSize: 14,
//                         color: HexColor(Colorscommon.greydark2),
//                       ),
//                       textAlign: TextAlign.start,

//                       //  controller: usernameController,
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: 'Enter Old Password',
//                         labelStyle: TextStyle(
//                           fontFamily: 'AvenirLTStd-Book',
//                           fontSize: 14,
//                           color: HexColor(Colorscommon.greydark2),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 15, left: 0, right: 0),
//                   decoration: const BoxDecoration(
//                       // border: Border(bottom: BorderSide(color: Colors.grey))
//                       ),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                         primaryColor: HexColor(Colorscommon.greencolor)),
//                     child: TextField(
//                       controller: newpasswordcontroller,
//                       obscureText: true,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontFamily: 'AvenirLTStd-Book',
//                         fontSize: 14,
//                         color: HexColor(Colorscommon.greydark2),
//                       ),
//                       // controller: passwordController,
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: "Enter New Password",
//                         labelStyle: TextStyle(
//                           fontFamily: 'AvenirLTStd-Book',
//                           fontSize: 14,
//                           color: HexColor(Colorscommon.greydark2),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 15, left: 0, right: 0),
//                   decoration: const BoxDecoration(
//                       // border: Border(bottom: BorderSide(color: Colors.grey))
//                       ),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                         primaryColor: HexColor(Colorscommon.greencolor)),
//                     child: TextField(
//                       controller: confirmpasswordcontroller,
//                       obscureText: true,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontFamily: 'AvenirLTStd-Book',
//                         fontSize: 14,
//                         color: HexColor(Colorscommon.greydark2),
//                       ),
//                       // controller: passwordController,
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: "Confirm New Password",
//                         labelStyle: TextStyle(
//                           fontFamily: 'AvenirLTStd-Book',
//                           fontSize: 14,
//                           color: HexColor(Colorscommon.greydark2),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Row(
//                     children: [
//                       Bouncing(
//                         onPress: () {
//                           validateInputs();
//                         },
//                         child: Container(
//                           margin:
//                               const EdgeInsets.only(top: 20, left: 0, right: 0),
//                           height: 40,
//                           width: 100,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               gradient: LinearGradient(colors: [
//                                 HexColor(Colorscommon.greenlight2),
//                                 HexColor(Colorscommon.greenlight2),
//                               ])),
//                           child: const Center(
//                             child: Avenirtextblack(
//                                 text: "Confirm",
//                                 fontsize: 14,
//                                 textcolor: Colors.white,
//                                 customfontweight: FontWeight.w500),
//                             //     child: Text(
//                             //   "Confirm",
//                             //   style: TextStyle(
//                             //       color: Colors.white,
//                             //       fontFamily: 'Lato',
//                             //       fontWeight: FontWeight.bold),
//                             // )
//                           ),
//                         ),
//                       ),
//                       Bouncing(
//                         onPress: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(
//                               top: 20, left: 10, right: 0),
//                           height: 40,
//                           width: 100,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(
//                                   color: HexColor(Colorscommon.greenlight2))),
//                           child: Center(
//                             child: Avenirtextblack(
//                                 text: "Close",
//                                 fontsize: 14,
//                                 textcolor: HexColor(Colorscommon.greenlight2),
//                                 customfontweight: FontWeight.w500),
//                             //     child: Text(
//                             //   "Close",
//                             //   style: TextStyle(
//                             //       color: HexColor(Colorscommon.greenlight2),
//                             //       fontFamily: 'Lato',
//                             //       fontWeight: FontWeight.bold),
//                             // )
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Navigator.pop(context, true);
//         return false;
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.green,
//         ),
//         home: Scaffold(
//           resizeToAvoidBottomInset: true,

//           appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(100),
//             child: AppBar(
//               backgroundColor: HexColor(Colorscommon.greenAppcolor),
//               centerTitle: true,
//               leading: Container(),
//               // leading: IconButton(
//               //   icon: const Icon(Icons.arrow_back, color: Colors.black),
//               //   onPressed: () => Navigator.of(context, rootNavigator: true),
//               //   // Navigator.push(
//               //   //     context,
//               //   //     MaterialPageRoute(
//               //   //         builder: (context) => const MyTabPage(
//               //   //               title: '',
//               //   //             )
//               //   //             )
//               //   //             ),
//               // ),
//               // leading: Bouncing(
//               //   onPress: () {
//               //     Navigator.pop(context);
//               //   },
//               //   child: const Icon(
//               //     Icons.arrow_back,
//               //     size: 30,
//               //     color: Colors.white,
//               //   ),
//               // ),
//               title: const Text(
//                 "Settings",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'Lato',
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               shape: CustomAppBarShape(),
//             ),
//           ),
//           body: Column(children: [
//             Container(
//               color: HexColor("#F8F8F8"),
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     getProfileView(),
//                     Container(
//                       margin: const EdgeInsets.only(left: 30),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             username,
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'AvenirLTStd-Black',
//                                 color: HexColor(Colorscommon.darkblack)),
//                           ),
//                           Text(
//                             emailshow,
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                                 color: HexColor(Colorscommon.darkblack)),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.keyboard_arrow_right,
//                             color: Color(0xff268D79)))
//                   ],
//                 ),
//               ),
//             ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   children: [
//             //     Expanded(
//             //       child: Container(
//             //         margin: const EdgeInsets.all(0),
//             //         child: const Center(
//             //             child: Text(
//             //           "Settings",
//             //           style: TextStyle(
//             //               color: Colors.white,
//             //               fontSize: 20,
//             //               fontWeight: FontWeight.bold),
//             //         )),
//             //         height: MediaQuery.of(context).size.width / 8,
//             //         color: HexColor(Colorscommon.greencolor),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             const SizedBox(
//               height: 10,
//             ),
//             Card(
//               elevation: .8,
//               margin: const EdgeInsets.all(15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: SizedBox(
//                 // height: MediaQuery.of(context).size.height ,
//                 width: MediaQuery.of(context).size.width - 40,
//                 child: ListView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   children: [
//                     // Container(
//                     //   margin: const EdgeInsets.all(10),
//                     //   height: 10,
//                     //   child: Row(
//                     //     children: const [
//                     //       Icon(
//                     //         Icons.lock_outline,
//                     //         color: Color(0xff268D79),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     Visibility(
//                       visible: _fingerValuestr == "1234",
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 0.0, horizontal: 10),
//                         // leading: const Icon(
//                         //   Icons.lock_outline,
//                         //   color: Color(0xff268D79),
//                         // ),
//                         title: Text(
//                           'Change Password',
//                           style: TextStyle(
//                               color: HexColor(
//                                 Colorscommon.greydark2,
//                               ),
//                               fontSize: 14,
//                               fontFamily: 'AvenirLTStd-Book',
//                               fontWeight: FontWeight.w500),
//                         ),
//                         trailing: const Icon(Icons.keyboard_arrow_right,
//                             color: Color(0xff268D79)),
//                         onTap: () {
//                           sessionManager.internetcheck().then((intenet) async {
//                             if (intenet) {
//                               oldpasswordcontroller.text = "";
//                               newpasswordcontroller.text = "";
//                               confirmpasswordcontroller.text = "";
//                               ChangePassword();
//                               //               final SharedPreferences pref = await SharedPreferences.getInstance();
//                               // String userid = pref.getString("userid") ?? "";
//                             } else {
//                               showTopSnackBar(
//                                 context,
//                                 const CustomSnackBar.error(
//                                   // icon: Icon(Icons.interests),
//                                   message:
//                                       "Please Check Your Internet Connection",
//                                   // backgroundColor: Colors.white,
//                                   // textStyle: TextStyle(color: Colors.red),
//                                 ),
//                               );
//                               // Fluttertoast.showToast(
//                               //   msg: "No Internet",
//                               //   toastLength: Toast.LENGTH_SHORT,
//                               //   gravity: ToastGravity.CENTER,
//                               // );
//                             }
//                           });
//                         },
//                       ),
//                     ),
//                     const Padding(
//                         padding: EdgeInsets.only(right: 10, left: 10),
//                         child: Divider(
//                           height: .1,
//                           thickness: .5,
//                         )),
//                     // const Divider(),
//                     // ListTile(
//                     //   contentPadding: const EdgeInsets.symmetric(
//                     //       vertical: 0.0, horizontal: 10),
//                     //   // leading: const Icon(
//                     //   //   Icons.notifications,
//                     //   //   color: Color(0xff268D79),
//                     //   // ),
//                     //   title: Text(
//                     //     'Notification',
//                     //     style: TextStyle(
//                     //         color: HexColor(
//                     //           Colorscommon.greydark2,
//                     //         ),
//                     //         fontSize: 14,
//                     //         fontFamily: 'AvenirLTStd-Book',
//                     //         fontWeight: FontWeight.w500),
//                     //   ),
//                     //   trailing: const Icon(Icons.keyboard_arrow_right,
//                     //       color: Color(0xff268D79)),
//                     //   onTap: () {},
//                     // ),
//                     // const Padding(
//                     //     padding: EdgeInsets.only(right: 10, left: 10),
//                     //     child: Divider(
//                     //       height: .1,
//                     //       thickness: .5,
//                     //     )),
//                     // const Divider(),
//                     ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 0.0, horizontal: 10),
//                       // leading: const Icon(
//                       //   Icons.fingerprint,
//                       //   color: Color(0xff268D79),
//                       // ),

//                       title: Text(
//                         'Use Biometric',
//                         style: TextStyle(
//                             color: HexColor(
//                               Colorscommon.greydark2,
//                             ),
//                             fontSize: 14,
//                             fontFamily: 'AvenirLTStd-Book',
//                             fontWeight: FontWeight.w500),
//                       ),
//                       trailing: CupertinoSwitch(
//                         activeColor: const Color(0xff268D79),
//                         value: _fingerValue,
//                         onChanged: (bool value) {
//                           setState(() {
//                             _fingerValue = value;
//                             setdata();
//                           });
//                         },
//                       ),
//                       onTap: () {},
//                     ),
//                     const Padding(
//                         padding: EdgeInsets.only(right: 10, left: 10),
//                         child: Divider(
//                           height: .1,
//                           thickness: .5,
//                         )),
//                     // const Divider(),
//                     ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 0.0, horizontal: 10),
//                       // leading: const Icon(
//                       //   Icons.logout,
//                       //   color: Color(0xff268D79),
//                       // ),

//                       title: Text(
//                         'Logout',
//                         style: TextStyle(
//                             color: HexColor(
//                               Colorscommon.greydark2,
//                             ),
//                             fontSize: 14,
//                             fontFamily: 'AvenirLTStd-Book',
//                             fontWeight: FontWeight.w500),
//                       ),
//                       trailing: const Icon(Icons.keyboard_arrow_right,
//                           color: Color(0xff268D79)),
//                       onTap: () {
//                         sessionManager.internetcheck().then((intenet) async {
//                           if (intenet) {
//                             _showDialog(context);
//                             // checkupdate(_30minstr);,
//                             // loading();
//                             // Loginapi(serveruuid, serverstate);
//                           } else {
//                             showTopSnackBar(
//                               context,
//                               const CustomSnackBar.error(
//                                 // icon: Icon(Icons.interests),
//                                 message:
//                                     "Please Check Your Internet Connection",
//                                 // backgroundColor: Colors.white,
//                                 // textStyle: TextStyle(color: Colors.red),
//                               ),
//                             );
//                           }
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Visibility(
//             //   visible: _fingerValuestr == "1234",
//             //   child: Bouncing(
//             //     // onTap: () {
//             //     //   ForgotPassword();
//             //     // },
//             //     onPress: () {
//             //       // ForgotPassword();
//             //       sessionManager.internetcheck().then((intenet) async {
//             //         if (intenet) {
//             //           oldpasswordcontroller.text = "";
//             //           newpasswordcontroller.text = "";
//             //           confirmpasswordcontroller.text = "";
//             //           ChangePassword();
//             //           //               final SharedPreferences pref = await SharedPreferences.getInstance();
//             //           // String userid = pref.getString("userid") ?? "";
//             //         } else {
//             //           showTopSnackBar(
//             //             context,
//             //             const CustomSnackBar.error(
//             //               // icon: Icon(Icons.interests),
//             //               message: "Please Check Your Internet Connection",
//             //               // backgroundColor: Colors.white,
//             //               // textStyle: TextStyle(color: Colors.red),
//             //             ),
//             //           );
//             //           // Fluttertoast.showToast(
//             //           //   msg: "No Internet",
//             //           //   toastLength: Toast.LENGTH_SHORT,
//             //           //   gravity: ToastGravity.CENTER,
//             //           // );
//             //         }
//             //       });
//             //     },
//             //     child: Card(
//             //       shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(10), // if you need this
//             //         side: BorderSide(
//             //           color: Colors.grey.withOpacity(0.5),
//             //           width: 1,
//             //         ),
//             //       ),
//             //       elevation: 3,
//             //       margin: const EdgeInsets.all(10),
//             //       child: Container(
//             //         padding: const EdgeInsets.all(10),
//             //         decoration: BoxDecoration(
//             //             borderRadius: const BorderRadius.all(Radius.circular(10)),
//             //             gradient: LinearGradient(colors: [
//             //               HexColor(Colorscommon.whitecolor),
//             //               HexColor(Colorscommon.whitelite)
//             //             ])),
//             //         child: Row(
//             //           children: [
//             //             Icon(
//             //               Icons.lock,
//             //               color: HexColor(Colorscommon.greencolor),
//             //             ),
//             //             Container(
//             //               margin: const EdgeInsets.all(10),
//             //               child: Text(
//             //                 'Change Password',
//             //                 style: TextStyle(
//             //                     fontFamily: 'TomaSans-Regular',
//             //                     fontWeight: FontWeight.bold,
//             //                     color: HexColor(Colorscommon.greycolor)),
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             // // Bouncing(
//             // //   // onTap: () {
//             // //   //   ForgotPassword();
//             // //   // },
//             // //   onPress: () {
//             // //     // ForgotPassword();
//             // //     sessionManager.internetcheck().then((intenet) async {
//             // //       if (intenet != null && intenet) {
//             // //         final SharedPreferences pref =
//             // //             await SharedPreferences.getInstance();
//             // //         String userid = pref.getString("userid") ?? "";
//             // //         Navigator.of(context).push(MaterialPageRoute(
//             // //             builder: (context) => const Localnotifications()));
//             // //         // ChangePassword();
//             // //       } else {
//             // //         showTopSnackBar(
//             // //           context,
//             // //           const CustomSnackBar.error(
//             // //             // icon: Icon(Icons.interests),
//             // //             message: "Please check your internet connection",
//             // //             // backgroundColor: Colors.white,
//             // //             // textStyle: TextStyle(color: Colors.red),
//             // //           ),
//             // //         );
//             // //         // Fluttertoast.showToast(
//             // //         //   msg: "No Internet",
//             // //         //   toastLength: Toast.LENGTH_SHORT,
//             // //         //   gravity: ToastGravity.CENTER,
//             // //         // );
//             // //       }
//             // //     });
//             // //   },
//             // //   child: Card(
//             // //     elevation: 2,
//             // //     margin: const EdgeInsets.all(10),
//             // //     child: Container(
//             // //       padding: const EdgeInsets.all(10),
//             // //       decoration: BoxDecoration(
//             // //           borderRadius: const BorderRadius.all(Radius.circular(10)),
//             // //           gradient: LinearGradient(colors: [
//             // //             HexColor(Colorscommon.whitecolor),
//             // //             HexColor(Colorscommon.whitelite)
//             // //           ])),
//             // //       child: Row(
//             // //         children: [
//             // //           Icon(
//             // //             Icons.notifications,
//             // //             color: HexColor(Colorscommon.greencolor),
//             // //           ),
//             // //           Container(
//             // //             margin: const EdgeInsets.all(10),
//             // //             child: Text(
//             // //               'Messages',
//             // //               style: TextStyle(
//             // //                   fontFamily: 'TomaSans-Regular',
//             // //                   fontWeight: FontWeight.bold,
//             // //                   color: HexColor(Colorscommon.greycolor)),
//             // //             ),
//             // //           ),
//             // //         ],
//             // //       ),
//             // //     ),
//             // //   ),
//             // // ),
//             // // ),
//             // // FadeAnimation(
//             // //   1.2,
//             // // Bouncing(
//             // //   onPress: () {},
//             // //   // onTap: () async {
//             // //   //   // AndroidIntent intent = AndroidIntent(
//             // //   //   //   action: 'action_view',
//             // //   //   //   data: "https://youtu.be/CEZ8dPtZj-E",
//             // //   //   // );
//             // //   //   // await intent.launch();
//             // //   // },
//             // //   child: Card(
//             // //     elevation: 2,
//             // //     margin: EdgeInsets.all(10),
//             // //     child: Container(
//             // //       padding: EdgeInsets.all(10),
//             // //       decoration: BoxDecoration(
//             // //           borderRadius: BorderRadius.all(Radius.circular(10)),
//             // //           gradient: LinearGradient(colors: [
//             // //             HexColor(Colorscommon.whitecolor),
//             // //             HexColor(Colorscommon.whitelite)
//             // //           ])),
//             // //       child: Row(
//             // //         children: [
//             // //           Icon(
//             // //             Icons.help_outline,
//             // //             color: HexColor(Colorscommon.greencolor),
//             // //           ),
//             // //           Container(
//             // //             margin: EdgeInsets.all(10),
//             // //             child: Text(
//             // //               'How to video',
//             // //               style: TextStyle(
//             // //                   fontFamily: 'TomaSans-Regular',
//             // //                   fontWeight: FontWeight.bold,
//             // //                   color: HexColor(Colorscommon.greycolor)),
//             // //             ),
//             // //           ),
//             // //           // Expanded(
//             // //           //   child: Align(
//             // //           //       alignment: Alignment.centerRight,
//             // //           //       child: Image.asset(
//             // //           //         'assets/forward.png',
//             // //           //         width: 15,
//             // //           //       )),
//             // //           // ),
//             // //         ],
//             // //       ),
//             // //     ),
//             // //   ),
//             // // ),
//             // // ),
//             // // FadeAnimation(
//             // //   1.2,
//             // Bouncing(
//             //   onPress: () async {
//             //     final SharedPreferences pref =
//             //         await SharedPreferences.getInstance();
//             //     String id = pref.getString("userid") ?? "";
//             //     String accesstoken = pref.getString("accesstokken") ?? "";
//             //     String email = pref.getString("email_id") ?? "";
//             //     print("id$id");
//             //     print("accesstoken$accesstoken");
//             //     print("email$email");

//             //     showDialog(
//             //         context: context,
//             //         builder: (BuildContext context) {
//             //           return AlertDialog(
//             //             insetPadding: const EdgeInsets.all(10),
//             //             contentPadding: EdgeInsets.zero,
//             //             clipBehavior: Clip.antiAliasWithSaveLayer,
//             //             titlePadding: EdgeInsets.zero,
//             //             title: Container(
//             //               height: 50,
//             //               // margin: const EdgeInsets.all(0),
//             //               color: HexColor(Colorscommon.greencolor),
//             //               // decoration: BoxDecoration(
//             //               //     borderRadius: BorderRadius.circular(0),
//             //               //     gradient: LinearGradient(colors: [
//             //               //       HexColor(Colorscommon.greencolor),
//             //               //       HexColor(Colorscommon.greenlite),
//             //               //     ])),
//             //               child: Center(
//             //                 child: Text(
//             //                   "Confirmation",
//             //                   style: TextStyle(
//             //                       fontSize: 17,
//             //                       fontFamily: "Lato",
//             //                       fontWeight: FontWeight.bold,
//             //                       color: HexColor(Colorscommon.whitecolor)),
//             //                   textAlign: TextAlign.start,
//             //                 ),
//             //               ),
//             //             ),
//             //             titleTextStyle: TextStyle(color: Colors.grey[700]),
//             //             // titlePadding: const EdgeInsets.only(left: 5, top: 5),
//             //             content: Container(
//             //               width: MediaQuery.of(context).size.width,
//             //               margin: const EdgeInsets.only(top: 5),
//             //               child: Padding(
//             //                 padding: const EdgeInsets.only(
//             //                     top: 20, bottom: 10, left: 10, right: 10),
//             //                 child: Text(
//             //                   "Are you sure want to logout ?",
//             //                   textAlign: TextAlign.center,
//             //                   style: TextStyle(
//             //                     fontFamily: 'TomaSans-Regular',
//             //                     fontSize: 18,
//             //                     color: HexColor(Colorscommon.greycolor),
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //             actions: <Widget>[
//             //               Row(
//             //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                 children: [
//             //                   Expanded(
//             //                     child: Container(
//             //                         margin: const EdgeInsets.only(top: 20),
//             //                         child: const Text(
//             //                           "Yes",
//             //                           style: TextStyle(
//             //                               color: Colors.white,
//             //                               fontFamily: 'Lato',
//             //                               fontWeight: FontWeight.bold),
//             //                         )),
//             //                   ),
//             //                   Expanded(
//             //                     flex: 1,
//             //                     child: Bouncing(
//             //                       onPress: () async {
//             //                         // SharedPreferences prefs = await SharedPreferences.getInstance();
//             //                         // Loginbool = 'false';
//             //                         // prefs.setString('loginbool', Loginbool);
//             //                         logoutapi(id, accesstoken, email);
//             //                       },
//             //                       child: Container(
//             //                         margin: const EdgeInsets.only(
//             //                             top: 20, left: 0, right: 0),
//             //                         height: 40,
//             //                         width: 100,
//             //                         decoration: BoxDecoration(
//             //                             borderRadius: BorderRadius.circular(5),
//             //                             gradient: LinearGradient(colors: [
//             //                               HexColor(Colorscommon.greencolor),
//             //                               HexColor(Colorscommon.greencolor),
//             //                             ])),
//             //                         child: const Center(
//             //                             child: Text(
//             //                           "Yes",
//             //                           style: TextStyle(
//             //                               color: Colors.white,
//             //                               fontFamily: 'Montserrat',
//             //                               fontWeight: FontWeight.bold),
//             //                         )),
//             //                       ),
//             //                       // child: Container(
//             //                       //   margin: const EdgeInsets.only(
//             //                       //       top: 20, left: 10, right: 0),
//             //                       //   padding: const EdgeInsets.all(5),
//             //                       //   height: 30,
//             //                       //   decoration: BoxDecoration(
//             //                       //       borderRadius:
//             //                       //           BorderRadius.circular(5),
//             //                       //       gradient: LinearGradient(colors: [
//             //                       //         HexColor(Colorscommon.greycolor),
//             //                       //         HexColor(Colorscommon.greycolor),
//             //                       //       ])),
//             //                       //   child: const Center(
//             //                       //       child: Text(
//             //                       //     "Yes",
//             //                       //     style: TextStyle(
//             //                       //         color: Colors.white,
//             //                       //         fontFamily: 'Lato',
//             //                       //         fontWeight: FontWeight.bold),
//             //                       //   )),
//             //                       // ),
//             //                     ),
//             //                   ),
//             //                   Expanded(
//             //                     flex: 1,
//             //                     child: Bouncing(
//             //                       onPress: () {
//             //                         Navigator.of(context, rootNavigator: true)
//             //                             .pop();
//             //                       },
//             //                       child: Container(
//             //                         margin: const EdgeInsets.only(
//             //                             top: 20, left: 10, right: 0),
//             //                         height: 40,
//             //                         width: 100,
//             //                         decoration: BoxDecoration(
//             //                             borderRadius: BorderRadius.circular(5),
//             //                             border: Border.all(
//             //                                 color: HexColor(
//             //                                     Colorscommon.greencolor))),
//             //                         child: const Center(
//             //                             child: Text(
//             //                           "No",
//             //                           style: TextStyle(
//             //                               color: Colors.grey,
//             //                               fontFamily: 'Montserrat',
//             //                               fontWeight: FontWeight.bold),
//             //                         )),
//             //                       ),
//             //                       // child: Container(
//             //                       //   margin: EdgeInsets.only(
//             //                       //       top: 20, left: 10, right: 0),
//             //                       //   height: 30,
//             //                       //   decoration: BoxDecoration(
//             //                       //       borderRadius:
//             //                       //           BorderRadius.circular(5),
//             //                       //       border: Border.all(
//             //                       //           color: HexColor(
//             //                       //               Colorscommon.greycolor))),
//             //                       //   child: Center(
//             //                       //       child: Text(
//             //                       //     "No",
//             //                       //     style: TextStyle(
//             //                       //         color: HexColor(
//             //                       //             Colorscommon.greycolor),
//             //                       //         fontFamily: 'Lato',
//             //                       //         fontWeight: FontWeight.bold),
//             //                       //   )),
//             //                       // ),
//             //                     ),
//             //                   ),
//             //                 ],
//             //               ),
//             //             ],
//             //           );
//             //         });
//             //   },
//             //   // onTap: () {
//             //   //   // Navigator.of(context).pushAndRemoveUntil(
//             //   //   //     MaterialPageRoute(builder: (context) => Login()),
//             //   //   //     (Route<dynamic> route) => false);
//             //   // },
//             //   child: Card(
//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(10), // if you need this
//             //       side: BorderSide(
//             //         color: Colors.grey.withOpacity(0.5),
//             //         width: 1,
//             //       ),
//             //     ),
//             //     elevation: 3,
//             //     margin: const EdgeInsets.all(10),
//             //     child: Container(
//             //       padding: const EdgeInsets.all(10),
//             //       decoration: BoxDecoration(
//             //           borderRadius: const BorderRadius.all(Radius.circular(10)),
//             //           gradient: LinearGradient(colors: [
//             //             HexColor(Colorscommon.whitecolor),
//             //             HexColor(Colorscommon.whitelite)
//             //           ])),
//             //       child: Row(
//             //         children: [
//             //           Icon(
//             //             Icons.logout,
//             //             color: HexColor(Colorscommon.greencolor),
//             //           ),
//             //           Container(
//             //             margin: const EdgeInsets.all(10),
//             //             child: Text(
//             //               'Logout',
//             //               style: TextStyle(
//             //                   fontFamily: 'TomaSans-Regular',
//             //                   fontWeight: FontWeight.bold,
//             //                   color: HexColor(Colorscommon.greycolor)),
//             //             ),
//             //           ),
//             //           // Expanded(
//             //           //   child: Align(
//             //           //       alignment: Alignment.centerRight,
//             //           //       child: Image.asset(
//             //           //         'assets/forward.png',
//             //           //         width: 15,
//             //           //       )),
//             //           // ),
//             //         ],
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             // Card(
//             //   shape: RoundedRectangleBorder(
//             //     borderRadius: BorderRadius.circular(10), // if you need this
//             //     side: BorderSide(
//             //       color: Colors.grey.withOpacity(0.5),
//             //       width: 1,
//             //     ),
//             //   ),
//             //   elevation: 3,
//             //   margin: const EdgeInsets.all(10),
//             //   child: Container(
//             //     padding: const EdgeInsets.all(10),
//             //     decoration: BoxDecoration(
//             //         borderRadius: const BorderRadius.all(Radius.circular(10)),
//             //         gradient: LinearGradient(colors: [
//             //           HexColor(Colorscommon.whitecolor),
//             //           HexColor(Colorscommon.whitelite)
//             //         ])),
//             //     child: Row(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         Text(
//             //           'Use Biometric',
//             //           style: TextStyle(
//             //               fontFamily: 'Lato',
//             //               color: HexColor(Colorscommon.greycolor)),
//             //         ),
//             //         CupertinoSwitch(
//             //           activeColor: HexColor(Colorscommon.greencolor),
//             //           value: _fingerValue,
//             //           onChanged: (bool value) {
//             //             setState(() {
//             //               _fingerValue = value;
//             //               setdata();
//             //             });
//             //             // setState(() {
//             //             //   _fingerValue = value;
//             //             //   setdata();
//             //             // });
//             //           },
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             // ),
//           ]),
//           // body: Builder(builder: (context) {
//           //   return WebView(
//           //     initialUrl: widget.loadURL,
//           //     // initialUrl: 'https://project-lithium--epuat.my.salesforce.com/',
//           //     // initialUrl:
//           //     //     "https://project-lithium--epuat.my.salesforce.com/services/auth/sso/SP_App_Mapping_v1?startURL=%2F",
//           //     javascriptMode: JavascriptMode.unrestricted,
//           //     // javascriptChannels: <JavascriptChannel>{
//           //     //   JavascriptChannel(
//           //     //     name: 'messageHandler',
//           //     //     onMessageReceived: (JavascriptMessage message) {
//           //     //       print("message from the web view=\"${message.message}\"");
//           //     //       print(message.message);
//           //     //       Map valueMap = json.decode(message.message);
//           //     //       String mapstr = valueMap["login"];
//           //     //       String uuidserver = valueMap["uuid"];
//           //     //       String serverstate = valueMap["state"];
//           //     //       print("uuidserver$uuidserver");
//           //     //       print("serverstate$serverstate");
//           //     //       // String mapstr = valueMap["uuid"];
//           //     //       print("mapstr$mapstr");
//           //     //       if (mapstr == "login") {
//           //     //         sessionManager.setuuid(uuidserver).then((value) => {});
//           //     //         sessionManager.setserverstate(serverstate).then((value) =>
//           //     //             {
//           //     //               Navigator.push(
//           //     //                   context,
//           //     //                   MaterialPageRoute(
//           //     //                       builder: (context) => const Login()))
//           //     //             });
//           //     //       } else {
//           //     //         // getuserdetailsbuuuid(uuidserver);
//           //     //       }
//           //     //     },
//           //     //   )
//           //     // },

//           //     // backgroundColor: Colors.green,
//           //     onWebViewCreated: (WebViewController webviewcontroller) {
//           //       // _controller.complete
//           //       controller = webviewcontroller;
//           //     },
//           //     // onWebResourceError: (url) {
//           //     //   print('errorurl$url');
//           //     // },
//           //     onProgress: (int val) {
//           //       print("val$val");
//           //     },
//           //     onPageStarted: (url) async {
//           //       print('staredurl$url');
//           //       if (url ==
//           //           "https://project-lithium--epuat.my.salesforce.com/") {
//           //         final SharedPreferences pref =
//           //             await SharedPreferences.getInstance();
//           //         String id = pref.getString("userid") ?? "";
//           //         String accesstoken = pref.getString("accesstokken") ?? "";
//           //         String email = pref.getString("email_id") ?? "";
//           //         logoutapi(id, accesstoken, email);
//           //       }

//           //       // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//           //       // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//           //       // // String? datastrid = androidInfo.androidId.toString();
//           //       // print("datastrid$datastrid");
//           //     },
//           //     onPageFinished: (url) {
//           //       // setState(() {
//           //       print("getredurl$url");
//           //       // });
//           //     },
//           //   );
//           // }),
//         ),
//       ),
//     );
//   }

//   void _showDialog(BuildContext context) async {
//     final SharedPreferences pref = await SharedPreferences.getInstance();
//     String id = pref.getString("userid") ?? "";
//     String accesstoken = pref.getString("accesstokken") ?? "";
//     String email = pref.getString("email_id") ?? "";
//     print("id$id");
//     print("accesstoken$accesstoken");
//     print("email$email");

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Bouncing(
//                     onPress: (() {
//                       Navigator.of(context, rootNavigator: true).pop();
//                     }),
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       padding: const EdgeInsets.all(2),
//                       child: Icon(
//                         Icons.clear,
//                         color: HexColor(Colorscommon.greydark),
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Logout?",
//                     style: TextStyle(color: HexColor(Colorscommon.greendark)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           content: Text(
//             "Are you sure you want to logout?",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: HexColor(Colorscommon.greydark2),
//                 fontFamily: "AvenirLTStd-Book",
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500),
//           ),
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: GestureDetector(
//                       onTap: () {
//                         Fluttertoast.showToast(
//                           msg: "Logout successfully",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.CENTER,
//                         );
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const Login()));

//                         // Navigator.push(context,
//                         //     MaterialPageRoute(builder: (context) {
//                         //   const Login();
//                         // }));
//                         // Navigator.push(
//                         //     context, const MaterialPagebuilder: (context) => Login());
//                         // //                Navigator.pushNamedAndRemoveUntil(
//                         // , MaterialPageRoute(builder: (context) => const Login()));
//                         // logoutapi(id, accesstoken, email);
//                       },
//                       child: Container(
//                         margin:
//                             const EdgeInsets.only(top: 10, left: 10, right: 0),
//                         padding: const EdgeInsets.all(5),
//                         height: 30,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             gradient: LinearGradient(colors: [
//                               HexColor(Colorscommon.greenlight2),
//                               HexColor(Colorscommon.greenlight2),
//                             ])),
//                         child: const Center(
//                             child: Text(
//                           "Log Out",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontFamily: 'AvenirLTStd-Black',
//                               fontWeight: FontWeight.w500),
//                         )),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context, rootNavigator: true).pop();
//                       },
//                       child: Container(
//                         margin:
//                             const EdgeInsets.only(top: 10, left: 10, right: 0),
//                         height: 30,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(
//                               color: HexColor(Colorscommon.greenlight2),
//                             )),
//                         child: Center(
//                             child: Text(
//                           "Cancel",
//                           style: TextStyle(
//                               color: HexColor(Colorscommon.greenlight2),
//                               fontSize: 13,
//                               fontFamily: 'AvenirLTStd-Black',
//                               fontWeight: FontWeight.w500),
//                           // style: TextStyle(
//                           //     color: HexColor(Colorscommon.greenlight2),
//                           //     fontFamily: 'Lato',
//                           //     fontWeight: FontWeight.bold),
//                         )),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   setdata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setBool('fprint', _fingerValue);
//       if (_fingerValue) {
//         prefs.setString('Fingershow', "1234");
//       } else {
//         prefs.setString('Fingershow', "134");
//       }

//       print('set-fp = $_fingerValue');
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => const Login()));
//     });
//   }

//   Getdata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _fingerValue = prefs.getBool('fprint') ?? false;

//     _fingerValuestr = prefs.getString('Fingershow');
//     print("_fingerValuestr$_fingerValuestr");
//     // _biometricbool = prefs.getBool('biometric') ?? false;

//     print('get-fp = $_fingerValue');
//     setState(() {});
//   }
// }

// ///new code design for sp app
// ///
// // ///
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';

// // class settings extends StatefulWidget {
// //   const settings({Key? key}) : super(key: key);

// //   @override
// //   State<settings> createState() => _settingsState();
// // }

// // class _settingsState extends State<settings> {
// //   bool _fingerValue = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(
// //           title: const Text(
// //             'Settings',
// //             style: TextStyle(color: Colors.white),
// //           ),
// //           backgroundColor: const Color(0xff268D79),
// //           elevation: 0,
// //           leading: const BackButton(color: Colors.white),
// //         ),
// //         body: Column(children: [
// //           ClipPath(
// //             clipper: RoundShape(),
// //             child: Container(
// //               height: 50,
// //               color: const Color(0xff268D79),
// //             ),
// //           ),
// //           Center(
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 getProfileView(),
// //                 Container(
// //                   margin: const EdgeInsets.only(left: 30),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: const [
// //                       Text(
// //                         'Aravind S',
// //                         style: TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.w700,
// //                             color: Colors.black),
// //                       ),
// //                       Text(
// //                         'aravind@gmail.com',
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: Colors.black,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 IconButton(
// //                     onPressed: () {},
// //                     icon: const Icon(Icons.keyboard_arrow_right,
// //                         color: Color(0xff268D79)))
// //               ],
// //             ),
// //           ),
// //           const SizedBox(
// //             height: 20,
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: SizedBox(
// //               height: MediaQuery.of(context).size.height / 3,
// //               width: MediaQuery.of(context).size.width - 40,
// //               child: Card(
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10.0)),
// //                 child: ListView(
// //                   children: [
// //                     ListTile(
// //                       leading: const Icon(
// //                         Icons.lock_outline,
// //                         color: Color(0xff268D79),
// //                       ),
// //                       title: const Text('Change Password'),
// //                       trailing: const Icon(Icons.keyboard_arrow_right,
// //                           color: Color(0xff268D79)),
// //                       onTap: () {},
// //                     ),
// //                     const Divider(),
// //                     ListTile(
// //                       leading: const Icon(
// //                         Icons.notifications,
// //                         color: Color(0xff268D79),
// //                       ),
// //                       title: const Text('Notification'),
// //                       trailing: const Icon(Icons.keyboard_arrow_right,
// //                           color: Color(0xff268D79)),
// //                       onTap: () {},
// //                     ),
// //                     const Divider(),
// //                     ListTile(
// //                       leading: const Icon(
// //                         Icons.fingerprint,
// //                         color: Color(0xff268D79),
// //                       ),
// //                       title: const Text('Use Biometric'),
// //                       trailing: CupertinoSwitch(
// //                         activeColor: const Color(0xff268D79),
// //                         value: _fingerValue,
// //                         onChanged: (bool value) {
// //                           setState(() {
// //                             _fingerValue = value;
// //                             // setdata();
// //                           });
// //                         },
// //                       ),
// //                       onTap: () {},
// //                     ),
// //                     const Divider(),
// //                     ListTile(
// //                       leading: const Icon(
// //                         Icons.logout,
// //                         color: Color(0xff268D79),
// //                       ),
// //                       title: const Text('Logout'),
// //                       trailing: const Icon(Icons.keyboard_arrow_right,
// //                           color: Color(0xff268D79)),
// //                       onTap: () {
// //                         _showDialog(context);
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           )
// //         ]));
// //   }
// // }

// // void _showDialog(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         title: const Center(
// //             child: Text(
// //           "Logout?",
// //           style: TextStyle(color: Color(0xff268D79)),
// //         )),
// //         content: const Text(
// //           "Are you sure you want to logout?",
// //           style: TextStyle(color: Colors.grey),
// //         ),
// //         actions: <Widget>[
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Expanded(
// //                   flex: 1,
// //                   child: GestureDetector(
// //                     onTap: () {},
// //                     child: Container(
// //                       margin:
// //                           const EdgeInsets.only(top: 10, left: 10, right: 0),
// //                       padding: const EdgeInsets.all(5),
// //                       height: 30,
// //                       decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(5),
// //                           gradient: const LinearGradient(
// //                               colors: [Color(0xff268D79), Color(0xff268D79)])),
// //                       child: const Center(
// //                           child: Text(
// //                         "Log Out",
// //                         style: TextStyle(
// //                             color: Colors.white,
// //                             fontFamily: 'Lato',
// //                             fontWeight: FontWeight.bold),
// //                       )),
// //                     ),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   flex: 1,
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       Navigator.of(context, rootNavigator: true).pop();
// //                     },
// //                     child: Container(
// //                       margin:
// //                           const EdgeInsets.only(top: 10, left: 10, right: 0),
// //                       height: 30,
// //                       decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(5),
// //                           border: Border.all(color: const Color(0xff268D79))),
// //                       child: const Center(
// //                           child: Text(
// //                         "Cancel",
// //                         style: TextStyle(
// //                             color: Color(0xff268D79),
// //                             fontFamily: 'Lato',
// //                             fontWeight: FontWeight.bold),
// //                       )),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }

// // Widget getProfileView() {
// //   return Stack(
// //     children: const <Widget>[
// //       CircleAvatar(
// //         radius: 35,
// //         backgroundColor: Color(0xff268D79),
// //         child: Icon(Icons.person_outline_rounded),
// //       ),
// // /*
// //       Positioned(
// //           bottom: 1,
// //           right: 1,
// //           child: Container(
// //             height: 30,
// //             width: 30,
// //             child: const Icon(
// //               Icons.edit,
// //               color: Colors.deepPurple,
// //               size: 20,
// //             ),
// //             decoration: BoxDecoration(
// //                 color: Colors.amber.shade200,
// //                 borderRadius: const BorderRadius.all(Radius.circular(20))),
// //           ))
// // */
// //     ],
// //   );
// // }

// // class RoundShape extends CustomClipper<Path> {
// //   @override
// //   getClip(Size size) {
// //     double height = size.height;
// //     double width = size.width;
// //     double curveHeight = size.height / 2;
// //     var p = Path();
// //     p.lineTo(0, height - curveHeight);
// //     p.quadraticBezierTo(width / 2, height, width, height - curveHeight);
// //     p.lineTo(width, 0);
// //     p.close();
// //     return p;
// //   }

// //   @override
// //   bool shouldReclip(CustomClipper oldClipper) => true;
// // }

// class CustomAppBarShape extends ContinuousRectangleBorder {
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     double h = rect.height;
//     double w = rect.width;
//     //  double height = size.height;
//     // double width = size.width;
//     double curveHeight = rect.height / 2;
//     var p = Path();
//     p.lineTo(0, h - 20);
//     p.quadraticBezierTo(w / 2, h, w, h - 20);
//     p.lineTo(w, 0);
//     p.close();
//     return p;
//     // var path = Path();
//     // path.lineTo(0, height + width * 0.1);
//     // path.arcToPoint(
//     //   Offset(width * 0.1, height),
//     //   radius: Radius.circular(width * 0.1),
//     // );
//     // path.lineTo(width * 0.9, height);
//     // path.arcToPoint(
//     //   Offset(width, height + width * 0.1),
//     //   radius: Radius.circular(width * 0.1),
//     // );
//     // path.lineTo(width, 0);
//     // path.close();

//     // return path;
//   }
// }

// Widget getProfileView() {
//   return Stack(
//     children: <Widget>[
//       Container(
//         padding: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: HexColor(Colorscommon.greenApp2color),
//             width: 2.0,
//           ),
//         ),
//         child: CircleAvatar(
//           radius: 35,
//           backgroundColor: HexColor(Colorscommon.greenApp2color),
//           child: const Icon(Icons.person_outline_rounded),
//         ),
//       ),
// /*
//       Positioned(
//           bottom: 1,
//           right: 1,
//           child: Container(
//             height: 30,
//             width: 30,
//             child: const Icon(
//               Icons.edit,
//               color: Colors.deepPurple,
//               size: 20,
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.amber.shade200,
//                 borderRadius: const BorderRadius.all(Radius.circular(20))),
//           ))
// */
//     ],
//   );
// }
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_sfdc_idp/Bouncing.dart';
// import 'package:flutter_application_sfdc_idp/Colors.dart';
// import 'package:flutter_application_sfdc_idp/CommonColor.dart';
// import 'package:flutter_application_sfdc_idp/CommonText.dart';
// import 'package:flutter_application_sfdc_idp/Login.dart';
// import 'package:flutter_application_sfdc_idp/SessionManager.dart';
// import 'package:flutter_application_sfdc_idp/URL.dart';
// import 'package:flutter_application_sfdc_idp/Utility.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:restart_app/restart_app.dart';
// // var uuid = Uuid();

// SessionManager sessionManager = SessionManager();

// class Settings extends StatefulWidget {
//   const Settings({Key? key}) : super(key: key);

//   @override
//   SettingsState createState() => SettingsState();
// }

// class SettingsState extends State<Settings> {
//   late BuildContext dialogContext_password;
//   bool _fingerValue = false;
//   TextEditingController emailorphonecontroller = TextEditingController();
//   Utility utility = Utility();
//   String? _fingerValuestr;
//   var username = "";
//   var emailshow = "";
//   @override
//   void initState() {
//     super.initState();
//     // LocalNotificationService.initialize(context);
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//     utility.GetUserdata().then((value) => {
//           print(utility.lithiumid.toString()),
//           username = utility.lithiumid,
//           emailshow = utility.emailId,
//           Getdata(),
//           setState(() {}),
//         });
//   }

//   Future<void> _showMyDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Change password',
//             style: TextStyle(color: Colors.green, fontSize: 20),
//           ),
//           // backgroundColor: Colors.green,
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: const <Widget>[
//                 TextField(),
//                 TextField(),
//                 TextField(),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 'Submit',
//                 style: TextStyle(
//                     color: Colors.green,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {},
//             ),
//             TextButton(
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(
//                     color: Colors.green,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // void ForgotPassword() {
//   //   emailorphonecontroller.text = "";
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (BuildContext context) {
//   //       dialogContext_password = context;

//   //       return Dialog(
//   //         insetPadding: EdgeInsets.all(5),

//   //         // padding: const EdgeInsets.all(5.0),
//   //         child: Container(
//   //           margin: EdgeInsets.all(15),
//   //           width: double.infinity,
//   //           padding: EdgeInsets.all(5),
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Align(
//   //                 alignment: Alignment.centerLeft,
//   //                 child: GradientText(
//   //                   "Forgot Password",
//   //                   18,
//   //                   gradient: LinearGradient(colors: [
//   //                     HexColor(Colorscommon.greencolor),
//   //                     HexColor(Colorscommon.greenlite),
//   //                   ]),
//   //                 ),
//   //               ),
//   //               Container(
//   //                 margin: EdgeInsets.only(top: 30, left: 0, right: 0),
//   //                 decoration: BoxDecoration(
//   //                     border: Border(bottom: BorderSide(color: Colors.grey))),
//   //                 child: Theme(
//   //                   data: Theme.of(context).copyWith(
//   //                       primaryColor: HexColor(Colorscommon.greencolor)),
//   //                   child: TextField(
//   //                     controller: emailorphonecontroller,
//   //                     maxLength: 10,
//   //                     keyboardType: TextInputType.number,

//   //                     // obscureText: true,
//   //                     style: TextStyle(
//   //                         color: Colors.grey,
//   //                         fontFamily: 'AvenirLTStd',
//   //                         fontWeight: FontWeight.bold),
//   //                     textAlign: TextAlign.start,

//   //                     //  controller: usernameController,
//   //                     decoration: InputDecoration(
//   //                         border: OutlineInputBorder(),
//   //                         labelText: 'Enter registered phone number'),
//   //                   ),
//   //                 ),
//   //               ),
//   //               Center(
//   //                 child: Row(
//   //                   children: [
//   //                     Bouncing(
//   //                       onPress: () {
//   //                         if (emailorphonecontroller.text.isNotEmpty) {
//   //                           sessionManager
//   //                               .internetcheck()
//   //                               .then((intenet) async {
//   //                             if (intenet != null && intenet) {
//   //                               ForgotpasswordAPI();
//   //                             } else {
//   //                               Fluttertoast.showToast(
//   //                                 msg: "Please check your internet connection",
//   //                                 toastLength: Toast.LENGTH_SHORT,
//   //                                 gravity: ToastGravity.CENTER,
//   //                               );
//   //                             }
//   //                           });
//   //                         } else {
//   //                           Fluttertoast.showToast(
//   //                             msg: "Please enter valid phone number",
//   //                             toastLength: Toast.LENGTH_SHORT,
//   //                             gravity: ToastGravity.CENTER,
//   //                           );
//   //                         }
//   //                       },
//   //                       child: Container(
//   //                         margin: EdgeInsets.only(top: 20, left: 0, right: 0),
//   //                         height: 40,
//   //                         width: 100,
//   //                         decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(5),
//   //                             gradient: LinearGradient(colors: [
//   //                               HexColor(Colorscommon.greencolor),
//   //                               HexColor(Colorscommon.greenlite),
//   //                             ])),
//   //                         child: Center(
//   //                             child: Text(
//   //                           "Confirm",
//   //                           style: TextStyle(
//   //                               color: Colors.white,
//   //                               fontFamily: 'Montserrat',
//   //                               fontWeight: FontWeight.bold),
//   //                         )),
//   //                       ),
//   //                     ),
//   //                     Bouncing(
//   //                       onPress: () {
//   //                         Navigator.pop(dialogContext_password);
//   //                       },
//   //                       child: Container(
//   //                         margin: EdgeInsets.only(top: 20, left: 10, right: 0),
//   //                         height: 40,
//   //                         width: 100,
//   //                         decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(5),
//   //                             border: Border.all(
//   //                                 color: HexColor(Colorscommon.greencolor))),
//   //                         child: Center(
//   //                             child: Text(
//   //                           "Close",
//   //                           style: TextStyle(
//   //                               color: Colors.grey,
//   //                               fontFamily: 'Montserrat',
//   //                               fontWeight: FontWeight.bold),
//   //                         )),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   // void updatefcmtoken(String username) async {
//   //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   //   String url = CommonURL.URL;
//   //   String? token;
//   //   token = await _firebaseMessaging.getToken();
//   //   print("fcmtoken$token");
//   //   Map<String, String> postdata = {
//   //     "from": "updateDriversFCMCode",
//   //     "username": username,
//   //     "idFCM": "$token",
//   //     "mobileType": "1",
//   //   };

//   //   Map<String, String> requestHeaders = {
//   //     'Content-type': 'application/hal+json',
//   //     'Accept': 'application/json',
//   //   };

//   //   final response = await http.post(url,
//   //       body: jsonEncode(postdata), headers: requestHeaders);

//   //   // print("${response.statusCode}");
//   //   // print("${response.body}");

//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
//   //     // print("jsonInput$jsonInput");

//   //     String status = jsonInput['status'].toString();
//   //     // String message = jsonInput['message'];
//   //     if (status == 'true') {
//   //       // Navigator.push(
//   //       //     context, MaterialPageRoute(builder: (context) => Login()));
//   //       // Fluttertoast.showToast(
//   //       //   msg: message,
//   //       //   toastLength: Toast.LENGTH_SHORT,
//   //       //   gravity: ToastGravity.CENTER,
//   //       // );
//   //     }
//   //   } else {}
//   // }

//   // void getuserdetailsbuuuid(String uuid) async {
//   //   String url = CommonURL.URL;
//   //   Map<String, String> postdata = {
//   //     "from": "getCurrentLoginDriver",
//   //     "uuid": uuid,
//   //   };

//   //   Map<String, String> requestHeaders = {
//   //     'Content-type': 'application/hal+json',
//   //     'Accept': 'application/json',
//   //   };

//   //   final response = await http.post(url,
//   //       body: jsonEncode(postdata), headers: requestHeaders);

//   //   print("${response.statusCode}");
//   //   print("${response.body}");

//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
//   //     print("jsonInput$jsonInput");

//   //     String status = jsonInput['status'].toString();
//   //     String message = jsonInput['message'];
//   //     if (status == 'true') {
//   //       String username = jsonInput['data']['lithium_id'].toString();
//   //       String password = jsonInput['data']['password'].toString();
//   //       String mobile_no = jsonInput['data']['mobile_no'].toString();
//   //       String access_token = jsonInput['data']['access_token'].toString();
//   //       String refresh_token = jsonInput['data']['refresh_token'].toString();
//   //       print("username==$username");
//   //       print("username==$username");
//   //       print("username==$username");
//   //       print("username==$username");
//   //       print("username==$username");
//   //       // updatefcmtoken(username);
//   //     }
//   //   } else {}
//   // }

//   void logoutapi(String id, String accesstoken, String email) async {
//     print("id$id");
//     print("accesstoken$accesstoken");
//     print("email$email");
//     String url = CommonURL.URL;
//     Map<String, String> postdata = {
//       "from": "driverLogout",
//       "id": id,
//       "access_token": accesstoken,
//       "username": email,
//     };

//     Map<String, String> requestHeaders = {
//       'Content-type': 'application/hal+json',
//       'Accept': 'application/json',
//     };

//     debugPrint('fetchdata $url');
//     debugPrint('fetchdata $postdata');

//     final response = await http.post(Uri.parse(url),
//         body: jsonEncode(postdata), headers: requestHeaders);

//     print("${response.statusCode}");
//     print(response.body);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);

//       // debugPrint('Passwordchnageresponse $jsonInput');

//       String success = jsonInput['success'].toString();
//       String message = jsonInput['message'];
//       // debugPrint('Location_success $success');
//       // debugPrint('Location_message $message');

//       Navigator.pop(context);

//       if (success == '1') {
//         // String idDriverr = jsonInput['id_driver'].toString();
//         // Navigator.of(context).pushAndRemoveUntil(
//         //     '/WebViewExample', (Route<dynamic> route) => false);
//         // Navigator.pushNamedAndRemoveUntil(
//         //     context, MaterialPageRoute(builder: (context) => const WebViewExample()));
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Restart.restartApp();

//         // Fluttertoast.showToast(
//         //   msg: message,
//         //   toastLength: Toast.LENGTH_SHORT,
//         //   gravity: ToastGravity.CENTER,
//         // );
//         // return Future.value(true);
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Restart.restartApp();
//       }

//       // Fluttertoast.showToast(
//       //   msg: message,
//       //   toastLength: Toast.LENGTH_SHORT,
//       //   gravity: ToastGravity.CENTER,
//       // );
//     } else {
//       debugPrint('SERVER=FAILED');

//       Fluttertoast.showToast(
//         msg: "Something Went Wrong Please Try Again",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//     }
//   }

//   // void ForgotpasswordAPI() async {
//   //   String url = CommonURL.URL;
//   //   Map<String, String> postdata = {
//   //     "from": "driversGetVerificationCode",
//   //     "emailOrMobile": emailorphonecontroller.text,
//   //   };

//   //   Map<String, String> requestHeaders = {
//   //     'Content-type': 'application/hal+json',
//   //     'Accept': 'application/json',
//   //   };

//   //   debugPrint('fetchdata $url');
//   //   debugPrint('fetchdata $postdata');

//   //   final response = await http.post(url,
//   //       body: jsonEncode(postdata), headers: requestHeaders);

//   //   print("${response.statusCode}");
//   //   print("${response.body}");

//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);

//   //     // debugPrint('Passwordchnageresponse $jsonInput');

//   //     String success = jsonInput['success'].toString();
//   //     String message = jsonInput['message'];
//   //     // debugPrint('Location_success $success');
//   //     // debugPrint('Location_message $message');

//   //     // Navigator.pop(dialogContext);

//   //     if (success == '1') {
//   //       String idDriverr = jsonInput['id_driver'].toString();

//   //       Fluttertoast.showToast(
//   //         msg: message,
//   //         toastLength: Toast.LENGTH_SHORT,
//   //         gravity: ToastGravity.CENTER,
//   //       );
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => ForgotPasswordClass(
//   //               text: emailorphonecontroller.text,
//   //               id_driver: idDriverr,
//   //             ),
//   //           ));
//   //       // return Future.value(true);
//   //     }

//   //     Fluttertoast.showToast(
//   //       msg: message,
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       gravity: ToastGravity.CENTER,
//   //     );
//   //   } else {
//   //     debugPrint('SERVER=FAILED');

//   //     Fluttertoast.showToast(
//   //       msg: "Something went wrong please try again",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       gravity: ToastGravity.CENTER,
//   //     );
//   //   }
//   // }

// // }
//   late WebViewController controller;
//   TextEditingController oldpasswordcontroller = TextEditingController();
//   TextEditingController newpasswordcontroller = TextEditingController();
//   TextEditingController confirmpasswordcontroller = TextEditingController();

//   void chagepasswordapirequest(String userid, clientid, accesstokken,
//       refreshtokken, mobile, oldPassword) async {
//     String url = CommonURL.URL;
//     // print(oldpasswordcontroller.text);
//     // print(newpasswordcontroller.text);
//     // print(confirmpasswordcontroller.text);
//     // print(clientid);
//     // print(userid);
//     // print(accesstokken);
//     // print(mobile);
//     // print(refreshtokken);
//     Map<String, String> postdata = {
//       "from": "changeDriversPassword",
//       "oldPassword": oldpasswordcontroller.text,
//       "newPassword": newpasswordcontroller.text,
//       "confirmPassword": confirmpasswordcontroller.text,
//       "clientID": clientid,
//       "userId": userid,
//       "access_token": accesstokken,
//       "username": utility.lithiumid,
//       "refresh_token": refreshtokken,
//     };
//     Map<String, String> requestHeaders = {
//       'Content-type': 'application/hal+json',
//       'Accept': 'application/json',
//     };
//     debugPrint('fetchdata $url');

//     final response = await http.post(Uri.parse(url),
//         body: jsonEncode(postdata), headers: requestHeaders);

//     print("${response.statusCode}");
//     print(response.body);

//     debugPrint('Passwordchnageresponse $response.statusCode');

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);

//       debugPrint('Passwordchnageresponse $jsonInput');

//       String success = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//       debugPrint('Location_success $success');
//       debugPrint('Location_message $message');

//       Navigator.pop(context);

//       if (success == 'true') {
//         // Navigator.pop(context);
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Timer(const Duration(milliseconds: 100), () {
//           // Restart.restartApp();
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const Login(),
//               ));
//           print(" This line is execute after 5 seconds");
//         });
//       }
//       if (success == 'false') {
//         // Navigator.pop(context);
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         // Timer(const Duration(milliseconds: 100), () {
//         //   // Restart.restartApp();
//         //   Navigator.push(
//         //       context,
//         //       MaterialPageRoute(
//         //         builder: (context) => const Login(),
//         //       ));
//         //   print(" This line is execute after 5 seconds");
//         // });
//       }
//     } else {
//       debugPrint('SERVER=FAILED');

//       Fluttertoast.showToast(
//         msg: "Something Went Wrong Please Try Again",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//     }
//   }

//   void loading() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         // dialogContext = context;
//         return Dialog(
//           child: Padding(
//             padding: const EdgeInsets.all(25.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 /*  new CircularProgressIndicator(
//                   valueColor: new AlwaysStoppedAnimation(Colors.red),
//                 ),*/

//                 Image.asset(
//                   'assets/lithiugif.gif',
//                   width: 50,
//                   // color: Colors.purple.shade800,
//                 ),
//                 Container(
//                     margin: const EdgeInsets.only(left: 10),
//                     child: const Text("Loading")),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   validateInputs() async {
//     if (oldpasswordcontroller.text.isNotEmpty) {
//       if (newpasswordcontroller.text.isNotEmpty) {
//         if (newpasswordcontroller.text == confirmpasswordcontroller.text) {
//           final SharedPreferences pref = await SharedPreferences.getInstance();
//           String userid = pref.getString("userid") ?? "";
//           // String clientid = pref.getString("clientid") ?? "";
//           // clientID:222
//           String clientid = '222';
//           String refreshtokken = pref.getString("refreshtokken") ?? "";
//           String accesstokken = pref.getString("accesstokken") ?? "";
//           String mobile = pref.getString("mobile_no") ?? "";

//           String oldPassword = pref.getString("password") ?? "";
//           print("userid$userid");
//           print("clientid$clientid");
//           print("refreshtokken$refreshtokken");
//           print("accesstokken$accesstokken");
//           print("mobile$mobile");
//           print("oldPassword$oldPassword");

//           // if (oldPassword == oldpasswordcontroller.text) {
//           sessionManager.internetcheck().then((intenet) async {
//             if (intenet) {
//               FocusScope.of(context).unfocus();
//               loading();
//               utility.GetUserdata().then((value) => {
//                     chagepasswordapirequest(userid, clientid, accesstokken,
//                         refreshtokken, mobile, oldPassword)
//                   });
//             } else {
//               showTopSnackBar(
//                 context,
//                 const CustomSnackBar.error(
//                   // icon: Icon(Icons.interests),
//                   message: "Please Check Your Internet Connection",
//                   // backgroundColor: Colors.white,
//                   // textStyle: TextStyle(color: Colors.red),
//                 ),
//               );
//               // Fluttertoast.showToast(
//               //   msg: "No Internet",
//               //   toastLength: Toast.LENGTH_SHORT,
//               //   gravity: ToastGravity.CENTER,
//               // );
//             }
//           });

//           // } else {
//           //   Fluttertoast.showToast(
//           //     msg: "incorrect old password",
//           //     toastLength: Toast.LENGTH_SHORT,
//           //     gravity: ToastGravity.CENTER,
//           //   );
//           // }
// //  void Chagepasswordapirequest(String userid, clientid, accesstokken,
// //       refreshtokken, mobile, oldPassword) async {

//         } else {
//           Fluttertoast.showToast(
//             msg: "New Password & Confirm Password Doesn't Match",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//           );
//         }
//       } else {
//         Fluttertoast.showToast(
//           msg: "Please Enter New Password",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Please Enter Old Password",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//     }
//   }

//   void ChangePassword() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         // dialogContext = context;

//         return Dialog(
//           insetPadding: const EdgeInsets.all(5),

//           // padding: const EdgeInsets.all(5.0),
//           child: Container(
//             margin: const EdgeInsets.all(15),
//             width: double.infinity,
//             padding: const EdgeInsets.all(5),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Avenirtextblack(
//                     customfontweight: FontWeight.normal,
//                     fontsize: 14,
//                     text: 'Change Password',
//                     textcolor: HexColor(Colorscommon.greendark2),
//                     // customfontweight: FontWeight.w500,
//                     // fontsize: 15,
//                     // text: 'Change Password',
//                     // textcolor: HexColor(Colorscommon.greencolor),
//                   ),
//                   // child: GradientText(
//                   //   "Change Password",
//                   //   18,
//                   //   gradient: LinearGradient(colors: [
//                   //     HexColor(Colorscommon.greencolor),
//                   //     HexColor(Colorscommon.greencolor),
//                   //   ]),
//                   // ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 30, left: 0, right: 0),
//                   decoration: const BoxDecoration(
//                       // border: Border(bottom: BorderSide(color: Colors.grey))
//                       ),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                         primaryColor: HexColor(Colorscommon.greencolor)),
//                     child: TextField(
//                       controller: oldpasswordcontroller,
//                       obscureText: true,
//                       style: TextStyle(
//                         fontFamily: 'AvenirLTStd-Book',
//                         fontSize: 14,
//                         color: HexColor(Colorscommon.greydark2),
//                       ),
//                       textAlign: TextAlign.start,

//                       //  controller: usernameController,
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: 'Enter Old Password',
//                         labelStyle: TextStyle(
//                           fontFamily: 'AvenirLTStd-Book',
//                           fontSize: 14,
//                           color: HexColor(Colorscommon.greydark2),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 15, left: 0, right: 0),
//                   decoration: const BoxDecoration(
//                       // border: Border(bottom: BorderSide(color: Colors.grey))
//                       ),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                         primaryColor: HexColor(Colorscommon.greencolor)),
//                     child: TextField(
//                       controller: newpasswordcontroller,
//                       obscureText: true,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontFamily: 'AvenirLTStd-Book',
//                         fontSize: 14,
//                         color: HexColor(Colorscommon.greydark2),
//                       ),
//                       // controller: passwordController,
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: "Enter New Password",
//                         labelStyle: TextStyle(
//                           fontFamily: 'AvenirLTStd-Book',
//                           fontSize: 14,
//                           color: HexColor(Colorscommon.greydark2),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 15, left: 0, right: 0),
//                   decoration: const BoxDecoration(
//                       // border: Border(bottom: BorderSide(color: Colors.grey))
//                       ),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                         primaryColor: HexColor(Colorscommon.greencolor)),
//                     child: TextField(
//                       controller: confirmpasswordcontroller,
//                       obscureText: true,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontFamily: 'AvenirLTStd-Book',
//                         fontSize: 14,
//                         color: HexColor(Colorscommon.greydark2),
//                       ),
//                       // controller: passwordController,
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: "Confirm New Password",
//                         labelStyle: TextStyle(
//                           fontFamily: 'AvenirLTStd-Book',
//                           fontSize: 14,
//                           color: HexColor(Colorscommon.greydark2),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Row(
//                     children: [
//                       Bouncing(
//                         onPress: () {
//                           validateInputs();
//                         },
//                         child: Container(
//                           margin:
//                               const EdgeInsets.only(top: 20, left: 0, right: 0),
//                           height: 40,
//                           width: 100,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               gradient: LinearGradient(colors: [
//                                 HexColor(Colorscommon.greenlight2),
//                                 HexColor(Colorscommon.greenlight2),
//                               ])),
//                           child: const Center(
//                             child: Avenirtextblack(
//                                 text: "Confirm",
//                                 fontsize: 14,
//                                 textcolor: Colors.white,
//                                 customfontweight: FontWeight.w500),
//                             //     child: Text(
//                             //   "Confirm",
//                             //   style: TextStyle(
//                             //       color: Colors.white,
//                             //       fontFamily: 'Lato',
//                             //       fontWeight: FontWeight.bold),
//                             // )
//                           ),
//                         ),
//                       ),
//                       Bouncing(
//                         onPress: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(
//                               top: 20, left: 10, right: 0),
//                           height: 40,
//                           width: 100,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(
//                                   color: HexColor(Colorscommon.greenlight2))),
//                           child: Center(
//                             child: Avenirtextblack(
//                                 text: "Close",
//                                 fontsize: 14,
//                                 textcolor: HexColor(Colorscommon.greenlight2),
//                                 customfontweight: FontWeight.w500),
//                             //     child: Text(
//                             //   "Close",
//                             //   style: TextStyle(
//                             //       color: HexColor(Colorscommon.greenlight2),
//                             //       fontFamily: 'Lato',
//                             //       fontWeight: FontWeight.bold),
//                             // )
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Navigator.pop(context, true);
//         return false;
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.green,
//         ),
//         home: Scaffold(
//           resizeToAvoidBottomInset: true,

//           appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(100),
//             child: AppBar(
//               backgroundColor: HexColor(Colorscommon.greenAppcolor),
//               centerTitle: true,
//               leading: Container(),
//               // leading: IconButton(
//               //   icon: const Icon(Icons.arrow_back, color: Colors.black),
//               //   onPressed: () => Navigator.of(context, rootNavigator: true),
//               //   // Navigator.push(
//               //   //     context,
//               //   //     MaterialPageRoute(
//               //   //         builder: (context) => const MyTabPage(
//               //   //               title: '',
//               //   //             )
//               //   //             )
//               //   //             ),
//               // ),
//               // leading: Bouncing(
//               //   onPress: () {
//               //     Navigator.pop(context);
//               //   },
//               //   child: const Icon(
//               //     Icons.arrow_back,
//               //     size: 30,
//               //     color: Colors.white,
//               //   ),
//               // ),
//               title: const Text(
//                 "Settings",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'Lato',
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               shape: CustomAppBarShape(),
//             ),
//           ),
//           body: Column(children: [
//             Container(
//               color: HexColor("#F8F8F8"),
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     getProfileView(),
//                     Container(
//                       margin: const EdgeInsets.only(left: 30),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             username,
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'AvenirLTStd-Black',
//                                 color: HexColor(Colorscommon.darkblack)),
//                           ),
//                           Text(
//                             emailshow,
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                                 color: HexColor(Colorscommon.darkblack)),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.keyboard_arrow_right,
//                             color: Color(0xff268D79)))
//                   ],
//                 ),
//               ),
//             ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   children: [
//             //     Expanded(
//             //       child: Container(
//             //         margin: const EdgeInsets.all(0),
//             //         child: const Center(
//             //             child: Text(
//             //           "Settings",
//             //           style: TextStyle(
//             //               color: Colors.white,
//             //               fontSize: 20,
//             //               fontWeight: FontWeight.bold),
//             //         )),
//             //         height: MediaQuery.of(context).size.width / 8,
//             //         color: HexColor(Colorscommon.greencolor),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             const SizedBox(
//               height: 10,
//             ),
//             Card(
//               elevation: .8,
//               margin: const EdgeInsets.all(15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: SizedBox(
//                 // height: MediaQuery.of(context).size.height ,
//                 width: MediaQuery.of(context).size.width - 40,
//                 child: ListView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   children: [
//                     // Container(
//                     //   margin: const EdgeInsets.all(10),
//                     //   height: 10,
//                     //   child: Row(
//                     //     children: const [
//                     //       Icon(
//                     //         Icons.lock_outline,
//                     //         color: Color(0xff268D79),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     Visibility(
//                       visible: _fingerValuestr == "1234",
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 0.0, horizontal: 10),
//                         // leading: const Icon(
//                         //   Icons.lock_outline,
//                         //   color: Color(0xff268D79),
//                         // ),
//                         title: Text(
//                           'Change Password',
//                           style: TextStyle(
//                               color: HexColor(
//                                 Colorscommon.greydark2,
//                               ),
//                               fontSize: 14,
//                               fontFamily: 'AvenirLTStd-Book',
//                               fontWeight: FontWeight.w500),
//                         ),
//                         trailing: const Icon(Icons.keyboard_arrow_right,
//                             color: Color(0xff268D79)),
//                         onTap: () {
//                           sessionManager.internetcheck().then((intenet) async {
//                             if (intenet) {
//                               oldpasswordcontroller.text = "";
//                               newpasswordcontroller.text = "";
//                               confirmpasswordcontroller.text = "";
//                               ChangePassword();
//                               //               final SharedPreferences pref = await SharedPreferences.getInstance();
//                               // String userid = pref.getString("userid") ?? "";
//                             } else {
//                               showTopSnackBar(
//                                 context,
//                                 const CustomSnackBar.error(
//                                   // icon: Icon(Icons.interests),
//                                   message:
//                                       "Please Check Your Internet Connection",
//                                   // backgroundColor: Colors.white,
//                                   // textStyle: TextStyle(color: Colors.red),
//                                 ),
//                               );
//                               // Fluttertoast.showToast(
//                               //   msg: "No Internet",
//                               //   toastLength: Toast.LENGTH_SHORT,
//                               //   gravity: ToastGravity.CENTER,
//                               // );
//                             }
//                           });
//                         },
//                       ),
//                     ),
//                     const Padding(
//                         padding: EdgeInsets.only(right: 10, left: 10),
//                         child: Divider(
//                           height: .1,
//                           thickness: .5,
//                         )),
//                     // const Divider(),
//                     // ListTile(
//                     //   contentPadding: const EdgeInsets.symmetric(
//                     //       vertical: 0.0, horizontal: 10),
//                     //   // leading: const Icon(
//                     //   //   Icons.notifications,
//                     //   //   color: Color(0xff268D79),
//                     //   // ),
//                     //   title: Text(
//                     //     'Notification',
//                     //     style: TextStyle(
//                     //         color: HexColor(
//                     //           Colorscommon.greydark2,
//                     //         ),
//                     //         fontSize: 14,
//                     //         fontFamily: 'AvenirLTStd-Book',
//                     //         fontWeight: FontWeight.w500),
//                     //   ),
//                     //   trailing: const Icon(Icons.keyboard_arrow_right,
//                     //       color: Color(0xff268D79)),
//                     //   onTap: () {},
//                     // ),
//                     // const Padding(
//                     //     padding: EdgeInsets.only(right: 10, left: 10),
//                     //     child: Divider(
//                     //       height: .1,
//                     //       thickness: .5,
//                     //     )),
//                     // const Divider(),
//                     ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 0.0, horizontal: 10),
//                       // leading: const Icon(
//                       //   Icons.fingerprint,
//                       //   color: Color(0xff268D79),
//                       // ),

//                       title: Text(
//                         'Use Biometric',
//                         style: TextStyle(
//                             color: HexColor(
//                               Colorscommon.greydark2,
//                             ),
//                             fontSize: 14,
//                             fontFamily: 'AvenirLTStd-Book',
//                             fontWeight: FontWeight.w500),
//                       ),
//                       trailing: CupertinoSwitch(
//                         activeColor: const Color(0xff268D79),
//                         value: _fingerValue,
//                         onChanged: (bool value) {
//                           setState(() {
//                             _fingerValue = value;
//                             setdata();
//                           });
//                         },
//                       ),
//                       onTap: () {},
//                     ),
//                     const Padding(
//                         padding: EdgeInsets.only(right: 10, left: 10),
//                         child: Divider(
//                           height: .1,
//                           thickness: .5,
//                         )),
//                     // const Divider(),
//                     ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 0.0, horizontal: 10),
//                       // leading: const Icon(
//                       //   Icons.logout,
//                       //   color: Color(0xff268D79),
//                       // ),

//                       title: Text(
//                         'Logout',
//                         style: TextStyle(
//                             color: HexColor(
//                               Colorscommon.greydark2,
//                             ),
//                             fontSize: 14,
//                             fontFamily: 'AvenirLTStd-Book',
//                             fontWeight: FontWeight.w500),
//                       ),
//                       trailing: const Icon(Icons.keyboard_arrow_right,
//                           color: Color(0xff268D79)),
//                       onTap: () {
//                         sessionManager.internetcheck().then((intenet) async {
//                           if (intenet) {
//                             _showDialog(context);
//                             // checkupdate(_30minstr);,
//                             // loading();
//                             // Loginapi(serveruuid, serverstate);
//                           } else {
//                             showTopSnackBar(
//                               context,
//                               const CustomSnackBar.error(
//                                 // icon: Icon(Icons.interests),
//                                 message:
//                                     "Please Check Your Internet Connection",
//                                 // backgroundColor: Colors.white,
//                                 // textStyle: TextStyle(color: Colors.red),
//                               ),
//                             );
//                           }
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Visibility(
//             //   visible: _fingerValuestr == "1234",
//             //   child: Bouncing(
//             //     // onTap: () {
//             //     //   ForgotPassword();
//             //     // },
//             //     onPress: () {
//             //       // ForgotPassword();
//             //       sessionManager.internetcheck().then((intenet) async {
//             //         if (intenet) {
//             //           oldpasswordcontroller.text = "";
//             //           newpasswordcontroller.text = "";
//             //           confirmpasswordcontroller.text = "";
//             //           ChangePassword();
//             //           //               final SharedPreferences pref = await SharedPreferences.getInstance();
//             //           // String userid = pref.getString("userid") ?? "";
//             //         } else {
//             //           showTopSnackBar(
//             //             context,
//             //             const CustomSnackBar.error(
//             //               // icon: Icon(Icons.interests),
//             //               message: "Please Check Your Internet Connection",
//             //               // backgroundColor: Colors.white,
//             //               // textStyle: TextStyle(color: Colors.red),
//             //             ),
//             //           );
//             //           // Fluttertoast.showToast(
//             //           //   msg: "No Internet",
//             //           //   toastLength: Toast.LENGTH_SHORT,
//             //           //   gravity: ToastGravity.CENTER,
//             //           // );
//             //         }
//             //       });
//             //     },
//             //     child: Card(
//             //       shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(10), // if you need this
//             //         side: BorderSide(
//             //           color: Colors.grey.withOpacity(0.5),
//             //           width: 1,
//             //         ),
//             //       ),
//             //       elevation: 3,
//             //       margin: const EdgeInsets.all(10),
//             //       child: Container(
//             //         padding: const EdgeInsets.all(10),
//             //         decoration: BoxDecoration(
//             //             borderRadius: const BorderRadius.all(Radius.circular(10)),
//             //             gradient: LinearGradient(colors: [
//             //               HexColor(Colorscommon.whitecolor),
//             //               HexColor(Colorscommon.whitelite)
//             //             ])),
//             //         child: Row(
//             //           children: [
//             //             Icon(
//             //               Icons.lock,
//             //               color: HexColor(Colorscommon.greencolor),
//             //             ),
//             //             Container(
//             //               margin: const EdgeInsets.all(10),
//             //               child: Text(
//             //                 'Change Password',
//             //                 style: TextStyle(
//             //                     fontFamily: 'TomaSans-Regular',
//             //                     fontWeight: FontWeight.bold,
//             //                     color: HexColor(Colorscommon.greycolor)),
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             // // Bouncing(
//             // //   // onTap: () {
//             // //   //   ForgotPassword();
//             // //   // },
//             // //   onPress: () {
//             // //     // ForgotPassword();
//             // //     sessionManager.internetcheck().then((intenet) async {
//             // //       if (intenet != null && intenet) {
//             // //         final SharedPreferences pref =
//             // //             await SharedPreferences.getInstance();
//             // //         String userid = pref.getString("userid") ?? "";
//             // //         Navigator.of(context).push(MaterialPageRoute(
//             // //             builder: (context) => const Localnotifications()));
//             // //         // ChangePassword();
//             // //       } else {
//             // //         showTopSnackBar(
//             // //           context,
//             // //           const CustomSnackBar.error(
//             // //             // icon: Icon(Icons.interests),
//             // //             message: "Please check your internet connection",
//             // //             // backgroundColor: Colors.white,
//             // //             // textStyle: TextStyle(color: Colors.red),
//             // //           ),
//             // //         );
//             // //         // Fluttertoast.showToast(
//             // //         //   msg: "No Internet",
//             // //         //   toastLength: Toast.LENGTH_SHORT,
//             // //         //   gravity: ToastGravity.CENTER,
//             // //         // );
//             // //       }
//             // //     });
//             // //   },
//             // //   child: Card(
//             // //     elevation: 2,
//             // //     margin: const EdgeInsets.all(10),
//             // //     child: Container(
//             // //       padding: const EdgeInsets.all(10),
//             // //       decoration: BoxDecoration(
//             // //           borderRadius: const BorderRadius.all(Radius.circular(10)),
//             // //           gradient: LinearGradient(colors: [
//             // //             HexColor(Colorscommon.whitecolor),
//             // //             HexColor(Colorscommon.whitelite)
//             // //           ])),
//             // //       child: Row(
//             // //         children: [
//             // //           Icon(
//             // //             Icons.notifications,
//             // //             color: HexColor(Colorscommon.greencolor),
//             // //           ),
//             // //           Container(
//             // //             margin: const EdgeInsets.all(10),
//             // //             child: Text(
//             // //               'Messages',
//             // //               style: TextStyle(
//             // //                   fontFamily: 'TomaSans-Regular',
//             // //                   fontWeight: FontWeight.bold,
//             // //                   color: HexColor(Colorscommon.greycolor)),
//             // //             ),
//             // //           ),
//             // //         ],
//             // //       ),
//             // //     ),
//             // //   ),
//             // // ),
//             // // ),
//             // // FadeAnimation(
//             // //   1.2,
//             // // Bouncing(
//             // //   onPress: () {},
//             // //   // onTap: () async {
//             // //   //   // AndroidIntent intent = AndroidIntent(
//             // //   //   //   action: 'action_view',
//             // //   //   //   data: "https://youtu.be/CEZ8dPtZj-E",
//             // //   //   // );
//             // //   //   // await intent.launch();
//             // //   // },
//             // //   child: Card(
//             // //     elevation: 2,
//             // //     margin: EdgeInsets.all(10),
//             // //     child: Container(
//             // //       padding: EdgeInsets.all(10),
//             // //       decoration: BoxDecoration(
//             // //           borderRadius: BorderRadius.all(Radius.circular(10)),
//             // //           gradient: LinearGradient(colors: [
//             // //             HexColor(Colorscommon.whitecolor),
//             // //             HexColor(Colorscommon.whitelite)
//             // //           ])),
//             // //       child: Row(
//             // //         children: [
//             // //           Icon(
//             // //             Icons.help_outline,
//             // //             color: HexColor(Colorscommon.greencolor),
//             // //           ),
//             // //           Container(
//             // //             margin: EdgeInsets.all(10),
//             // //             child: Text(
//             // //               'How to video',
//             // //               style: TextStyle(
//             // //                   fontFamily: 'TomaSans-Regular',
//             // //                   fontWeight: FontWeight.bold,
//             // //                   color: HexColor(Colorscommon.greycolor)),
//             // //             ),
//             // //           ),
//             // //           // Expanded(
//             // //           //   child: Align(
//             // //           //       alignment: Alignment.centerRight,
//             // //           //       child: Image.asset(
//             // //           //         'assets/forward.png',
//             // //           //         width: 15,
//             // //           //       )),
//             // //           // ),
//             // //         ],
//             // //       ),
//             // //     ),
//             // //   ),
//             // // ),
//             // // ),
//             // // FadeAnimation(
//             // //   1.2,
//             // Bouncing(
//             //   onPress: () async {
//             //     final SharedPreferences pref =
//             //         await SharedPreferences.getInstance();
//             //     String id = pref.getString("userid") ?? "";
//             //     String accesstoken = pref.getString("accesstokken") ?? "";
//             //     String email = pref.getString("email_id") ?? "";
//             //     print("id$id");
//             //     print("accesstoken$accesstoken");
//             //     print("email$email");

//             //     showDialog(
//             //         context: context,
//             //         builder: (BuildContext context) {
//             //           return AlertDialog(
//             //             insetPadding: const EdgeInsets.all(10),
//             //             contentPadding: EdgeInsets.zero,
//             //             clipBehavior: Clip.antiAliasWithSaveLayer,
//             //             titlePadding: EdgeInsets.zero,
//             //             title: Container(
//             //               height: 50,
//             //               // margin: const EdgeInsets.all(0),
//             //               color: HexColor(Colorscommon.greencolor),
//             //               // decoration: BoxDecoration(
//             //               //     borderRadius: BorderRadius.circular(0),
//             //               //     gradient: LinearGradient(colors: [
//             //               //       HexColor(Colorscommon.greencolor),
//             //               //       HexColor(Colorscommon.greenlite),
//             //               //     ])),
//             //               child: Center(
//             //                 child: Text(
//             //                   "Confirmation",
//             //                   style: TextStyle(
//             //                       fontSize: 17,
//             //                       fontFamily: "Lato",
//             //                       fontWeight: FontWeight.bold,
//             //                       color: HexColor(Colorscommon.whitecolor)),
//             //                   textAlign: TextAlign.start,
//             //                 ),
//             //               ),
//             //             ),
//             //             titleTextStyle: TextStyle(color: Colors.grey[700]),
//             //             // titlePadding: const EdgeInsets.only(left: 5, top: 5),
//             //             content: Container(
//             //               width: MediaQuery.of(context).size.width,
//             //               margin: const EdgeInsets.only(top: 5),
//             //               child: Padding(
//             //                 padding: const EdgeInsets.only(
//             //                     top: 20, bottom: 10, left: 10, right: 10),
//             //                 child: Text(
//             //                   "Are you sure want to logout ?",
//             //                   textAlign: TextAlign.center,
//             //                   style: TextStyle(
//             //                     fontFamily: 'TomaSans-Regular',
//             //                     fontSize: 18,
//             //                     color: HexColor(Colorscommon.greycolor),
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //             actions: <Widget>[
//             //               Row(
//             //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                 children: [
//             //                   Expanded(
//             //                     child: Container(
//             //                         margin: const EdgeInsets.only(top: 20),
//             //                         child: const Text(
//             //                           "Yes",
//             //                           style: TextStyle(
//             //                               color: Colors.white,
//             //                               fontFamily: 'Lato',
//             //                               fontWeight: FontWeight.bold),
//             //                         )),
//             //                   ),
//             //                   Expanded(
//             //                     flex: 1,
//             //                     child: Bouncing(
//             //                       onPress: () async {
//             //                         // SharedPreferences prefs = await SharedPreferences.getInstance();
//             //                         // Loginbool = 'false';
//             //                         // prefs.setString('loginbool', Loginbool);
//             //                         logoutapi(id, accesstoken, email);
//             //                       },
//             //                       child: Container(
//             //                         margin: const EdgeInsets.only(
//             //                             top: 20, left: 0, right: 0),
//             //                         height: 40,
//             //                         width: 100,
//             //                         decoration: BoxDecoration(
//             //                             borderRadius: BorderRadius.circular(5),
//             //                             gradient: LinearGradient(colors: [
//             //                               HexColor(Colorscommon.greencolor),
//             //                               HexColor(Colorscommon.greencolor),
//             //                             ])),
//             //                         child: const Center(
//             //                             child: Text(
//             //                           "Yes",
//             //                           style: TextStyle(
//             //                               color: Colors.white,
//             //                               fontFamily: 'Montserrat',
//             //                               fontWeight: FontWeight.bold),
//             //                         )),
//             //                       ),
//             //                       // child: Container(
//             //                       //   margin: const EdgeInsets.only(
//             //                       //       top: 20, left: 10, right: 0),
//             //                       //   padding: const EdgeInsets.all(5),
//             //                       //   height: 30,
//             //                       //   decoration: BoxDecoration(
//             //                       //       borderRadius:
//             //                       //           BorderRadius.circular(5),
//             //                       //       gradient: LinearGradient(colors: [
//             //                       //         HexColor(Colorscommon.greycolor),
//             //                       //         HexColor(Colorscommon.greycolor),
//             //                       //       ])),
//             //                       //   child: const Center(
//             //                       //       child: Text(
//             //                       //     "Yes",
//             //                       //     style: TextStyle(
//             //                       //         color: Colors.white,
//             //                       //         fontFamily: 'Lato',
//             //                       //         fontWeight: FontWeight.bold),
//             //                       //   )),
//             //                       // ),
//             //                     ),
//             //                   ),
//             //                   Expanded(
//             //                     flex: 1,
//             //                     child: Bouncing(
//             //                       onPress: () {
//             //                         Navigator.of(context, rootNavigator: true)
//             //                             .pop();
//             //                       },
//             //                       child: Container(
//             //                         margin: const EdgeInsets.only(
//             //                             top: 20, left: 10, right: 0),
//             //                         height: 40,
//             //                         width: 100,
//             //                         decoration: BoxDecoration(
//             //                             borderRadius: BorderRadius.circular(5),
//             //                             border: Border.all(
//             //                                 color: HexColor(
//             //                                     Colorscommon.greencolor))),
//             //                         child: const Center(
//             //                             child: Text(
//             //                           "No",
//             //                           style: TextStyle(
//             //                               color: Colors.grey,
//             //                               fontFamily: 'Montserrat',
//             //                               fontWeight: FontWeight.bold),
//             //                         )),
//             //                       ),
//             //                       // child: Container(
//             //                       //   margin: EdgeInsets.only(
//             //                       //       top: 20, left: 10, right: 0),
//             //                       //   height: 30,
//             //                       //   decoration: BoxDecoration(
//             //                       //       borderRadius:
//             //                       //           BorderRadius.circular(5),
//             //                       //       border: Border.all(
//             //                       //           color: HexColor(
//             //                       //               Colorscommon.greycolor))),
//             //                       //   child: Center(
//             //                       //       child: Text(
//             //                       //     "No",
//             //                       //     style: TextStyle(
//             //                       //         color: HexColor(
//             //                       //             Colorscommon.greycolor),
//             //                       //         fontFamily: 'Lato',
//             //                       //         fontWeight: FontWeight.bold),
//             //                       //   )),
//             //                       // ),
//             //                     ),
//             //                   ),
//             //                 ],
//             //               ),
//             //             ],
//             //           );
//             //         });
//             //   },
//             //   // onTap: () {
//             //   //   // Navigator.of(context).pushAndRemoveUntil(
//             //   //   //     MaterialPageRoute(builder: (context) => Login()),
//             //   //   //     (Route<dynamic> route) => false);
//             //   // },
//             //   child: Card(
//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(10), // if you need this
//             //       side: BorderSide(
//             //         color: Colors.grey.withOpacity(0.5),
//             //         width: 1,
//             //       ),
//             //     ),
//             //     elevation: 3,
//             //     margin: const EdgeInsets.all(10),
//             //     child: Container(
//             //       padding: const EdgeInsets.all(10),
//             //       decoration: BoxDecoration(
//             //           borderRadius: const BorderRadius.all(Radius.circular(10)),
//             //           gradient: LinearGradient(colors: [
//             //             HexColor(Colorscommon.whitecolor),
//             //             HexColor(Colorscommon.whitelite)
//             //           ])),
//             //       child: Row(
//             //         children: [
//             //           Icon(
//             //             Icons.logout,
//             //             color: HexColor(Colorscommon.greencolor),
//             //           ),
//             //           Container(
//             //             margin: const EdgeInsets.all(10),
//             //             child: Text(
//             //               'Logout',
//             //               style: TextStyle(
//             //                   fontFamily: 'TomaSans-Regular',
//             //                   fontWeight: FontWeight.bold,
//             //                   color: HexColor(Colorscommon.greycolor)),
//             //             ),
//             //           ),
//             //           // Expanded(
//             //           //   child: Align(
//             //           //       alignment: Alignment.centerRight,
//             //           //       child: Image.asset(
//             //           //         'assets/forward.png',
//             //           //         width: 15,
//             //           //       )),
//             //           // ),
//             //         ],
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             // Card(
//             //   shape: RoundedRectangleBorder(
//             //     borderRadius: BorderRadius.circular(10), // if you need this
//             //     side: BorderSide(
//             //       color: Colors.grey.withOpacity(0.5),
//             //       width: 1,
//             //     ),
//             //   ),
//             //   elevation: 3,
//             //   margin: const EdgeInsets.all(10),
//             //   child: Container(
//             //     padding: const EdgeInsets.all(10),
//             //     decoration: BoxDecoration(
//             //         borderRadius: const BorderRadius.all(Radius.circular(10)),
//             //         gradient: LinearGradient(colors: [
//             //           HexColor(Colorscommon.whitecolor),
//             //           HexColor(Colorscommon.whitelite)
//             //         ])),
//             //     child: Row(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         Text(
//             //           'Use Biometric',
//             //           style: TextStyle(
//             //               fontFamily: 'Lato',
//             //               color: HexColor(Colorscommon.greycolor)),
//             //         ),
//             //         CupertinoSwitch(
//             //           activeColor: HexColor(Colorscommon.greencolor),
//             //           value: _fingerValue,
//             //           onChanged: (bool value) {
//             //             setState(() {
//             //               _fingerValue = value;
//             //               setdata();
//             //             });
//             //             // setState(() {
//             //             //   _fingerValue = value;
//             //             //   setdata();
//             //             // });
//             //           },
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             // ),
//           ]),
//           // body: Builder(builder: (context) {
//           //   return WebView(
//           //     initialUrl: widget.loadURL,
//           //     // initialUrl: 'https://project-lithium--epuat.my.salesforce.com/',
//           //     // initialUrl:
//           //     //     "https://project-lithium--epuat.my.salesforce.com/services/auth/sso/SP_App_Mapping_v1?startURL=%2F",
//           //     javascriptMode: JavascriptMode.unrestricted,
//           //     // javascriptChannels: <JavascriptChannel>{
//           //     //   JavascriptChannel(
//           //     //     name: 'messageHandler',
//           //     //     onMessageReceived: (JavascriptMessage message) {
//           //     //       print("message from the web view=\"${message.message}\"");
//           //     //       print(message.message);
//           //     //       Map valueMap = json.decode(message.message);
//           //     //       String mapstr = valueMap["login"];
//           //     //       String uuidserver = valueMap["uuid"];
//           //     //       String serverstate = valueMap["state"];
//           //     //       print("uuidserver$uuidserver");
//           //     //       print("serverstate$serverstate");
//           //     //       // String mapstr = valueMap["uuid"];
//           //     //       print("mapstr$mapstr");
//           //     //       if (mapstr == "login") {
//           //     //         sessionManager.setuuid(uuidserver).then((value) => {});
//           //     //         sessionManager.setserverstate(serverstate).then((value) =>
//           //     //             {
//           //     //               Navigator.push(
//           //     //                   context,
//           //     //                   MaterialPageRoute(
//           //     //                       builder: (context) => const Login()))
//           //     //             });
//           //     //       } else {
//           //     //         // getuserdetailsbuuuid(uuidserver);
//           //     //       }
//           //     //     },
//           //     //   )
//           //     // },

//           //     // backgroundColor: Colors.green,
//           //     onWebViewCreated: (WebViewController webviewcontroller) {
//           //       // _controller.complete
//           //       controller = webviewcontroller;
//           //     },
//           //     // onWebResourceError: (url) {
//           //     //   print('errorurl$url');
//           //     // },
//           //     onProgress: (int val) {
//           //       print("val$val");
//           //     },
//           //     onPageStarted: (url) async {
//           //       print('staredurl$url');
//           //       if (url ==
//           //           "https://project-lithium--epuat.my.salesforce.com/") {
//           //         final SharedPreferences pref =
//           //             await SharedPreferences.getInstance();
//           //         String id = pref.getString("userid") ?? "";
//           //         String accesstoken = pref.getString("accesstokken") ?? "";
//           //         String email = pref.getString("email_id") ?? "";
//           //         logoutapi(id, accesstoken, email);
//           //       }

//           //       // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//           //       // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//           //       // // String? datastrid = androidInfo.androidId.toString();
//           //       // print("datastrid$datastrid");
//           //     },
//           //     onPageFinished: (url) {
//           //       // setState(() {
//           //       print("getredurl$url");
//           //       // });
//           //     },
//           //   );
//           // }),
//         ),
//       ),
//     );
//   }

//   void _showDialog(BuildContext context) async {
//     final SharedPreferences pref = await SharedPreferences.getInstance();
//     String id = pref.getString("userid") ?? "";
//     String accesstoken = pref.getString("accesstokken") ?? "";
//     String email = pref.getString("email_id") ?? "";
//     print("id$id");
//     print("accesstoken$accesstoken");
//     print("email$email");

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Bouncing(
//                     onPress: (() {
//                       Navigator.of(context, rootNavigator: true).pop();
//                     }),
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       padding: const EdgeInsets.all(2),
//                       child: Icon(
//                         Icons.clear,
//                         color: HexColor(Colorscommon.greydark),
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Logout?",
//                     style: TextStyle(color: HexColor(Colorscommon.greendark)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           content: Text(
//             "Are you sure you want to logout?",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: HexColor(Colorscommon.greydark2),
//                 fontFamily: "AvenirLTStd-Book",
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500),
//           ),
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: GestureDetector(
//                       onTap: () {
//                         Fluttertoast.showToast(
//                           msg: "Logout successfully",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.CENTER,
//                         );
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const Login()));

//                         // Navigator.push(context,
//                         //     MaterialPageRoute(builder: (context) {
//                         //   const Login();
//                         // }));
//                         // Navigator.push(
//                         //     context, const MaterialPagebuilder: (context) => Login());
//                         // //                Navigator.pushNamedAndRemoveUntil(
//                         // , MaterialPageRoute(builder: (context) => const Login()));
//                         // logoutapi(id, accesstoken, email);
//                       },
//                       child: Container(
//                         margin:
//                             const EdgeInsets.only(top: 10, left: 10, right: 0),
//                         padding: const EdgeInsets.all(5),
//                         height: 30,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             gradient: LinearGradient(colors: [
//                               HexColor(Colorscommon.greenlight2),
//                               HexColor(Colorscommon.greenlight2),
//                             ])),
//                         child: const Center(
//                             child: Text(
//                           "Log Out",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontFamily: 'AvenirLTStd-Black',
//                               fontWeight: FontWeight.w500),
//                         )),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context, rootNavigator: true).pop();
//                       },
//                       child: Container(
//                         margin:
//                             const EdgeInsets.only(top: 10, left: 10, right: 0),
//                         height: 30,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(
//                               color: HexColor(Colorscommon.greenlight2),
//                             )),
//                         child: Center(
//                             child: Text(
//                           "Cancel",
//                           style: TextStyle(
//                               color: HexColor(Colorscommon.greenlight2),
//                               fontSize: 13,
//                               fontFamily: 'AvenirLTStd-Black',
//                               fontWeight: FontWeight.w500),
//                           // style: TextStyle(
//                           //     color: HexColor(Colorscommon.greenlight2),
//                           //     fontFamily: 'Lato',
//                           //     fontWeight: FontWeight.bold),
//                         )),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   setdata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setBool('fprint', _fingerValue);
//       if (_fingerValue) {
//         prefs.setString('Fingershow', "1234");
//       } else {
//         prefs.setString('Fingershow', "134");
//       }

//       print('set-fp = $_fingerValue');
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => const Login()));
//     });
//   }

//   Getdata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _fingerValue = prefs.getBool('fprint') ?? false;

//     _fingerValuestr = prefs.getString('Fingershow');
//     print("_fingerValuestr$_fingerValuestr");
//     // _biometricbool = prefs.getBool('biometric') ?? false;

//     print('get-fp = $_fingerValue');
//     setState(() {});
//   }
// }

// ///new code design for sp app
// ///
// // ///
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';

// // class settings extends StatefulWidget {
// //   const settings({Key? key}) : super(key: key);

// //   @override
// //   State<settings> createState() => _settingsState();
// // }

// // class _settingsState extends State<settings> {
// //   bool _fingerValue = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(
// //           title: const Text(
// //             'Settings',
// //             style: TextStyle(color: Colors.white),
// //           ),
// //           backgroundColor: const Color(0xff268D79),
// //           elevation: 0,
// //           leading: const BackButton(color: Colors.white),
// //         ),
// //         body: Column(children: [
// //           ClipPath(
// //             clipper: RoundShape(),
// //             child: Container(
// //               height: 50,
// //               color: const Color(0xff268D79),
// //             ),
// //           ),
// //           Center(
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 getProfileView(),
// //                 Container(
// //                   margin: const EdgeInsets.only(left: 30),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: const [
// //                       Text(
// //                         'Aravind S',
// //                         style: TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.w700,
// //                             color: Colors.black),
// //                       ),
// //                       Text(
// //                         'aravind@gmail.com',
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: Colors.black,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 IconButton(
// //                     onPressed: () {},
// //                     icon: const Icon(Icons.keyboard_arrow_right,
// //                         color: Color(0xff268D79)))
// //               ],
// //             ),
// //           ),
// //           const SizedBox(
// //             height: 20,
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: SizedBox(
// //               height: MediaQuery.of(context).size.height / 3,
// //               width: MediaQuery.of(context).size.width - 40,
// //               child: Card(
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10.0)),
// //                 child: ListView(
// //                   children: [
// //                     ListTile(
// //                       leading: const Icon(
// //                         Icons.lock_outline,
// //                         color: Color(0xff268D79),
// //                       ),
// //                       title: const Text('Change Password'),
// //                       trailing: const Icon(Icons.keyboard_arrow_right,
// //                           color: Color(0xff268D79)),
// //                       onTap: () {},
// //                     ),
// //                     const Divider(),
// //                     ListTile(
// //                       leading: const Icon(
// //                         Icons.notifications,
// //                         color: Color(0xff268D79),
// //                       ),
// //                       title: const Text('Notification'),
// //                       trailing: const Icon(Icons.keyboard_arrow_right,
// //                           color: Color(0xff268D79)),
// //                       onTap: () {},
// //                     ),
// //                     const Divider(),
// //                     ListTile(
// //                       leading: const Icon(
// //                         Icons.fingerprint,
// //                         color: Color(0xff268D79),
// //                       ),
// //                       title: const Text('Use Biometric'),
// //                       trailing: CupertinoSwitch(
// //                         activeColor: const Color(0xff268D79),
// //                         value: _fingerValue,
// //                         onChanged: (bool value) {
// //                           setState(() {
// //                             _fingerValue = value;
// //                             // setdata();
// //                           });
// //                         },
// //                       ),
// //                       onTap: () {},
// //                     ),
// //                     const Divider(),
// //                     ListTile(
// //                       leading: const Icon(
// //                         Icons.logout,
// //                         color: Color(0xff268D79),
// //                       ),
// //                       title: const Text('Logout'),
// //                       trailing: const Icon(Icons.keyboard_arrow_right,
// //                           color: Color(0xff268D79)),
// //                       onTap: () {
// //                         _showDialog(context);
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           )
// //         ]));
// //   }
// // }

// // void _showDialog(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         title: const Center(
// //             child: Text(
// //           "Logout?",
// //           style: TextStyle(color: Color(0xff268D79)),
// //         )),
// //         content: const Text(
// //           "Are you sure you want to logout?",
// //           style: TextStyle(color: Colors.grey),
// //         ),
// //         actions: <Widget>[
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Expanded(
// //                   flex: 1,
// //                   child: GestureDetector(
// //                     onTap: () {},
// //                     child: Container(
// //                       margin:
// //                           const EdgeInsets.only(top: 10, left: 10, right: 0),
// //                       padding: const EdgeInsets.all(5),
// //                       height: 30,
// //                       decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(5),
// //                           gradient: const LinearGradient(
// //                               colors: [Color(0xff268D79), Color(0xff268D79)])),
// //                       child: const Center(
// //                           child: Text(
// //                         "Log Out",
// //                         style: TextStyle(
// //                             color: Colors.white,
// //                             fontFamily: 'Lato',
// //                             fontWeight: FontWeight.bold),
// //                       )),
// //                     ),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   flex: 1,
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       Navigator.of(context, rootNavigator: true).pop();
// //                     },
// //                     child: Container(
// //                       margin:
// //                           const EdgeInsets.only(top: 10, left: 10, right: 0),
// //                       height: 30,
// //                       decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(5),
// //                           border: Border.all(color: const Color(0xff268D79))),
// //                       child: const Center(
// //                           child: Text(
// //                         "Cancel",
// //                         style: TextStyle(
// //                             color: Color(0xff268D79),
// //                             fontFamily: 'Lato',
// //                             fontWeight: FontWeight.bold),
// //                       )),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }

// // Widget getProfileView() {
// //   return Stack(
// //     children: const <Widget>[
// //       CircleAvatar(
// //         radius: 35,
// //         backgroundColor: Color(0xff268D79),
// //         child: Icon(Icons.person_outline_rounded),
// //       ),
// // /*
// //       Positioned(
// //           bottom: 1,
// //           right: 1,
// //           child: Container(
// //             height: 30,
// //             width: 30,
// //             child: const Icon(
// //               Icons.edit,
// //               color: Colors.deepPurple,
// //               size: 20,
// //             ),
// //             decoration: BoxDecoration(
// //                 color: Colors.amber.shade200,
// //                 borderRadius: const BorderRadius.all(Radius.circular(20))),
// //           ))
// // */
// //     ],
// //   );
// // }

// // class RoundShape extends CustomClipper<Path> {
// //   @override
// //   getClip(Size size) {
// //     double height = size.height;
// //     double width = size.width;
// //     double curveHeight = size.height / 2;
// //     var p = Path();
// //     p.lineTo(0, height - curveHeight);
// //     p.quadraticBezierTo(width / 2, height, width, height - curveHeight);
// //     p.lineTo(width, 0);
// //     p.close();
// //     return p;
// //   }

// //   @override
// //   bool shouldReclip(CustomClipper oldClipper) => true;
// // }

// class CustomAppBarShape extends ContinuousRectangleBorder {
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     double h = rect.height;
//     double w = rect.width;
//     //  double height = size.height;
//     // double width = size.width;
//     double curveHeight = rect.height / 2;
//     var p = Path();
//     p.lineTo(0, h - 20);
//     p.quadraticBezierTo(w / 2, h, w, h - 20);
//     p.lineTo(w, 0);
//     p.close();
//     return p;
//     // var path = Path();
//     // path.lineTo(0, height + width * 0.1);
//     // path.arcToPoint(
//     //   Offset(width * 0.1, height),
//     //   radius: Radius.circular(width * 0.1),
//     // );
//     // path.lineTo(width * 0.9, height);
//     // path.arcToPoint(
//     //   Offset(width, height + width * 0.1),
//     //   radius: Radius.circular(width * 0.1),
//     // );
//     // path.lineTo(width, 0);
//     // path.close();

//     // return path;
//   }
// }

// Widget getProfileView() {
//   return Stack(
//     children: <Widget>[
//       Container(
//         padding: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: HexColor(Colorscommon.greenApp2color),
//             width: 2.0,
//           ),
//         ),
//         child: CircleAvatar(
//           radius: 35,
//           backgroundColor: HexColor(Colorscommon.greenApp2color),
//           child: const Icon(Icons.person_outline_rounded),
//         ),
//       ),
// /*
//       Positioned(
//           bottom: 1,
//           right: 1,
//           child: Container(
//             height: 30,
//             width: 30,
//             child: const Icon(
//               Icons.edit,
//               color: Colors.deepPurple,
//               size: 20,
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.amber.shade200,
//                 borderRadius: const BorderRadius.all(Radius.circular(20))),
//           ))
// */
//     ],
//   );
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/Login.dart';
import 'package:flutter_application_sfdc_idp/Odo.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:flutter_application_sfdc_idp/widget/language_picker_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
//import 'package:restart_app/restart_app.dart';

// var uuid = Uuid();

SessionManager sessionManager = SessionManager();

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late BuildContext dialogContext_password;
  bool _fingerValue = false;
  TextEditingController emailorphonecontroller = TextEditingController();
  Utility utility = Utility();
  String? _fingerValuestr;
  var username = "";
  var emailshow = "";


  @override
  void initState() {
    super.initState();

    // LocalNotificationService.initialize(context); // Uncomment if needed

    // No need for this in webview_flutter 4.5+
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();

    utility.GetUserdata().then((value) {
      print(utility.lithiumid.toString());
      username = utility.lithiumid;
      emailshow = utility.emailId;

      Getdata(); // Call your method to fetch additional data

      if (mounted) {
        setState(() {});
      }
    });
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.changePassword,
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

  // void ForgotPassword() {
  //   emailorphonecontroller.text = "";
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       dialogContext_password = context;

  //       return Dialog(
  //         insetPadding: EdgeInsets.all(5),

  //         // padding: const EdgeInsets.all(5.0),
  //         child: Container(
  //           margin: EdgeInsets.all(15),
  //           width: double.infinity,
  //           padding: EdgeInsets.all(5),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: GradientText(
  //                   "Forgot Password",
  //                   18,
  //                   gradient: LinearGradient(colors: [
  //                     HexColor(Colorscommon.greencolor),
  //                     HexColor(Colorscommon.greenlite),
  //                   ]),
  //                 ),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(top: 30, left: 0, right: 0),
  //                 decoration: BoxDecoration(
  //                     border: Border(bottom: BorderSide(color: Colors.grey))),
  //                 child: Theme(
  //                   data: Theme.of(context).copyWith(
  //                       primaryColor: HexColor(Colorscommon.greencolor)),
  //                   child: TextField(
  //                     controller: emailorphonecontroller,
  //                     maxLength: 10,
  //                     keyboardType: TextInputType.number,

  //                     // obscureText: true,
  //                     style: TextStyle(
  //                         color: Colors.grey,
  //                         fontFamily: 'AvenirLTStd',
  //                         fontWeight: FontWeight.bold),
  //                     textAlign: TextAlign.start,

  //                     //  controller: usernameController,
  //                     decoration: InputDecoration(
  //                         border: OutlineInputBorder(),
  //                         labelText: 'Enter registered phone number'),
  //                   ),
  //                 ),
  //               ),
  //               Center(
  //                 child: Row(
  //                   children: [
  //                     Bouncing(
  //                       onPress: () {
  //                         if (emailorphonecontroller.text.isNotEmpty) {
  //                           sessionManager
  //                               .internetcheck()
  //                               .then((intenet) async {
  //                             if (intenet != null && intenet) {
  //                               ForgotpasswordAPI();
  //                             } else {
  //                               Fluttertoast.showToast(
  //                                 msg: "Please check your internet connection",
  //                                 toastLength: Toast.LENGTH_SHORT,
  //                                 gravity: ToastGravity.CENTER,
  //                               );
  //                             }
  //                           });
  //                         } else {
  //                           Fluttertoast.showToast(
  //                             msg: "Please enter valid phone number",
  //                             toastLength: Toast.LENGTH_SHORT,
  //                             gravity: ToastGravity.CENTER,
  //                           );
  //                         }
  //                       },
  //                       child: Container(
  //                         margin: EdgeInsets.only(top: 20, left: 0, right: 0),
  //                         height: 40,
  //                         width: 100,
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(5),
  //                             gradient: LinearGradient(colors: [
  //                               HexColor(Colorscommon.greencolor),
  //                               HexColor(Colorscommon.greenlite),
  //                             ])),
  //                         child: Center(
  //                             child: Text(
  //                           "Confirm",
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontFamily: 'Montserrat',
  //                               fontWeight: FontWeight.bold),
  //                         )),
  //                       ),
  //                     ),
  //                     Bouncing(
  //                       onPress: () {
  //                         Navigator.pop(dialogContext_password);
  //                       },
  //                       child: Container(
  //                         margin: EdgeInsets.only(top: 20, left: 10, right: 0),
  //                         height: 40,
  //                         width: 100,
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(5),
  //                             border: Border.all(
  //                                 color: HexColor(Colorscommon.greencolor))),
  //                         child: Center(
  //                             child: Text(
  //                           "Close",
  //                           style: TextStyle(
  //                               color: Colors.grey,
  //                               fontFamily: 'Montserrat',
  //                               fontWeight: FontWeight.bold),
  //                         )),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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

  void logoutapi(String id, String accesstoken, String email) async {
    print("id$id");
    print("accesstoken$accesstoken");
    print("email$email");
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
        //Restart.restartApp();

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
        //Restart.restartApp();
      }

      // Fluttertoast.showToast(
      //   msg: message,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
    } else {
      debugPrint('SERVER=FAILED');

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.somethingwentwrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  // void ForgotpasswordAPI() async {
  //   String url = CommonURL.URL;
  //   Map<String, String> postdata = {
  //     "from": "driversGetVerificationCode",
  //     "emailOrMobile": emailorphonecontroller.text,
  //   };

  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/hal+json',
  //     'Accept': 'application/json',
  //   };

  //   debugPrint('fetchdata $url');
  //   debugPrint('fetchdata $postdata');

  //   final response = await http.post(url,
  //       body: jsonEncode(postdata), headers: requestHeaders);

  //   print("${response.statusCode}");
  //   print("${response.body}");

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);

  //     // debugPrint('Passwordchnageresponse $jsonInput');

  //     String success = jsonInput['success'].toString();
  //     String message = jsonInput['message'];
  //     // debugPrint('Location_success $success');
  //     // debugPrint('Location_message $message');

  //     // Navigator.pop(dialogContext);

  //     if (success == '1') {
  //       String idDriverr = jsonInput['id_driver'].toString();

  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ForgotPasswordClass(
  //               text: emailorphonecontroller.text,
  //               id_driver: idDriverr,
  //             ),
  //           ));
  //       // return Future.value(true);
  //     }

  //     Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //     );
  //   } else {
  //     debugPrint('SERVER=FAILED');

  //     Fluttertoast.showToast(
  //       msg: "Something went wrong please try again",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //     );
  //   }
  // }

// }
  late WebViewController controller;
  TextEditingController oldpasswordcontroller = TextEditingController();
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  void chagepasswordapirequest(String userid, clientid, accesstokken,
      refreshtokken, mobile, oldPassword) async {
    String url = CommonURL.URL;
    // print(oldpasswordcontroller.text);
    // print(newpasswordcontroller.text);
    // print(confirmpasswordcontroller.text);
    // print(clientid);
    // print(userid);
    // print(accesstokken);
    // print(mobile);
    // print(refreshtokken);
    Map<String, String> postdata = {
      "from": "changeDriversPassword",
      "oldPassword": oldpasswordcontroller.text,
      "newPassword": newpasswordcontroller.text,
      "confirmPassword": confirmpasswordcontroller.text,
      "clientID": clientid,
      "userId": userid,
      "access_token": accesstokken,
      "username": utility.lithiumid,
      "refresh_token": refreshtokken,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };
    debugPrint('fetchdata $url');

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);

    print("${response.statusCode}");
    print(response.body);

    debugPrint('Passwordchnageresponse $response.statusCode');

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      debugPrint('Passwordchnageresponse $jsonInput');

      String success = jsonInput['status'].toString();
      String message = jsonInput['message'];
      debugPrint('Location_success $success');
      debugPrint('Location_message $message');

      Navigator.pop(context);

      if (success == 'true') {
        // Navigator.pop(context);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Timer(const Duration(milliseconds: 100), () {
          // Restart.restartApp();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ));
          print(" This line is execute after 5 seconds");
        });
      }
      if (success == 'false') {
        // Navigator.pop(context);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        // Timer(const Duration(milliseconds: 100), () {
        //   // Restart.restartApp();
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const Login(),
        //       ));
        //   print(" This line is execute after 5 seconds");
        // });
      }
    } else {
      debugPrint('SERVER=FAILED');

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.somethingwentwrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
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
                  // color: Colors.purple.shade800,
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
          String mobile = pref.getString("mobile_no") ?? "";

          String oldPassword = pref.getString("password") ?? "";
          print("userid$userid");
          print("clientid$clientid");
          print("refreshtokken$refreshtokken");
          print("accesstokken$accesstokken");
          print("mobile$mobile");
          print("oldPassword$oldPassword");

          // if (oldPassword == oldpasswordcontroller.text) {
          sessionManager.internetcheck().then((intenet) async {
            if (intenet) {
              FocusScope.of(context).unfocus();
              loading();
              utility.GetUserdata().then((value) => {
                    chagepasswordapirequest(userid, clientid, accesstokken,
                        refreshtokken, mobile, oldPassword)
                  });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                final overlay = Overlay.of(context);
                if (overlay == null) return;

                showTopSnackBar(
                  overlay,
                  CustomSnackBar.error(
                    message: AppLocalizations.of(context)!
                        .pleasecheckinternetconnection,
                  ),
                );
              });

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
            msg: AppLocalizations.of(context)!.passwordnotmatch,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.pleaseenternewpassword,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.pleaseenteroldpassword,
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
                  child: Avenirtextblack(
                    customfontweight: FontWeight.normal,
                    fontsize: 14,
                    text: AppLocalizations.of(context)!.changePassword,
                    textcolor: HexColor(Colorscommon.greendark2),
                    // customfontweight: FontWeight.w500,
                    // fontsize: 15,
                    // text: 'Change Password',
                    // textcolor: HexColor(Colorscommon.greencolor),
                  ),
                  // child: GradientText(
                  //   "Change Password",
                  //   18,
                  //   gradient: LinearGradient(colors: [
                  //     HexColor(Colorscommon.greencolor),
                  //     HexColor(Colorscommon.greencolor),
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
                      controller: oldpasswordcontroller,
                      obscureText: true,
                      style: TextStyle(
                        fontFamily: 'AvenirLTStd-Book',
                        fontSize: 14,
                        color: HexColor(Colorscommon.greydark2),
                      ),
                      textAlign: TextAlign.start,

                      //  controller: usernameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Enter Old Password',
                        labelStyle: TextStyle(
                          fontFamily: 'AvenirLTStd-Book',
                          fontSize: 14,
                          color: HexColor(Colorscommon.greydark2),
                        ),
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
                      controller: newpasswordcontroller,
                      obscureText: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'AvenirLTStd-Book',
                        fontSize: 14,
                        color: HexColor(Colorscommon.greydark2),
                      ),
                      // controller: passwordController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Enter New Password",
                        labelStyle: TextStyle(
                          fontFamily: 'AvenirLTStd-Book',
                          fontSize: 14,
                          color: HexColor(Colorscommon.greydark2),
                        ),
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
                      style: TextStyle(
                        fontFamily: 'AvenirLTStd-Book',
                        fontSize: 14,
                        color: HexColor(Colorscommon.greydark2),
                      ),
                      // controller: passwordController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Confirm New Password",
                        labelStyle: TextStyle(
                          fontFamily: 'AvenirLTStd-Book',
                          fontSize: 14,
                          color: HexColor(Colorscommon.greydark2),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Bouncing(
                          onPress: () {
                            validateInputs();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 0, right: 0),
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(colors: [
                                  HexColor(Colorscommon.greenlight2),
                                  HexColor(Colorscommon.greenlight2),
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
                                      ? 12
                                      : 14,
                                  textcolor: Colors.white,
                                  customfontweight: FontWeight.w500),
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
                      ),
                      Expanded(
                        flex: 2,
                        child: Bouncing(
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
                                      ? 12
                                      : 14,
                                  textcolor: HexColor(Colorscommon.greenlight2),
                                  customfontweight: FontWeight.w500),
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
        // Navigator.pop(context, true);
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

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: AppBar(
              backgroundColor: HexColor(Colorscommon.greenAppcolor),
              centerTitle: true,
              leading: Container(),
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back, color: Colors.black),
              //   onPressed: () => Navigator.of(context, rootNavigator: true),
              //   // Navigator.push(
              //   //     context,
              //   //     MaterialPageRoute(
              //   //         builder: (context) => const MyTabPage(
              //   //               title: '',
              //   //             )
              //   //             )
              //   //             ),
              // ),
              // leading: Bouncing(
              //   onPress: () {
              //     Navigator.pop(context);
              //   },
              //   child: const Icon(
              //     Icons.arrow_back,
              //     size: 30,
              //     color: Colors.white,
              //   ),
              // ),
              title: Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lato',
                  fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                          AppLocalizations.of(context)!.id == "आयडी" ||
                          AppLocalizations.of(context)!.id == "ಐಡಿ")
                      ? 15
                      : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: CustomAppBarShape(),
            ),
          ),
          body:Column(children: [
            Container(
              color: HexColor("#F8F8F8"),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getProfileView(),
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'AvenirLTStd-Black',
                                color: HexColor(Colorscommon.darkblack)),
                          ),
                          // Text(
                          //   emailshow,
                          //   style: TextStyle(
                          //       fontSize: 13,
                          //       fontWeight: FontWeight.w700,
                          //       color: HexColor(Colorscommon.darkblack)),
                          // ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.keyboard_arrow_right,
                            color: Color(0xff268D79)))
                  ],
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Expanded(
            //       child: Container(
            //         margin: const EdgeInsets.all(0),
            //         child: const Center(
            //             child: Text(
            //           "Settings",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold),
            //         )),
            //         height: MediaQuery.of(context).size.width / 8,
            //         color: HexColor(Colorscommon.greencolor),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            Card(
              elevation: .8,
              margin: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SizedBox(
                // height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width - 40,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    // Container(
                    //   margin: const EdgeInsets.all(10),
                    //   height: 10,
                    //   child: Row(
                    //     children: const [
                    //       Icon(
                    //         Icons.lock_outline,
                    //         color: Color(0xff268D79),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10),
                      // leading: const Icon(
                      //   Icons.logout,
                      //   color: Color(0xff268D79),
                      // ),

                      title: Text(
                        AppLocalizations.of(context)!.qRcode,
                        style: TextStyle(
                            color: HexColor(
                              Colorscommon.greydark2,
                            ),
                            fontSize: (AppLocalizations.of(context)!.id ==
                                        "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ")
                                ? 12
                                : 14,
                            fontFamily: 'AvenirLTStd-Book',
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right,
                          color: Color(0xff268D79)),
                      onTap: () {
                        sessionManager.internetcheck().then((intenet) async {
                          if (intenet) {
                            //QR code
                            qrGenerate(context);
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
                          }
                        });
                      },
                    ),
                    const Padding(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Divider(
                          height: .1,
                          thickness: .5,
                        )),
                    Visibility(
                      visible: _fingerValuestr == "1234",
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10),
                        // leading: const Icon(
                        //   Icons.lock_outline,
                        //   color: Color(0xff268D79),
                        // ),
                        title: Text(
                          AppLocalizations.of(context)!.changePassword,
                          style: TextStyle(
                              color: HexColor(
                                Colorscommon.greydark2,
                              ),
                              fontSize: (AppLocalizations.of(context)!.id ==
                                          "ஐடி" ||
                                      AppLocalizations.of(context)!.id ==
                                          "आयडी" ||
                                      AppLocalizations.of(context)!.id == "ಐಡಿ")
                                  ? 12
                                  : 14,
                              fontFamily: 'AvenirLTStd-Book',
                              fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right,
                            color: Color(0xff268D79)),
                        onTap: () {
                          sessionManager.internetcheck().then((intenet) async {
                            if (intenet) {
                              oldpasswordcontroller.text = "";
                              newpasswordcontroller.text = "";
                              confirmpasswordcontroller.text = "";
                              ChangePassword();
                              //               final SharedPreferences pref = await SharedPreferences.getInstance();
                              // String userid = pref.getString("userid") ?? "";
                            } else {
                             // WidgetsBinding.instance.addPostFrameCallback((_) {
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
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Divider(
                          height: .1,
                          thickness: .5,
                        )),
                    // const Divider(),
                    // ListTile(
                    //   contentPadding: const EdgeInsets.symmetric(
                    //       vertical: 0.0, horizontal: 10),
                    //   // leading: const Icon(
                    //   //   Icons.notifications,
                    //   //   color: Color(0xff268D79),
                    //   // ),
                    //   title: Text(
                    //     'Notification',
                    //     style: TextStyle(
                    //         color: HexColor(
                    //           Colorscommon.greydark2,
                    //         ),
                    //         fontSize: 14,
                    //         fontFamily: 'AvenirLTStd-Book',
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    //   trailing: const Icon(Icons.keyboard_arrow_right,
                    //       color: Color(0xff268D79)),
                    //   onTap: () {},
                    // ),
                    // const Padding(
                    //     padding: EdgeInsets.only(right: 10, left: 10),
                    //     child: Divider(
                    //       height: .1,
                    //       thickness: .5,
                    //     )),
                    // const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10),
                      // leading: const Icon(
                      //   Icons.fingerprint,
                      //   color: Color(0xff268D79),
                      // ),

                      title: Text(
                        AppLocalizations.of(context)!.useBiometric,
                        style: TextStyle(
                            color: HexColor(
                              Colorscommon.greydark2,
                            ),
                            fontSize: (AppLocalizations.of(context)!.id ==
                                        "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ")
                                ? 12
                                : 14,
                            fontFamily: 'AvenirLTStd-Book',
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: CupertinoSwitch(
                        activeColor: const Color(0xff268D79),
                        value: _fingerValue,
                        onChanged: (bool value) {
                          setState(() {
                            _fingerValue = value;
                            setdata();
                          });
                        },
                      ),
                      onTap: () {},
                    ),
                    const Padding(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Divider(
                          height: .1,
                          thickness: .5,
                        )),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10),
                      // leading: const Icon(
                      //   Icons.logout,
                      //   color: Color(0xff268D79),
                      // ),

                      title: Text(
                        AppLocalizations.of(context)!.language,
                        style: TextStyle(
                            color: HexColor(
                              Colorscommon.greydark2,
                            ),
                            fontSize: (AppLocalizations.of(context)!.id ==
                                        "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ")
                                ? 12
                                : 14,
                            fontFamily: 'AvenirLTStd-Book',
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right,
                          color: Color(0xff268D79)),
                      onTap: () {
                        sessionManager.internetcheck().then((intenet) async {
                          if (intenet) {
                            //QR code
                            selectlanguagepopup(context);
                          } else {
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
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
                          }
                        });
                      },
                    ),

                    const Padding(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Divider(
                          height: .1,
                          thickness: .5,
                        )),
                    // const Divider(),
                    // ListTile(
                    //   contentPadding: const EdgeInsets.symmetric(
                    //       vertical: 0.0, horizontal: 10),
                    //   // leading: const Icon(
                    //   //   Icons.logout,
                    //   //   color: Color(0xff268D79),
                    //   // ),
                    //
                    //   title: Text(
                    //     "Odometter",
                    //     style: TextStyle(
                    //         color: HexColor(
                    //           Colorscommon.greydark2,
                    //         ),
                    //         fontSize: (AppLocalizations.of(context)!.id ==
                    //             "ஐடி" ||
                    //             AppLocalizations.of(context)!.id ==
                    //                 "आयडी" ||
                    //             AppLocalizations.of(context)!.id == "ಐಡಿ")
                    //             ? 12
                    //             : 14,
                    //         fontFamily: 'AvenirLTStd-Book',
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    //   trailing: const Icon(Icons.keyboard_arrow_right,
                    //       color: Color(0xff268D79)),
                    //   onTap: () {
                    //     sessionManager.internetcheck().then((intenet) async {
                    //       if (intenet) {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => const Odo()),
                    //         );
                    //       } else {
                    //         showTopSnackBar(
                    //           context,
                    //           const CustomSnackBar.error(
                    //             // icon: Icon(Icons.interests),
                    //             message:
                    //             "Please Check Your Internet Connection",
                    //             // backgroundColor: Colors.white,
                    //             // textStyle: TextStyle(color: Colors.red),
                    //           ),
                    //         );
                    //       }
                    //     });
                    //   },
                    // ),

                    const Padding(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Divider(
                          height: .1,
                          thickness: .5,
                        )),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10),
                      // leading: const Icon(
                      //   Icons.logout,
                      //   color: Color(0xff268D79),
                      // ),

                      title: Text(
                        AppLocalizations.of(context)!.logout,
                        style: TextStyle(
                            color: HexColor(
                              Colorscommon.greydark2,
                            ),
                            fontSize: (AppLocalizations.of(context)!.id ==
                                        "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ")
                                ? 12
                                : 15,
                            fontFamily: 'AvenirLTStd-Book',
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right,
                          color: Color(0xff268D79)),
                      onTap: () {
                        sessionManager.internetcheck().then((intenet) async {
                          if (intenet) {
                            _showDialog(context);
                            // checkupdate(_30minstr);,
                            // loading();
                            // Loginapi(serveruuid, serverstate);
                          } else {
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
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
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Visibility(
            //   visible: _fingerValuestr == "1234",
            //   child: Bouncing(
            //     // onTap: () {
            //     //   ForgotPassword();
            //     // },
            //     onPress: () {
            //       // ForgotPassword();
            //       sessionManager.internetcheck().then((intenet) async {
            //         if (intenet) {
            //           oldpasswordcontroller.text = "";
            //           newpasswordcontroller.text = "";
            //           confirmpasswordcontroller.text = "";
            //           ChangePassword();
            //           //               final SharedPreferences pref = await SharedPreferences.getInstance();
            //           // String userid = pref.getString("userid") ?? "";
            //         } else {
            //           showTopSnackBar(
            //             context,
            //             const CustomSnackBar.error(
            //               // icon: Icon(Icons.interests),
            //               message: "Please Check Your Internet Connection",
            //               // backgroundColor: Colors.white,
            //               // textStyle: TextStyle(color: Colors.red),
            //             ),
            //           );
            //           // Fluttertoast.showToast(
            //           //   msg: "No Internet",
            //           //   toastLength: Toast.LENGTH_SHORT,
            //           //   gravity: ToastGravity.CENTER,
            //           // );
            //         }
            //       });
            //     },
            //     child: Card(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10), // if you need this
            //         side: BorderSide(
            //           color: Colors.grey.withOpacity(0.5),
            //           width: 1,
            //         ),
            //       ),
            //       elevation: 3,
            //       margin: const EdgeInsets.all(10),
            //       child: Container(
            //         padding: const EdgeInsets.all(10),
            //         decoration: BoxDecoration(
            //             borderRadius: const BorderRadius.all(Radius.circular(10)),
            //             gradient: LinearGradient(colors: [
            //               HexColor(Colorscommon.whitecolor),
            //               HexColor(Colorscommon.whitelite)
            //             ])),
            //         child: Row(
            //           children: [
            //             Icon(
            //               Icons.lock,
            //               color: HexColor(Colorscommon.greencolor),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.all(10),
            //               child: Text(
            //                 'Change Password',
            //                 style: TextStyle(
            //                     fontFamily: 'TomaSans-Regular',
            //                     fontWeight: FontWeight.bold,
            //                     color: HexColor(Colorscommon.greycolor)),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // // Bouncing(
            // //   // onTap: () {
            // //   //   ForgotPassword();
            // //   // },
            // //   onPress: () {
            // //     // ForgotPassword();
            // //     sessionManager.internetcheck().then((intenet) async {
            // //       if (intenet != null && intenet) {
            // //         final SharedPreferences pref =
            // //             await SharedPreferences.getInstance();
            // //         String userid = pref.getString("userid") ?? "";
            // //         Navigator.of(context).push(MaterialPageRoute(
            // //             builder: (context) => const Localnotifications()));
            // //         // ChangePassword();
            // //       } else {
            // //         showTopSnackBar(
            // //           context,
            // //           const CustomSnackBar.error(
            // //             // icon: Icon(Icons.interests),
            // //             message: "Please check your internet connection",
            // //             // backgroundColor: Colors.white,
            // //             // textStyle: TextStyle(color: Colors.red),
            // //           ),
            // //         );
            // //         // Fluttertoast.showToast(
            // //         //   msg: "No Internet",
            // //         //   toastLength: Toast.LENGTH_SHORT,
            // //         //   gravity: ToastGravity.CENTER,
            // //         // );
            // //       }
            // //     });
            // //   },
            // //   child: Card(
            // //     elevation: 2,
            // //     margin: const EdgeInsets.all(10),
            // //     child: Container(
            // //       padding: const EdgeInsets.all(10),
            // //       decoration: BoxDecoration(
            // //           borderRadius: const BorderRadius.all(Radius.circular(10)),
            // //           gradient: LinearGradient(colors: [
            // //             HexColor(Colorscommon.whitecolor),
            // //             HexColor(Colorscommon.whitelite)
            // //           ])),
            // //       child: Row(
            // //         children: [
            // //           Icon(
            // //             Icons.notifications,
            // //             color: HexColor(Colorscommon.greencolor),
            // //           ),
            // //           Container(
            // //             margin: const EdgeInsets.all(10),
            // //             child: Text(
            // //               'Messages',
            // //               style: TextStyle(
            // //                   fontFamily: 'TomaSans-Regular',
            // //                   fontWeight: FontWeight.bold,
            // //                   color: HexColor(Colorscommon.greycolor)),
            // //             ),
            // //           ),
            // //         ],
            // //       ),
            // //     ),
            // //   ),
            // // ),
            // // ),
            // // FadeAnimation(
            // //   1.2,
            // // Bouncing(
            // //   onPress: () {},
            // //   // onTap: () async {
            // //   //   // AndroidIntent intent = AndroidIntent(
            // //   //   //   action: 'action_view',
            // //   //   //   data: "https://youtu.be/CEZ8dPtZj-E",
            // //   //   // );
            // //   //   // await intent.launch();
            // //   // },
            // //   child: Card(
            // //     elevation: 2,
            // //     margin: EdgeInsets.all(10),
            // //     child: Container(
            // //       padding: EdgeInsets.all(10),
            // //       decoration: BoxDecoration(
            // //           borderRadius: BorderRadius.all(Radius.circular(10)),
            // //           gradient: LinearGradient(colors: [
            // //             HexColor(Colorscommon.whitecolor),
            // //             HexColor(Colorscommon.whitelite)
            // //           ])),
            // //       child: Row(
            // //         children: [
            // //           Icon(
            // //             Icons.help_outline,
            // //             color: HexColor(Colorscommon.greencolor),
            // //           ),
            // //           Container(
            // //             margin: EdgeInsets.all(10),
            // //             child: Text(
            // //               'How to video',
            // //               style: TextStyle(
            // //                   fontFamily: 'TomaSans-Regular',
            // //                   fontWeight: FontWeight.bold,
            // //                   color: HexColor(Colorscommon.greycolor)),
            // //             ),
            // //           ),
            // //           // Expanded(
            // //           //   child: Align(
            // //           //       alignment: Alignment.centerRight,
            // //           //       child: Image.asset(
            // //           //         'assets/forward.png',
            // //           //         width: 15,
            // //           //       )),
            // //           // ),
            // //         ],
            // //       ),
            // //     ),
            // //   ),
            // // ),
            // // ),
            // // FadeAnimation(
            // //   1.2,
            // Bouncing(
            //   onPress: () async {
            //     final SharedPreferences pref =
            //         await SharedPreferences.getInstance();
            //     String id = pref.getString("userid") ?? "";
            //     String accesstoken = pref.getString("accesstokken") ?? "";
            //     String email = pref.getString("email_id") ?? "";
            //     print("id$id");
            //     print("accesstoken$accesstoken");
            //     print("email$email");

            //     showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //             insetPadding: const EdgeInsets.all(10),
            //             contentPadding: EdgeInsets.zero,
            //             clipBehavior: Clip.antiAliasWithSaveLayer,
            //             titlePadding: EdgeInsets.zero,
            //             title: Container(
            //               height: 50,
            //               // margin: const EdgeInsets.all(0),
            //               color: HexColor(Colorscommon.greencolor),
            //               // decoration: BoxDecoration(
            //               //     borderRadius: BorderRadius.circular(0),
            //               //     gradient: LinearGradient(colors: [
            //               //       HexColor(Colorscommon.greencolor),
            //               //       HexColor(Colorscommon.greenlite),
            //               //     ])),
            //               child: Center(
            //                 child: Text(
            //                   "Confirmation",
            //                   style: TextStyle(
            //                       fontSize: 17,
            //                       fontFamily: "Lato",
            //                       fontWeight: FontWeight.bold,
            //                       color: HexColor(Colorscommon.whitecolor)),
            //                   textAlign: TextAlign.start,
            //                 ),
            //               ),
            //             ),
            //             titleTextStyle: TextStyle(color: Colors.grey[700]),
            //             // titlePadding: const EdgeInsets.only(left: 5, top: 5),
            //             content: Container(
            //               width: MediaQuery.of(context).size.width,
            //               margin: const EdgeInsets.only(top: 5),
            //               child: Padding(
            //                 padding: const EdgeInsets.only(
            //                     top: 20, bottom: 10, left: 10, right: 10),
            //                 child: Text(
            //                   "Are you sure want to logout ?",
            //                   textAlign: TextAlign.center,
            //                   style: TextStyle(
            //                     fontFamily: 'TomaSans-Regular',
            //                     fontSize: 18,
            //                     color: HexColor(Colorscommon.greycolor),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             actions: <Widget>[
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Expanded(
            //                     child: Container(
            //                         margin: const EdgeInsets.only(top: 20),
            //                         child: const Text(
            //                           "Yes",
            //                           style: TextStyle(
            //                               color: Colors.white,
            //                               fontFamily: 'Lato',
            //                               fontWeight: FontWeight.bold),
            //                         )),
            //                   ),
            //                   Expanded(
            //                     flex: 1,
            //                     child: Bouncing(
            //                       onPress: () async {
            //                         // SharedPreferences prefs = await SharedPreferences.getInstance();
            //                         // Loginbool = 'false';
            //                         // prefs.setString('loginbool', Loginbool);
            //                         logoutapi(id, accesstoken, email);
            //                       },
            //                       child: Container(
            //                         margin: const EdgeInsets.only(
            //                             top: 20, left: 0, right: 0),
            //                         height: 40,
            //                         width: 100,
            //                         decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.circular(5),
            //                             gradient: LinearGradient(colors: [
            //                               HexColor(Colorscommon.greencolor),
            //                               HexColor(Colorscommon.greencolor),
            //                             ])),
            //                         child: const Center(
            //                             child: Text(
            //                           "Yes",
            //                           style: TextStyle(
            //                               color: Colors.white,
            //                               fontFamily: 'Montserrat',
            //                               fontWeight: FontWeight.bold),
            //                         )),
            //                       ),
            //                       // child: Container(
            //                       //   margin: const EdgeInsets.only(
            //                       //       top: 20, left: 10, right: 0),
            //                       //   padding: const EdgeInsets.all(5),
            //                       //   height: 30,
            //                       //   decoration: BoxDecoration(
            //                       //       borderRadius:
            //                       //           BorderRadius.circular(5),
            //                       //       gradient: LinearGradient(colors: [
            //                       //         HexColor(Colorscommon.greycolor),
            //                       //         HexColor(Colorscommon.greycolor),
            //                       //       ])),
            //                       //   child: const Center(
            //                       //       child: Text(
            //                       //     "Yes",
            //                       //     style: TextStyle(
            //                       //         color: Colors.white,
            //                       //         fontFamily: 'Lato',
            //                       //         fontWeight: FontWeight.bold),
            //                       //   )),
            //                       // ),
            //                     ),
            //                   ),
            //                   Expanded(
            //                     flex: 1,
            //                     child: Bouncing(
            //                       onPress: () {
            //                         Navigator.of(context, rootNavigator: true)
            //                             .pop();
            //                       },
            //                       child: Container(
            //                         margin: const EdgeInsets.only(
            //                             top: 20, left: 10, right: 0),
            //                         height: 40,
            //                         width: 100,
            //                         decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.circular(5),
            //                             border: Border.all(
            //                                 color: HexColor(
            //                                     Colorscommon.greencolor))),
            //                         child: const Center(
            //                             child: Text(
            //                           "No",
            //                           style: TextStyle(
            //                               color: Colors.grey,
            //                               fontFamily: 'Montserrat',
            //                               fontWeight: FontWeight.bold),
            //                         )),
            //                       ),
            //                       // child: Container(
            //                       //   margin: EdgeInsets.only(
            //                       //       top: 20, left: 10, right: 0),
            //                       //   height: 30,
            //                       //   decoration: BoxDecoration(
            //                       //       borderRadius:
            //                       //           BorderRadius.circular(5),
            //                       //       border: Border.all(
            //                       //           color: HexColor(
            //                       //               Colorscommon.greycolor))),
            //                       //   child: Center(
            //                       //       child: Text(
            //                       //     "No",
            //                       //     style: TextStyle(
            //                       //         color: HexColor(
            //                       //             Colorscommon.greycolor),
            //                       //         fontFamily: 'Lato',
            //                       //         fontWeight: FontWeight.bold),
            //                       //   )),
            //                       // ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           );
            //         });
            //   },
            //   // onTap: () {
            //   //   // Navigator.of(context).pushAndRemoveUntil(
            //   //   //     MaterialPageRoute(builder: (context) => Login()),
            //   //   //     (Route<dynamic> route) => false);
            //   // },
            //   child: Card(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10), // if you need this
            //       side: BorderSide(
            //         color: Colors.grey.withOpacity(0.5),
            //         width: 1,
            //       ),
            //     ),
            //     elevation: 3,
            //     margin: const EdgeInsets.all(10),
            //     child: Container(
            //       padding: const EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //           borderRadius: const BorderRadius.all(Radius.circular(10)),
            //           gradient: LinearGradient(colors: [
            //             HexColor(Colorscommon.whitecolor),
            //             HexColor(Colorscommon.whitelite)
            //           ])),
            //       child: Row(
            //         children: [
            //           Icon(
            //             Icons.logout,
            //             color: HexColor(Colorscommon.greencolor),
            //           ),
            //           Container(
            //             margin: const EdgeInsets.all(10),
            //             child: Text(
            //               'Logout',
            //               style: TextStyle(
            //                   fontFamily: 'TomaSans-Regular',
            //                   fontWeight: FontWeight.bold,
            //                   color: HexColor(Colorscommon.greycolor)),
            //             ),
            //           ),
            //           // Expanded(
            //           //   child: Align(
            //           //       alignment: Alignment.centerRight,
            //           //       child: Image.asset(
            //           //         'assets/forward.png',
            //           //         width: 15,
            //           //       )),
            //           // ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10), // if you need this
            //     side: BorderSide(
            //       color: Colors.grey.withOpacity(0.5),
            //       width: 1,
            //     ),
            //   ),
            //   elevation: 3,
            //   margin: const EdgeInsets.all(10),
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //         borderRadius: const BorderRadius.all(Radius.circular(10)),
            //         gradient: LinearGradient(colors: [
            //           HexColor(Colorscommon.whitecolor),
            //           HexColor(Colorscommon.whitelite)
            //         ])),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           'Use Biometric',
            //           style: TextStyle(
            //               fontFamily: 'Lato',
            //               color: HexColor(Colorscommon.greycolor)),
            //         ),
            //         CupertinoSwitch(
            //           activeColor: HexColor(Colorscommon.greencolor),
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
          // body: Builder(builder: (context) {
          //   return WebView(
          //     initialUrl: widget.loadURL,
          //     // initialUrl: 'https://project-lithium--epuat.my.salesforce.com/',
          //     // initialUrl:
          //     //     "https://project-lithium--epuat.my.salesforce.com/services/auth/sso/SP_App_Mapping_v1?startURL=%2F",
          //     javascriptMode: JavascriptMode.unrestricted,
          //     // javascriptChannels: <JavascriptChannel>{
          //     //   JavascriptChannel(
          //     //     name: 'messageHandler',
          //     //     onMessageReceived: (JavascriptMessage message) {
          //     //       print("message from the web view=\"${message.message}\"");
          //     //       print(message.message);
          //     //       Map valueMap = json.decode(message.message);
          //     //       String mapstr = valueMap["login"];
          //     //       String uuidserver = valueMap["uuid"];
          //     //       String serverstate = valueMap["state"];
          //     //       print("uuidserver$uuidserver");
          //     //       print("serverstate$serverstate");
          //     //       // String mapstr = valueMap["uuid"];
          //     //       print("mapstr$mapstr");
          //     //       if (mapstr == "login") {
          //     //         sessionManager.setuuid(uuidserver).then((value) => {});
          //     //         sessionManager.setserverstate(serverstate).then((value) =>
          //     //             {
          //     //               Navigator.push(
          //     //                   context,
          //     //                   MaterialPageRoute(
          //     //                       builder: (context) => const Login()))
          //     //             });
          //     //       } else {
          //     //         // getuserdetailsbuuuid(uuidserver);
          //     //       }
          //     //     },
          //     //   )
          //     // },

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
          //       if (url ==
          //           "https://project-lithium--epuat.my.salesforce.com/") {
          //         final SharedPreferences pref =
          //             await SharedPreferences.getInstance();
          //         String id = pref.getString("userid") ?? "";
          //         String accesstoken = pref.getString("accesstokken") ?? "";
          //         String email = pref.getString("email_id") ?? "";
          //         logoutapi(id, accesstoken, email);
          //       }

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

  void selectlanguagepopup(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Bouncing(
                    onPress: (() {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
                    child: Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.clear,
                        color: HexColor(Colorscommon.greydark),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle(
                        fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                AppLocalizations.of(context)!.id == "आयडी" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ")
                            ? 12
                            : 18,
                        color: HexColor(Colorscommon.greendark)),
                  ),
                ],
              ),
              // LanguagePickerWidget(
              //   fontsizeprefeerd: 15,
              // ),
            ],
          ),
          content: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.language_sharp),
                SizedBox(
                  width: 10,
                ),
                LanguagePickerWidget(
                  fontsizeprefeerd: 15,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 0),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: HexColor(Colorscommon.greenlight2),
                            )),
                        child: Center(
                            child: Text(
                          "Ok",
                          style: TextStyle(
                              color: HexColor(Colorscommon.greenlight2),
                              fontSize: 13,
                              fontFamily: 'AvenirLTStd-Black',
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void qrGenerate(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Bouncing(
                    onPress: (() {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
                    child: Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.clear,
                        color: HexColor(Colorscommon.greydark),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.qRcode,
                    style: TextStyle(
                        fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                AppLocalizations.of(context)!.id == "आयडी" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ")
                            ? 12
                            : 14,
                        color: HexColor(Colorscommon.greendark)),
                  ),
                ],
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: QrImageView(
              data: "User : $username",
              size: 100,
              // embeddedImage: const AssetImage('assets/logo.png'),
              embeddedImageStyle:
                  QrEmbeddedImageStyle(size: const Size(80, 80)),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 0),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: HexColor(Colorscommon.greenlight2),
                            )),
                        child: Center(
                            child: Text(
                          "Ok",
                          style: TextStyle(
                              color: HexColor(Colorscommon.greenlight2),
                              fontSize: 13,
                              fontFamily: 'AvenirLTStd-Black',
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String id = pref.getString("userid") ?? "";
    String accesstoken = pref.getString("accesstokken") ?? "";
    String email = pref.getString("email_id") ?? "";
    print("id$id");
    print("accesstoken$accesstoken");
    print("email$email");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Bouncing(
                    onPress: (() {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
                    child: Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.clear,
                        color: HexColor(Colorscommon.greydark),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.logout + " ?",
                    style: TextStyle(
                        fontSize: 15, color: HexColor(Colorscommon.greendark)),
                  ),
                ],
              ),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.areyousureyouwanttologout,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: HexColor(Colorscommon.greydark2),
                fontFamily: "AvenirLTStd-Book",
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.logoutsuccessfully,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));

                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   const Login();
                        // }));
                        // Navigator.push(
                        //     context, const MaterialPagebuilder: (context) => Login());
                        // //                Navigator.pushNamedAndRemoveUntil(
                        // , MaterialPageRoute(builder: (context) => const Login()));
                        // logoutapi(id, accesstoken, email);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 0),
                        padding: const EdgeInsets.all(5),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(colors: [
                              HexColor(Colorscommon.greenlight2),
                              HexColor(Colorscommon.greenlight2),
                            ])),
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)!.logout,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'AvenirLTStd-Black',
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 0),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: HexColor(Colorscommon.greenlight2),
                            )),
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                              color: HexColor(Colorscommon.greenlight2),
                              fontSize: 13,
                              fontFamily: 'AvenirLTStd-Black',
                              fontWeight: FontWeight.w500),
                          // style: TextStyle(
                          //     color: HexColor(Colorscommon.greenlight2),
                          //     fontFamily: 'Lato',
                          //     fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  setdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('fprint', _fingerValue);
      if (_fingerValue) {
        prefs.setString('Fingershow', "1234");
      } else {
        prefs.setString('Fingershow', "134");
      }

      print('set-fp = $_fingerValue');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Login()));
    });
  }

  Getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fingerValue = prefs.getBool('fprint') ?? false;

    _fingerValuestr = prefs.getString('Fingershow');
    print("_fingerValuestr$_fingerValuestr");
    // _biometricbool = prefs.getBool('biometric') ?? false;

    print('get-fp = $_fingerValue');
    setState(() {});
  }
}

///new code design for sp app
///
// ///
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class settings extends StatefulWidget {
//   const settings({Key? key}) : super(key: key);

//   @override
//   State<settings> createState() => _settingsState();
// }

// class _settingsState extends State<settings> {
//   bool _fingerValue = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Settings',
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: const Color(0xff268D79),
//           elevation: 0,
//           leading: const BackButton(color: Colors.white),
//         ),
//         body: Column(children: [
//           ClipPath(
//             clipper: RoundShape(),
//             child: Container(
//               height: 50,
//               color: const Color(0xff268D79),
//             ),
//           ),
//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 getProfileView(),
//                 Container(
//                   margin: const EdgeInsets.only(left: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'Aravind S',
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         'aravind@gmail.com',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.keyboard_arrow_right,
//                         color: Color(0xff268D79)))
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height / 3,
//               width: MediaQuery.of(context).size.width - 40,
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0)),
//                 child: ListView(
//                   children: [
//                     ListTile(
//                       leading: const Icon(
//                         Icons.lock_outline,
//                         color: Color(0xff268D79),
//                       ),
//                       title: const Text('Change Password'),
//                       trailing: const Icon(Icons.keyboard_arrow_right,
//                           color: Color(0xff268D79)),
//                       onTap: () {},
//                     ),
//                     const Divider(),
//                     ListTile(
//                       leading: const Icon(
//                         Icons.notifications,
//                         color: Color(0xff268D79),
//                       ),
//                       title: const Text('Notification'),
//                       trailing: const Icon(Icons.keyboard_arrow_right,
//                           color: Color(0xff268D79)),
//                       onTap: () {},
//                     ),
//                     const Divider(),
//                     ListTile(
//                       leading: const Icon(
//                         Icons.fingerprint,
//                         color: Color(0xff268D79),
//                       ),
//                       title: const Text('Use Biometric'),
//                       trailing: CupertinoSwitch(
//                         activeColor: const Color(0xff268D79),
//                         value: _fingerValue,
//                         onChanged: (bool value) {
//                           setState(() {
//                             _fingerValue = value;
//                             // setdata();
//                           });
//                         },
//                       ),
//                       onTap: () {},
//                     ),
//                     const Divider(),
//                     ListTile(
//                       leading: const Icon(
//                         Icons.logout,
//                         color: Color(0xff268D79),
//                       ),
//                       title: const Text('Logout'),
//                       trailing: const Icon(Icons.keyboard_arrow_right,
//                           color: Color(0xff268D79)),
//                       onTap: () {
//                         _showDialog(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ]));
//   }
// }

// void _showDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: const Center(
//             child: Text(
//           "Logout?",
//           style: TextStyle(color: Color(0xff268D79)),
//         )),
//         content: const Text(
//           "Are you sure you want to logout?",
//           style: TextStyle(color: Colors.grey),
//         ),
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: GestureDetector(
//                     onTap: () {},
//                     child: Container(
//                       margin:
//                           const EdgeInsets.only(top: 10, left: 10, right: 0),
//                       padding: const EdgeInsets.all(5),
//                       height: 30,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           gradient: const LinearGradient(
//                               colors: [Color(0xff268D79), Color(0xff268D79)])),
//                       child: const Center(
//                           child: Text(
//                         "Log Out",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'Lato',
//                             fontWeight: FontWeight.bold),
//                       )),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context, rootNavigator: true).pop();
//                     },
//                     child: Container(
//                       margin:
//                           const EdgeInsets.only(top: 10, left: 10, right: 0),
//                       height: 30,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           border: Border.all(color: const Color(0xff268D79))),
//                       child: const Center(
//                           child: Text(
//                         "Cancel",
//                         style: TextStyle(
//                             color: Color(0xff268D79),
//                             fontFamily: 'Lato',
//                             fontWeight: FontWeight.bold),
//                       )),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

// Widget getProfileView() {
//   return Stack(
//     children: const <Widget>[
//       CircleAvatar(
//         radius: 35,
//         backgroundColor: Color(0xff268D79),
//         child: Icon(Icons.person_outline_rounded),
//       ),
// /*
//       Positioned(
//           bottom: 1,
//           right: 1,
//           child: Container(
//             height: 30,
//             width: 30,
//             child: const Icon(
//               Icons.edit,
//               color: Colors.deepPurple,
//               size: 20,
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.amber.shade200,
//                 borderRadius: const BorderRadius.all(Radius.circular(20))),
//           ))
// */
//     ],
//   );
// }

// class RoundShape extends CustomClipper<Path> {
//   @override
//   getClip(Size size) {
//     double height = size.height;
//     double width = size.width;
//     double curveHeight = size.height / 2;
//     var p = Path();
//     p.lineTo(0, height - curveHeight);
//     p.quadraticBezierTo(width / 2, height, width, height - curveHeight);
//     p.lineTo(width, 0);
//     p.close();
//     return p;
//   }

//   @override
//   bool shouldReclip(CustomClipper oldClipper) => true;
// }

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

Widget getProfileView() {
  return Stack(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: HexColor(Colorscommon.greenApp2color),
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          radius: 35,
          backgroundColor: HexColor(Colorscommon.greenApp2color),
          child: const Icon(Icons.person_outline_rounded),
        ),
      ),
/*
      Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            height: 30,
            width: 30,
            child: const Icon(
              Icons.edit,
              color: Colors.deepPurple,
              size: 20,
            ),
            decoration: BoxDecoration(
                color: Colors.amber.shade200,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
          ))
*/
    ],
  );
}


// Row(
// children: [
// // Expanded(
// //   flex: 1,
// //   child: Avenirtextmedium(
// //     customfontweight: FontWeight.w500,
// //     fontsize: 14,
// //     text: "Vehicle No",
// //     textcolor: HexColor(Colorscommon.greendark),
// //   ),
// // ),
// Expanded(
// flex: 3,
// child: Container(
// padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
// decoration: BoxDecoration(
// color: Colors.white,
// border: Border.all(color: Colors.grey),
// borderRadius: BorderRadius.circular(8),
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.2),
// spreadRadius: 2,
// blurRadius: 4,
// offset: Offset(0, 2),
// ),
// ],
// ),
// child: isLoading
// ? Center(
// child: CircularProgressIndicator(),
// )
//     : isVehicleNoSelected
// ? Row(
// children: [
// Expanded(
// child: Text(
// selectedVehicleNo ?? '',
// style: TextStyle(
// fontSize: 14,
// color: Colors.black,
// ),
// ),
// ),
// ],
// )
//     : Row(
// children: [
// Expanded(
// child: DropdownButtonHideUnderline(
// child: DropdownButton2<String>(
// isExpanded: true,
// hint: Text(
// 'Vehicle No',
// style: TextStyle(
// fontSize: 14,
// color: Theme.of(context).hintColor,
// ),
// ),
// items: vehicleNoData
//     .map((vehicle) => DropdownMenuItem<String>(
// value: vehicle['vehiclenumber']
//     .toString(),
// child: Text(
// vehicle['vehiclenumber'].toString(),
// style: const TextStyle(
// fontSize: 14,
// ),
// ),
// ))
//     .toList(),
// value: selectedVehicleNo,
// onChanged: (value) {
// setState(() {
// selectedVehicleNo = value;
// showStartSocRow = true;
// isVehicleNoSelected = true;
// showQRScannerButton = false; // Hide QR scanner button after selection
// });
// saveDraft();
// },
// buttonStyleData: const ButtonStyleData(
// padding: EdgeInsets.symmetric(horizontal: 16),
// height: 40,
// width: 200,
// ),
// dropdownStyleData: const DropdownStyleData(
// maxHeight: 200,
// ),
// menuItemStyleData: const MenuItemStyleData(
// height: 40,
// ),
// dropdownSearchData: DropdownSearchData(
// searchController: textEditingController,
// searchInnerWidgetHeight: 50,
// searchInnerWidget: Container(
// height: 50,
// padding: const EdgeInsets.only(
// top: 8,
// bottom: 4,
// right: 8,
// left: 8,
// ),
// child: TextFormField(
// expands: true,
// maxLines: null,
// controller: textEditingController,
// decoration: InputDecoration(
// isDense: true,
// contentPadding: const EdgeInsets.symmetric(
// horizontal: 10,
// vertical: 8,
// ),
// hintText: 'Search for a vehicle...',
// hintStyle: const TextStyle(fontSize: 12),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(8),
// ),
// ),
// ),
// ),
// searchMatchFn: (item, searchValue) {
// return item.value
//     .toString()
//     .toLowerCase()
//     .contains(searchValue.toLowerCase());
// },
// ),
// onMenuStateChange: (isOpen) {
// if (!isOpen) {
// textEditingController.clear();
// }
// },
// ),
// ),
// ),
// if (isOnline)
// IconButton(
// icon: Icon(Icons.refresh),
// onPressed: fetchVehicleNumbers,
// ),
// if (showQRScannerButton)
// IconButton(
// icon: Icon(Icons.qr_code_scanner),
// onPressed: () async {
// var qrValue = await showDialog<String>(
// context: context,
// builder: (BuildContext context) {
// return QrDialog(
// textfieldEditingController: textEditingController,
// dialogContext: context,
// );
// },
// );
//
// if (qrValue != null && qrValue.isNotEmpty) {
// // Define the regex pattern for car numbers (adjust the pattern as needed)
// final RegExp carNumberRegex = RegExp(r'^[A-Z]{2}\d{2}[A-Z]{1,2}\d{1,4}$');
//
// if (carNumberRegex.hasMatch(qrValue)) {
// setState(() {
// selectedVehicleNo = qrValue;
// isVehicleNoSelected = true;
// showStartSocRow = true;
// showQRScannerButton = false; // Hide QR scanner button after selection
// });
// saveDraft();
// } else {
// Fluttertoast.showToast(
// msg: "Invalid car number format. Please scan a valid car number.",
// toastLength: Toast.LENGTH_SHORT,
// gravity: ToastGravity.BOTTOM,
// timeInSecForIosWeb: 1,
// backgroundColor: Colors.red,
// textColor: Colors.white,
// fontSize: 16.0,
// );
// }
// }
// },
// ),
// ],
// ),
// ),
// ),
// ],
// ),