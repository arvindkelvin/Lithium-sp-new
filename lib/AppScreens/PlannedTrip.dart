import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:flutter_application_sfdc_idp/widget/language_picker_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../l10n/app_localizations.dart';

SessionManager sessionManager = SessionManager();

class PlannedTrip extends StatefulWidget {
  const PlannedTrip({Key? key}) : super(key: key);

  @override
  State<PlannedTrip> createState() => _PlannedTripState();
}

class _PlannedTripState extends State<PlannedTrip> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  Utility utility = Utility();
  bool isdata = false;
  bool isloading = true;
  bool _fingerValue = false;
  String? _fingerValuestr;
  bool isexpanded = false;
  List cardexpandedstatuslist = [];
  List triplistdata = [];
  Map<String, dynamic> jsonInput = {};
  bool refreshbool = false;

  @override
  void initState() {
    super.initState();
    // LocalNotificationService.initialize(context);
    //utility.showYourpopupinternetstatus(context);
   // if (Platform.isAndroid) WebView.platform = AndroidWebView();
    utility.GetUserdata().then((value) => {
          Getdata(),
          getplannedtriplist(),
          setState(() {}),
        });
  }

  Getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fingerValue = prefs.getBool('fprint') ?? false;
    _fingerValuestr = prefs.getString('Fingershow');

    setState(() {});
  }



  Future<void> getplannedtriplist() async {
   // var url = Uri.parse("http://10.10.14.14:8092/webservice");
    var url = Uri.parse(CommonURL.localone);
    isloading = true;

    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    // Create a JSON-encoded string for the data field
    String dataJson = jsonEncode([
      {
        "service_provider": utility.service_provider_c, // Replace with appropriate value
      }
    ]);

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(headers)
      ..fields['from'] = "tripDetails"
      ..fields['data'] = dataJson
      ..fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    print("tripDetails postdata = $url ${request.fields}");

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      print("tripDetails status code = ${response.statusCode}");
      isloading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonInput = jsonDecode(response.body);

        String status = jsonInput['status'].toString();

        if (status == 'true') {
          var data = jsonInput["data"];

          if (data != null && data is List && data.isNotEmpty) {
            triplistdata = data;
            isdata = true;
            print("triplistdata = $triplistdata");
          } else {
            isdata = false;
            print("No data available.");
          }
        } else {
          Fluttertoast.showToast(
            msg: jsonInput['message'].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.somethingwentwrong,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      Fluttertoast.showToast(
        msg: "An error occurred: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }


  //
  // Future getplannedtriplist() async {
  //   var url = Uri.parse(CommonURL.localone);
  //   isloading = true;
  //
  //   Map<String, String> headers = {
  //     'Content-type': 'application/x-www-form-urlencoded',
  //     'Accept': 'application/json',
  //   };
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "tripDetails";
  //   request.fields['idUser'] = utility.userid;
  //   request.fields['lithiumID'] = utility.lithiumid;
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //   request.fields['languageType'] =
  //       AppLocalizations.of(context)!.languagecode.toString();
  //
  //   print("tripDetails postdata = $url ${request.fields}");
  //
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //
  //   print("tripDetails statuscode = ${response.statusCode}");
  //   isloading = false;
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //      jsonInput = jsonDecode(response.body);
  //
  //     String status = jsonInput['status'].toString();
  //
  //     if (status == 'true') {
  //
  //       triplistdata = jsonInput["data"];
  //       print("triplistdata == $triplistdata");
  //       if (triplistdata.isNotEmpty) {
  //         isdata = true;
  //       }
  //       print("get tripDetails jsonInput = $triplistdata");
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: AppLocalizations.of(context)!.somethingwentwrong,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //     );
  //   }
  //
  //   setState(() {});
  // }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    getplannedtriplist();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    getplannedtriplist();
    if(mounted)
      setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: HexColor(Colorscommon.greenAppcolor),
            centerTitle: true,
            leading: Container(),
            title: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.plannedtrips,
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
                Text(
                  "(" + utility.Todaystr + ")",
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
              ],
            ),
            shape: CustomAppBarShape(),
          ),
        ),
        body: Container(
          color: HexColor(Colorscommon.backgroundcolor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: !isdata,
                child: !isloading
                    ? Container(
                        margin: const EdgeInsets.all(10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No Data Available',
                                style: TextStyle(
                                    color: HexColor(Colorscommon.redcolor),
                                    fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: IconButton(onPressed: () {
                                  setState(() {
                                    refreshbool = true;
                                  });
                                  getplannedtriplist();
                                }, icon: Icon(Icons.refresh,
                                    size: 20,color: Colors.red) /*: Transform.rotate(
                                  angle: 180 * math.pi / 180,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.refresh,
                                        color: Colors.red,size: 20
                                      ),onPressed: () {
                                    setState(() {
                                      refreshbool = false;
                                      getplannedtriplist();
                                    });
                                  },))*/
                                ),
                              )
                            ],
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
                                borderRadius: BorderRadius.circular(
                                    10), // if you need this
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
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: const WaterDropHeader(),
                      footer: CustomFooter(
                        builder: (BuildContext context,LoadStatus? mode){
                          Widget body ;
                          if(mode==LoadStatus.idle){
                            body =  Text("");
                          }
                          else if(mode==LoadStatus.loading){
                            body =  const CupertinoActivityIndicator();
                          }
                          else if(mode == LoadStatus.failed){
                            body = const Text("Load Failed!Click retry!");
                          }
                          else if(mode == LoadStatus.canLoading){
                            body = const Text("release to load more");
                          }
                          else{
                            body = const Text("No more Data");
                          }
                          return SizedBox(
                            height: 55.0,
                            child: Center(child:body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: triplistdata.length,
                          itemBuilder: (context, index) {
                            String cardexpandedstatus = "false";
                            cardexpandedstatuslist.add(cardexpandedstatus);

                            return Card(
                              margin: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                // if you need this
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              elevation: 3,
                              key: UniqueKey(),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(children: [
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Avenirtextmedium(
                                            text: "Trip Time",
                                            fontsize: 15,
                                            textcolor:
                                                HexColor(Colorscommon.greendark),
                                            customfontweight: FontWeight.w500),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Avenirtextmedium(
                                            text: triplistdata[index]
                                                ["trip_time"]??"N/A",
                                            fontsize: 15,
                                            textcolor:
                                                HexColor(Colorscommon.greydark2),
                                            customfontweight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Row(
                                  //   // ignore: prefer_const_literals_to_create_immutables
                                  //   children: [
                                  //     Expanded(
                                  //       flex: 1,
                                  //       child: Avenirtextmedium(
                                  //           text: "Trip createddate",
                                  //           fontsize: 15,
                                  //           textcolor:
                                  //           HexColor(Colorscommon.greendark),
                                  //           customfontweight: FontWeight.w500),
                                  //     ),
                                  //     Expanded(
                                  //       flex: 1,
                                  //       child: Avenirtextmedium(
                                  //           text: triplistdata[index]
                                  //           ["createddate"],
                                  //           fontsize: 15,
                                  //           textcolor:
                                  //           HexColor(Colorscommon.greydark2),
                                  //           customfontweight: FontWeight.w500),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 10),
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Avenirtextmedium(
                                            text: "Trip Type",
                                            fontsize: 15,
                                            textcolor:
                                                HexColor(Colorscommon.greendark),
                                            customfontweight: FontWeight.w500),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Avenirtextmedium(
                                            text: triplistdata[index]
                                                ["trip_type"]??"N/A",
                                            fontsize: 15,
                                            textcolor:
                                                HexColor(Colorscommon.greydark2),
                                            customfontweight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Avenirtextmedium(
                                            text: "Parent Site",
                                            fontsize: 15,
                                            textcolor:
                                            HexColor(Colorscommon.greendark),
                                            customfontweight: FontWeight.w500),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Avenirtextmedium(
                                            text: triplistdata[index]
                                            ['campusname']??"N/A",
                                            fontsize: 15,
                                            textcolor:
                                            HexColor(Colorscommon.greydark2),
                                            customfontweight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: HexColor(
                                                Colorscommon.greenlight2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                    ?.viewmore ??
                                                "View more",
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontFamily: "AvenirLTStd-Black"),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              cardexpandedstatuslist[index] =
                                                  "true";
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible:
                                        cardexpandedstatuslist[index] != "false",
                                    child: const Divider(),
                                  ),
                                  Visibility(
                                    visible:
                                        cardexpandedstatuslist[index] != "false",
                                    child: Row(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Text(
                                          "More Details",
                                          style: TextStyle(
                                              fontSize: (AppLocalizations.of(
                                                                  context)
                                                              ?.id ==
                                                          "ஐடி" ||
                                                      AppLocalizations.of(context)
                                                              ?.id ==
                                                          "आयडी" ||
                                                      AppLocalizations.of(context)
                                                              ?.id ==
                                                          "ಐಡಿ")
                                                  ? 13
                                                  : 15,
                                              fontFamily: "AvenirLTStd-Black",
                                              fontWeight: FontWeight.w500,
                                              color: HexColor(
                                                  Colorscommon.greendark)),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        cardexpandedstatuslist[index] != "false",
                                    child: const SizedBox(
                                      height: 10,
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        cardexpandedstatuslist[index] != "false",
                                    child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(
                                            top: 5, right: 10, left: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                      text: "Site Manager Number",
                                                      fontsize: (AppLocalizations.of(
                                                          context)
                                                          ?.id ==
                                                          "ஐடி" ||
                                                          AppLocalizations.of(
                                                              context)
                                                              ?.id ==
                                                              "आयडी" ||
                                                          AppLocalizations.of(
                                                              context)
                                                              ?.id ==
                                                              "ಐಡಿ")
                                                          ? 13
                                                          : 15,
                                                      textcolor: HexColor(
                                                          Colorscommon.greendark),
                                                      customfontweight:
                                                      FontWeight.w500),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                  Avenirtextmedium(
                                                    text: triplistdata[index]["site_desk_number"] != null
                                                        ? (triplistdata[index]["site_desk_number"].startsWith("+91")
                                                        ? triplistdata[index]["site_desk_number"].substring(3)
                                                        : triplistdata[index]["site_desk_number"])
                                                        : "N/A", // Provide a default value like "N/A" or handle it appropriately
                                                    fontsize: (AppLocalizations.of(context)?.id == "ஐடி" ||
                                                        AppLocalizations.of(context)?.id == "आयडी" ||
                                                        AppLocalizations.of(context)?.id == "ಐಡಿ")
                                                        ? 13
                                                        : 15,
                                                    textcolor: HexColor(Colorscommon.greydark2),
                                                    customfontweight: FontWeight.w500,
                                                  )

                                                  // Avenirtextmedium(
                                                  //     text: triplistdata[index]["site_desk_number"].startsWith("+91")
                                                  //         ? triplistdata[index]["site_desk_number"].substring(3)
                                                  //         : triplistdata[index]["site_desk_number"],
                                                  //     fontsize: (AppLocalizations.of(context)?.id == "ஐடி" ||
                                                  //         AppLocalizations.of(context)?.id == "आयडी" ||
                                                  //         AppLocalizations.of(context)?.id == "ಐಡಿ") ? 13 : 15,
                                                  //     textcolor: HexColor(Colorscommon.greydark2),
                                                  //     customfontweight: FontWeight.w500
                                                  // ),
                                                ),

                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                      text: "Supervisor Number",
                                                      fontsize: (AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ஐடி" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "आयडी" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ಐಡಿ")
                                                          ? 13
                                                          : 15,
                                                      textcolor: HexColor(
                                                          Colorscommon.greendark),
                                                      customfontweight:
                                                          FontWeight.w500),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                      // text: triplistdata[index]
                                                      //     ["supervisor_number"].toString(),
                                                      text: triplistdata[index]
                                                          ["supervisor_number"]??"N/A",
                                                      fontsize: (AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ஐடி" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "आयडी" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ಐಡಿ")
                                                          ? 13
                                                          : 15,
                                                      textcolor: HexColor(
                                                          Colorscommon.greydark2),
                                                      customfontweight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                      text: "Vehicle",
                                                      fontsize: 15,
                                                      textcolor:
                                                      HexColor(Colorscommon.greendark),
                                                      customfontweight: FontWeight.w500),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                    //  text: triplistdata[index]["name"].toString(),
                                                      text: triplistdata[index]["name"] ?? "N/A",
                                                      fontsize: 15,
                                                      textcolor:
                                                      HexColor(Colorscommon.greydark2),
                                                      customfontweight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                      text: "ETMS App",
                                                      fontsize: (AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ஐடி" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "आयडी" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ಐಡಿ")
                                                          ? 13
                                                          : 15,
                                                      textcolor: HexColor(
                                                          Colorscommon.greendark),
                                                      customfontweight:
                                                          FontWeight.w500),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                      text: triplistdata[index]
                                                          ["etms_app"]??"N/A",
                                                      fontsize: (AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ஐடி" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "आयडी" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ಐಡಿ")
                                                          ? 13
                                                          : 15,
                                                      textcolor: HexColor(
                                                          Colorscommon.greydark2),
                                                      customfontweight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                      text: "Comments",
                                                      fontsize: (AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ஐடி" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "आयडी" ||
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.id ==
                                                                  "ಐಡಿ")
                                                          ? 13
                                                          : 15,
                                                      textcolor: HexColor(
                                                          Colorscommon.greendark),
                                                      customfontweight:
                                                          FontWeight.w500),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Avenirtextmedium(
                                                    text: triplistdata[index]["comments"] ?? "N/A", // Use an empty string if comments is null
                                                    fontsize: (AppLocalizations.of(context)?.id == "ஐடி" ||
                                                        AppLocalizations.of(context)?.id == "आयडी" ||
                                                        AppLocalizations.of(context)?.id == "ಐಡಿ")
                                                        ? 13
                                                        : 15,
                                                    textcolor: HexColor(Colorscommon.greydark2),
                                                    customfontweight: FontWeight.w500,
                                                  ),
                                                )

                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Bouncing(
                                                  onPress: () {
                                                    // print("1234");
                                                    setState(() {
                                                      cardexpandedstatuslist[
                                                          index] = "false";
                                                    });
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                        top: 20,
                                                        left: 10,
                                                        right: 0),
                                                    height: 30,
                                                    // width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        border: Border.all(
                                                            color: HexColor(
                                                                Colorscommon
                                                                    .greencolor))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                    context)
                                                                ?.close ??
                                                            "Close",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: (AppLocalizations.of(
                                                                                context)
                                                                            ?.id ==
                                                                        "ஐடி" ||
                                                                    AppLocalizations.of(
                                                                                context)
                                                                            ?.id ==
                                                                        "आयडी" ||
                                                                    AppLocalizations.of(
                                                                                context)
                                                                            ?.id ==
                                                                        "ಐಡಿ")
                                                                ? 13
                                                                : 14,
                                                            fontFamily:
                                                                'AvenirLTStd-Black',
                                                            fontWeight:
                                                                FontWeight.w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                ]),
                              ),
                            );
                          }),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

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
