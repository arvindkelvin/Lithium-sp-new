import 'dart:convert';
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

class Grievancelist extends StatefulWidget {
  const Grievancelist({Key? key}) : super(key: key);

  @override
  State<Grievancelist> createState() => _GrievancelistState();
}

class _GrievancelistState extends State<Grievancelist> {
  bool isdata = false;
  bool isloading = true;
  Utility utility = Utility();
  List Grievancelistarray = [];
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

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      isloading = false;

      if (status == 'true') {
        List array = jsonInput['data'];

        if (array.isNotEmpty) {
          isdata = true;
          Grievancelistarray = array;
        }

      //  setState(() {});
      } else {
        // Handle the case where the status is not true
      }
    } else {
      // Handle the case where the response status code is not 200 or 201
    }

    setState(() {});
  }


  // getGrievancelistlist() async {
  //   print("texttgjhgjhehk");
  //
  //   var url = Uri.parse(CommonURL.herokuurl);
  //
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   print(utility.lithiumid);
  //   print(utility.service_provider_c);
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "getGrievanceList";
  //   request.fields['fromDate'] = "2022-07-01";
  //   request.fields['toDate'] = "2022-07-31";
  //   request.fields['idUser'] = utility.userid;
  //   request.fields['lithiumID'] = utility.lithiumid;
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //   request.fields['type'] = "Late";
  //   request.fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();
  //
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
  //         Grievancelistarray = array;
  //
  //       }
  //
  //       setState(() {});
  //
  //
  //     } else {
  //
  //     }
  //   } else {}
  //
  //   setState(() {});
  // }

  // getGrievancelistlist() async {
  //   // String url = CommonURL.BASE_URL;
  //   var url = Uri.parse(CommonURL.URL);
  //   Map<String, String> postdata = {
  //     "from": "getGrievanceDetails",
  //     "idUser": utility.userid,
  //   };
  //   // print(postdata.toString());
  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/hal+json',
  //     'Accept': 'application/json',
  //   };

  //   final response = await http.post(url,
  //       body: jsonEncode(postdata), headers: requestHeaders);

  //   // //print("${response.statusCode}");
  //   // print("${response.body}");

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
    // Filter grievances to only show those that are "Open" or "In Progress"
    List filteredGrievances = Grievancelistarray.where((grievance) {
      String status = grievance['grievance_status'].toString().toUpperCase();
      return status == "OPEN" || status == "IN PROGRESS";
    }).toList();

    // Check if any data is available after filtering
    bool isDataAvailable = filteredGrievances.isNotEmpty;

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
                visible: !isDataAvailable,
                child: Visibility(
                  visible: !isloading,
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
              visible: !isloading,
              child: Visibility(
                visible: isDataAvailable,
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredGrievances.length,
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
                                offset: const Offset(0, 3),
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
                                    color: Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
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
                                            textcolor:
                                            HexColor(Colorscommon.greendark),
                                            customfontweight: FontWeight.w500,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            text: filteredGrievances[index]['gDate']
                                                .toString(),
                                            fontsize: 14,
                                            textcolor:
                                            HexColor(Colorscommon.greydark2),
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
                                            textcolor:
                                            HexColor(Colorscommon.greendark),
                                            customfontweight: FontWeight.w500,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            child: Avenirtextbook(
                                              text: filteredGrievances[index]
                                              ['categoryName']
                                                  .toString(),
                                              fontsize: 14,
                                              textcolor:
                                              HexColor(Colorscommon.greydark2),
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
                                            textcolor:
                                            HexColor(Colorscommon.greendark),
                                            customfontweight: FontWeight.w500,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            text: filteredGrievances[index]
                                            ['grievance_status']
                                                .toString(),
                                            fontsize: 14,
                                            textcolor:
                                            HexColor(Colorscommon.greydark2),
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
                                            text: AppLocalizations.of(context)!.engagementofficerremarks,
                                            fontsize: 14,
                                            textcolor: HexColor(Colorscommon.greendark),
                                            customfontweight: FontWeight.w500,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            text: filteredGrievances[index]
                                            ['description']
                                                .toString() ==
                                                "null"
                                                ? "       -"
                                                : filteredGrievances[index]
                                            ['description']
                                                .toString(),
                                            fontsize: 14,
                                            textcolor: HexColor(Colorscommon.greydark2),
                                            customfontweight: FontWeight.w500,
                                          ),
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
            ),
          ],
        ),
      ),
    );
  }

}
