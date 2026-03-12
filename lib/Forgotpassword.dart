import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/Login.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';

class ForgotPasswordClass extends StatefulWidget {
  @override
  ForgotPassword_ createState() => ForgotPassword_();

  String text;
  String id_driver = "";

  ForgotPasswordClass({
    Key? key,
    required this.text,
    required this.id_driver,
  }) : super(key: key);
}

class ForgotPassword_ extends State<ForgotPasswordClass> {
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  late BuildContext dialogContext;
  bool hasError = false;
  bool isverified = false;
  String currentText = "";
  String mobilenumber = "";
  SessionManager sessionManager = SessionManager();
  String Lithiumid = "";
  final bool _fingerValue = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CommonAppbar(
          title: AppLocalizations.of(context)!.forgot_Password,
          appBar: AppBar(),
          widgets: const [],
        ),
      ),
      // appBar: AppBar(
      //   title: Text(
      //     'Forgot Password',
      //     style: TextStyle(fontFamily: "Lato"),
      //   ),
      //   backgroundColor: HexColor(Colorscommon.greencolor),
      // ),

      body: Container(
        color: HexColor(Colorscommon.backgroundcolor),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Avenirtextblack(
                text: AppLocalizations.of(context)!.phonenumberverify,
                fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                    ? 14
                    : 17,
                textcolor: HexColor(Colorscommon.greydark2),
                customfontweight: FontWeight.bold),
            // const Text(
            //   'Phone Number Verification',
            //   sty
            //   // style: TextStyle(
            //   //     fontSize: 18,
            //   //     color:,
            //   //     fontFamily: 'TomaSans-Regular',
            //   //     fontWeight: FontWeight.bold),
            // ),
            const SizedBox(
              height: 10,
            ),
            Avenirtextbook(
                // text: 'Enter the code sent to ' + widget.text,
                text:
                    AppLocalizations.of(context)!.entercode + " " + widget.text,
                fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                    ? 14
                    : 14,
                textcolor: HexColor(Colorscommon.greydark2),
                customfontweight: FontWeight.normal),
            // Text(

            //   style: const TextStyle(
            //     fontSize: 13,
            //     color: Colors.black54,
            //     fontFamily: 'TomaSans-Regular',
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            PinCodeTextField(
                keyboardType: TextInputType.number,
                appContext: context,
                length: 5,
                onChanged: (onChanged) {
                  print('valuee' + onChanged);
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveColor: Colors.grey,
                  disabledColor: Colors.black54,
                  activeColor: HexColor(Colorscommon.greencolor),
                  activeFillColor: hasError ? Colors.green : Colors.green,
                ),
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                onCompleted: (value) {
                  print('valuee' + value);

                  setState(() {
                    currentText = value;
                  });
                }),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 0, right: 0),
              decoration: const BoxDecoration(
                  // border: Border(bottom: BorderSide(color: Colors.grey))
                  ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: HexColor(Colorscommon.greencolor)),
                child: TextField(
                  controller: newpasswordcontroller,
                  obscureText: true,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'AvenirLTStd-Book',
                    fontSize: 14,
                    // fontWeight: FontWeight.w300,
                    color: HexColor(Colorscommon.greydark2),
                  ),
                  // controller: passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Enter New Password",
                    labelStyle: TextStyle(
                      fontFamily: 'AvenirLTStd-Book',
                      // fontWeight: FontWeight.w300,
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
                data: Theme.of(context)
                    .copyWith(primaryColor: HexColor(Colorscommon.greencolor)),
                child: TextField(
                  controller: confirmpasswordcontroller,
                  obscureText: true,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'AvenirLTStd-Book',
                    // fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: HexColor(Colorscommon.greydark2),
                  ),
                  // controller: passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Confirm New Password",
                    labelStyle: TextStyle(
                      fontFamily: 'AvenirLTStd-Book',
                      // fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: HexColor(Colorscommon.greydark2),
                    ),
                  ),
                ),
              ),
            ),
            Bouncing(
              onPress: () {
                ValidateInputs();
              },
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(13),
                  margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(colors: [
                        HexColor(Colorscommon.greenlight2),
                        HexColor(Colorscommon.greenlight2),
                      ])),
                  child: Center(
                    child: Avenirtextblack(
                        text: AppLocalizations.of(context)!.confirm,
                        fontsize: 14,
                        textcolor: Colors.white,
                        customfontweight: FontWeight.bold),
                    //     child: Text(
                    //   "Confirm",
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontFamily: 'TomaSans-Lato',
                    //       fontSize: 17,
                    //       fontWeight: FontWeight.bold),
                    // )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future setData() async {
  //   Future<String> LithiumID_s = sessionManager.GetLithiumID();
  //   LithiumID_s.then((value) {
  //     Lithiumid = value.toString();
  //     print('Settingspage' + Lithiumid);
  //   });

  //   // Future<String> Id_driver = sessionManager.GetId_driver();
  //   // Id_driver.then((value) {
  //   //   id_driver = value.toString();
  //   //   print('Settingspage' + id_driver);
  //   //
  //   //   sessionManager.internetcheck().then((intenet) async {
  //   //     if (intenet != null && intenet) {
  //   //     } else {
  //   //       Fluttertoast.showToast(
  //   //         msg: "Please check internet connection!!" + " !!",
  //   //         toastLength: Toast.LENGTH_SHORT,
  //   //         gravity: ToastGravity.CENTER,
  //   //       );
  //   //     }
  //   //   });
  //   // });
  // }

  @override
  void initState() {
    ///setData();
  }

  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
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

  ValidateInputs() {
    if (currentText.isNotEmpty) {
      if (newpasswordcontroller.text.isNotEmpty) {
        if (confirmpasswordcontroller.text.isNotEmpty) {
          if (newpasswordcontroller.text == confirmpasswordcontroller.text) {
            ForgotpasswordAPI();
          } else {
            Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.passwordnotmatch,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.pleaseenterconfirmpassword + " ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.pleaseenternewpassword + " ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.pleaseentervaildotp + " ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  // ValidateInputs() {
  //   if (currentText.isNotEmpty) {
  //     if (newpasswordcontroller.text.isNotEmpty) {
  //       if (confirmpasswordcontroller.text.isNotEmpty) {
  //         if (newpasswordcontroller.text == confirmpasswordcontroller.text) {
  //           ForgotpasswordAPI();
  //         } else {
  //           Fluttertoast.showToast(
  //             msg: "New Password & Confirm Password Doesn't Match ",
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.CENTER,
  //           );
  //         }
  //       } else {
  //         Fluttertoast.showToast(
  //           msg: "Please Enter Confirm Password" " ",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //         );
  //       }
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: "Please Enter New Password" " ",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: "Please Enter Valid OTP" " ",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //     );
  //   }
  // }

  setdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('fprint', _fingerValue);

      prefs.setString('lithiumid', "");
      print('set-fp = $_fingerValue');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Login()));
    });
  }

  void ForgotpasswordAPI() async {
    String url = CommonURL.URL;
    print(widget.id_driver);

    loading();
    Map<String, String> postdata = {
      "from": "driversForgotPassword",
      "newPassword": newpasswordcontroller.text,
      "confirmPassword": confirmpasswordcontroller.text,
      "id_user": widget.id_driver == "null" ? "" : widget.id_driver,
      "verificationCode": currentText,
      "languageType" : AppLocalizations.of(context)!.languagecode.toString(),
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

    // debugPrint('Passwordchnageresponse $response.statusCode');

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      // debugPrint('Passwordchnageresponse $jsonInput');

      String success = jsonInput['success'].toString();
      String message = jsonInput['message'];
      debugPrint('Location_success $success');
      debugPrint('Location_message $message');

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      Navigator.pop(dialogContext);

      if (success == '1') {
        Codec<String, String> stringToBase64 = utf8.fuse(base64);

        String encoded = stringToBase64.encode(newpasswordcontroller.text);
        debugPrint("newpassword " + encoded);
        setdata();
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const Login(),
        //     ));
        // return Future.value(true);
      }
    } else {
      debugPrint('SERVER=FAILED');
      Navigator.pop(dialogContext);
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.somethingwentwrong + " ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}
