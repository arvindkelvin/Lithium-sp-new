import 'dart:convert';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:math' as math;
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../l10n/app_localizations.dart';

class CancelEos extends StatefulWidget {
  const CancelEos({Key? key}) : super(key: key);

  @override
  State<CancelEos> createState() => _CancelEosState();
}

class _CancelEosState extends State<CancelEos> {
  SessionManager sessionManager = SessionManager();
  bool isdata = false;
  bool isloading = true;
  Utility utility = Utility();
  List calceleoslist = [];
  late DateTime levfromdate;
  DateTime Today = DateTime.now();

  @override
  void initState() {
    super.initState();
    utility.GetUserdata().then((value) => {
          sessionManager.internetcheck().then((intenet) async {
            if (intenet) {
              //utility.showYourpopupinternetstatus(context);
            } else {
               WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              final overlay = Overlay.of(context);
              if (overlay == null) return;

              showTopSnackBar(
                overlay,
                const CustomSnackBar.error(
                  message: "Please Check Your Internet Connection",
                ),
              );
              });
            }
          }),
          getcanceleoslist(),
        });
  }

  @override
  void dispose() {
    super.dispose();
  }



  Future<void> getcanceleoslist() async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };


    print(utility.service_provider_c);

    // Use a JSON-encoded string for the data field
    String dataJson = jsonEncode([
      {
         "service_provider": utility.service_provider_c
       // "service_provider": "a14HE00000264FwYAI"
      }
    ]);
    print(utility.lithiumid);
    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(headers)
      ..fields['from'] = "getEOSCancelViewList"
      ..fields['data'] = dataJson // Add the JSON-encoded string as the 'data' field
      ..fields['idUser'] = utility.userid
      ..fields['service_provider_c'] = utility.service_provider_c
      ..fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);
        print("cacelist: $jsonInput");

        bool status = jsonInput['status'] ?? false;
        String message = jsonInput['message'].toString();
        isloading = false;

        if (status) {
          List<dynamic> array = jsonInput['data'] ?? [];
          if (array.isNotEmpty) {
            isdata = true;
            calceleoslist = array;
            print("cancel list = $calceleoslist");
          }
        } else {
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
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      setState(() {});
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
            // ignore: unnecessary_new
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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

  applycancel(String eosid) async {
    // String url = CommonURL.BASE_URL;
    loading();
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    // var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "eosCancelStatusUpdate";
    request.fields['idUser'] = utility.userid;
    request.fields['idEOS'] = eosid;
    request.fields['service_provider_c'] = utility.service_provider_c;
    request.fields['lithiumID'] = utility.lithiumid;
    request.fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    // request.files.add(await http.MultipartFile.fromPath('file', _image.path));

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    print("canceleos =" + response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("applycancel= $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (status == 'true') {
        setState(() {});
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
    getcanceleoslist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CommonAppbar(
          title: AppLocalizations.of(context)!.cancel_EOS,
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
            // const SizedBox(height: 10),
            Visibility(
              visible: !isdata,
              child: !isloading
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'No Data Available',
                          style: TextStyle(
                              color: HexColor(Colorscommon.redcolor),
                              fontSize: 16),
                        ),
                      ))
                  : Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        // enabled: _enabled,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // if you need this
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0),
                                width: 1,
                              ),
                            ),
                            elevation: 3,
                            // In many cases, the key isn't mandatory
                            key: UniqueKey(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: CommonText(
                                          text: "     ",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount: 6,
                        ),
                      ),
                    ),
            ),
            Visibility(
              visible: isdata,
              child: Expanded(
                // Use ListView.builder

                child: ListView.builder(
                    shrinkWrap: true,
                    // the number of items in the list
                    physics: const BouncingScrollPhysics(),
                    itemCount: calceleoslist.length,

                    // display each item of the product list
                    itemBuilder: (context, index) {
                      //debugPrint('Indexvalue' + index.toString());
                      // debugPrint('modellength' +
                      //     permissionModel.detail.length.toString());

                      var reasonstr;
                      if (calceleoslist[index]['reason'] ==
                          "Family Emergency") {
                        reasonstr = AppLocalizations.of(context)!
                            .family_emergency
                            .toString();
                      } else if (calceleoslist[index]['reason'] == "Festival") {
                        reasonstr =
                            AppLocalizations.of(context)!.festival.toString();
                      } else if (calceleoslist[index]['reason'] ==
                          "Personal Reasons") {
                        reasonstr = AppLocalizations.of(context)!
                            .personal_Reasons
                            .toString();
                      } else {
                        reasonstr = calceleoslist[index]['reason'].toString();
                      }

                      DateTime levfromdate = DateFormat('dd-MM-yyyy').parse(calceleoslist[index]['from_date']);
                      print("condition status = ${levfromdate.isBefore(Today)}");
                      print("condition status 2 ($levfromdate)= ${calceleoslist[index]
                      ['eos_status_name'].toString().toUpperCase() != "Cancelled".toUpperCase()}");
                      return Card(
                        margin: const EdgeInsets.all(10),

                        // shape: Border(
                        //     left: BorderSide(
                        //         color: Color(
                        //                 (math.Random().nextDouble() * 0xFFFFFF)
                        //                     .toInt())
                        //             .withOpacity(1.0),
                        //         width: 5)),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.1),
                            width: .1,
                          ),
                        ),
                        elevation: .8,
                        // In many cases, the key isn't mandatory
                        key: UniqueKey(),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 5,
                                    height: 115,
                                    // height: calceleoslist[index]
                                    //                 ['eos_status_name']
                                    //             .toString()
                                    //             .toUpperCase() ==
                                    //         "Cancelled".toUpperCase()
                                    //     ? 80
                                    //     : 120,
                                    decoration: BoxDecoration(
                                        color: Color(
                                                (math.Random().nextDouble() *
                                                        0xFFFFFF)
                                                    .toInt())
                                            .withOpacity(1.0),
                                        borderRadius: const BorderRadius.all(
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
                                              customfontweight: FontWeight.w500,
                                              fontsize:
                                                  (AppLocalizations.of(context)!
                                                                  .id ==
                                                              "ஐடி" ||
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                              "आयडी" ||
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                              "ಐಡಿ")
                                                      ? 12
                                                      : 15,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .from,
                                              textcolor: HexColor(
                                                  Colorscommon.greendark),
                                            )
                                            // child: CommonText2(
                                            //   text: "From",
                                            // ),
                                            ),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            customfontweight: FontWeight.normal,
                                            fontsize:
                                                (AppLocalizations.of(context)!
                                                                .id ==
                                                            "ஐடி" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "आयडी" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "ಐಡಿ")
                                                    ? 12
                                                    : 14,
                                            text: calceleoslist[index]
                                                    ["from_date"]
                                                .toString(),
                                            textcolor: HexColor(
                                                Colorscommon.greydark2),
                                          ),
                                          // child: CommonText(
                                          //   text: calceleoslist[index]
                                          //           ['from_date']
                                          //       .toString(),
                                          // ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Avenirtextmedium(
                                                customfontweight:
                                                    FontWeight.w500,
                                                fontsize: (AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "ஐடி" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "आयडी" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "ಐಡಿ")
                                                    ? 12
                                                    : 15,
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .days,
                                                textcolor: HexColor(
                                                    Colorscommon.greendark),
                                              )
                                              // child: CommonText2(
                                              //   text: "Days",
                                              // ),
                                              ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            customfontweight: FontWeight.w500,
                                            fontsize:
                                                (AppLocalizations.of(context)!
                                                                .id ==
                                                            "ஐடி" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "आयडी" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "ಐಡಿ")
                                                    ? 12
                                                    : 14,
                                            text: calceleoslist[index]["nodays"]
                                                .toString(),
                                            textcolor: HexColor(
                                                Colorscommon.greydark2),
                                          ),
                                          // child: CommonText(
                                          //   text: calceleoslist[index]
                                          //           ['from_date']
                                          //       .toString(),
                                          // ),
                                        ),
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
                                              customfontweight: FontWeight.w500,
                                              fontsize:
                                                  (AppLocalizations.of(context)!
                                                                  .id ==
                                                              "ஐடி" ||
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                              "आयडी" ||
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                              "ಐಡಿ")
                                                      ? 12
                                                      : 15,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .to,
                                              textcolor: HexColor(
                                                  Colorscommon.greendark),
                                            )
                                            // child: CommonText2(
                                            //   text: "To",
                                            // ),
                                            ),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            customfontweight: FontWeight.normal,
                                            fontsize:
                                                (AppLocalizations.of(context)!
                                                                .id ==
                                                            "ஐடி" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "आयडी" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "ಐಡಿ")
                                                    ? 12
                                                    : 14,
                                            text: calceleoslist[index]
                                                    ["to_date"]
                                                .toString(),
                                            textcolor: HexColor(
                                                Colorscommon.greydark2),
                                          ),
                                          // child: CommonText(
                                          //   text: calceleoslist[index]
                                          //           ['from_date']
                                          //       .toString(),
                                          // ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Avenirtextmedium(
                                              customfontweight: FontWeight.w500,
                                              fontsize:
                                                  (AppLocalizations.of(context)!
                                                                  .id ==
                                                              "ஐடி" ||
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                              "आयडी" ||
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                              "ಐಡಿ")
                                                      ? 12
                                                      : 15,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .status,
                                              textcolor: HexColor(
                                                  Colorscommon.greendark),
                                            )
                                            // child: CommonText2(
                                            //   text: "Status",
                                            // ),
                                            ),
                                        // Expanded(
                                        //   flex: 1,
                                        //   child: CommonText2(
                                        //     text: calceleoslist[index]['reason']
                                        //         .toString(),
                                        //   ),
                                        // ),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            customfontweight: FontWeight.w500,
                                            fontsize:
                                                (AppLocalizations.of(context)!
                                                                .id ==
                                                            "ஐடி" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "आयडी" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "ಐಡಿ")
                                                    ? 12
                                                    : 14,
                                            text: calceleoslist[index]
                                                    ["eos_status_name"]
                                                .toString(),
                                            textcolor: calceleoslist[index]
                                                            ['eos_status_name']
                                                        .toString() ==
                                                    "Submitted"
                                                ? HexColor("#F3BD6A")
                                                : calceleoslist[index][
                                                                'eos_status_name']
                                                            .toString() ==
                                                        "Approved"
                                                    ? HexColor(
                                                        Colorscommon.greencolor)
                                                    : HexColor(
                                                        Colorscommon.red),
                                          ),
                                          // child: CommonText(
                                          //   text: calceleoslist[index]
                                          //           ['from_date']
                                          //       .toString(),
                                          // ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Avenirtextmedium(
                                              customfontweight: FontWeight.w500,
                                              fontsize:
                                                  (AppLocalizations.of(context)!
                                                                  .id ==
                                                              "ஐடி" ||
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                              "आयडी" ||
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .id ==
                                                              "ಐಡಿ")
                                                      ? 12
                                                      : 15,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .reason,
                                              textcolor: HexColor(
                                                  Colorscommon.greendark),
                                            )
                                            ),
                                        Expanded(
                                          flex: 5,
                                          child: Avenirtextbook(
                                            customfontweight: FontWeight.normal,
                                            fontsize:
                                                (AppLocalizations.of(context)!
                                                                .id ==
                                                            "ஐடி" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "आयडी" ||
                                                        AppLocalizations.of(
                                                                    context)!
                                                                .id ==
                                                            "ಐಡಿ")
                                                    ? 12
                                                    : 14,
                                            text: reasonstr
                                                .toString(),
                                            textcolor: HexColor(
                                                Colorscommon.greydark2),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                      Visibility(
                                        visible: (
                                            calceleoslist[index]
                                        ['eos_status_name']
                                            .toString()
                                            .toUpperCase() !=
                                            "Cancelled".toUpperCase()
                                            &&
                                                calceleoslist[index]['eos_status_name']
                                            .toString().toUpperCase() !=
                                            "Rejected by Site Manager".toUpperCase()
                                            && calceleoslist[index]['eos_status_name'].toString().toUpperCase() !=
                                            "Auto Reject".toUpperCase()
                                            && (Today.isBefore(levfromdate))
                                        ),
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            Bouncing(
                                              onPress: () async {
                                                var cancelid =
                                                    calceleoslist[index]['id']
                                                        .toString();
                                                print("cancelid$cancelid");
                                                sessionManager
                                                    .internetcheck()
                                                    .then((intenet) async {
                                                  if (intenet) {
                                                    showAnimatedDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      animationType:
                                                          DialogTransitionType
                                                              .scale,
                                                      curve:
                                                          Curves.fastOutSlowIn,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          title: Row(
                                                            children: [
                                                              Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      Avenirtextblack(
                                                                    customfontweight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                            AppLocalizations.of(context)!.id ==
                                                                                "आयडी" ||
                                                                            AppLocalizations.of(context)!.id ==
                                                                                "ಐಡಿ")
                                                                        ? 12
                                                                        : 15,
                                                                    text: AppLocalizations.of(
                                                                            context)!
                                                                        .confirmation,
                                                                    textcolor: HexColor(
                                                                        Colorscommon
                                                                            .greendark),
                                                                  )
                                                                  ),
                                                              Expanded(
                                                                // ignore: avoid_unnecessary_containers
                                                                child: Container(
                                                                    child: Divider(
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .litegrey),
                                                                  height: 20,
                                                                )),
                                                              ),
                                                            ],
                                                          ),
                                                          titleTextStyle: TextStyle(
                                                              color: HexColor(
                                                                  Colorscommon
                                                                      .greydark2)),
                                                          titlePadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5,
                                                                  top: 5),
                                                          content: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .areyousurewanttocancelthis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "आयडी" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "ಐಡಿ")
                                                                      ? 13
                                                                      : 14,
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .greycolor),
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
                                                                      margin: const EdgeInsets.only(top: 20),
                                                                      child: Divider(
                                                                        color: HexColor(
                                                                            Colorscommon.litegrey),
                                                                        height:
                                                                            20,
                                                                      )),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      Bouncing(
                                                                    onPress:
                                                                        () {
                                                                      sessionManager
                                                                          .internetcheck()
                                                                          .then(
                                                                              (intenet) async {
                                                                        if (intenet) {
                                                                          applycancel(
                                                                              cancelid);
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
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              20,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              0),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          gradient: LinearGradient(colors: [
                                                                            HexColor(Colorscommon.greenlight2),
                                                                            HexColor(Colorscommon.greenlight2),
                                                                          ])),
                                                                      child:
                                                                          Center(
                                                                        child: Avenirtextblack(
                                                                            text: AppLocalizations.of(context)!
                                                                                .yes,
                                                                            fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                                                ? 12
                                                                                : 13,
                                                                            textcolor:
                                                                                Colors.white,
                                                                            customfontweight: FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      Bouncing(
                                                                    onPress:
                                                                        () {
                                                                      Navigator.of(
                                                                              context,
                                                                              rootNavigator: true)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              20,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              0),
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          border:
                                                                              Border.all(color: HexColor(Colorscommon.greencolor))),
                                                                      child:
                                                                          Center(
                                                                        child: Avenirtextblack(
                                                                            text: AppLocalizations.of(context)!
                                                                                .no,
                                                                            fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                                                ? 12
                                                                                : 13,
                                                                            textcolor:
                                                                                HexColor(Colorscommon.greenlight2),
                                                                            customfontweight: FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
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
                                                });
                                              },
                                              child: SizedBox(
                                                height: 30,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: HexColor(
                                                        Colorscommon
                                                            .greencolor),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                  ),
                                                  child: Avenirtextmedium(
                                                    customfontweight:
                                                        FontWeight.w500,
                                                    fontsize: (AppLocalizations.of(
                                                                        context)!
                                                                    .id ==
                                                                "ஐடி" ||
                                                            AppLocalizations.of(
                                                                        context)!
                                                                    .id ==
                                                                "आयडी" ||
                                                            AppLocalizations.of(
                                                                        context)!
                                                                    .id ==
                                                                "ಐಡಿ")
                                                        ? 12
                                                        : 14,
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .cancel,
                                                    textcolor: Colors.white,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
