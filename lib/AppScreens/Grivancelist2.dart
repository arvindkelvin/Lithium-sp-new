import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:math' as math;
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../l10n/app_localizations.dart';

class Grievancelist2 extends StatefulWidget {
  const Grievancelist2({Key? key}) : super(key: key);

  @override
  State<Grievancelist2> createState() => _Grievancelist2State();
}

class _Grievancelist2State extends State<Grievancelist2> {
  bool isdata = false;
  bool isloading = true;
  Utility utility = Utility();
  List Grievancelistarray = [];
  var spusername = "";

  @override
  void initState() {
    super.initState();;
    print('hello grevience');
    utility.GetUserdata().then((value) =>
    {
      sessionManager.internetcheck().then((intenet) async {
        if (intenet) {
          //utility.showYourpopupinternetstatus(context);
          // checkupdate(_30minstr);,
          // loading();
          // Loginapi(serveruuid, serverstate);
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
      spusername = utility.mobileuser,
      getGrievancelistlist(),
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  getGrievancelistlist() async {
    print("Fetching grievance list...");

    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    print(utility.lithiumid);
    print(utility.service_provider_c);

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getGrievanceList";
    //request.fields['fromDate'] = "2022-07-01";
    //request.fields['toDate'] = "2022-07-31";
    //request.fields['idUser'] = utility.userid;
    //request.fields['lithiumID'] = utility.lithiumid;
    //request.fields['service_provider_c'] = utility.service_provider_c;
    // request.fields['type'] = "Late";
    //request.fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    // Encoding the service_provider data as JSON
    String dataJson = jsonEncode([{"service_provider": utility.service_provider_c}]);
    request.fields['data'] = dataJson;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("Grievance list: $jsonInput");
      log("Grievance list1: $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      isloading = false;

      if (status == 'true') {
        List array = jsonInput['data'];

        if (array.isNotEmpty) {
          isdata = true;
          Grievancelistarray = array;
        }

        setState(() {});
      } else {
        // Handle the case where the status is not true
      }
    } else {
      // Handle the case where the response status code is not 200 or 201
    }

    setState(() {});
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
    getGrievancelistlist();
  }

  @override
  Widget build(BuildContext context) {
    // Check if there are any resolved grievances
    List resolvedGrievances = Grievancelistarray.where((grievance) {
      String grievanceStatus = grievance['grievance_status'].toString();
      return grievanceStatus == "Closed" || grievanceStatus == "Resolved" ;// Adjust based on actual resolved status
    }).toList();


    bool hasResolvedGrievances = resolvedGrievances.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                visible: !isloading ,
                child: Visibility(
                  visible: !hasResolvedGrievances,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: const Center(
                        child: Text("No Data Available"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !isloading && hasResolvedGrievances,
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: resolvedGrievances.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: HexColor(Colorscommon.greencolor),
                          width: 1.1,
                        ),
                      ),
                      elevation: 5,
                      key: UniqueKey(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
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
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                      .toInt())
                                      .withOpacity(1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 60,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Avenirtextmedium(
                                          text: AppLocalizations.of(context)!.date,
                                          fontsize: 15,
                                          textcolor: HexColor(Colorscommon.greendark),
                                          customfontweight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Avenirtextbook(
                                          text: resolvedGrievances[index]['gDate']
                                              .toString(),
                                          fontsize: 14,
                                          textcolor: HexColor(Colorscommon.greydark2),
                                          customfontweight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Avenirtextmedium(
                                          text: AppLocalizations.of(context)!.category,
                                          fontsize: 15,
                                          textcolor: HexColor(Colorscommon.greendark),
                                          customfontweight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          child: Avenirtextbook(
                                            text: resolvedGrievances[index]['categoryName']
                                                .toString(),
                                            fontsize: 14,
                                            textcolor: HexColor(Colorscommon.greydark2),
                                            customfontweight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Avenirtextmedium(
                                          text: AppLocalizations.of(context)!.status,
                                          fontsize: 15,
                                          textcolor: HexColor(Colorscommon.greendark),
                                          customfontweight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Avenirtextbook(
                                          text: resolvedGrievances[index]['grievance_status']
                                              .toString()
                                              ,
                                          fontsize: 14,
                                          textcolor: HexColor(Colorscommon.greydark2),
                                          customfontweight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Avenirtextmedium(
                                                  text: AppLocalizations
                                                      .of(context)!
                                                      .engagementofficerremarks,
                                                  fontsize: (AppLocalizations
                                                      .of(
                                                      context)!
                                                      .id ==
                                                      "ஐடி" ||
                                                      AppLocalizations.of(
                                                          context)!
                                                          .id ==
                                                          "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                                      AppLocalizations
                                                          .of(
                                                          context)!
                                                          .id ==
                                                          "ಐಡಿ")
                                                      ? 12
                                                      : 14,
                                                  textcolor: HexColor(
                                                      Colorscommon
                                                          .greendark),
                                                  customfontweight:
                                                  FontWeight.w500),

                                            ],
                                          ),
                                        ),
                                      ),


                                      Expanded(
                                        flex: 2,
                                        child: Avenirtextbook(
                                            text: Grievancelistarray[index][
                                            'description']
                                                .toString() ==
                                                "null"
                                                ? "       -"
                                                : Grievancelistarray[index]
                                            ['description']
                                                .toString(),
                                            fontsize: (AppLocalizations.of(
                                                context)!
                                                .id ==
                                                "ஐடி" ||
                                                AppLocalizations.of(
                                                    context)!
                                                    .id ==
                                                    "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                                AppLocalizations.of(context)!
                                                    .id ==
                                                    "ಐಡಿ")
                                                ? 12
                                                : 14,
                                            textcolor:
                                            HexColor(Colorscommon.greydark2),
                                            customfontweight: FontWeight.w500),

                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
