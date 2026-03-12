import 'dart:convert';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:math' as math;
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../l10n/app_localizations.dart';

class Extratriplist extends StatefulWidget {
  const Extratriplist({Key? key}) : super(key: key);

  @override
  State<Extratriplist> createState() => _ExtratriplistState();
}

class _ExtratriplistState extends State<Extratriplist> {
  bool isdata = false;
  bool isloading = true;
  Utility utility = Utility();
  List Extratriplistarray = [];
  var spusername = "";
  @override
  void initState() {
    super.initState();
    utility.GetUserdata().then((value) => {
          sessionManager.internetcheck().then((intenet) async {
            if (intenet) {
              //utility.showYourpopupinternetstatus(context);
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
              //});
            }
          }),
          spusername = utility.mobileuser,
          getExtratriplistlist(),
        });
  }

  @override
  void dispose() {
    super.dispose();
  }



  Future<void> getExtratriplistlist() async {
    print("Sending request to fetch extra trip list...");

    var url = Uri.parse(CommonURL.localone);
    print("URL: $url");

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    // Create a JSON-encoded string for the data field
    String dataJson = jsonEncode([
      {
        //"lithiumID": utility.lithiumid,
        "service_provider": utility.service_provider_c
      }
    ]);

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(headers)
      ..fields['from'] = "getExtraTripList"
      ..fields['data'] = dataJson
      ..fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      print("getExtratriplistlist status code = ${response.statusCode}");
      print("getExtratriplistlist response body = ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);

        String status = jsonInput['status'].toString();
        String message = jsonInput['message'];
        isloading = false;

        if (status == 'true') {
          List array = jsonInput['data'];

          if (array.isNotEmpty) {
            isdata = true;
            Extratriplistarray = array;
          }

          setState(() {});

        } else {
          // Handle the case where status is not true
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

    setState(() {});
  }


  // getExtratriplistlist() async {
  //   print("texttgjhgjhehk");
  //
  //   var url = Uri.parse(CommonURL.herokuurl);
  //   // String url = CommonURL.URL;
  //
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //   // var uri = Uri.parse(url);
  //   print(utility.lithiumid);
  //   print(utility.service_provider_c);
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "getExtraTripList";
  //
  //   request.fields['lithiumID'] = utility.lithiumid;
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //   request.fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();
  //
  //   // request.files.add(await http.MultipartFile.fromPath('file', _image.path));
  //
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     print("grievancelist$jsonInput");
  //
  //     String status = jsonInput['status'].toString();
  //     String message = jsonInput['message'];
  //     isloading = false;
  //     if (status == 'true') {
  //       List array = jsonInput['data'];
  //
  //       if (array.isNotEmpty) {
  //         isdata = true;
  //         Extratriplistarray = array;
  //         // if (jsonInput['data'].length.isNotempty) {
  //         // print(jsonInput['data']);
  //         // for (int i = 0; i < jsonInput['data'].length; i++) {
  //         //   // print(jsonInput['data'][i]);
  //         //   reasonnamearray.add(array[i]['reason'].toString());
  //         //   reasonidarray.add(array[i]["id"].toString());
  //         // }
  //         // }
  //       }
  //
  //       setState(() {});
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
  //       // Fluttertoast.showToast(
  //       //   msg: message,
  //       //   toastLength: Toast.LENGTH_SHORT,
  //       //   gravity: ToastGravity.CENTER,
  //       // );
  //     }
  //   } else {}
  //   // Navigator.pop(context);
  //   setState(() {});
  // }

  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // dialogContext = context;
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            // ignore: unnecessary_new
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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

  applycancel(String eosid) async {
    // String url = CommonURL.BASE_URL;
    loading();
    var url = Uri.parse(CommonURL.URL);
    Map<String, String> postdata = {
      "from": "eosCancelStatusUpdate",
      "idUser": utility.userid,
      "idEOS": eosid,
    };
    // print(postdata.toString());
    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(url,
        body: jsonEncode(postdata), headers: requestHeaders);

    // //print("${response.statusCode}");
    // print("${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("applycancel$jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (status == 'true') {
        setState(() {});
        // reasonnamearray
        //        final String lithiumid = "lithiumid";
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
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        // updatefcmtoken(lithiumId, callbackURL, uuid);

      } else {
        // Navigator.pop(context);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
    Navigator.pop(context);
    Navigator.pop(context);
    getExtratriplistlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CommonAppbar(
          title: AppLocalizations.of(context)!.extra_hours_List,
          appBar: AppBar(),
          widgets: const [],
        ),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        color: HexColor(Colorscommon.backgroundcolor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Visibility(
              visible: isloading,
              child: CircularProgressIndicator(
                color: HexColor(Colorscommon.greencolor),
              ),
            ),
            Center(
              child: Visibility(
                  visible: !isdata,
                  child: Visibility(
                    visible: !isloading,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: const Center(
                              child: Text("No Data Available"))),
                    ),
                  )),
            ),
            // Visibility(
            //   visible: isdata,
            //   child: Expanded(
            //     // Use ListView.builder

            //     child: ListView.builder(
            //         shrinkWrap: true,
            //         // the number of items in the list
            //         physics: const BouncingScrollPhysics(),
            //         itemCount: Extratriplistarray.length,

            //         // display each item of the product list
            //         itemBuilder: (context, index) {
            //           //debugPrint('Indexvalue' + index.toString());
            //           // debugPrint('modellength' +
            //           //     permissionModel.detail.length.toString());

            //           return Card(
            //             margin: const EdgeInsets.all(10),
            //             shape: RoundedRectangleBorder(
            //               borderRadius:
            //                   BorderRadius.circular(10), // if you need this
            //               side: BorderSide(
            //                 color: Colors.grey.withOpacity(0.5),
            //                 width: 1,
            //               ),
            //             ),
            //             elevation: 3,
            //             // In many cases, the key isn't mandatory
            //             key: UniqueKey(),
            //             child: Container(
            //               padding: const EdgeInsets.all(10),
            //               child: Column(
            //                 children: [
            //                   Row(
            //                     // ignore: prefer_const_literals_to_create_immutables
            //                     children: [
            //                       const Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: "GrievanceDate",
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: Extratriplistarray[index]
            //                                   ['grievanceDate']
            //                               .toString(),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     // ignore: prefer_const_literals_to_create_immutables
            //                     children: [
            //                       const Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: "Description",
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: Container(
            //                           padding: const EdgeInsets.all(2),
            //                           // decoration: BoxDecoration(
            //                           //     border: Border.all(
            //                           //         color: Colors.grey.shade200)),
            //                           child: CommonText(
            //                             text: Extratriplistarray[index]
            //                                     ['Description']
            //                                 .toString(),
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     // ignore: prefer_const_literals_to_create_immutables
            //                     children: [
            //                       const Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: "TAT(Days)",
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: Extratriplistarray[index]['TAT']
            //                               .toString(),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     // ignore: prefer_const_literals_to_create_immutables
            //                     children: [
            //                       const Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: "PersonResponsible",
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: Extratriplistarray[index]
            //                                   ['personResponsible']
            //                               .toString(),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     // ignore: prefer_const_literals_to_create_immutables
            //                     children: [
            //                       const Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: "Status",
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: CommonText(
            //                           text: Extratriplistarray[index]
            //                                   ['grievanceStatus']
            //                               .toString(),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     // ignore: prefer_const_literals_to_create_immutables
            //                     mainAxisAlignment: MainAxisAlignment.end,
            //                     children: [
            //                       Bouncing(
            //                         onPress: () {
            //                           var url = Extratriplistarray[index]
            //                                   ['viewAttachment']
            //                               .toString();
            //                           showDialog(
            //                             context: context,
            //                             barrierDismissible: false,
            //                             builder: (BuildContext context) {
            //                               // dialogContext = context;
            //                               return Dialog(
            //                                 child: Padding(
            //                                   padding: const EdgeInsets.all(0),

            //                                   child: SizedBox(
            //                                     height: MediaQuery.of(context)
            //                                             .size
            //                                             .height /
            //                                         3.9,
            //                                     width: MediaQuery.of(context)
            //                                         .size
            //                                         .width,
            //                                     child: Column(children: [
            //                                       Image.network(url),
            //                                       Bouncing(
            //                                           child: Container(
            //                                             width: 100,
            //                                             padding:
            //                                                 const EdgeInsets
            //                                                     .all(5),
            //                                             height: 35,
            //                                             decoration:
            //                                                 BoxDecoration(
            //                                                     borderRadius:
            //                                                         BorderRadius
            //                                                             .circular(
            //                                                                 5),
            //                                                     gradient:
            //                                                         LinearGradient(
            //                                                             colors: [
            //                                                           HexColor(
            //                                                               Colorscommon
            //                                                                   .greencolor),
            //                                                           HexColor(
            //                                                               Colorscommon
            //                                                                   .greencolor),
            //                                                         ])),
            //                                             child: const Center(
            //                                                 child: Text(
            //                                               "Close",
            //                                               style: TextStyle(
            //                                                   color:
            //                                                       Colors.white,
            //                                                   fontFamily:
            //                                                       'Lato',
            //                                                   fontWeight:
            //                                                       FontWeight
            //                                                           .bold),
            //                                             )),
            //                                           ),
            //                                           onPress: () {
            //                                             Navigator.pop(context);
            //                                           })
            //                                     ]),
            //                                   ),
            //                                   // ),
            //                                 ),
            //                               );
            //                             },
            //                           );
            //                         },
            //                         child: Container(
            //                           width: 150,
            //                           margin: const EdgeInsets.only(
            //                               top: 10, left: 10, right: 0),
            //                           padding: const EdgeInsets.all(5),
            //                           height: 35,
            //                           decoration: BoxDecoration(
            //                               borderRadius:
            //                                   BorderRadius.circular(5),
            //                               gradient: LinearGradient(colors: [
            //                                 HexColor(Colorscommon.greencolor),
            //                                 HexColor(Colorscommon.greencolor),
            //                               ])),
            //                           child: const Center(
            //                               child: Text(
            //                             "ViewAttachment",
            //                             style: TextStyle(
            //                                 color: Colors.white,
            //                                 fontFamily: 'Lato',
            //                                 fontWeight: FontWeight.bold),
            //                           )),
            //                         ),
            //                       ),
            //                       // Expanded(
            //                       //   flex: 1,
            //                       //   child: CommonText(
            //                       //     text: Extratriplistarray[index]
            //                       //             ['viewAttachment']
            //                       //         .toString(),
            //                       //   ),
            //                       // ),
            //                     ],
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           );
            //         }),
            //   ),
            // ),
            Visibility(
              visible: !isloading,
              child: Visibility(
                visible: isdata,
                child: Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      // the number of items in the list
                      physics: const BouncingScrollPhysics(),
                      itemCount: Extratriplistarray.length,

                      // display each item of the product list
                      itemBuilder: (context, index) {
                        //debugPrint('Indexvalue' + index.toString());
                        // debugPrint('modellength' +
                        //     permissionModel.detail.length.toString());

                        return Card(
                          margin: const EdgeInsets.all(10),
                          // shape: Border(
                          //     left: BorderSide(
                          //         color: Color((math.Random().nextDouble() *
                          //                     0xFFFFFF)
                          //                 .toInt())
                          //             .withOpacity(1.0),
                          //         width: 5)),
                         // margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: HexColor(Colorscommon.greencolor),
                              width: 1.1,
                            ),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.5),
                          // In many cases, the key isn't mandatory
                          key: UniqueKey(),
                          child:  Container(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white, // Solid background color
                              borderRadius: BorderRadius.circular(15), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // Soft shadow effect
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3), // Subtle border
                                width: 1,
                              ),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: 5,
                                        height: 250,
                                        decoration: BoxDecoration(
                                            color: Color((math.Random()
                                                            .nextDouble() *
                                                        0xFFFFFF)
                                                    .toInt())
                                                .withOpacity(1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 60,
                                    child: Column(
                                      children: [
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .name,
                                                  fontsize: (AppLocalizations
                                                                  .of(context)!
                                                              .id ==
                                                           "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                      ? 12
                                                      : (AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 15,
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                  customfontweight:
                                                      FontWeight.w500),
                                              // child: CommonText2(
                                              //   text: "Name",
                                              // ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Avenirtextbook(
                                                  text: spusername.toString(),
                                                  fontsize:
                                                      (AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon.greydark2),
                                                  customfontweight:
                                                      FontWeight.w500),
                                              // child: CommonText(
                                              //   text: Grievancelistarray[index]
                                              //           ['date__c']
                                              //       .toString(),
                                              // ),
                                            ),
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: CommonText(
                                            //     text: spusername,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .trip_Date,
                                                  fontsize:
                                                      (AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 15,
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                  customfontweight:
                                                      FontWeight.w500),
                                              // child: CommonText2(
                                              //   text: "Name",
                                              // ),
                                            ),
                                            // const Expanded(
                                            //   flex: 1,
                                            //   child: CommonText2(
                                            //     text: "Trip Date",
                                            //   ),
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: Avenirtextbook(
                                                  text: Extratriplistarray[index]['voucher_Date']
                                                                  .toString() ==
                                                              "null" ||
                                                          Extratriplistarray[index][
                                                                      'voucher_Date']
                                                                  .toString() ==
                                                              ""
                                                      ? "-"
                                                      : Extratriplistarray[index][
                                                              'voucher_Date']
                                                          .toString(),
                                                  fontsize:
                                                      (AppLocalizations.of(context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon.greydark2),
                                                  customfontweight: FontWeight.w500),
                                              // child: CommonText(
                                              //   text: Grievancelistarray[index]
                                              //           ['date__c']
                                              //       .toString(),
                                              // ),
                                            ),
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: CommonText(
                                            //     text: Extratriplistarray[index][
                                            //                         'voucher_date__c']
                                            //                     .toString() ==
                                            //                 "null" ||
                                            //             Extratriplistarray[
                                            //                             index][
                                            //                         'voucher_date__c']
                                            //                     .toString() ==
                                            //                 ""
                                            //         ? "-"
                                            //         : Extratriplistarray[index]
                                            //                 ['voucher_date__c']
                                            //             .toString(),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .trip_Id,
                                                  fontsize:
                                                      (AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 15,
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                  customfontweight:
                                                      FontWeight.w500),
                                              // child: CommonText2(
                                              //   text: "Name",
                                              // ),
                                            ),
                                            // const Expanded(
                                            //   flex: 1,
                                            //   child: CommonText2(
                                            //     text: "Trip Id",
                                            //   ),
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: Avenirtextbook(
                                                  text: Extratriplistarray[index]['trip_id']
                                                                  .toString() ==
                                                              "null" ||
                                                          Extratriplistarray[index]
                                                                      [
                                                                      'trip_id']
                                                                  .toString() ==
                                                              ""
                                                      ? "-"
                                                      : Extratriplistarray[index]
                                                              ['trip_id']
                                                          .toString(),
                                                  fontsize:
                                                      (AppLocalizations.of(context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon.greydark2),
                                                  customfontweight: FontWeight.w500),
                                              // child: CommonText(
                                              //   text: Grievancelistarray[index]
                                              //           ['date__c']
                                              //       .toString(),
                                              // ),
                                            ),
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: Container(
                                            //     padding:
                                            //         const EdgeInsets.all(2),

                                            //     // decoration: BoxDecoration(
                                            //     //     border: Border.all(
                                            //     //         color: Colors.grey.shade200)),
                                            //     child: CommonText(
                                            //       text: Extratriplistarray[
                                            //                               index]
                                            //                           [
                                            //                           'trip_id__c']
                                            //                       .toString() ==
                                            //                   "null" ||
                                            //               Extratriplistarray[
                                            //                               index]
                                            //                           [
                                            //                           'trip_id__c']
                                            //                       .toString() ==
                                            //                   ""
                                            //           ? "-"
                                            //           : Extratriplistarray[
                                            //                       index]
                                            //                   ['trip_id__c']
                                            //               .toString(),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .trip_StartTime,
                                                  fontsize:
                                                      (AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 15,
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                  customfontweight:
                                                      FontWeight.w500),
                                              // child: CommonText2(
                                              //   text: "Name",
                                              // ),
                                            ),
                                            // const Expanded(
                                            //   flex: 1,
                                            //   child: CommonText2(
                                            //     text: "Trip Start Time",
                                            //   ),
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: Avenirtextbook(
                                                  text: Extratriplistarray[index]['trip_start_time']
                                                                  .toString() ==
                                                              "null" ||
                                                          Extratriplistarray[index][
                                                                      'trip_start_time']
                                                                  .toString() ==
                                                              ""
                                                      ? "-"
                                                      : Extratriplistarray[index][
                                                              'trip_start_time']
                                                          .toString(),
                                                  fontsize:
                                                      (AppLocalizations.of(context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon.greydark2),
                                                  customfontweight: FontWeight.w500),
                                              // child: CommonText(
                                              //   text: Grievancelistarray[index]
                                              //           ['date__c']
                                              //       .toString(),
                                              // ),
                                            ),
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: CommonText(
                                            //     text: Extratriplistarray[index][
                                            //                         'trip_start_time__c']
                                            //                     .toString() ==
                                            //                 "null" ||
                                            //             Extratriplistarray[
                                            //                             index][
                                            //                         'trip_start_time__c']
                                            //                     .toString() ==
                                            //                 ""
                                            //         ? "-"
                                            //         : Extratriplistarray[index][
                                            //                 'trip_start_time__c']
                                            //             .toString(),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .trip_endtime,
                                                  fontsize:
                                                      (AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 15,
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                  customfontweight:
                                                      FontWeight.w500),
                                              // child: CommonText2(
                                              //   text: "Name",
                                              // ),
                                            ),
                                            // const Expanded(
                                            //   flex: 1,
                                            //   child: CommonText2(
                                            //     text: "Trip End Time",
                                            //   ),
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: Avenirtextbook(
                                                  text: Extratriplistarray[index]['trip_end_time']
                                                                  .toString() ==
                                                              "null" ||
                                                          Extratriplistarray[index][
                                                                      'trip_end_time']
                                                                  .toString() ==
                                                              ""
                                                      ? "-"
                                                      : Extratriplistarray[index][
                                                              'trip_end_time']
                                                          .toString(),
                                                  fontsize:
                                                      (AppLocalizations.of(context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon.greydark2),
                                                  customfontweight: FontWeight.w500),
                                              // child: CommonText(
                                              //   text: Grievancelistarray[index]
                                              //           ['date__c']
                                              //       .toString(),
                                              // ),
                                            ),
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: CommonText(
                                            //     text: Extratriplistarray[index][
                                            //                         'trip_end_time__c']
                                            //                     .toString() ==
                                            //                 "null" ||
                                            //             Extratriplistarray[
                                            //                             index][
                                            //                         'trip_end_time__c']
                                            //                     .toString() ==
                                            //                 ""
                                            //         ? "-"
                                            //         : Extratriplistarray[index]
                                            //                 ['trip_end_time__c']
                                            //             .toString(),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                  text: AppLocalizations.of(
                                                      context)!
                                                      .total_extra_hours,
                                                  fontsize:
                                                  (AppLocalizations.of(
                                                      context)!
                                                      .id ==
                                                      "ஐடி" ||
                                                      AppLocalizations.of(
                                                          context)!
                                                          .id ==
                                                          "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                      ? 12
                                                      : 15,
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                  customfontweight:
                                                  FontWeight.w500),
                                              // child: CommonText2(
                                              //   text: "Name",
                                              // ),
                                            ),
                                            // const Expanded(
                                            //   flex: 1,
                                            //   child: CommonText2(
                                            //     text: "Trip Start Time",
                                            //   ),
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: Avenirtextbook(
                                                  text: Extratriplistarray[index]['total_hours']
                                                      .toString() ==
                                                      "null" ||
                                                      Extratriplistarray[index][
                                                      'total_hours']
                                                          .toString() ==
                                                          ""
                                                      ? "-"
                                                      : Extratriplistarray[index][
                                                  'total_hours']
                                                      .toString(),
                                                  fontsize:
                                                  (AppLocalizations.of(context)!
                                                      .id ==
                                                      "ஐடி" ||
                                                      AppLocalizations.of(
                                                          context)!
                                                          .id ==
                                                          "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                      ? 12
                                                      : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon.greydark2),
                                                  customfontweight: FontWeight.w500),
                                              // child: CommonText(
                                              //   text: Grievancelistarray[index]
                                              //           ['date__c']
                                              //       .toString(),
                                              // ),
                                            ),
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: CommonText(
                                            //     text: Extratriplistarray[index][
                                            //                         'trip_start_time__c']
                                            //                     .toString() ==
                                            //                 "null" ||
                                            //             Extratriplistarray[
                                            //                             index][
                                            //                         'trip_start_time__c']
                                            //                     .toString() ==
                                            //                 ""
                                            //         ? "-"
                                            //         : Extratriplistarray[index][
                                            //                 'trip_start_time__c']
                                            //             .toString(),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                  text: AppLocalizations.of(
                                                      context)!
                                                      .trip_amount,
                                                  fontsize:
                                                  (AppLocalizations.of(
                                                      context)!
                                                      .id ==
                                                      "ஐடி" ||
                                                      AppLocalizations.of(
                                                          context)!
                                                          .id ==
                                                          "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                      ? 12
                                                      : 15,
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                  customfontweight:
                                                  FontWeight.w500),
                                              // child: CommonText2(
                                              //   text: "Name",
                                              // ),
                                            ),
                                            // const Expanded(
                                            //   flex: 1,
                                            //   child: CommonText2(
                                            //     text: "Trip Start Time",
                                            //   ),
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: Avenirtextbook(
                                                  text: Extratriplistarray[index]['voucher_amount__c']
                                                      .toString() ==
                                                      "null" ||
                                                      Extratriplistarray[index][
                                                      'voucher_amount__c']
                                                          .toString() ==
                                                          ""
                                                      ? "-"
                                                      : Extratriplistarray[index][
                                                  'voucher_amount__c']
                                                      .toString(),
                                                  fontsize:
                                                  (AppLocalizations.of(context)!
                                                      .id ==
                                                      "ஐடி" ||
                                                      AppLocalizations.of(
                                                          context)!
                                                          .id ==
                                                          "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                      ? 12
                                                      : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon.greydark2),
                                                  customfontweight: FontWeight.w500),
                                              // child: CommonText(
                                              //   text: Grievancelistarray[index]
                                              //           ['date__c']
                                              //       .toString(),
                                              // ),
                                            ),
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: CommonText(
                                            //     text: Extratriplistarray[index][
                                            //                         'trip_start_time__c']
                                            //                     .toString() ==
                                            //                 "null" ||
                                            //             Extratriplistarray[
                                            //                             index][
                                            //                         'trip_start_time__c']
                                            //                     .toString() ==
                                            //                 ""
                                            //         ? "-"
                                            //         : Extratriplistarray[index][
                                            //                 'trip_start_time__c']
                                            //             .toString(),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                  text: AppLocalizations.of(context)!.status ,
                                                  fontsize:
                                                      (AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 15,
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                  customfontweight:
                                                      FontWeight.w500),
                                              // child: CommonText2(
                                              //   text: "Name",
                                              // ),
                                            ),
                                            // const Expanded(
                                            //   flex: 1,
                                            //   child: CommonText2(
                                            //     text: "Status",
                                            //   ),
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: Avenirtextbook(
                                                  text: Extratriplistarray[index]['extra_trip_approval_status']
                                                                  .toString() ==
                                                              "null" ||
                                                          Extratriplistarray[index][
                                                                      'extra_trip_approval_status']
                                                                  .toString() ==
                                                              ""
                                                      ? "-"
                                                      : Extratriplistarray[index][
                                                              'extra_trip_approval_status']
                                                          .toString(),
                                                  fontsize:
                                                      (AppLocalizations.of(context)!
                                                                  .id ==
                                                               "ஐடி" ||
                                                                AppLocalizations.of(
                                                                            context)!
                                                                        .id ==
                                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          ? 12
                                                          : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon.greydark2),
                                                  customfontweight: FontWeight.w500),
                                              // child: CommonText(
                                              //   text: Grievancelistarray[index]
                                              //           ['date__c']
                                              //       .toString(),
                                              // ),
                                            ),
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: CommonText(
                                            //     text: Extratriplistarray[index][
                                            //                         'extra_trip_approval_status__c']
                                            //                     .toString() ==
                                            //                 "null" ||
                                            //             Extratriplistarray[
                                            //                             index][
                                            //                         'extra_trip_approval_status__c']
                                            //                     .toString() ==
                                            //                 ""
                                            //         ? "-"
                                            //         : Extratriplistarray[index][
                                            //                 'extra_trip_approval_status__c']
                                            //             .toString(),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Row(
                                        //   // ignore: prefer_const_literals_to_create_immutables
                                        //   children: [
                                        //     Expanded(
                                        //       flex: 1,
                                        //       child: Avenirtextmedium(
                                        //           text: AppLocalizations.of(
                                        //                   context)!
                                        //               .engagementofficerremarks,
                                        //           fontsize:
                                        //               (AppLocalizations.of(
                                        //                               context)!
                                        //                           .id ==
                                        //                        "ஐடி" ||
                                        //                         AppLocalizations.of(
                                        //                                     context)!
                                        //                                 .id ==
                                        //                             "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        //                   ? 12
                                        //                   : 15,
                                        //           textcolor: HexColor(
                                        //               Colorscommon.greendark),
                                        //           customfontweight:
                                        //               FontWeight.w500),
                                        //       // child: CommonText2(
                                        //       //   text: "Name",
                                        //       // ),
                                        //     ),
                                        //     // const Expanded(
                                        //     //   flex: 1,
                                        //     //   child: CommonText2(
                                        //     //     text:
                                        //     //         "Engagement officer Remarks",
                                        //     //   ),
                                        //     // ),
                                        //     Expanded(
                                        //       flex: 2,
                                        //       child: Avenirtextbook(
                                        //           text: Extratriplistarray[index]['extra_trip_remarks']
                                        //                           .toString() ==
                                        //                       "null" ||
                                        //                   Extratriplistarray[index][
                                        //                               'extra_trip_remarks']
                                        //                           .toString() ==
                                        //                       ""
                                        //               ? "-"
                                        //               : Extratriplistarray[index][
                                        //                       'extra_trip_remarks']
                                        //                   .toString(),
                                        //           fontsize:
                                        //               (AppLocalizations.of(context)!
                                        //                           .id ==
                                        //                        "ஐடி" ||
                                        //                         AppLocalizations.of(
                                        //                                     context)!
                                        //                                 .id ==
                                        //                             "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        //                   ? 12
                                        //                   : 14,
                                        //           textcolor: HexColor(
                                        //               Colorscommon.greydark2),
                                        //           customfontweight: FontWeight.w500),
                                        //       // child: CommonText(
                                        //       //   text: Grievancelistarray[index]
                                        //       //           ['date__c']
                                        //       //       .toString(),
                                        //       // ),
                                        //     ),
                                        //     // Expanded(
                                        //     //   flex: 2,
                                        //     //   child: CommonText(
                                        //     //     text: Extratriplistarray[index][
                                        //     //                         'extra_trip_remarks__c']
                                        //     //                     .toString() ==
                                        //     //                 "null" ||
                                        //     //             Extratriplistarray[
                                        //     //                             index][
                                        //     //                         'extra_trip_remarks__c']
                                        //     //                     .toString() ==
                                        //     //                 ""
                                        //     //         ? "-"
                                        //     //         : Extratriplistarray[index][
                                        //     //                 'extra_trip_remarks__c']
                                        //     //             .toString(),
                                        //     //   ),
                                        //     // ),
                                        //   ],
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Row(
                                        //   // ignore: prefer_const_literals_to_create_immutables
                                        //   children: [
                                        //     const Expanded(
                                        //       flex: 1,
                                        //       child: CommonText(
                                        //         text: "Approval Status",
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       flex: 1,
                                        //       child: CommonText(
                                        //         text: Extratriplistarray[index]
                                        //                         ['approval_status__c']
                                        //                     .toString() ==
                                        //                 "null"
                                        //             ? "-"
                                        //             : Extratriplistarray[index]
                                        //                     ['approval_status__c']
                                        //                 .toString(),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Row(
                                        //   // ignore: prefer_const_literals_to_create_immutables
                                        //   mainAxisAlignment: MainAxisAlignment.end,
                                        //   children: [
                                        //     Bouncing(
                                        //       onPress: () {
                                        //         var url = Extratriplistarray[index]
                                        //                 ['viewAttachment']
                                        //             .toString();
                                        //         showDialog(
                                        //           context: context,
                                        //           barrierDismissible: false,
                                        //           builder: (BuildContext context) {
                                        //             // dialogContext = context;
                                        //             return Dialog(
                                        //               child: Padding(
                                        //                 padding: const EdgeInsets.all(0),

                                        //                 child: SizedBox(
                                        //                   height: MediaQuery.of(context)
                                        //                           .size
                                        //                           .height /
                                        //                       3.9,
                                        //                   width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width,
                                        //                   child: Column(children: [
                                        //                     Image.network(url),
                                        //                     Bouncing(
                                        //                         child: Container(
                                        //                           width: 100,
                                        //                           padding:
                                        //                               const EdgeInsets
                                        //                                   .all(5),
                                        //                           height: 35,
                                        //                           decoration:
                                        //                               BoxDecoration(
                                        //                                   borderRadius:
                                        //                                       BorderRadius
                                        //                                           .circular(
                                        //                                               5),
                                        //                                   gradient:
                                        //                                       LinearGradient(
                                        //                                           colors: [
                                        //                                         HexColor(
                                        //                                             Colorscommon
                                        //                                                 .greencolor),
                                        //                                         HexColor(
                                        //                                             Colorscommon
                                        //                                                 .greencolor),
                                        //                                       ])),
                                        //                           child: const Center(
                                        //                               child: Text(
                                        //                             "Close",
                                        //                             style: TextStyle(
                                        //                                 color:
                                        //                                     Colors.white,
                                        //                                 fontFamily:
                                        //                                     'Lato',
                                        //                                 fontWeight:
                                        //                                     FontWeight
                                        //                                         .bold),
                                        //                           )),
                                        //                         ),
                                        //                         onPress: () {
                                        //                           Navigator.pop(context);
                                        //                         })
                                        //                   ]),
                                        //                 ),
                                        //                 // ),
                                        //               ),
                                        //             );
                                        //           },
                                        //         );
                                        //       },
                                        //       child: Container(
                                        //         width: 150,
                                        //         margin: const EdgeInsets.only(
                                        //             top: 10, left: 10, right: 0),
                                        //         padding: const EdgeInsets.all(5),
                                        //         height: 35,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(5),
                                        //             gradient: LinearGradient(colors: [
                                        //               HexColor(Colorscommon.greencolor),
                                        //               HexColor(Colorscommon.greencolor),
                                        //             ])),
                                        //         child: const Center(
                                        //             child: Text(
                                        //           "ViewAttachment",
                                        //           style: TextStyle(
                                        //               color: Colors.white,
                                        //               fontFamily: 'Lato',
                                        //               fontWeight: FontWeight.bold),
                                        //         )),
                                        //       ),
                                        //     ),
                                        //     // Expanded(
                                        //     //   flex: 1,
                                        //     //   child: CommonText(
                                        //     //     text: Extratriplistarray[index]
                                        //     //             ['viewAttachment']
                                        //     //         .toString(),
                                        //     //   ),
                                        //     // ),
                                        //   ],
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
