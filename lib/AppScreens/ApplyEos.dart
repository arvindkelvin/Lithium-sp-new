import 'dart:convert';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../Login.dart';
import '../l10n/app_localizations.dart';

class ApplyEos extends StatefulWidget {
  @override
  _ApplyEos createState() => _ApplyEos();
}

class _ApplyEos extends State<ApplyEos> {
  Utility utility = Utility();

  String? fromdate;
  String? fromdatesend;
  String? todate;
  String? todatesend;
  String? punchType;
  String? newValue;
  bool isdata = false;
  bool isloading = false;
  String? fromdatevaild;

  // Initial Selected Value
  String? dropdownvalue;
  String? reasonidsend;

  // Li.st of items in our dropdown menu
  List<String> reasonnamearray = [];
  List<String> reasonidarray = [];
  List last5eoslistarray = [];

  SessionManager sessionManager = SessionManager();
  // late Future<List<Missedlist>> futurelist;
  // ApplyEosModel ApplyEosModel = null;
  // Missedlist missedlist = null;
  @override
  void initState() {
    // utility.GetUserdata().then(() => {});
    // utility.GetUserdata().then((_) {
     //geteoslist();
    //geteoslast5list();
    // });
    super.initState();
    //AppVersionCheck().checkForUpdate(context, isLoginPage: false);
    //VersionChecker().checkVersion(context, isLoginPage: false);



    utility.GetUserdata().then((value) => {
      sessionManager.internetcheck().then((intenet) async {
        if (intenet) {
          //utility.showYourpopupinternetstatus(context);
          // checkupdate(_30minstr);

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
      geteoslist(),
      geteoslast5list(),
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CommonAppbar(
            title: AppLocalizations.of(context)!.apply_EOS,
            appBar: AppBar(),
            widgets: const [],
          ),
        ),
        body: Container(
          color: HexColor(Colorscommon.backgroundcolor),
          // color: Colors.grey.shade200,
          margin: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.width / 2 - 30,
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 10, right: 10, left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!
                                        .id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ")
                                        ? 12
                                        : 14,
                                    text: AppLocalizations.of(context)!.from,
                                    textcolor: HexColor(Colorscommon.greendark),
                                  ),
                                  // child: Text(
                                  //   "From",
                                  //   textAlign: TextAlign.start,
                                  //   // textDirection: TextDirection.ltr,
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       color:
                                  //           HexColor(Colorscommon.greendark)),
                                  // ),
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: GestureDetector(
                                  onTap: () {
                                    Future<String> fromdatee =
                                    utility.Displaydate(
                                        context, "2", "0", "", "");

                                    fromdatee.then((value) {
                                      //debugPrint("datepick" + value.toString());
                                      fromdatevaild = value.toString();
                                      fromdatesend = utility.DateConvert3(
                                          value.toString());

                                      setState(() {
                                        fromdate = utility.DateConvertINDIA1(
                                            value.toString());
                                        todate = null;
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.only(
                                        right: 15.0,
                                        left: 15.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: const ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                    ),
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(color: Colors.blueAccent)),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/DateInput.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                        // Icon(
                                        //   Icons.calendar_month_outlined,
                                        //   color:
                                        //       HexColor(Colorscommon.greendark),
                                        // ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 5),
                                            child: Avenirtextbook(
                                              customfontweight:
                                              FontWeight.normal,
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
                                              text: fromdate ?? "Select Date",
                                              textcolor: HexColor(
                                                  Colorscommon.greydark2),
                                            ),
                                          ),
                                          // child: Text(
                                          //   fromdate ?? "Select Date",
                                          //   // textAlign: TextAlign.center,
                                          //   style: TextStyle(
                                          //       color: HexColor(
                                          //           Colorscommon.greydark2)),
                                          // ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 10, right: 10, left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!
                                        .id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ")
                                        ? 12
                                        : 14,
                                    text: AppLocalizations.of(context)!.to,
                                    textcolor: HexColor(Colorscommon.greendark),
                                  ),
                                  // child: Text(
                                  //   "To",
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       color:
                                  //           HexColor(Colorscommon.greendark)),
                                  // ),
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: GestureDetector(
                                  onTap: () {
                                    if (fromdate == null) {
                                      Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)!
                                            .selectfromdate,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    } else {
                                      Future<String> fromdatee =
                                      utility.Displaydate(context, "2", "1",
                                          fromdatevaild ?? "", "1");

                                      fromdatee.then((value) {
                                        //("datepick" + value.toString());
                                        todatesend = utility.DateConvert3(
                                            value.toString());

                                        setState(() {
                                          todate = utility.DateConvertINDIA1(
                                              value.toString());
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.only(
                                        right: 15.0,
                                        left: 15.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: const ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                      color: Colors.white,
                                    ),
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(color: Colors.blueAccent)),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/DateInput.png"),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                        // Icon(
                                        //   Icons.calendar_month_outlined,
                                        //   color:
                                        //       HexColor(Colorscommon.greendark),
                                        // ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 5),
                                            child: Avenirtextbook(
                                              customfontweight:
                                              FontWeight.normal,
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
                                              text: todate ?? "Select Date",
                                              textcolor: HexColor(
                                                  Colorscommon.greydark2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                        margin:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Avenirtextmedium(
                            customfontweight: FontWeight.w500,
                            fontsize: (AppLocalizations.of(context)!.id ==
                                "ஐடி" ||
                                AppLocalizations.of(context)!.id ==
                                    "आयडी" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ")
                                ? 12
                                : 14,
                            text: AppLocalizations.of(context)!.reason,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 40,
                              margin: const EdgeInsets.only(
                                  right: 15.0,
                                  left: 15.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                ),
                                color: Colors.white,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    canvasColor: Colors.grey.shade100),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    hint: Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                            AssetImage("assets/Reason.png"),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text("Select Reason")
                                    ]),

                                    style: TextStyle(
                                        fontSize: (AppLocalizations.of(context)!
                                            .id ==
                                            "ஐடி" ||
                                            AppLocalizations.of(context)!
                                                .id ==
                                                "आयडी" ||
                                            AppLocalizations.of(context)!
                                                .id ==
                                                "ಐಡಿ")
                                            ? 12
                                            : 14,
                                        fontFamily: 'AvenirLTStd-Book',
                                        color:
                                        HexColor(Colorscommon.greydark2)),
                                    elevation: 0,
                                    value: dropdownvalue,
                                    items: reasonnamearray.map((items) {
                                      return DropdownMenuItem(
                                          value: items,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/Reason.png"),
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                items.toString(),
                                              ),
                                            ],
                                          ));
                                    }).toList(),

                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: HexColor(Colorscommon.greenlight2),
                                    ),
                                    onChanged: (value) {
                                      dropdownvalue = value.toString();
                                      for (int i = 0;
                                      i < reasonnamearray.length;
                                      i++) {
                                        // print(jsonInput['data'][i]);
                                        if (dropdownvalue ==
                                            reasonnamearray[i].toString()) {
                                          reasonidsend =
                                              reasonidarray[i].toString();
                                        }
                                      }

                                      setState(() {});
                                      // for (int i = 0;
                                      //     i < data["devliverypoints"].length;
                                      //     i++) {
                                      //   if (value ==
                                      //       data["devliverypoints"][i]
                                      //               ["warehouseName"]
                                      //           .toString()) {
                                      //     dropdownvalue = value.toString();
                                      //     address = data["devliverypoints"][i]
                                      //             ["warehouseAddress"]
                                      //         .toString();
                                      //     idwarehouse = data["devliverypoints"][i]
                                      //             ["idWarehouse"]
                                      //         .toString();
                                      //     // print(data["devliverypoints"][i]
                                      //     //         ["idWarehouse"]
                                      //     //     .toString());
                                      //   }
                                      // }
                                      // setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: 40,
                            margin: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor(Colorscommon.greenlight2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              //                      RaisedButton(
                              // color: HexColor(Colorscommon.greenlight2),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(5)),
                              child: Avenirtextblack(
                                customfontweight: FontWeight.normal,
                                fontsize: (AppLocalizations.of(context)!.id ==
                                    "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ")
                                    ? 12
                                    : 14,
                                text: AppLocalizations.of(context)!.submit,
                                textcolor: Colors.white,
                              ),
                              onPressed: () async {
                                if (fromdatesend == null) {
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .selectfromdate,
                                    gravity: ToastGravity.CENTER,
                                  );
                                } else if (todatesend == null) {
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .selecttodate,
                                    gravity: ToastGravity.CENTER,
                                  );
                                } else if (reasonidsend == null) {
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .pleaseslectroster,
                                    gravity: ToastGravity.CENTER,
                                  );
                                } else {
                                  sessionManager
                                      .internetcheck()
                                      .then((intenet) async {
                                    if (intenet) {
                                      //utility.showYourpopupinternetstatus(context);
                                      loading();
                                      // utility.GetUserdata().then(
                                      addeos(
                                        reasonidsend.toString(),
                                        fromdatesend.toString(),
                                        todatesend.toString(),
                                      );
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
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.all(10),

                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  // shape: const Border(
                  //     right: BorderSide(color: Colors.red, width: 5)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        color: HexColor(Colorscommon.whitecolor),
                        // margin: EdgeInsets.all(20),
                        // width: 100,
                        // margin: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Avenirtextblack(
                            customfontweight: FontWeight.normal,
                            fontsize: (AppLocalizations.of(context)!.id ==
                                "ஐடி" ||
                                AppLocalizations.of(context)!.id ==
                                    "आयडी" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ")
                                ? 15
                                : 21,
                            text: AppLocalizations.of(context)!.lasteos,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                          // child: Text(
                          //   "Last 5 EOS Transactions",
                          //   style: TextStyle(
                          //       color: HexColor(Colorscommon.greenAppcolor),
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 20),
                          // ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 25,
                        color: HexColor(Colorscommon.whitecolor),
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Avenirtextmedium(
                                customfontweight: FontWeight.w500,
                                fontsize: (AppLocalizations.of(context)!.id ==
                                    "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ")
                                    ? 13
                                    : 15,
                                text: AppLocalizations.of(context)!.from,
                                textcolor: HexColor(Colorscommon.greendark),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Avenirtextmedium(
                                customfontweight: FontWeight.w500,
                                fontsize: (AppLocalizations.of(context)!.id ==
                                    "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ")
                                    ? 13
                                    : 15,
                                text: AppLocalizations.of(context)!.to,
                                textcolor: HexColor(Colorscommon.greendark),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!
                                        .id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ")
                                        ? 13
                                        : 15,
                                    text: AppLocalizations.of(context)!.reason,
                                    textcolor: HexColor(Colorscommon.greendark),
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!
                                        .id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ")
                                        ? 13
                                        : 15,
                                    text: AppLocalizations.of(context)!.status,
                                    textcolor: HexColor(Colorscommon.greendark),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black,
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 5, right: 5),
                      ),
                      Visibility(
                        visible: isdata,
                        child: Expanded(
                          // Use ListView.builder

                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: last5eoslistarray.length,
                              itemBuilder: (context, index) {
                                if (last5eoslistarray.isNotEmpty) {

                                  var reasonstr;
                                  if (last5eoslistarray[index]['reason'] == "Family Emergency") {
                                    reasonstr = AppLocalizations.of(context)!.family_emergency.toString();
                                  } else if (last5eoslistarray[index]
                                  ['reason'] == "Festival") {
                                    reasonstr = AppLocalizations.of(context)!.festival.toString();
                                  } else if (last5eoslistarray[index]
                                  ['reason'] == "Personal Reasons") {
                                    reasonstr = AppLocalizations.of(context)!.personal_Reasons.toString();
                                  } else {
                                    reasonstr = last5eoslistarray[index]['reason'].toString();
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300))),
                                    // height: 50,
                                    // In many cases, the key isn't mandatory
                                    key: UniqueKey(),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Avenirtextbook(
                                              customfontweight:
                                              FontWeight.normal,
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
                                              text: last5eoslistarray[index]
                                              ["from_date"]
                                                  .toString(),
                                              textcolor: HexColor(
                                                  Colorscommon.greydark2),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Avenirtextbook(
                                              customfontweight:
                                              FontWeight.normal,
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
                                              text: last5eoslistarray[index]
                                              ["to_date"]
                                                  .toString(),
                                              textcolor: HexColor(
                                                  Colorscommon.greydark2),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  reasonstr.toString(),
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'AvenirLTStd-Book',
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
                                                          ? 12
                                                          : 14,
                                                      color: HexColor(
                                                          Colorscommon
                                                              .greydark2)),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  last5eoslistarray[index]
                                                  ["eos_status_name"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'AvenirLTStd-Book',
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
                                                          ? 12
                                                          : 14,
                                                      color: HexColor(
                                                          Colorscommon
                                                              .greydark2)),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                        replacement: isloading == true
                            ? Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: const Center(
                                child: Text("No Data Available.")))
                            : Expanded(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            // enabled: _enabled,
                            child: ListView.builder(
                              itemBuilder: (_, __) => Padding(
                                padding:
                                const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: 40.0,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              itemCount: 6,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }



  Future<void> geteoslast5list() async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    print(utility.lithiumid);
    print(utility.service_provider_c);

    // Use a JSON-encoded string for the data field
    String dataJson = jsonEncode([
      {
        "lithiumid": utility.lithiumid
      }
    ]);

    var request = http.MultipartRequest("POST", url)
      ..headers.addAll(headers)
      ..fields['from'] = "getLast5EOSDetails"
      ..fields['data'] = dataJson // Add the JSON-encoded string as the 'data' field
      ..fields['idUser'] = utility.userid
      ..fields['service_provider_c'] = utility.service_provider_c
      ..fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      isloading = true;
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);
        print("last5dat: $jsonInput");

        bool status = jsonInput['status'] ?? false;
        String message = jsonInput['message'].toString();

        if (status) {
          isdata = true;
          List<dynamic> array = jsonInput['data'] ?? [];
          if (array.isNotEmpty) {
            last5eoslistarray = array;
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


  geteoslist() async {
    // String url = CommonURL.BASE_URL;
    var url = Uri.parse(CommonURL.localone);
    // String url = CommonURL.URL;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    // var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getEOSActiveReasonList";
    request.fields['idUser'] = utility.userid;
    request.fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    // request.files.add(await http.MultipartFile.fromPath('file', _image.path));

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      // print("loginresponse$jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (status == 'true') {
        List array = jsonInput['data'];
        if (array.isNotEmpty) {
          // if (jsonInput['data'].length.isNotempty) {
          // print(jsonInput['data']);
          for (int i = 0; i < jsonInput['data'].length; i++) {
            print(array[i]['name'].toString());
            if (array[i]['name'].toString() == "Family Emergency") {
              reasonnamearray.add(
                  AppLocalizations.of(context)!.family_emergency.toString());
            } else if (array[i]['name'].toString() == "Festival") {
              reasonnamearray
                  .add(AppLocalizations.of(context)!.festival.toString());
            } else if (array[i]['name'].toString() == "Personal Reasons") {
              reasonnamearray.add(
                  AppLocalizations.of(context)!.personal_Reasons.toString());
            }

            reasonidarray.add(array[i]["id"].toString());
          }
          // }
        }
        setState(() {});
      } else {
        // Navigator.pop(context);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
  }

  void addeos(
      String idReason, String fromdateserver, String todateserver) async {

    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "eosAdd";
    request.fields['idUser'] = utility.userid;
    request.fields['fromDate'] = fromdateserver;
    request.fields['toDate'] = todateserver;
    request.fields['idReason'] = idReason;
    request.fields['reason'] = dropdownvalue!;
    request.fields['service_provider_c'] = utility.service_provider_c;
    request.fields['lithiumID'] = utility.lithiumid.toString();
    request.fields['languageType'] = AppLocalizations.of(context)!.languagecode.toString();

    // request.files.add(await http.MultipartFile.fromPath('file', _image.path));

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    print("eosAdd = ${response.statusCode}, ${request.fields}");
    print("${response.body}");
    print("johnnny n=${utility.service_provider_c.toString()}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("eosAdd = $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (status == 'true') {
        fromdate = "Select Date";
        todate = "Select Date";

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
    Navigator.pop(context);
    geteoslast5list();

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
}
