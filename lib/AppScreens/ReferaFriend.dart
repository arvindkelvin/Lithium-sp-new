import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../l10n/app_localizations.dart';

class ReferaFriend extends StatefulWidget {
  const ReferaFriend({Key? key}) : super(key: key);

  @override
  State<ReferaFriend> createState() => _ReferaFriendState();
}

class _ReferaFriendState extends State<ReferaFriend> {
  bool isdata = false;
  bool isloading = true;
  bool isLoadingSidedata = true;
  bool isLoadingSidedata1 = true;

  // bool isexpanded = true;
  bool isexpanded = false;
  String? tileexpanded;
  String? cardexpandedstatus;
  String? selectedid;
  TextEditingController drivertextcontroller = TextEditingController();
  TextEditingController mobiletextcontroller = TextEditingController();
  ScrollController listcontroller = ScrollController();
  Utility utility = Utility();
  List referschemelist = [];
  List driverreferrallist = [];
  var referdrivertext;
  String? service_provider;
  String? schemevalue;

  List<Map<String, dynamic>> siteData = [];
  List<Map<String, dynamic>> cityData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //code will run when widget rendering complete
    });
    Future<String> Serviceprovider = sessionManager.getspid();
    Serviceprovider.then((value) {
      service_provider = value.toString();
      print('service_provider--$service_provider');
    });
    tileexpanded = "false";

    cardexpandedstatus = "false";
    utility.GetUserdata().then((value) => {
          referdrivertext = AppLocalizations.of(context)!.driversrefered,
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
          getReferschemelist(),
          getReferaFriendlist(""),
          fetchReferralsite(),
          fetchReferralcity(),
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchReferralsite() async {
    var empname = utility.sp_username;
    print("Employee Name: $empname");

    // Extract the city code from the empname
    String cityCode =
        empname.substring(4, 7); // Extracts characters at index 4, 5, and 6
    print("Extracted City Code: $cityCode");

    var url = Uri.parse(CommonURL.localone);

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['from'] = 'getrefferalfriendsp';
      request.fields['data'] = json.encode([
        {"view": "site", "city": cityCode},
        // Pass the extracted city code dynamically
      ]);
      request.headers['Accept'] = 'application/json';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("Response Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseJson = json.decode(responseBody);
        String message = responseJson['message'];
        if (responseJson['status'] == true) {
          setState(() {
            siteData = List<Map<String, dynamic>>.from(responseJson['data']);
            isLoadingSidedata = false;
          });
        } else {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          setState(() {
            isLoadingSidedata = false;
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "Internal Server error, try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        setState(() {
          isLoadingSidedata = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Internal Server error, try again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      setState(() {
        isLoadingSidedata = false;
      });
    }
  }

  Future<void> fetchReferralcity() async {
    var empname = utility.sp_username;
    print("Employee Name: $empname");

    // Extract the city code from the empname
    String cityCode =
        empname.substring(4, 7); // Extracts characters at index 4, 5, and 6
    print("Extracted City Code: $cityCode");

    // const String url = "http://10.10.14.14:8092/webservice";
    var url = Uri.parse(CommonURL.localone);

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['from'] = 'getrefferalfriendsp';
      request.fields['data'] = json.encode([
        {"view": "city", "city": cityCode},
      ]);
      request.headers['Accept'] = 'application/json';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("Response Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseJson = json.decode(responseBody);
        String message = responseJson['message'];

        if (responseJson['status'] == true) {
          setState(() {
            cityData = List<Map<String, dynamic>>.from(responseJson['data']);
            isLoadingSidedata1 = false;
          });
        } else {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          setState(() {
            isLoadingSidedata1 = false;
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "Internal Server error try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        setState(() {
          isLoadingSidedata1 = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Internal Server error try again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      setState(() {
        isLoadingSidedata1 = false;
      });
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    setState(() {});
  }

  // need to set the loading for list ////////////
  Future<void> getReferaFriendlist(String id) async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    // Define the data for the request
    String dataJson = jsonEncode([
      {"lithiumid": utility.lithiumid}
    ]);

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "referralFriendsList";
    request.fields['data'] = dataJson;
    request.fields['languageType'] =
        AppLocalizations.of(context)!.languagecode.toString();

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      print("getReferaFriendlist status code = ${response.statusCode}");
      print("getReferaFriendlist response body = ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);

        bool status = jsonInput['status'] ?? false;
        String message = jsonInput['message'] ?? "";

        if (status) {
          List<dynamic> data = jsonInput['data'] ?? [];
          if (data.isNotEmpty) {
            setState(() {
              driverreferrallist = data;
              isdata = true;
            });

            // Navigator.pop(context); // Uncomment this if needed
          } else {
            Fluttertoast.showToast(
              msg: "No data available",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          }
        } else {
          setState(() {
            driverreferrallist = [];
            isdata = false;
          });

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
    }
  }

  Future<void> getReferschemelist() async {
    var url = Uri.parse(CommonURL.localone);
    isloading = true;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    print(utility.service_provider_c);
    print(utility.userid);

    // Define your data
    String dataJson = jsonEncode([
      {
        // "lithiumid": utility.lithiumid
        "lithiumid": utility.lithiumid
      }
    ]);

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(headers)
      ..fields['from'] = "referralShemesList"
      ..fields['idUser'] = utility.userid
      ..fields['service_provider_c'] = utility.service_provider_c
      ..fields['languageType'] =
          AppLocalizations.of(context)!.languagecode.toString()
      ..fields['data'] = dataJson;

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);
      print("getReferschemelist status code = ${response.statusCode}");
      print("getReferschemelist response body = ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);
        print("referralShemesList jsonInput = $jsonInput");
        String status = jsonInput['status'].toString();

        if (status == 'true') {
          isloading = false;

          List array = jsonInput['data'];

          if (array.isNotEmpty) {
            isdata = true;
            referschemelist = array;
            print('referschemelist--$referschemelist');
            schemevalue = array[0]['sfdcid'];
            print('schemevalue$schemevalue');
          } else {
            Fluttertoast.showToast(
              msg: "No data available",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          }
        } else if (status == 'false') {
          isloading = false;
          print("status = $status");
          Fluttertoast.showToast(
            msg: "No data available",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        print("Server error: ${response.statusCode}");
        Fluttertoast.showToast(
          msg: "Server error: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      if (mounted) setState(() {});
    }
  }

  adddriver(String referrralidstr, String referralSchemeC, String name,
      String mobilenumber) async {
    // String url = CommonURL.BASE_URL;
    loading();
    var url = Uri.parse(CommonURL.localone);
    // String url = CommonURL.URL;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    // var uri = Uri.parse(url);
    // print(utility.service_provider_c);
    // print(mobilenumber);
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "referralFriendsAdd";
    request.fields['idUser'] = utility.userid;
    request.fields['service_provider_c'] = utility.service_provider_c;
    request.fields['referral_scheme_c'] = schemevalue!;
    request.fields['name'] = name;
    request.fields['mobileNo'] = mobilenumber;
    request.fields['idReferralScheme'] = referrralidstr;
    request.fields['languageType'] =
        AppLocalizations.of(context)!.languagecode.toString();

    // request.files.add(await http.MultipartFile.fromPath('file', _image.path));

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      // print("cacelist$jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      print("refer message = $message");
      if (status == 'true') {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        getReferaFriendlist('');
        drivertextcontroller.clear();
        mobiletextcontroller.clear();
      } else {
        Fluttertoast.showToast(
          msg:
              "Duplicate Record! Prospect with the same Mobile Number already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
    Navigator.pop(context);
    // Navigator.pop(context);
    // getReferaFriendlist(referrralidstr);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CommonAppbar(
          title: AppLocalizations.of(context)!.refer_a_Friend,
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
              visible: isloading,
              child: Center(
                child: CircularProgressIndicator(
                  color: HexColor(Colorscommon.greencolor),
                ),
              ),
            ),
            Center(
              child: Visibility(
                  visible: !isdata && !isloading,
                  child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: const Center(child: Text("No Data Available")))),
            ),
            Visibility(
              visible: isdata,
              child: Expanded(
                // Use ListView.builder
                flex: 1,
                child: ListView(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        // the number of items in the list
                        physics: const BouncingScrollPhysics(),
                        itemCount: referschemelist.length,

                        // display each item of the product list
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(10),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // if you need this
                                    side: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
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
                                            Avenirtextblack(
                                                text: referschemelist[index]
                                                                    ['name']
                                                                .toString() ==
                                                            "null" ||
                                                        referschemelist[index]
                                                                    ['name']
                                                                .toString() ==
                                                            ""
                                                    ? "-"
                                                    : referschemelist[index]
                                                            ['name']
                                                        .toString(),
                                                fontsize: 15,
                                                textcolor: HexColor(
                                                    Colorscommon.greendark),
                                                customfontweight:
                                                    FontWeight.w500),
                                            Avenirtextblack(
                                                text: " Referral Scheme",
                                                fontsize: 15,
                                                textcolor: HexColor(
                                                    Colorscommon.greendark),
                                                customfontweight:
                                                    FontWeight.w500)
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Avenirtextbook(
                                                text: referschemelist[index][
                                                                    'start_date']
                                                                .toString() ==
                                                            "null" ||
                                                        referschemelist[index][
                                                                    'start_date']
                                                                .toString() ==
                                                            ""
                                                    ? "-"
                                                    : referschemelist[index]
                                                            ['start_date']
                                                        .toString(),
                                                fontsize: 12,
                                                textcolor: HexColor(
                                                    Colorscommon.greydark2),
                                                customfontweight:
                                                    FontWeight.w500),
                                            Avenirtextbook(
                                                text: " to ",
                                                fontsize: 12,
                                                textcolor: HexColor(
                                                    Colorscommon.greydark2),
                                                customfontweight:
                                                    FontWeight.w500),
                                            Avenirtextbook(
                                                text: referschemelist[index]
                                                                    ['end_date']
                                                                .toString() ==
                                                            "null" ||
                                                        referschemelist[index]
                                                                    ['end_date']
                                                                .toString() ==
                                                            ""
                                                    ? "-"
                                                    : referschemelist[index]
                                                            ['end_date']
                                                        .toString(),
                                                fontsize: 12,
                                                textcolor: HexColor(
                                                    Colorscommon.greydark2),
                                                customfontweight:
                                                    FontWeight.w500),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Avenirtextbook(
                                                text: AppLocalizations.of(
                                                            context)!
                                                        .refersenone +
                                                    (referschemelist[index][
                                                                        'referral_incentive_amount__c']
                                                                    .toString() ==
                                                                "null" ||
                                                            referschemelist[index]
                                                                        [
                                                                        'referral_incentive_amount__c']
                                                                    .toString() ==
                                                                ""
                                                        ? "-"
                                                        : referschemelist[index]
                                                                [
                                                                'referral_incentive_amount__c']
                                                            .toString()) +
                                                    " " +
                                                    AppLocalizations.of(
                                                            context)!
                                                        .refersentwo,
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
                                                textcolor: HexColor(
                                                    Colorscommon.greydark2),
                                              ),
                                            ),
                                            const Spacer(),
                                            Visibility(
                                              visible:
                                                  cardexpandedstatus == "false",
                                              child: Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  height: 30,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: HexColor(
                                                          Colorscommon
                                                              .greenlight2),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                    ),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .refer,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "AvenirLTStd-Black"),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        cardexpandedstatus =
                                                            "true";
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible:
                                              cardexpandedstatus != "false",
                                          child: const Divider(),
                                        ),
                                        Visibility(
                                          visible:
                                              cardexpandedstatus != "false",
                                          child: Row(
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .driversdetails,
                                                style: TextStyle(
                                                    fontSize: (AppLocalizations.of(
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
                                                        ? 13
                                                        : 15,
                                                    fontFamily:
                                                        "AvenirLTStd-Black",
                                                    fontWeight: FontWeight.w500,
                                                    color: HexColor(Colorscommon
                                                        .greendark)),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              cardexpandedstatus != "false",
                                          child: const SizedBox(
                                            height: 10,
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              cardexpandedstatus != "false",
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: const EdgeInsets.only(
                                                  top: 5, right: 10, left: 10),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .name,
                                                  style: TextStyle(
                                                      fontSize: (AppLocalizations.of(
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
                                                          ? 13
                                                          : 15,
                                                      fontFamily:
                                                          'Avenir LT Std 65 Medium',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: HexColor(
                                                          Colorscommon
                                                              .greendark)),
                                                ),
                                              )),
                                        ),
                                        Visibility(
                                          visible:
                                              cardexpandedstatus != "false",
                                          child: Container(
                                            height: 40,
                                            margin: const EdgeInsets.all(10.0),
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: ShapeDecoration(
                                              color: HexColor("#F8F8F8"),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 0.1,
                                                    style: BorderStyle.solid),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                              ),
                                            ),
                                            child: Center(
                                              child: TextFormField(
                                                controller:
                                                    drivertextcontroller,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'AvenirLTStd-Book',
                                                    fontWeight: FontWeight.w500,
                                                    color: HexColor(Colorscommon
                                                        .greydark2)),
                                                decoration: InputDecoration(
                                                  hintText: 'Enter Name',
                                                  hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'AvenirLTStd-Book',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: HexColor(
                                                          Colorscommon
                                                              .greydark2)),

                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  // contentPadding: EdgeInsetsDirectional.only(start: 10.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              cardexpandedstatus != "false",
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: const EdgeInsets.only(
                                                  top: 5, right: 10, left: 10),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .mobilenumber,
                                                  style: TextStyle(
                                                      fontSize: (AppLocalizations.of(
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
                                                          ? 13
                                                          : 15,
                                                      fontFamily:
                                                          'Avenir LT Std 65 Medium',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: HexColor(
                                                          Colorscommon
                                                              .greendark)),
                                                ),
                                              )),
                                        ),
                                        Visibility(
                                          visible:
                                              cardexpandedstatus != "false",
                                          child: Container(
                                            height: 40,
                                            margin: const EdgeInsets.all(10.0),
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: ShapeDecoration(
                                              color: HexColor("#F8F8F8"),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 0.1,
                                                    style: BorderStyle.solid),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                              ),
                                            ),
                                            // decoration: BoxDecoration(
                                            //     border: Border.all(color: Colors.blueAccent)),
                                            child: Center(
                                              child: TextFormField(
                                                controller:
                                                    mobiletextcontroller,
                                                maxLength: 10,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'AvenirLTStd-Book',
                                                    fontWeight: FontWeight.w500,
                                                    color: HexColor(Colorscommon
                                                        .greydark2)),
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  hintText:
                                                      'Enter Mobile Number',
                                                  hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'AvenirLTStd-Book',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: HexColor(
                                                          Colorscommon
                                                              .greydark2)),
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  // contentPadding: EdgeInsetsDirectional.only(start: 10.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              cardexpandedstatus != "false",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Bouncing(
                                                  onPress: () async {
                                                    String referrralid =
                                                        referschemelist[index]
                                                                ['id']
                                                            .toString();
                                                    String referralSchemeC =
                                                        referschemelist[index][
                                                                'referral_scheme_c']
                                                            .toString();
                                                    if (drivertextcontroller
                                                        .text.isEmpty) {
                                                      Fluttertoast.showToast(
                                                        msg: AppLocalizations
                                                                .of(context)!
                                                            .pleaseentername,
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                      );
                                                    } else if (mobiletextcontroller
                                                        .text.isEmpty) {
                                                      Fluttertoast.showToast(
                                                        msg: AppLocalizations
                                                                .of(context)!
                                                            .pleaseentermobilenumber,
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                      );
                                                    } else {
                                                      sessionManager
                                                          .internetcheck()
                                                          .then(
                                                              (intenet) async {
                                                        if (intenet) {
                                                          //utility.showYourpopupinternetstatus(context);
                                                          adddriver(
                                                              referrralid,
                                                              referralSchemeC,
                                                              drivertextcontroller
                                                                  .text,
                                                              mobiletextcontroller
                                                                  .text);
                                                          setState(() {
                                                            cardexpandedstatus =
                                                                "false";
                                                          });
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
                                                              CustomSnackBar.error(
                                                                message: AppLocalizations.of(context)!
                                                                    .pleasecheckinternetconnection,
                                                              ),
                                                            );
                                                          });

                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20,
                                                            left: 10,
                                                            right: 0),
                                                    height: 30,
                                                    // width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              HexColor(
                                                                  Colorscommon
                                                                      .greendark),
                                                              HexColor(
                                                                  Colorscommon
                                                                      .greendark),
                                                            ])),
                                                    child: Center(
                                                        child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .submit,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: (AppLocalizations.of(
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
                                                              ? 13
                                                              : 14,
                                                          fontFamily:
                                                              'AvenirLTStd-Black',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Bouncing(
                                                  onPress: () {
                                                    // print("1234");
                                                    setState(() {
                                                      cardexpandedstatus =
                                                          "false";
                                                    });
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20,
                                                            left: 10,
                                                            right: 0),
                                                    height: 30,
                                                    // width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: HexColor(
                                                                Colorscommon
                                                                    .greencolor))),
                                                    child: Center(
                                                        child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancel,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: (AppLocalizations.of(
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
                                                              ? 13
                                                              : 14,
                                                          fontFamily:
                                                              'AvenirLTStd-Black',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    Card(
                      color: Colors.white,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // if you need this
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              HexColor(Colorscommon.greendark2),
                          // here for close state
                          colorScheme: ColorScheme.light(
                            surface: HexColor(Colorscommon.greendark2),
                          ),
                          // here for open state in replacement of deprecated accentColor
                          dividerColor: Colors
                              .transparent, // if you want to remove the border
                        ),
                        child: ExpansionTile(
                          backgroundColor: Colors.white,
                          iconColor: HexColor(Colorscommon.greendark2),
                          title: Row(
                            children: [
                              Icon(
                                Icons.add_business_rounded,
                                color: HexColor(Colorscommon.greendark2),
                              ),
                              Visibility(
                                visible: tileexpanded == "true",
                                child: Text(
                                  "${driverreferrallist.length.toString()}  $referdrivertext",
                                  style: TextStyle(
                                      fontSize:
                                          (AppLocalizations.of(context)!.id ==
                                                      "ஐடி" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "ಐಡಿ")
                                              ? 13
                                              : 15,
                                      fontFamily: "AvenirLTStd-Black",
                                      fontWeight: FontWeight.w500,
                                      color: HexColor(Colorscommon.greendark2)),
                                ),
                              ),
                              Visibility(
                                visible: tileexpanded == "false",
                                child: Text(
                                  "${driverreferrallist.length.toString()} $referdrivertext",
                                  style: TextStyle(
                                      fontSize:
                                          (AppLocalizations.of(context)!.id ==
                                                      "ஐடி" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "ಐಡಿ")
                                              ? 13
                                              : 15,
                                      fontFamily: "Avenir LT Std 65 Medium",
                                      fontWeight: FontWeight.w500,
                                      color: HexColor(Colorscommon.greendark2)),
                                ),
                              )
                            ],
                          ),
                          // trailing: const SizedBox(),

                          onExpansionChanged: (bool val) {
                            // print(val.toString());
                            setState(() {
                              tileexpanded = val.toString();
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Avenirtextmedium(
                                      customfontweight: FontWeight.w500,
                                      fontsize:
                                          (AppLocalizations.of(context)!.id ==
                                                      "ஐடி" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "ಐಡಿ")
                                              ? 13
                                              : 15,
                                      text: AppLocalizations.of(context)!.name,
                                      textcolor:
                                          HexColor(Colorscommon.greenlight2),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Avenirtextmedium(
                                        customfontweight: FontWeight.w500,
                                        fontsize: 15,
                                        text: ' ',
                                        textcolor:
                                            HexColor(Colorscommon.greenlight2),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Avenirtextmedium(
                                      customfontweight: FontWeight.w500,
                                      fontsize:
                                          (AppLocalizations.of(context)!.id ==
                                                      "ஐடி" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "ಐಡಿ")
                                              ? 13
                                              : 15,
                                      text:
                                          AppLocalizations.of(context)!.mobile,
                                      textcolor:
                                          HexColor(Colorscommon.greenlight2),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Avenirtextmedium(
                                      customfontweight: FontWeight.w500,
                                      fontsize: 15,
                                      text: ' ',
                                      textcolor:
                                          HexColor(Colorscommon.greenlight2),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Avenirtextmedium(
                                      customfontweight: FontWeight.w500,
                                      fontsize:
                                          (AppLocalizations.of(context)!.id ==
                                                      "ஐடி" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!
                                                          .id ==
                                                      "ಐಡಿ")
                                              ? 13
                                              : 15,
                                      text:
                                          AppLocalizations.of(context)!.status,
                                      textcolor:
                                          HexColor(Colorscommon.greenlight2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Divider(
                                color: HexColor(Colorscommon.greydark2),
                                thickness: 1,
                              ),
                            ),
                            ListView.separated(
                                separatorBuilder: (_, __) => Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Divider(
                                        color: HexColor(Colorscommon.greydark2),
                                        thickness: .5,
                                      ),
                                    ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: driverreferrallist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            customfontweight: FontWeight.w500,
                                            fontsize: 14,
                                            text: driverreferrallist[index]
                                                    ["name"]
                                                .toString(),
                                            textcolor: HexColor(
                                                Colorscommon.greydark2),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Avenirtextmedium(
                                              customfontweight: FontWeight.w500,
                                              fontsize: 15,
                                              text: ' ',
                                              textcolor: HexColor(
                                                  Colorscommon.greenlight2),
                                            )),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            customfontweight: FontWeight.w500,
                                            fontsize: 14,
                                            text: driverreferrallist[index]
                                                    ["mobileno"]
                                                .toString(),
                                            textcolor: HexColor(
                                                Colorscommon.greydark2),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Avenirtextmedium(
                                              customfontweight: FontWeight.w500,
                                              fontsize: 15,
                                              text: ' ',
                                              textcolor: HexColor(
                                                  Colorscommon.greenlight2),
                                            )),
                                        Expanded(
                                          flex: 2,
                                          child: Avenirtextbook(
                                            customfontweight: FontWeight.w500,
                                            fontsize: 14,
                                            text: driverreferrallist[index]
                                                    ["status"]
                                                .toString(),
                                            textcolor: HexColor(
                                                Colorscommon.greydark2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // Site Wise SP Requirement Inside Card with fixed size
                          Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                color: HexColor(Colorscommon.greendark2)
                                    .withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            elevation: 3,
                            key: UniqueKey(),
                            child: SizedBox(
                              width: double.infinity,
                              height: 300, // Fixed height
                              child: Scrollbar(
                                thumbVisibility: true,
                                // Always show the scrollbar
                                thickness: 6.0,
                                // Set the thickness of the scrollbar
                                radius: Radius.circular(8),
                                // hoverThickness: 6.0,
                                trackVisibility: true,
                                // Add Scrollbar here
                                child: isLoadingSidedata
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<
                                                      Color>(
                                                  HexColor(Colorscommon
                                                      .greendark2)), // You can change color
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              "Loading ...",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              // Heading and other content inside the card
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Text(
                                                  "Site Wise SP Requirement",
                                                  style: TextStyle(
                                                    fontSize: (AppLocalizations.of(
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
                                                        ? 13
                                                        : 15,
                                                    fontFamily:
                                                        "AvenirLTStd-Black",
                                                    fontWeight: FontWeight.w500,
                                                    color: HexColor(Colorscommon
                                                        .greendark2),
                                                  ),
                                                ),
                                              ),
                                              siteData.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                        "No site sp required data available",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    )
                                                  : SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: DataTable(
                                                        columnSpacing: 20.0,
                                                        horizontalMargin: 15.0,
                                                        headingRowHeight: 40,
                                                        dataRowHeight: 35,
                                                        headingRowColor:
                                                            MaterialStateProperty
                                                                .resolveWith(
                                                          (states) => Colors
                                                              .white, // Changed to HexColor
                                                        ),
                                                        border: TableBorder(
                                                          horizontalInside:
                                                              BorderSide(
                                                            color: HexColor(
                                                                Colorscommon
                                                                    .greendark2),
                                                            width: 1,
                                                          ),
                                                          verticalInside:
                                                              BorderSide(
                                                            color: HexColor(
                                                                Colorscommon
                                                                    .greendark2),
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          top: BorderSide(
                                                            color: HexColor(
                                                                Colorscommon
                                                                    .greendark2),
                                                            width: 1,
                                                          ),
                                                          bottom: BorderSide(
                                                            color: HexColor(
                                                                Colorscommon
                                                                    .greendark2),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        dataRowColor:
                                                            MaterialStateProperty
                                                                .resolveWith(
                                                          (states) =>
                                                              Colors.white,
                                                        ),
                                                        columns: [
                                                          DataColumn(
                                                            label: Center(

                                                              child: Text(
                                                                "Site Location",
                                                                style: TextStyle(
                                                                  fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "आयडी" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "ಐಡಿ")
                                                                      ? 13
                                                                      : 15,
                                                                  fontFamily:
                                                                      "AvenirLTStd-Black",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .greendark2),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              "Sp Required",
                                                              style: TextStyle(
                                                                fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "आयडी" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "ಐಡಿ")
                                                                    ? 13
                                                                    : 15,
                                                                fontFamily:
                                                                    "AvenirLTStd-Black",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: HexColor(
                                                                    Colorscommon
                                                                        .greendark2),
                                                              ),
                                                            ),
                                                          ),
                                                          // DataColumn(
                                                          //   label: Text(
                                                          //     "Site Code",
                                                          //     style: TextStyle(
                                                          //       fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                          //           AppLocalizations.of(context)!.id == "आयडी" ||
                                                          //           AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                          //           ? 13
                                                          //           : 15,
                                                          //       fontFamily: "AvenirLTStd-Black",
                                                          //       fontWeight: FontWeight.w500,
                                                          //       color: HexColor(Colorscommon.greendark2),
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                        ],
                                                        rows: siteData
                                                            .map((data) {
                                                          return DataRow(
                                                            color:
                                                                MaterialStateProperty
                                                                    .resolveWith(
                                                              (states) =>
                                                                  siteData.indexOf(
                                                                                  data) %
                                                                              2 ==
                                                                          0
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .white,
                                                            ),
                                                            cells: [
                                                              DataCell(
                                                                Text(
                                                                  formatText(data['site_location']?.toString() ?? 'N/A'),
                                                                  style: TextStyle(fontSize: 14),
                                                                ),
                                                              ),

                                                              DataCell(
                                                                Center(
                                                                  child: Text(
                                                                    data['referral_needed']
                                                                            ?.toString() ??
                                                                        'N/A',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              ),
                                                              // DataCell(
                                                              //   Align(
                                                              //     alignment: Alignment.centerLeft, // Centered "Site Code"
                                                              //     child: Text(
                                                              //       data['site_code']?.toString() ?? 'N/A',
                                                              //       style: TextStyle(fontSize: 14),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // City Wise SP Requirement Inside Card with fixed size
                          Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                color: HexColor(Colorscommon.greendark2)
                                    .withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            elevation: 3,
                            key: UniqueKey(),
                            child: SizedBox(
                              width: double.infinity, // Full width
                              height: 300, // Fixed height
                              child: Scrollbar(
                                // Add Scrollbar here
                                thumbVisibility: true,
                                // Always show the scrollbar
                                thickness: 6.0,
                                // Set the thickness of the scrollbar
                                radius: Radius.circular(8),
                                //hoverThickness: 6.0,
                                trackVisibility: true,
                                // Add Scrollbar here
                                child: isLoadingSidedata1
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<
                                                      Color>(
                                                  HexColor(Colorscommon
                                                      .greendark2)), // You can change color
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              "Loading ...",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        // Wrap with SingleChildScrollView
                                        child: Column(
                                          children: [
                                            // Heading and other content inside the card
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Text(
                                                "City Wise SP Requirement",
                                                style: TextStyle(
                                                  fontSize: (AppLocalizations.of(
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
                                                      ? 13
                                                      : 15,
                                                  fontFamily:
                                                      "AvenirLTStd-Black",
                                                  fontWeight: FontWeight.w500,
                                                  color: HexColor(
                                                      Colorscommon.greendark2),
                                                ),
                                              ),
                                            ),
                                            cityData.isEmpty
                                                ? Center(
                                                    child: Text(
                                                      "No city referral data available",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                  )
                                                : SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: DataTable(
                                                      columnSpacing: 65.0,
                                                      horizontalMargin: 15.0,
                                                      headingRowHeight: 35,
                                                      dataRowHeight: 30,
                                                      headingRowColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                        (states) =>
                                                            Colors.white,
                                                      ),
                                                      border: TableBorder(
                                                        horizontalInside:
                                                            BorderSide(
                                                          color: HexColor(
                                                              Colorscommon
                                                                  .greendark2),
                                                          width: 1,
                                                        ),
                                                        verticalInside:
                                                            BorderSide(
                                                          color: HexColor(
                                                              Colorscommon
                                                                  .greendark2),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        top: BorderSide(
                                                          color: HexColor(
                                                              Colorscommon
                                                                  .greendark2),
                                                          width: 1,
                                                        ),
                                                        bottom: BorderSide(
                                                          color: HexColor(
                                                              Colorscommon
                                                                  .greendark2),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      dataRowColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                        (states) =>
                                                            Colors.white,
                                                      ),
                                                      columns: [
                                                        DataColumn(
                                                          label: Text(
                                                            "City Code",
                                                            style: TextStyle(
                                                              fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                      AppLocalizations.of(context)!
                                                                              .id ==
                                                                          "आयडी" ||
                                                                      AppLocalizations.of(context)!
                                                                              .id ==
                                                                          "ಐಡಿ")
                                                                  ? 13
                                                                  : 15,
                                                              fontFamily:
                                                                  "AvenirLTStd-Black",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: HexColor(
                                                                  Colorscommon
                                                                      .greendark2),
                                                            ),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Text(
                                                            "Sp Required",
                                                            style: TextStyle(
                                                              fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                      AppLocalizations.of(context)!
                                                                              .id ==
                                                                          "आयडी" ||
                                                                      AppLocalizations.of(context)!
                                                                              .id ==
                                                                          "ಐಡಿ")
                                                                  ? 13
                                                                  : 15,
                                                              fontFamily:
                                                                  "AvenirLTStd-Black",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: HexColor(
                                                                  Colorscommon
                                                                      .greendark2),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      rows:
                                                          cityData.map((data) {
                                                        return DataRow(
                                                          color:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                            (states) =>
                                                                cityData.indexOf(data) %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .white,
                                                          ),
                                                          cells: [
                                                            DataCell(
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  data['city_code']
                                                                          ?.toString() ??
                                                                      'N/A',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Center(
                                                                child: Text(
                                                                  data['referral_needed']
                                                                          ?.toString() ??
                                                                      'N/A',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList(),
                                                    ),

                                                  ),

                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatText(String text) {
    final words = text.split(' '); // Split text into words
    StringBuffer formattedText = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      formattedText.write(words[i]);

      // Add a newline after every 3 words
      if ((i + 1) % 3 == 0 && i != words.length - 1) {
        formattedText.write('\n');
      } else if (i != words.length - 1) {
        formattedText.write(' ');
      }
    }

    return formattedText.toString();
  }

}
