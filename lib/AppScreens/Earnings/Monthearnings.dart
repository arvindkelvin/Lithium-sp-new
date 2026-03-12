import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Dashboardtabbar.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/Model/MonthlyCategoryDetails.dart';
import 'package:flutter_application_sfdc_idp/Model/MonthlySubCategoryDetails.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../l10n/app_localizations.dart';

class Monthearnings extends StatefulWidget {
  const Monthearnings({Key? key}) : super(key: key);

  @override
  State<Monthearnings> createState() => _MonthearningsState();
}

class _MonthearningsState extends State<Monthearnings> {
  Utility utility = Utility();
  final List<TextEditingController> _controllers = [];
  bool dropdownvaluebool = false;
  String? dropdownvalue;
  late String yearvalue;
  var username = "";
  late String paycycledatevalue;
  late File _image;
  late String sfidstr;
  late String fromDate;
  late String toDate;
  String imgname = '';
  bool imagebool = false;
  bool listloadstatus = false;
  String service_provider = '';
  String? change_date;
  List<dynamic> datedroplist = [];
  String? dropdownvalue2;
  String? fromdate;
  String? isgrivanceshowbymonth = "false";
  String? isWeeklyEarningAlreadyExist = "false";
  String? isNoGrievanceExist = "false";
  String? tripTime;
  String? statusValue;
  String? totalNoOfTripPerformed;
  String? todate;
  List items = [];
  List firstsfidarray = [];
  List items2 = [];
  List monthdetailsarray = [];
  List<dynamic> serviceDayDetails = [];
  List additionDeletionData = [];
  List attendance_datelist = [];
  late String benchFileName;

  // List monthyearningsarray = [];
  String? sp_pay_cycle_start_date__c;
  String? sp_pay_cycle_end_date__c;
  String? showname;
  MonthlyCategoryDetails? monthlyCategoryDetails;
  MonthlySubCategoryDetails? monthlySubCategoryDetails;
  bool isLoading = false;
  bool dataLoaded = false;

  String? total_paid_duty_days;
  String? total_Present_PI;
  String? bench_days;
  String? total_bench;
  String? training_days;
  String? total_training;
  String? EOS;
  String? UEOS;
  String? Unauthorised_EOS;
  String? WEOS;
  String? Weekly_Off;
  String? Extra_Hours;
  String? Extra_Hours1;
  String? Late;
  String? Late_Amount;
  String? Referral_Bonus;
  String? Service_Day_Bonus;
  String? trip_incentive;
  String? No_of_Over_Speed;
  String? Joining_Bonus;
  String? Convenyenace;
  String? Loyalty_Bonus;
  String? Awards;
  String? Arrear;
  String? Advance_Recovered_in_current_cycle;
  String? Total_TDS;
  String? Campus_Debit_Note;
  String? Over_Speed;
  String? Deposit;
  String? PVC_Recovered_in_Current_Cycle;
  String? Vehicle_Charge;
  String? Trip_Penalty;
  String? PG_Amount;
  String? KarmaLife_Advance_Withdrawal;
  String? KarmaLife_Advance_Withdrawal_Subscript;
  String? Uber_Vehicle_Charge;
  String? Uber_Balance_Pay_Out;
  String? Total_Additions;
  String? Total_Deductions;
  String? Total_Net_Payable;
  String? Quarterly_Incentive;









  String? no_of_training_days__c;
  String? week_off_days__c;
  String? no_of_bench_days__c;
  String? no_of_continuous_shift_days__c;
  String? no_of_ueos_days__c;
  String? no_of_eos_days__c;
  String? total_no_extra_hours_day__c;
  String? convenyenace_days__c;
  String? service_attendance_bonus_days__c;
  String? no_of_days_late__c;
  String? continuous_shift_amount__c;
  String? extra_hours_amount__c;
  String? referral_bonus_amount__c;
  String? arrears_amount__c;
  String? awards_amount__c;
  String? welfare_amount__c;
  String? festival__c;
  String? bench_payment__c;
  String? ueos_deduction_amount__c;
  String? campus_debit_amount__c;
  String? deposit_recovery_amount__c;
  String? Dent_Recovered_in_current_cycle;
  String? accident_recovery_amount__c;
  String? tds_amount__c;
  String? total_additions_rollup__c;
  String? total_deductions_rollup__c;
  String? total_earnings__c;
  String? Total_TDS_Recovered_in_Current_Cycle;
  //String? total_tds_recovered_in_currentcycle__c;

  String type = "Bench";
  bool isFirstTime = true;
  String? numberOfTrips;
  String? selectedDate;
  String? selectedCategorySfid;
  String? selectedSubCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true; // Set loading to true initially
    print("dropdownvalue$dropdownvalue");
    Future<String> Serviceprovider = sessionManager.getspid();
    Serviceprovider.then((value) {
      service_provider = value.toString();
    });
    utility.GetUserdata().then((value) => {
          sessionManager.internetcheck().then((intenet) async {
            if (intenet) {
              utility.showspeedteststatus(context);
              //await getmonthearnings(); // Call your API here
              isLoading = false; // Set loading to false after API call
              // checkupdate(_30minstr);,
              // loading();
              // Loginapi(serveruuid, serverstate);
              print("sp_pay_cycle_start_date__c = $sp_pay_cycle_start_date__c");
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
          }), // spuser
          username = utility.lithiumid, getmonthearnings()
        });
    yearvalue = "";
    paycycledatevalue = "";
    sfidstr = "";
  }

  String breakAfterWords(String text) {
    List<String> words = text.split(' ');
    if (words.length <= 2) return text; // Return as is if the text has 2 or fewer words.

    if (words[0].length < 3 && words[1].length < 3) {
      // If both first and second words are less than 3 letters, keep the first four words together
      if (words.length > 4) {
        words.insert(4, '\n'); // Insert a new line before the fifth word
      }
    } else {
      // Otherwise, keep the first two words together
      if (words.length > 2) {
        words.insert(2, '\n'); // Insert a new line before the third word
      }
    }

    // Join words carefully to avoid spaces before line breaks
    return words.join(' ').replaceAll(' \n', '\n');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 8), // Add space at start and end

                  margin: const EdgeInsets.only(right: 0, left: 0),
                  child: Avenirtextblack(
                    customfontweight: FontWeight.w500,
                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                            AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                            AppLocalizations.of(context)!.id == "आयडी")
                        ? 12
                        : 14,
                    text: AppLocalizations.of(context)!.monthYear + " :",
                    textcolor: HexColor(Colorscommon.greenAppcolor),
                  ),
                ),
                Container(
                  height: 30,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.only(right: 0, left: 0),
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(canvasColor: Colors.grey.shade100),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: const Text("-- Select Month -- "),
                        style: TextStyle(
                            fontFamily: 'AvenirLTStd-Book',
                            fontSize: (AppLocalizations.of(context)!.id ==
                                        "ஐடி" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                    AppLocalizations.of(context)!.id == "आयडी")
                                ? 12
                                : 12,
                            color: HexColor(Colorscommon.greydark2),
                            fontWeight: FontWeight.w500),
                        elevation: 0,
                        value: dropdownvalue,
                        items: items.map((items) {
                          return DropdownMenuItem(
                              value: items,
                              child: Text(
                                " " + items.toString(),
                              ));
                        }).toList(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: HexColor(Colorscommon.greencolor),
                        ),
                        onChanged: (value) {
                          setState(() {
                            listloadstatus = true;
                          });
                          dropdownvalue = value.toString();
                          dropdownvaluebool = false;
                          String sfidarrayname;
                          for (int i = 0; i < items.length; i++) {
                            if (items[i].toString() == value) {
                              sfidarrayname = firstsfidarray[i].toString();
                              getmonthearningsdetailsbymonth(sfidarrayname);
                            }
                          }
                          dropdownvalue2 = null;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),

            SizedBox(height: 20),
            if (dataLoaded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(

                    margin: const EdgeInsets.all(0),
                    height: 25,
                    child: Row(
                      children: [
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "आयडी")
                              ? 14
                              : 14,
                          text: AppLocalizations.of(context)!.sp_payment_name +
                              " : ",
                          textcolor: HexColor(Colorscommon.greendark),
                        ),
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "आयडी")
                              ? 14
                              : 14,
                          text: (showname != null &&
                              showname!.isNotEmpty)
                              ? showname!
                              : "     -",

                          textcolor: HexColor(Colorscommon.blackcolor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0),
                    height: 25,
                    child: Row(
                      children: [
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "आयडी")
                              ? 14
                              : 14,
                          text: AppLocalizations.of(context)!
                                  .sp_payment_start_date +
                              " : ",
                          textcolor: HexColor(Colorscommon.greendark),
                        ),
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "आयडी")
                              ? 14
                              : 14,
                          text: (sp_pay_cycle_start_date__c != null &&
                              sp_pay_cycle_start_date__c!.isNotEmpty)
                              ? sp_pay_cycle_start_date__c!
                              : "     -",
                          textcolor: HexColor(Colorscommon.blackcolor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0),
                    height: 25,
                    child: Row(
                      children: [
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "आयडी")
                              ? 14
                              : 14,
                          text: AppLocalizations.of(context)!
                                  .sp_payment_end_date +
                              "   : ",
                          textcolor: HexColor(Colorscommon.greendark),
                        ),
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "आयडी")
                              ? 14
                              : 14,
                          text: (sp_pay_cycle_end_date__c != null &&
                                  sp_pay_cycle_end_date__c!.isNotEmpty)
                              ? sp_pay_cycle_end_date__c!
                              : "     -",
                          textcolor: HexColor(Colorscommon.blackcolor),
                        ),
                      ],
                     ),
                  ),
                ],
              ),
            SizedBox(height: 50),
            //Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
            // SizedBox(height: 20), // Add some spacing between the date and headings
            if (dataLoaded)
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 8), // Add space at start and end

                child: Column(
                  children: [
                    // Headings for Description, Days, and Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: 18, // Adjust the font size as needed
                          text: "Description",
                          textcolor: HexColor(Colorscommon.greendark),
                        ),
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: 18, // Adjust the font size as needed
                          text: "Days",
                          textcolor: HexColor(Colorscommon.greendark),
                        ),
                        Avenirtextblack(
                          customfontweight: FontWeight.w500,
                          fontsize: 18, // Adjust the font size as needed
                          text: "Amount",
                          textcolor: HexColor(Colorscommon.greendark),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
                     SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            // text: AppLocalizations.of(context)!
                            //     .total_paid_duty_days,
                            text: breakAfterWords(AppLocalizations.of(context)!.total_paid_duty_days),

                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (total_paid_duty_days != null &&
                                total_paid_duty_days!.isNotEmpty)
                                ? total_paid_duty_days!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (total_Present_PI != null &&
                                total_Present_PI!.isNotEmpty)
                                ? total_Present_PI!
                                : "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              print(
                                  "Warning icon in the first Expanded tapped!");

                              try {
                                // Fetch attendance dates
                                String Type = "Bench";
                                List<String>? attendanceDatelist =
                                    await getMonthlyEarningDateDetails(
                                  sp_pay_cycle_start_date__c!,
                                  sp_pay_cycle_end_date__c!,
                                  Type,
                                );

                                // Fetch category details
                                await getMonthlyEarningCategoryDetails(type);

                                if (attendanceDatelist != null) {
                                  String? selectedDate = "Select Date";
                                  String? selectedCategory = "Select Category";
                                  String? selectedSubCategory =
                                      "Select SubCategory";
                                  String selectedCategorySfid =
                                      "Select Category";

                                  int dropdownLevel = 0;

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return AlertDialog(
                                            title: Avenirtextblack(
                                              customfontweight: FontWeight.w500,
                                              fontsize: 16,
                                              text: "Bench day",
                                              textcolor: HexColor(
                                                  Colorscommon.greendark),
                                            ),
                                            content: SizedBox(
                                              height: dropdownLevel == 0
                                                  ? 75.0
                                                  : dropdownLevel == 1
                                                      ? 100.0
                                                      : dropdownLevel == 2
                                                          ? 150.0
                                                          : dropdownLevel == 3
                                                              ? 300.0
                                                              : 350.0,
                                              //height: dropdownLevel == 0 ? 100.0 : 150.0,

                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  if (dropdownLevel >= 0)
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " Bench Date",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 30),
                                                        // Adjust the spacing between Dropdown and Text
                                                        Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                              String>(
                                                            value: selectedDate,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    "Select Date",
                                                                child:
                                                                    Avenirtextblack(
                                                                  customfontweight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontsize: 12,
                                                                  text:
                                                                      "Select date",
                                                                  textcolor: HexColor(
                                                                      Colorscommon
                                                                          .greendark),
                                                                ),
                                                              ),
                                                              ...attendanceDatelist
                                                                  .map((String
                                                                      value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child:
                                                                      Avenirtextblack(
                                                                    customfontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    text: value,
                                                                    textcolor: HexColor(
                                                                        Colorscommon
                                                                            .greendark),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ],
                                                            onChanged: (String?
                                                                newValue) {
                                                              if (newValue !=
                                                                  null) {
                                                                print(
                                                                    "Bench Date: $newValue");
                                                                setState(() {
                                                                  selectedDate =
                                                                      newValue;
                                                                  dropdownLevel =
                                                                      1;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel >= 1)
                                                    Row(
                                                      children: [
                                                        // Text side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " Category",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 30),
                                                        Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                                selectedCategorySfid,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    "Select Category",
                                                                child:
                                                                    Avenirtextblack(
                                                                  customfontweight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontsize: 12,
                                                                  text:
                                                                      "Select Category",
                                                                  textcolor: HexColor(
                                                                      Colorscommon
                                                                          .greendark),
                                                                ),
                                                              ),
                                                              if (monthlyCategoryDetails
                                                                      ?.data !=
                                                                  null)
                                                                ...monthlyCategoryDetails!
                                                                    .data!
                                                                    .map(
                                                                  (category) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          category?.sfid ??
                                                                              "",
                                                                      child:
                                                                          Avenirtextblack(
                                                                        customfontweight:
                                                                            FontWeight.w500,
                                                                        fontsize:
                                                                            12,
                                                                        text: (category?.name ??
                                                                            ""),
                                                                        textcolor:
                                                                            HexColor(Colorscommon.greendark),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                            ],
                                                            onChanged: (String?
                                                                newValue) async {
                                                              if (newValue !=
                                                                      null &&
                                                                  newValue !=
                                                                      "Select Category") {
                                                                setState(() {
                                                                  selectedCategorySfid =
                                                                      newValue;
                                                                  dropdownLevel =
                                                                      2;
                                                                });
                                                                await getMonthlyEarningSubCategoryDetails(
                                                                  newValue,
                                                                );
                                                                print(
                                                                    "newValue= $newValue");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel >= 2)
                                                    Row(
                                                      children: [
                                                        // Text side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " SubCategory",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Dropdown side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: FutureBuilder<
                                                                  List<
                                                                      Map<String,
                                                                          String>>>(
                                                                future: getMonthlyEarningSubCategoryDetails(
                                                                    selectedCategorySfid),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    // Check if data is available
                                                                    List<Map<String, String>>
                                                                        subCategoryList =
                                                                        snapshot.data ??
                                                                            [];

                                                                    if (subCategoryList
                                                                        .isNotEmpty) {
                                                                      return DropdownButton<
                                                                          String>(
                                                                        alignment:
                                                                            AlignmentDirectional.bottomStart,
                                                                        value:
                                                                            selectedSubCategory,
                                                                        items: [
                                                                          DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                "Select SubCategory",
                                                                            child:
                                                                                Avenirtextblack(
                                                                              customfontweight: FontWeight.w500,
                                                                              fontsize: 12,
                                                                              text: "Select SubCategory",
                                                                              textcolor: HexColor(Colorscommon.greendark),
                                                                            ),
                                                                          ),
                                                                          ...subCategoryList
                                                                              .map((subCategory) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: subCategory['sfid'] ?? "Select SubCategory",
                                                                              child: Avenirtextblack(
                                                                                customfontweight: FontWeight.w500,
                                                                                fontsize: 12,
                                                                                text: (subCategory['name'] ?? "Select SubCategory"),
                                                                                textcolor: HexColor(Colorscommon.greendark),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ],
                                                                        onChanged:
                                                                            (String?
                                                                                newValue) {
                                                                          if (newValue !=
                                                                              null) {
                                                                            setState(() {
                                                                              selectedSubCategory = newValue;
                                                                              dropdownLevel = 3; // Updated dropdownLevel
                                                                            });
                                                                            print("Johnny = $newValue");
                                                                          }
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // Return some placeholder or empty widget when there is no data
                                                                      return SizedBox
                                                                          .shrink();
                                                                    }
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        "Error: ${snapshot.error}");
                                                                  } else {
                                                                    // Return an empty container if there is no data or error
                                                                    return SizedBox
                                                                        .shrink();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel == 3)
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                                  Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    "No Of Trip",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: TextField(
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    numberOfTrips =
                                                                        value;
                                                                  });
                                                                },
                                                                onSubmitted:
                                                                    (valuestr) {
                                                                  setState(
                                                                      () {});
                                                                },
                                                                maxLength: 5,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .deny(
                                                                    RegExp(
                                                                        '[.,]'), // Deny dots and commas
                                                                  ),
                                                                ],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "ಐಡಿ" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "आयडी")
                                                                      ? 12
                                                                      : 14,
                                                                  fontFamily:
                                                                      'AvenirLTStd-Book',
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .greydark2),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                cursorColor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'No of Trips Performed',
                                                                  counterText:
                                                                      "",
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                HexColor(Colorscommon.greendark)),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                HexColor(Colorscommon.greendark)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor: HexColor(
                                                                    Colorscommon
                                                                        .greenlight2),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                              ),
                                                              //                      RaisedButton(
                                                              // color: HexColor(Colorscommon.greenlight2),
                                                              // shape: RoundedRectangleBorder(
                                                              //     borderRadius: BorderRadius.circular(5)),
                                                              child:
                                                                  Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "आयडी" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "ಐಡಿ" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "ಐಡಿ")
                                                                    ? 12
                                                                    : 14,
                                                                text: AppLocalizations.of(
                                                                        context)!
                                                                    .submit,
                                                                textcolor:
                                                                    Colors
                                                                        .white,
                                                              ),

                                                              onPressed: () {
                                                                // Your onPressed logic here
                                                                print(
                                                                    "Selected Date: $selectedDate");
                                                                print(
                                                                    "Selected Category SFID: $selectedCategorySfid");
                                                                print(
                                                                    "Selected SubCategory: $selectedSubCategory");
                                                                print(
                                                                    "Number of Trips: $numberOfTrips");
                                                                // Call your function or perform any other actions
                                                                // e.g., submitData(selectedDate, selectedCategorySfid, selectedSubCategory, numberOfTrips);
                                                                String Type =
                                                                    "Bench";
                                                                getMonthlyEarningmonthlyEarningIssueAdd(
                                                                    selectedDate!,
                                                                    selectedCategorySfid,
                                                                    selectedSubCategory,
                                                                    numberOfTrips,
                                                                    Type);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Avenirtextblack(
                                                  customfontweight:
                                                      FontWeight.w500,
                                                  fontsize: 12,
                                                  text: "Close",
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  print(
                                      "Error: Unable to fetch attendance dates - returned null");
                                }
                              } catch (error) {
                                print("Error in onTap: $error");
                              } finally {
                                // Set loading to false when data fetching is complete
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  children: [
                                    Avenirtextblack(
                                      customfontweight: FontWeight.w500,
                                      fontsize: 12,
                                      text: AppLocalizations.of(context)!
                                          .bench_days,
                                      textcolor:
                                          HexColor(Colorscommon.greendark),
                                    ),
                                    SizedBox(width: 20),
                                    // Icon(
                                    //   Icons.warning,
                                    //   color: HexColor(Colorscommon.greydark2),
                                    //   size: 15,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (bench_days != null &&
                                bench_days!.isNotEmpty)
                                ? bench_days!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (total_bench != null &&
                                total_bench!.isNotEmpty)
                                ? total_bench!
                                : "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!
                                .training_days,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (training_days != null &&
                                training_days!.isNotEmpty)
                                ? training_days!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (total_training != null &&
                                total_training!.isNotEmpty)
                                ? total_training!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              print(
                                  "Warning icon in the first Expanded tapped!");

                              try {
                                // Fetch attendance dates
                                String Type = "EOS";
                                List<String>? attendanceDatelist =
                                    await getMonthlyEarningDateDetails(
                                  sp_pay_cycle_start_date__c!,
                                  sp_pay_cycle_end_date__c!,
                                  Type,
                                );

                                // Fetch category details
                                await getMonthlyEarningCategoryDetails(type);

                                if (attendanceDatelist != null) {
                                  String? selectedDate = "Select Date";
                                  String? selectedCategory = "Select Category";
                                  String? selectedSubCategory =
                                      "Select SubCategory";
                                  String selectedCategorySfid =
                                      "Select Category";

                                  int dropdownLevel = 0;

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return AlertDialog(
                                            title: Avenirtextblack(
                                              customfontweight: FontWeight.w500,
                                              fontsize: 16,
                                              text: "EOS day",
                                              textcolor: HexColor(
                                                  Colorscommon.greendark),
                                            ),
                                            content: SizedBox(
                                              height: dropdownLevel == 0
                                                  ? 75.0
                                                  : dropdownLevel == 1
                                                      ? 100.0
                                                      : dropdownLevel == 2
                                                          ? 150.0
                                                          : dropdownLevel == 3
                                                              ? 300.0
                                                              : 350.0,
                                              //height: dropdownLevel == 0 ? 100.0 : 150.0,

                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  if (dropdownLevel >= 0)
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " EOS Date",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 30),
                                                        // Adjust the spacing between Dropdown and Text
                                                        Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                              String>(
                                                            value: selectedDate,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    "Select Date",
                                                                child:
                                                                    Avenirtextblack(
                                                                  customfontweight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontsize: 12,
                                                                  text:
                                                                      "Select date",
                                                                  textcolor: HexColor(
                                                                      Colorscommon
                                                                          .greendark),
                                                                ),
                                                              ),
                                                              ...attendanceDatelist
                                                                  .map((String
                                                                      value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child:
                                                                      Avenirtextblack(
                                                                    customfontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    text: value,
                                                                    textcolor: HexColor(
                                                                        Colorscommon
                                                                            .greendark),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ],
                                                            onChanged: (String?
                                                                newValue) {
                                                              if (newValue !=
                                                                  null) {
                                                                print(
                                                                    "EOS Date: $newValue");
                                                                setState(() {
                                                                  selectedDate =
                                                                      newValue;
                                                                  dropdownLevel =
                                                                      1;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel >= 1)
                                                    Row(
                                                      children: [
                                                        // Text side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " Category",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 30),
                                                        Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                                selectedCategorySfid,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    "Select Category",
                                                                child:
                                                                    Avenirtextblack(
                                                                  customfontweight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontsize: 12,
                                                                  text:
                                                                      "Select Category",
                                                                  textcolor: HexColor(
                                                                      Colorscommon
                                                                          .greendark),
                                                                ),
                                                              ),
                                                              if (monthlyCategoryDetails
                                                                      ?.data !=
                                                                  null)
                                                                ...monthlyCategoryDetails!
                                                                    .data!
                                                                    .map(
                                                                  (category) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          category?.sfid ??
                                                                              "",
                                                                      child:
                                                                          Avenirtextblack(
                                                                        customfontweight:
                                                                            FontWeight.w500,
                                                                        fontsize:
                                                                            12,
                                                                        text: (category?.name ??
                                                                            ""),
                                                                        textcolor:
                                                                            HexColor(Colorscommon.greendark),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                            ],
                                                            onChanged: (String?
                                                                newValue) async {
                                                              if (newValue !=
                                                                      null &&
                                                                  newValue !=
                                                                      "Select Category") {
                                                                setState(() {
                                                                  selectedCategorySfid =
                                                                      newValue;
                                                                  dropdownLevel =
                                                                      2;
                                                                });
                                                                await getMonthlyEarningSubCategoryDetails(
                                                                  newValue,
                                                                );
                                                                print(
                                                                    "newValue= $newValue");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel >= 2)
                                                    Row(
                                                      children: [
                                                        // Text side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " SubCategory",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Dropdown side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: FutureBuilder<
                                                                  List<
                                                                      Map<String,
                                                                          String>>>(
                                                                future: getMonthlyEarningSubCategoryDetails(
                                                                    selectedCategorySfid),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    // Check if data is available
                                                                    List<Map<String, String>>
                                                                        subCategoryList =
                                                                        snapshot.data ??
                                                                            [];

                                                                    if (subCategoryList
                                                                        .isNotEmpty) {
                                                                      return DropdownButton<
                                                                          String>(
                                                                        alignment:
                                                                            AlignmentDirectional.bottomStart,
                                                                        value:
                                                                            selectedSubCategory,
                                                                        items: [
                                                                          DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                "Select SubCategory",
                                                                            child:
                                                                                Avenirtextblack(
                                                                              customfontweight: FontWeight.w500,
                                                                              fontsize: 12,
                                                                              text: "Select SubCategory",
                                                                              textcolor: HexColor(Colorscommon.greendark),
                                                                            ),
                                                                          ),
                                                                          ...subCategoryList
                                                                              .map((subCategory) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: subCategory['sfid'] ?? "Select SubCategory",
                                                                              child: Avenirtextblack(
                                                                                customfontweight: FontWeight.w500,
                                                                                fontsize: 12,
                                                                                text: (subCategory['name'] ?? "Select SubCategory"),
                                                                                textcolor: HexColor(Colorscommon.greendark),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ],
                                                                        onChanged:
                                                                            (String?
                                                                                newValue) {
                                                                          if (newValue !=
                                                                              null) {
                                                                            setState(() {
                                                                              selectedSubCategory = newValue;
                                                                              dropdownLevel = 3; // Updated dropdownLevel
                                                                            });
                                                                            print("Johnny = $newValue");
                                                                          }
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // Return some placeholder or empty widget when there is no data
                                                                      return SizedBox
                                                                          .shrink();
                                                                    }
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        "Error: ${snapshot.error}");
                                                                  } else {
                                                                    // Return an empty container if there is no data or error
                                                                    return SizedBox
                                                                        .shrink();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel == 3)
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                                  Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    "No Of Trip",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: TextField(
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    numberOfTrips =
                                                                        value;
                                                                  });
                                                                },
                                                                onSubmitted:
                                                                    (valuestr) {
                                                                  setState(
                                                                      () {});
                                                                },
                                                                maxLength: 5,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .deny(
                                                                    RegExp(
                                                                        '[.,]'), // Deny dots and commas
                                                                  ),
                                                                ],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "ಐಡಿ" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "आयडी")
                                                                      ? 12
                                                                      : 14,
                                                                  fontFamily:
                                                                      'AvenirLTStd-Book',
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .greydark2),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                cursorColor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'No of Trips Performed',
                                                                  counterText:
                                                                      "",
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                HexColor(Colorscommon.greendark)),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                HexColor(Colorscommon.greendark)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor: HexColor(
                                                                    Colorscommon
                                                                        .greenlight2),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                              ),
                                                              //                      RaisedButton(
                                                              // color: HexColor(Colorscommon.greenlight2),
                                                              // shape: RoundedRectangleBorder(
                                                              //     borderRadius: BorderRadius.circular(5)),
                                                              child:
                                                                  Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "आयडी" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "ಐಡಿ" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "ಐಡಿ")
                                                                    ? 12
                                                                    : 14,
                                                                text: AppLocalizations.of(
                                                                        context)!
                                                                    .submit,
                                                                textcolor:
                                                                    Colors
                                                                        .white,
                                                              ),

                                                              onPressed: () {
                                                                // Your onPressed logic here
                                                                print(
                                                                    "Selected Date: $selectedDate");
                                                                print(
                                                                    "Selected Category SFID: $selectedCategorySfid");
                                                                print(
                                                                    "Selected SubCategory: $selectedSubCategory");
                                                                print(
                                                                    "Number of Trips: $numberOfTrips");
                                                                // Call your function or perform any other actions
                                                                // e.g., submitData(selectedDate, selectedCategorySfid, selectedSubCategory, numberOfTrips);
                                                                String Type =
                                                                    "Bench";
                                                                getMonthlyEarningmonthlyEarningIssueAdd(
                                                                    selectedDate!,
                                                                    selectedCategorySfid,
                                                                    selectedSubCategory,
                                                                    numberOfTrips,
                                                                    Type);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Avenirtextblack(
                                                  customfontweight:
                                                      FontWeight.w500,
                                                  fontsize: 12,
                                                  text: "Close",
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  print(
                                      "Error: Unable to fetch attendance dates - returned null");
                                }
                              } catch (error) {
                                print("Error in onTap: $error");
                              } finally {
                                // Set loading to false when data fetching is complete
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  children: [
                                    Avenirtextblack(
                                      customfontweight: FontWeight.w500,
                                      fontsize: 12,
                                      text: breakAfterWords(AppLocalizations.of(context)!.no_of_eos_days),

                                      // text: AppLocalizations.of(context)!
                                      //     .no_of_eos_days,
                                      textcolor:
                                          HexColor(Colorscommon.greendark),
                                    ),
                                    SizedBox(width: 20),
                                    // Icon(
                                    //   Icons.warning,
                                    //   color: HexColor(Colorscommon.greydark2),
                                    //   size: 15,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (EOS != null &&
                                EOS!.isNotEmpty)
                                ? EOS!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),


                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!
                                .weos,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:  (Weekly_Off != null &&
                                Weekly_Off!.isNotEmpty)
                                ? Weekly_Off!
                                :"-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:  "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!
                                .number_of_Extra_Hours,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Extra_Hours != null &&
                                Extra_Hours!.isNotEmpty)
                                ? Extra_Hours!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Extra_Hours1 != null &&
                                Extra_Hours1!.isNotEmpty)
                                ? Extra_Hours1!
                                : "-",
                         //   text: "$extra_hours_amount__c",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),



                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              print(
                                  "Warning icon in the first Expanded tapped!");

                              try {
                                // Fetch attendance dates
                                String Type = "UEOS";
                                List<String>? attendanceDatelist =
                                await getMonthlyEarningDateDetails(
                                  sp_pay_cycle_start_date__c!,
                                  sp_pay_cycle_end_date__c!,
                                  Type,
                                );

                                // Fetch category details
                                await getMonthlyEarningCategoryDetails(type);

                                if (attendanceDatelist != null) {
                                  String? selectedDate = "Select Date";
                                  String? selectedCategory = "Select Category";
                                  String? selectedSubCategory =
                                      "Select SubCategory";
                                  String selectedCategorySfid =
                                      "Select Category";

                                  int dropdownLevel = 0;

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return AlertDialog(
                                            title: Avenirtextblack(
                                              customfontweight: FontWeight.w500,
                                              fontsize: 16,
                                              text: "UEOS day",
                                              textcolor: HexColor(
                                                  Colorscommon.greendark),
                                            ),
                                            content: SizedBox(
                                              height: dropdownLevel == 0
                                                  ? 75.0
                                                  : dropdownLevel == 1
                                                  ? 100.0
                                                  : dropdownLevel == 2
                                                  ? 150.0
                                                  : dropdownLevel == 3
                                                  ? 300.0
                                                  : 350.0,
                                              //height: dropdownLevel == 0 ? 100.0 : 150.0,

                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  if (dropdownLevel >= 0)
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                const BoxDecoration(
                                                                  image:
                                                                  DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                FontWeight
                                                                    .w500,
                                                                fontsize: 12,
                                                                text:
                                                                " UEOS Date",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 30),
                                                        // Adjust the spacing between Dropdown and Text
                                                        Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                              String>(
                                                            value: selectedDate,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                "Select Date",
                                                                child:
                                                                Avenirtextblack(
                                                                  customfontweight:
                                                                  FontWeight
                                                                      .w500,
                                                                  fontsize: 12,
                                                                  text:
                                                                  "Select date",
                                                                  textcolor: HexColor(
                                                                      Colorscommon
                                                                          .greendark),
                                                                ),
                                                              ),
                                                              ...attendanceDatelist
                                                                  .map((String
                                                              value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child:
                                                                  Avenirtextblack(
                                                                    customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                    fontsize:
                                                                    12,
                                                                    text: value,
                                                                    textcolor: HexColor(
                                                                        Colorscommon
                                                                            .greendark),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ],
                                                            onChanged: (String?
                                                            newValue) {
                                                              if (newValue !=
                                                                  null) {
                                                                print(
                                                                    "UEOS Date: $newValue");
                                                                setState(() {
                                                                  selectedDate =
                                                                      newValue;
                                                                  dropdownLevel =
                                                                  1;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel >= 1)
                                                    Row(
                                                      children: [
                                                        // Text side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                const BoxDecoration(
                                                                  image:
                                                                  DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                FontWeight
                                                                    .w500,
                                                                fontsize: 12,
                                                                text:
                                                                " Category",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 30),
                                                        Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                            selectedCategorySfid,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                "Select Category",
                                                                child:
                                                                Avenirtextblack(
                                                                  customfontweight:
                                                                  FontWeight
                                                                      .w500,
                                                                  fontsize: 12,
                                                                  text:
                                                                  "Select Category",
                                                                  textcolor: HexColor(
                                                                      Colorscommon
                                                                          .greendark),
                                                                ),
                                                              ),
                                                              if (monthlyCategoryDetails
                                                                  ?.data !=
                                                                  null)
                                                                ...monthlyCategoryDetails!
                                                                    .data!
                                                                    .map(
                                                                      (category) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                      category?.sfid ??
                                                                          "",
                                                                      child:
                                                                      Avenirtextblack(
                                                                        customfontweight:
                                                                        FontWeight.w500,
                                                                        fontsize:
                                                                        12,
                                                                        text: (category?.name ??
                                                                            ""),
                                                                        textcolor:
                                                                        HexColor(Colorscommon.greendark),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                            ],
                                                            onChanged: (String?
                                                            newValue) async {
                                                              if (newValue !=
                                                                  null &&
                                                                  newValue !=
                                                                      "Select Category") {
                                                                setState(() {
                                                                  selectedCategorySfid =
                                                                      newValue;
                                                                  dropdownLevel =
                                                                  2;
                                                                });
                                                                await getMonthlyEarningSubCategoryDetails(
                                                                  newValue,
                                                                );
                                                                print(
                                                                    "newValue= $newValue");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel >= 2)
                                                    Row(
                                                      children: [
                                                        // Text side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                const BoxDecoration(
                                                                  image:
                                                                  DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                FontWeight
                                                                    .w500,
                                                                fontsize: 12,
                                                                text:
                                                                " SubCategory",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Dropdown side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child:
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                              Axis.horizontal,
                                                              child: FutureBuilder<
                                                                  List<
                                                                      Map<String,
                                                                          String>>>(
                                                                future: getMonthlyEarningSubCategoryDetails(
                                                                    selectedCategorySfid),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    // Check if data is available
                                                                    List<Map<String, String>>
                                                                    subCategoryList =
                                                                        snapshot.data ??
                                                                            [];

                                                                    if (subCategoryList
                                                                        .isNotEmpty) {
                                                                      return DropdownButton<
                                                                          String>(
                                                                        alignment:
                                                                        AlignmentDirectional.bottomStart,
                                                                        value:
                                                                        selectedSubCategory,
                                                                        items: [
                                                                          DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                            "Select SubCategory",
                                                                            child:
                                                                            Avenirtextblack(
                                                                              customfontweight: FontWeight.w500,
                                                                              fontsize: 12,
                                                                              text: "Select SubCategory",
                                                                              textcolor: HexColor(Colorscommon.greendark),
                                                                            ),
                                                                          ),
                                                                          ...subCategoryList
                                                                              .map((subCategory) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: subCategory['sfid'] ?? "Select SubCategory",
                                                                              child: Avenirtextblack(
                                                                                customfontweight: FontWeight.w500,
                                                                                fontsize: 12,
                                                                                text: (subCategory['name'] ?? "Select SubCategory"),
                                                                                textcolor: HexColor(Colorscommon.greendark),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ],
                                                                        onChanged:
                                                                            (String?
                                                                        newValue) {
                                                                          if (newValue !=
                                                                              null) {
                                                                            setState(() {
                                                                              selectedSubCategory = newValue;
                                                                              dropdownLevel = 3; // Updated dropdownLevel
                                                                            });
                                                                            print("Johnny = $newValue");
                                                                          }
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // Return some placeholder or empty widget when there is no data
                                                                      return SizedBox
                                                                          .shrink();
                                                                    }
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        "Error: ${snapshot.error}");
                                                                  } else {
                                                                    // Return an empty container if there is no data or error
                                                                    return SizedBox
                                                                        .shrink();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel == 3)
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                              Avenirtextblack(
                                                                customfontweight:
                                                                FontWeight
                                                                    .w500,
                                                                fontsize: 12,
                                                                text:
                                                                "No Of Trip",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: TextField(
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    numberOfTrips =
                                                                        value;
                                                                  });
                                                                },
                                                                onSubmitted:
                                                                    (valuestr) {
                                                                  setState(
                                                                          () {});
                                                                },
                                                                maxLength: 5,
                                                                keyboardType:
                                                                TextInputType
                                                                    .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .deny(
                                                                    RegExp(
                                                                        '[.,]'), // Deny dots and commas
                                                                  ),
                                                                ],
                                                                style:
                                                                TextStyle(
                                                                  fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                      AppLocalizations.of(context)!.id ==
                                                                          "ಐಡಿ" ||
                                                                      AppLocalizations.of(context)!.id ==
                                                                          "आयडी")
                                                                      ? 12
                                                                      : 14,
                                                                  fontFamily:
                                                                  'AvenirLTStd-Book',
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .greydark2),
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                ),
                                                                cursorColor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                                decoration:
                                                                InputDecoration(
                                                                  hintText:
                                                                  'No of Trips Performed',
                                                                  counterText:
                                                                  "",
                                                                  enabledBorder:
                                                                  UnderlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                        HexColor(Colorscommon.greendark)),
                                                                  ),
                                                                  focusedBorder:
                                                                  UnderlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                        HexColor(Colorscommon.greendark)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                            child:
                                                            ElevatedButton(
                                                              style:
                                                              ElevatedButton
                                                                  .styleFrom(
                                                                backgroundColor: HexColor(
                                                                    Colorscommon
                                                                        .greenlight2),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        5)),
                                                              ),
                                                              //                      RaisedButton(
                                                              // color: HexColor(Colorscommon.greenlight2),
                                                              // shape: RoundedRectangleBorder(
                                                              //     borderRadius: BorderRadius.circular(5)),
                                                              child:
                                                              Avenirtextblack(
                                                                customfontweight:
                                                                FontWeight
                                                                    .normal,
                                                                fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                    AppLocalizations.of(context)!.id ==
                                                                        "आयडी" ||
                                                                    AppLocalizations.of(context)!.id ==
                                                                        "ಐಡಿ" ||
                                                                    AppLocalizations.of(context)!.id ==
                                                                        "ಐಡಿ")
                                                                    ? 12
                                                                    : 14,
                                                                text: AppLocalizations.of(
                                                                    context)!
                                                                    .submit,
                                                                textcolor:
                                                                Colors
                                                                    .white,
                                                              ),

                                                              onPressed: () {
                                                                // Your onPressed logic here
                                                                print(
                                                                    "Selected Date: $selectedDate");
                                                                print(
                                                                    "Selected Category SFID: $selectedCategorySfid");
                                                                print(
                                                                    "Selected SubCategory: $selectedSubCategory");
                                                                print(
                                                                    "Number of Trips: $numberOfTrips");
                                                                // Call your function or perform any other actions
                                                                // e.g., submitData(selectedDate, selectedCategorySfid, selectedSubCategory, numberOfTrips);
                                                                String Type =
                                                                    "Bench";
                                                                getMonthlyEarningmonthlyEarningIssueAdd(
                                                                    selectedDate!,
                                                                    selectedCategorySfid,
                                                                    selectedSubCategory,
                                                                    numberOfTrips,
                                                                    Type);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Avenirtextblack(
                                                  customfontweight:
                                                  FontWeight.w500,
                                                  fontsize: 12,
                                                  text: "Close",
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  print(
                                      "Error: Unable to fetch attendance dates - returned null");
                                }
                              } catch (error) {
                                print("Error in onTap: $error");
                              } finally {
                                // Set loading to false when data fetching is complete
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  children: [
                                    Avenirtextblack(
                                      customfontweight: FontWeight.w500,
                                      fontsize: 12,
                                      // text: AppLocalizations.of(context)!
                                      //     .no_of_ueos_days,
                                      text: breakAfterWords(AppLocalizations.of(context)!.no_of_ueos_days),

                                      textcolor:
                                      HexColor(Colorscommon.greendark),
                                    ),
                                    SizedBox(width: 20),
                                    // Icon(
                                    //   Icons.warning,
                                    //   color: HexColor(Colorscommon.greydark2),
                                    //   size: 15,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (UEOS != null &&
                                UEOS!.isNotEmpty)
                                ? UEOS!
                                : "-",
                            //text: "$no_of_ueos_days__c",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Unauthorised_EOS != null &&
                                Unauthorised_EOS!.isNotEmpty)
                                ? Unauthorised_EOS!
                                : "-",
                            //text: "$ueos_deduction_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              print(
                                  "Warning icon in the first Expanded tapped!");

                              try {
                                // Fetch attendance dates
                                String Type = "Late";
                                List<String>? attendanceDatelist =
                                    await getMonthlyEarningDateDetails(
                                  sp_pay_cycle_start_date__c!,
                                  sp_pay_cycle_end_date__c!,
                                  Type,
                                );

                                // Fetch category details
                                await getMonthlyEarningCategoryDetails(type);

                                if (attendanceDatelist != null) {
                                  String? selectedDate = "Select Date";
                                  String? selectedCategory = "Select Category";
                                  String? selectedSubCategory =
                                      "Select SubCategory";
                                  String selectedCategorySfid =
                                      "Select Category";

                                  int dropdownLevel = 0;

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return AlertDialog(
                                            title: Avenirtextblack(
                                              customfontweight: FontWeight.w500,
                                              fontsize: 16,
                                              text: "Late day",
                                              textcolor: HexColor(
                                                  Colorscommon.greendark),
                                            ),
                                            content: SizedBox(
                                              height: dropdownLevel == 0
                                                  ? 75.0
                                                  : dropdownLevel == 1
                                                      ? 100.0
                                                      : dropdownLevel == 2
                                                          ? 150.0
                                                          : dropdownLevel == 3
                                                              ? 300.0
                                                              : 350.0,
                                              //height: dropdownLevel == 0 ? 100.0 : 150.0,

                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  if (dropdownLevel >= 0)
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " Late Date",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 30),
                                                        // Adjust the spacing between Dropdown and Text
                                                        Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                              String>(
                                                            value: selectedDate,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    "Select Date",
                                                                child:
                                                                    Avenirtextblack(
                                                                  customfontweight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontsize: 12,
                                                                  text:
                                                                      "Select date",
                                                                  textcolor: HexColor(
                                                                      Colorscommon
                                                                          .greendark),
                                                                ),
                                                              ),
                                                              ...attendanceDatelist
                                                                  .map((String
                                                                      value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child:
                                                                      Avenirtextblack(
                                                                    customfontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    text: value,
                                                                    textcolor: HexColor(
                                                                        Colorscommon
                                                                            .greendark),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ],
                                                            onChanged: (String?
                                                                newValue) {
                                                              if (newValue !=
                                                                  null) {
                                                                print(
                                                                    "Late Date: $newValue");
                                                                setState(() {
                                                                  selectedDate =
                                                                      newValue;
                                                                  dropdownLevel =
                                                                      1;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel >= 1)
                                                    Row(
                                                      children: [
                                                        // Text side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " Category",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 30),
                                                        Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                                selectedCategorySfid,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    "Select Category",
                                                                child:
                                                                    Avenirtextblack(
                                                                  customfontweight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontsize: 12,
                                                                  text:
                                                                      "Select Category",
                                                                  textcolor: HexColor(
                                                                      Colorscommon
                                                                          .greendark),
                                                                ),
                                                              ),
                                                              if (monthlyCategoryDetails
                                                                      ?.data !=
                                                                  null)
                                                                ...monthlyCategoryDetails!
                                                                    .data!
                                                                    .map(
                                                                  (category) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          category?.sfid ??
                                                                              "",
                                                                      child:
                                                                          Avenirtextblack(
                                                                        customfontweight:
                                                                            FontWeight.w500,
                                                                        fontsize:
                                                                            12,
                                                                        text: (category?.name ??
                                                                            ""),
                                                                        textcolor:
                                                                            HexColor(Colorscommon.greendark),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                            ],
                                                            onChanged: (String?
                                                                newValue) async {
                                                              if (newValue !=
                                                                      null &&
                                                                  newValue !=
                                                                      "Select Category") {
                                                                setState(() {
                                                                  selectedCategorySfid =
                                                                      newValue;
                                                                  dropdownLevel =
                                                                      2;
                                                                });
                                                                await getMonthlyEarningSubCategoryDetails(
                                                                  newValue,
                                                                );
                                                                print(
                                                                    "newValue= $newValue");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel >= 2)
                                                    Row(
                                                      children: [
                                                        // Text side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            children: [
                                                              // Add your image widget here
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/Reason.png"),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                  ),
                                                                ),
                                                              ),

                                                              // Adjust the spacing between the image and text

                                                              Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    " SubCategory",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Dropdown side
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: FutureBuilder<
                                                                  List<
                                                                      Map<String,
                                                                          String>>>(
                                                                future: getMonthlyEarningSubCategoryDetails(
                                                                    selectedCategorySfid),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    // Check if data is available
                                                                    List<Map<String, String>>
                                                                        subCategoryList =
                                                                        snapshot.data ??
                                                                            [];

                                                                    if (subCategoryList
                                                                        .isNotEmpty) {
                                                                      return DropdownButton<
                                                                          String>(
                                                                        alignment:
                                                                            AlignmentDirectional.bottomStart,
                                                                        value:
                                                                            selectedSubCategory,
                                                                        items: [
                                                                          DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                "Select SubCategory",
                                                                            child:
                                                                                Avenirtextblack(
                                                                              customfontweight: FontWeight.w500,
                                                                              fontsize: 12,
                                                                              text: "Select SubCategory",
                                                                              textcolor: HexColor(Colorscommon.greendark),
                                                                            ),
                                                                          ),
                                                                          ...subCategoryList
                                                                              .map((subCategory) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: subCategory['sfid'] ?? "Select SubCategory",
                                                                              child: Avenirtextblack(
                                                                                customfontweight: FontWeight.w500,
                                                                                fontsize: 12,
                                                                                text: (subCategory['name'] ?? "Select SubCategory"),
                                                                                textcolor: HexColor(Colorscommon.greendark),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ],
                                                                        onChanged:
                                                                            (String?
                                                                                newValue) {
                                                                          if (newValue !=
                                                                              null) {
                                                                            setState(() {
                                                                              selectedSubCategory = newValue;
                                                                              dropdownLevel = 3; // Updated dropdownLevel
                                                                            });
                                                                            print("Johnny = $newValue");
                                                                          }
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // Return some placeholder or empty widget when there is no data
                                                                      return SizedBox
                                                                          .shrink();
                                                                    }
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        "Error: ${snapshot.error}");
                                                                  } else {
                                                                    // Return an empty container if there is no data or error
                                                                    return SizedBox
                                                                        .shrink();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (dropdownLevel == 3)
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                                  Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontsize: 12,
                                                                text:
                                                                    "No Of Trip",
                                                                textcolor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: TextField(
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    numberOfTrips =
                                                                        value;
                                                                  });
                                                                },
                                                                onSubmitted:
                                                                    (valuestr) {
                                                                  setState(
                                                                      () {});
                                                                },
                                                                maxLength: 5,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .deny(
                                                                    RegExp(
                                                                        '[.,]'), // Deny dots and commas
                                                                  ),
                                                                ],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "ಐಡಿ" ||
                                                                          AppLocalizations.of(context)!.id ==
                                                                              "आयडी")
                                                                      ? 12
                                                                      : 14,
                                                                  fontFamily:
                                                                      'AvenirLTStd-Book',
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .greydark2),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                cursorColor: HexColor(
                                                                    Colorscommon
                                                                        .greendark),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'No of Trips Performed',
                                                                  counterText:
                                                                      "",
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                HexColor(Colorscommon.greendark)),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                HexColor(Colorscommon.greendark)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor: HexColor(
                                                                    Colorscommon
                                                                        .greenlight2),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                              ),
                                                              //                      RaisedButton(
                                                              // color: HexColor(Colorscommon.greenlight2),
                                                              // shape: RoundedRectangleBorder(
                                                              //     borderRadius: BorderRadius.circular(5)),
                                                              child:
                                                                  Avenirtextblack(
                                                                customfontweight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "आयडी" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "ಐಡಿ" ||
                                                                        AppLocalizations.of(context)!.id ==
                                                                            "ಐಡಿ")
                                                                    ? 12
                                                                    : 14,
                                                                text: AppLocalizations.of(
                                                                        context)!
                                                                    .submit,
                                                                textcolor:
                                                                    Colors
                                                                        .white,
                                                              ),

                                                              onPressed: () {
                                                                // Your onPressed logic here
                                                                print(
                                                                    "Selected Date: $selectedDate");
                                                                print(
                                                                    "Selected Category SFID: $selectedCategorySfid");
                                                                print(
                                                                    "Selected SubCategory: $selectedSubCategory");
                                                                print(
                                                                    "Number of Trips: $numberOfTrips");
                                                                // Call your function or perform any other actions
                                                                // e.g., submitData(selectedDate, selectedCategorySfid, selectedSubCategory, numberOfTrips);
                                                                String Type =
                                                                    "Bench";
                                                                getMonthlyEarningmonthlyEarningIssueAdd(
                                                                    selectedDate!,
                                                                    selectedCategorySfid,
                                                                    selectedSubCategory,
                                                                    numberOfTrips,
                                                                    Type);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Avenirtextblack(
                                                  customfontweight:
                                                      FontWeight.w500,
                                                  fontsize: 12,
                                                  text: "Close",
                                                  textcolor: HexColor(
                                                      Colorscommon.greendark),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  print(
                                      "Error: Unable to fetch attendance dates - returned null");
                                }
                              } catch (error) {
                                print("Error in onTap: $error");
                              } finally {
                                // Set loading to false when data fetching is complete
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  children: [
                                    Avenirtextblack(
                                      customfontweight: FontWeight.w500,
                                      fontsize: 12,
                                      // text: AppLocalizations.of(context)!
                                      //     .no_of_days_late,
                                      text: breakAfterWords(AppLocalizations.of(context)!.no_of_days_late),

                                      textcolor:
                                          HexColor(Colorscommon.greendark),
                                    ),
                                    SizedBox(width: 20),
                                    // Icon(
                                    //   Icons.warning,
                                    //   color: HexColor(Colorscommon.greydark2),
                                    //   size: 15,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: ( Late!= null &&
                                Late!.isNotEmpty)
                                ? Late!
                                : "-",
                            //text: "$no_of_days_late__c",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: ( Late_Amount!= null &&
                                Late_Amount!.isNotEmpty)
                                ? Late_Amount!
                                : "-",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
                    // SizedBox(height:20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.referral_bonus,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Referral_Bonus != null &&
                                Referral_Bonus!.isNotEmpty)
                                ? Referral_Bonus!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.service_days_bonus,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Service_Day_Bonus != null &&
                                Service_Day_Bonus!.isNotEmpty)
                                ? Service_Day_Bonus!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.trip_incentive,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (trip_incentive != null &&
                                trip_incentive!.isNotEmpty)
                                ? trip_incentive!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.quarterly_incentive,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight:FontWeight.w500,
                            fontsize: 12,
                            text: (Quarterly_Incentive != null &&
                                Quarterly_Incentive!.isNotEmpty)
                                ? Quarterly_Incentive!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.joining_bonus,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Joining_Bonus != null &&
                                Joining_Bonus!.isNotEmpty)
                                ? Joining_Bonus!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.convenyenace,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Convenyenace != null &&
                                Convenyenace!.isNotEmpty)
                                ? Convenyenace!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.loyalty_bonus,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Loyalty_Bonus != null &&
                                Loyalty_Bonus!.isNotEmpty)
                                ? Loyalty_Bonus!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.awards,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Awards != null &&
                                Awards!.isNotEmpty)
                                ? Awards!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.arrear,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Arrear != null &&
                                Arrear!.isNotEmpty)
                                ? Arrear!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),








                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.no_of_over_speed,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (No_of_Over_Speed != null &&
                                No_of_Over_Speed!.isNotEmpty)
                                ? No_of_Over_Speed!
                                : "-",

                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.over_speed,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight:FontWeight.w500,
                            fontsize: 12,
                            text: (Over_Speed != null &&
                                Over_Speed!.isNotEmpty)
                                ? Over_Speed!
                                : "-",

                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.accident_recovery,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Advance_Recovered_in_current_cycle != null &&
                                Advance_Recovered_in_current_cycle!.isNotEmpty)
                                ? Advance_Recovered_in_current_cycle!
                                : "-",

                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.advance_recovery,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Dent_Recovered_in_current_cycle != null &&
                                Dent_Recovered_in_current_cycle!.isNotEmpty)
                                ? Dent_Recovered_in_current_cycle!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.campus_debit_note,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Campus_Debit_Note != null &&
                                Campus_Debit_Note!.isNotEmpty)
                                ? Campus_Debit_Note!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.deposit,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Deposit != null &&
                                Deposit!.isNotEmpty)
                                ? Deposit!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.pvc_recovered,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (PVC_Recovered_in_Current_Cycle != null &&
                                PVC_Recovered_in_Current_Cycle!.isNotEmpty)
                                ? PVC_Recovered_in_Current_Cycle!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.vehicle_charge,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Vehicle_Charge != null &&
                                Vehicle_Charge!.isNotEmpty)
                                ? Vehicle_Charge!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.trip_penalty,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Trip_Penalty != null &&
                                Trip_Penalty!.isNotEmpty)
                                ? Trip_Penalty!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.pg_amount,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (PG_Amount != null &&
                                PG_Amount!.isNotEmpty)
                                ? PG_Amount!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.karmalife_advance_withdrawal,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (KarmaLife_Advance_Withdrawal != null &&
                                KarmaLife_Advance_Withdrawal!.isNotEmpty)
                                ? KarmaLife_Advance_Withdrawal!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.karmalife_advance_withdrawal_subscript,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (KarmaLife_Advance_Withdrawal_Subscript != null &&
                                KarmaLife_Advance_Withdrawal_Subscript!.isNotEmpty)
                                ? KarmaLife_Advance_Withdrawal_Subscript!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.total_ts_recovered_in_current_cycle,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Total_TDS_Recovered_in_Current_Cycle != null &&
                                Total_TDS_Recovered_in_Current_Cycle!.isNotEmpty)
                                ? Total_TDS_Recovered_in_Current_Cycle!
                                : "-",

                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.uber_vehicle_charge,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Uber_Vehicle_Charge != null &&
                                Uber_Vehicle_Charge!.isNotEmpty)
                                ? Uber_Vehicle_Charge!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.uber_balance_pay_out,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Uber_Balance_Pay_Out != null &&
                                Uber_Balance_Pay_Out!.isNotEmpty)
                                ? Uber_Balance_Pay_Out!
                                : "-",
                            // text: "$advance_recovery_amount__c",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.total_additions,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Total_Additions != null &&
                                Total_Additions!.isNotEmpty)
                                ? Total_Additions!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text:
                            AppLocalizations.of(context)!.total_deductions,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Total_Deductions != null &&
                                Total_Deductions!.isNotEmpty)
                                ? Total_Deductions!
                                : "-",

                            textcolor: HexColor(Colorscommon.blackcolor) ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!.tds,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Total_TDS != null && Total_TDS!.isNotEmpty)
                                ? double.tryParse(Total_TDS!)?.toInt().toString() ?? "-"
                                : "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: AppLocalizations.of(context)!
                                .net_service_payment,
                            textcolor: HexColor(Colorscommon.greendark),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Avenirtextblack(
                            customfontweight: FontWeight.w500,
                            fontsize: 12,
                            text: (Total_Net_Payable != null && Total_Net_Payable!.isNotEmpty)
                                ? double.tryParse(Total_Net_Payable!)?.toInt().toString() ?? "-"
                                : "-",
                            textcolor: HexColor(Colorscommon.blackcolor),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

            if (dataLoaded == false)
              Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HexColor(Colorscommon.greendark),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              )
          ],
        ),
      ),
    );
  }

  getmonthearnings() async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);

    String dataJson = jsonEncode([
      {
        "service_provider": utility.service_provider_c
      }
    ]);

    request.fields['from'] = "getMonthYearDropdownByMonthlyEarning";
    request.fields['idUser'] = utility.userid;
    request.fields['service_provider_c'] = utility.service_provider_c;
    request.fields['lithiumID'] = utility.lithiumid;
    request.fields['languageType'] =
        AppLocalizations.of(context)!.languagecode.toString();
    request.fields['data'] = dataJson;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    print("fields = $url ${request.fields}");

    String? sfidValue;
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      String? status = jsonInput['status'].toString();

      if (status == 'true') {
        var dataarray = jsonInput['data'] as List;

        for (int i = 0; i < dataarray.length; i++) {
          if (i == 0) {
            dropdownvalue = dataarray[i]['showname'].toString();
            yearvalue = dataarray[i]['viewyear'].toString();
            sfidstr = dataarray[i]['sfid'].toString();
            getmonthearningsdetailsbymonth(dataarray[i]['sfid'].toString());
          }
          var changeTodate = (dataarray[i]['showname']).toString();
          var dropsfidarray = (dataarray[i]['sfid']).toString();
          items.add(changeTodate);
          firstsfidarray.add(dropsfidarray);
        }

        if (dataarray.isNotEmpty) {
          sfidValue = dataarray[0]['sfid'].toString();
          print("sfidValue = $sfidValue");
          await getmonthearningsdetailsbymonth(sfidValue);
        }

        if (mounted) {
          setState(() {
            dataLoaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            dataLoaded = false;
          });
        }
      }

      if (jsonInput.containsKey('data') &&
          jsonInput['data'] != null &&
          jsonInput['data'].isNotEmpty) {
        sp_pay_cycle_start_date__c =
        jsonInput['data'][0]['sp_pay_cycle_start_date__c'];
        sp_pay_cycle_end_date__c =
        jsonInput['data'][0]['sp_pay_cycle_end_date__c'];
        showname = jsonInput['data'][0]['showname'];
        print("showname == $showname");
      } else {
        print("No Data available");
        if (mounted) {
          setState(() {
            dataLoaded = true;
          });
        }
        print("No Data john");
        if (sfidValue != null) {
          await getmonthearningsdetailsbymonth(sfidValue);
        }
      }
    }
  }


  // getmonthearnings() async {
  //   var url = Uri.parse(CommonURL.localone);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //
  //   // Prepare JSON data for the request
  //   String dataJson = jsonEncode([
  //     {
  //       "service_provider": "a14HE000002vxAH"
  //     }
  //   ]);
  //
  //   // Add the required fields
  //   request.fields['from'] = "getMonthYearDropdownByMonthlyEarning";
  //   request.fields['idUser'] = utility.userid;
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //   request.fields['lithiumID'] = utility.lithiumid;
  //   request.fields['languageType'] =
  //       AppLocalizations.of(context)!.languagecode.toString();
  //   request.fields['data'] = dataJson;
  //
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //   print("fields = $url ${request.fields}");
  //
  //   String? sfidValue;
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     String? status = jsonInput['status'].toString();
  //
  //     if (status == 'true') {
  //       var dataarray = jsonInput['data'] as List;
  //
  //       for (int i = 0; i < dataarray.length; i++) {
  //         if (i == 0) {
  //           dropdownvalue = dataarray[i]['viewmonth'].toString();
  //           yearvalue = dataarray[i]['viewyear'].toString();
  //           sfidstr = dataarray[i]['sfid'].toString();
  //           getmonthearningsdetailsbymonth(dataarray[i]['sfid'].toString());
  //         }
  //         var changeTodate = (dataarray[i]['viewmonth']).toString();
  //         var dropsfidarray = (dataarray[i]['sfid']).toString();
  //         items.add(changeTodate);
  //         firstsfidarray.add(dropsfidarray);
  //       }
  //
  //       if (dataarray.isNotEmpty) {
  //         sfidValue = dataarray[0]['sfid'].toString();
  //         print("sfidValue = $sfidValue");
  //         await getmonthearningsdetailsbymonth(sfidValue);
  //       }
  //
  //       setState(() {
  //         dataLoaded = true;
  //       });
  //     } else {
  //       setState(() {
  //         dataLoaded = false;
  //       });
  //     }
  //
  //     if (jsonInput.containsKey('data') &&
  //         jsonInput['data'] != null &&
  //         jsonInput['data'].isNotEmpty) {
  //       sp_pay_cycle_start_date__c =
  //       jsonInput['data'][0]['sp_pay_cycle_start_date__c'];
  //       sp_pay_cycle_end_date__c =
  //       jsonInput['data'][0]['sp_pay_cycle_end_date__c'];
  //       showname = jsonInput['data'][0]['showname'];
  //       print("showname == $showname");
  //     } else {
  //       print("No Data available");
  //       setState(() {
  //         dataLoaded = true;
  //       });
  //       print("No Data john");
  //       if (sfidValue != null) {
  //         await getmonthearningsdetailsbymonth(sfidValue);
  //       }
  //     }
  //   }
  // }



  // getmonthearnings() async {
  //   var url = Uri.parse(CommonURL.herokuurl);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "getMonthYearDropdownByMonthlyEarning";
  //   request.fields['idUser'] = utility.userid;
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //   request.fields['lithiumID'] = utility.lithiumid;
  //   request.fields['languageType'] =
  //       AppLocalizations.of(context)!.languagecode.toString();
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //   print("fields = $url ${request.fields}");
  //
  //   String? sfidValue; // Declare sfidValue outside the block
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     String? status;
  //
  //     status = jsonInput['status'].toString();
  //
  //     if (status == 'true') {
  //       var dataarray = jsonInput['data'] as List;
  //       for (int i = 0; i < dataarray.length; i++) {
  //         if (i == 0) {
  //           dropdownvalue = dataarray[i]['viewmonth'].toString();
  //           yearvalue = dataarray[i]['viewyear'].toString();
  //           sfidstr = dataarray[i]['sfid'].toString();
  //           getmonthearningsdetailsbymonth(dataarray[i]['sfid'].toString());
  //         }
  //         var changeTodate = (dataarray[i]['viewmonth']).toString();
  //         var dropsfidarray = (dataarray[i]['sfid']).toString();
  //         items.add(changeTodate);
  //         firstsfidarray.add(dropsfidarray);
  //       }
  //
  //       if (dataarray.isNotEmpty) {
  //         sfidValue = dataarray[0]['sfid'].toString();
  //         print("sfidValue = $sfidValue");
  //         await getmonthearningsdetailsbymonth(sfidValue);
  //         // Now you have called the next API with the sfid value
  //       }
  //
  //       setState(() {
  //         dataLoaded = true; // Set the boolean to true after data is loaded
  //       });
  //     } else {
  //       setState(() {
  //         dataLoaded =
  //             false; // Set the boolean to false if there is an issue loading data
  //       });
  //     }
  //
  //     if (jsonInput.containsKey('data') &&
  //         jsonInput['data'] != null &&
  //         jsonInput['data'].isNotEmpty) {
  //       sp_pay_cycle_start_date__c =
  //           jsonInput['data'][0]['sp_pay_cycle_start_date__c'];
  //       sp_pay_cycle_end_date__c =
  //           jsonInput['data'][0]['sp_pay_cycle_end_date__c'];
  //       showname = jsonInput['data'][0]['showname'];
  //       print("showname == $showname");
  //     } else {
  //       print("No Data available");
  //       setState(() {
  //         dataLoaded = true;
  //       });
  //       print("No Data john");
  //       if (sfidValue != null) {
  //         await getmonthearningsdetailsbymonth(sfidValue);
  //       }
  //       // Handle the case where 'data' is null or empty
  //     }
  //   }
  // }

  // getmonthearningsdetailsbymonth(String sfid) async {
  //   var url = Uri.parse(CommonURL.localone);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "getMonthlyEarningPayDetails";
  //   request.fields['sfid'] = sfid;
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //   print("fields 1 = $url ${request.fields}");
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     listloadstatus = false;
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     print("lithiumIDdetails=$jsonInput");
  //
  //     if (jsonInput['status'] == true) {
  //       List<dynamic> data = jsonInput['data'];
  //
  //       if (data.isNotEmpty) {
  //         List<Map<String, dynamic>> detailsList =
  //             List<Map<String, dynamic>>.from(data);
  //
  //         Map<String, dynamic> details = detailsList[0];
  //         String status = jsonInput['status'].toString();
  //         no_of_days_present__c = details['no_of_days_present__c'];
  //         no_of_training_days__c = details['no_of_training_days__c'];
  //         week_off_days__c = details['week_off_days__c'];
  //         no_of_bench_days__c = details['no_of_bench_days__c'];
  //         no_of_continuous_shift_days__c =
  //             details['no_of_continuous_shift_days__c'];
  //         no_of_ueos_days__c = details['no_of_ueos_days__c'];
  //         total_no_extra_hours_day__c = details['total_no_extra_hours_day__c'];
  //         convenyenace_days__c = details['convenyenace_days__c'];
  //         service_attendance_bonus_days__c =
  //             details['service_attendance_bonus_days__c'];
  //         no_of_days_late__c = details['no_of_days_late__c'];
  //         continuous_shift_amount__c = details['continuous_shift_amount__c'];
  //         extra_hours_amount__c = details['extra_hours_amount__c'];
  //         referral_bonus_amount__c = details['referral_bonus_amount__c'];
  //         arrears_amount__c = details['arrears_amount__c'];
  //         awards_amount__c = details['awards_amount__c'];
  //         welfare_amount__c = details['welfare_amount__c'];
  //         festival__c = details['festival__c'];
  //         bench_payment__c = details['bench_payment__c'];
  //         ueos_deduction_amount__c = details['ueos_deduction_amount__c'];
  //         campus_debit_amount__c = details['campus_debit_amount__c'];
  //         deposit_recovery_amount__c = details['deposit_recovery_amount__c'];
  //         advance_recovery_amount__c = details['advance_recovery_amount__c'];
  //         accident_recovery_amount__c = details['accident_recovery_amount__c'];
  //         tds_amount__c = details['tds_amount__c'];
  //         total_additions_rollup__c = details['total_additions_rollup__c'];
  //         total_deductions_rollup__c = details['total_deductions_rollup__c'];
  //         total_earnings__c = details['total_earnings__c'];
  //
  //         print("No of Days Present: $no_of_days_present__c");
  //         print("No of Training Days: $no_of_training_days__c");
  //         print("status: $status");
  //       }
  //     }
  //   }
  // }

  getmonthearningsdetailsbymonth(String sfid) async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);

    String dataJson = jsonEncode([
      {
        "sp_payment": sfidstr,
        "service_provider": utility.service_provider_c
      }
    ]);

    request.fields['from'] = "getMonthlyEarningPaymentDetails";
    request.fields['data'] = dataJson;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    print("fields 1 = $url ${request.fields}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      listloadstatus = false;
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("lithiumIDdetails=$jsonInput");

      if (jsonInput['status'] == true) {
        List<dynamic> data = jsonInput['data'];

        if (data.isNotEmpty) {
          Map<String, dynamic> details = data[0];

         // String? total_paid_duty_dayss = details['Total_paid_duty_days']?.toString();
          total_paid_duty_days = details['check_In']?.toString();
          total_Present_PI = details['Total_Present_PI']?.toString();
          bench_days = details['Bench_Days']?.toString();
          total_bench = details['Total_Bench']?.toString();
          training_days = details['Training_Days']?.toString();
          total_training = details['Total_Training']?.toString();
          EOS = details['EOS']?.toString();
          UEOS = details['UEOS']?.toString();
          Unauthorised_EOS = details['Unauthorised_EOS']?.toString();
          Weekly_Off = details['Weekly_Off']?.toString();
          Extra_Hours = details['Number_of_Extra_Hours']?.toString();
          Extra_Hours1 = details['Extra_Hours']?.toString();
          Late = details['Late']?.toString();
          Late_Amount = details['Late_Amount']?.toString();
          Referral_Bonus = details['Referral_Bonus']?.toString();
          Service_Day_Bonus = details['Service_Day_Bonus']?.toString();
          trip_incentive = details['Trip_Incentive']?.toString();
          No_of_Over_Speed = details['No_of_Over_Speed']?.toString();
          Joining_Bonus = details['Joining_Bonus']?.toString();
          Convenyenace = details['Convenyenace']?.toString();
          Loyalty_Bonus = details['Loyalty_Bonus']?.toString();
          Awards = details['Awards']?.toString();
          Arrear = details['Arrear']?.toString();
          Dent_Recovered_in_current_cycle = details['Dent_Recovered_in_current_cycle']?.toString();
          Advance_Recovered_in_current_cycle = details['Advance_Recovered_in_current_cycle']?.toString();
          Total_TDS = details['Total_TDS']?.toString();
          Campus_Debit_Note = details['Campus_Debit_Note']?.toString();
          Over_Speed = details['Over_Speed']?.toString();
          Deposit = details['Deposit']?.toString();
          PVC_Recovered_in_Current_Cycle = details['PVC_Recovered_in_Current_Cycle']?.toString();
          Vehicle_Charge = details['Vehicle_Charge']?.toString();
          Trip_Penalty = details['Trip_Penalty']?.toString();
          PG_Amount = details['PG_Amount']?.toString();
          KarmaLife_Advance_Withdrawal = details['KarmaLife_Advance_Withdrawal']?.toString();
          KarmaLife_Advance_Withdrawal_Subscript = details['KarmaLife_Advance_Withdrawal_Subscript']?.toString();
          Uber_Vehicle_Charge = details['Uber_Vehicle_Charge']?.toString();
          Uber_Balance_Pay_Out = details['Uber_Balance_Pay_Out']?.toString();
          Total_Additions = details['Total_Additions']?.toString();
          Total_Deductions = details['Total_Deductions']?.toString();
          Total_Net_Payable = details['Total_Net_Payable']?.toString();
          Quarterly_Incentive = details['Quarterly_Incentive']?.toString();
         // over_speed__c = details['Over_Speed']?.toString();










          no_of_training_days__c = details['no_of_training_days']?.toString();
          week_off_days__c = details['week_off_days']?.toString();
          no_of_bench_days__c = details['no_of_bench_days']?.toString();
          no_of_continuous_shift_days__c =
              details['no_of_continuous_shift_days']?.toString();
          no_of_ueos_days__c = details['no_of_ueos_days']?.toString();
          no_of_eos_days__c = details['no_of_eos_days']?.toString();
          print("no_of_eos_days__c==$no_of_eos_days__c");
          total_no_extra_hours_day__c = details['total_no_extra_hours_day']?.toString();
          convenyenace_days__c = details['convenyenace_days']?.toString();
          service_attendance_bonus_days__c =
              details['service_attendance_bonus_days']?.toString();
          no_of_days_late__c = details['no_of_days_late']?.toString();
          continuous_shift_amount__c = details['continuous_shift_amount']?.toString();
          extra_hours_amount__c = details['extra_hours_amount']?.toString();
          referral_bonus_amount__c = details['referral_bonus_amount']?.toString();
          arrears_amount__c = details['arrears_amount']?.toString();
          awards_amount__c = details['awards_amount']?.toString();
          welfare_amount__c = details['welfare_amount']?.toString();
          festival__c = details['festival']?.toString();
          bench_payment__c = details['bench_payment']?.toString();
          ueos_deduction_amount__c = details['ueos_deduction_amount']?.toString();
          campus_debit_amount__c = details['campus_debit_amount']?.toString();
          deposit_recovery_amount__c = details['deposit_recovery_amount']?.toString();
          accident_recovery_amount__c = details['accident_recovery_amount']?.toString();
          tds_amount__c = details['tds_amount']?.toString();
          total_additions_rollup__c = details['total_additions_rollup']?.toString();
          total_deductions_rollup__c = details['total_deductions_rollup']?.toString();
          total_earnings__c = details['total_earnings']?.toString();
          Total_TDS_Recovered_in_Current_Cycle = details['Total_TDS_Recovered_in_Current_Cycle']?.toString();



          print("total_paid_duty_days: $total_paid_duty_days");
          print("No of Training Days: $no_of_training_days__c");
          print("Status: ${jsonInput['status']}");
        }
      }
    }
  }



  Future<List<String>> getMonthlyEarningDateDetails(
      String start, String end, String type) async {
    loading();
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);

    // Construct the data field as a JSON string
    String dataJson = jsonEncode([
      {
        // "service_provider": utility.service_provider_c,
        "service_provider": utility.service_provider_c,
        "sp_pay_cycle_start_date": start,
        "sp_pay_cycle_end_date": end,
      }
    ]);

    request.fields['from'] = "getMonthlyEarningDateDetails";
    request.fields['data'] = dataJson;
    request.fields['type'] = type;

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);
      print("DateDetails fields = $url ${request.fields}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);
        print("DateDetails = $jsonInput");

        if (jsonInput['status'] == true) {
          List<dynamic> data = jsonInput['data'];

          if (data.isEmpty) {
            Fluttertoast.showToast(
              msg: "No data available",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            return []; // Return an empty list if no data is available
          }

          // Map attendance dates to a list of strings
          List<String> attendanceDateList = data.map((item) {
            return item['attendance_date'].toString(); // Ensure this key matches the API response
          }).toList();

          return attendanceDateList;
        } else {
          throw Exception("Data not available");
        }
      } else {
        throw Exception("HTTP Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching attendance dates: $error");
      stopLoading(context);
      Fluttertoast.showToast(
        msg: "No data available",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception("Error fetching attendance dates");
    }
  }


  // Future<List<String>> getMonthlyEarningDateDetails(
  //     String start, String end, String Type) async {
  //   loading();
  //   var url = Uri.parse(CommonURL.localone);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "getMonthlyEarningDateDetails";
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //   request.fields['sp_pay_cycle_start_date__c'] = start;
  //   request.fields['sp_pay_cycle_end_date__c'] = end;
  //   request.fields['type'] = Type;
  //
  //   try {
  //     var streamResponse = await request.send();
  //     var response = await http.Response.fromStream(streamResponse);
  //     print("DateDetails fields = $url ${request.fields}");
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //       print("DateDetails =$jsonInput");
  //
  //       if (jsonInput['status'] == true) {
  //         List<dynamic> data = jsonInput['data'];
  //
  //         if (data.isEmpty) {
  //           Fluttertoast.showToast(
  //             msg: "No data available",
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.BOTTOM,
  //           );
  //           return []; // Returning an empty list when there is no data
  //         }
  //
  //         List<String> attendanceDateList = data.map((item) {
  //           return item['attendance_date__c'].toString();
  //         }).toList();
  //
  //         return attendanceDateList;
  //       } else {
  //         throw Exception("Data not available");
  //       }
  //     } else {
  //       throw Exception("HTTP Status Code: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error fetching attendance dates: $error");
  //     stopLoading(context);
  //     Fluttertoast.showToast(
  //       msg: "No data available",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //     throw Exception("Error fetching attendance dates");
  //   }
  // }

  Future<void> getMonthlyEarningCategoryDetails(String type) async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getMonthlyEarningCategoryDetails";
    request.fields['service_provider_c'] = utility.service_provider_c;
    request.fields['type'] = type;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    print("CategoryDetails fields = $url ${request.fields}");
    stopLoading(context);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      print("CategoryDetails = $jsonInput");

      if (jsonInput.containsKey('data')) {
        monthlyCategoryDetails = MonthlyCategoryDetails.fromJson(jsonInput);

        List<String?> sfidList = monthlyCategoryDetails?.data
                ?.map((categoryData) => categoryData.sfid)
                ?.toList() ??
            [];

        // Use sfidList as needed
        print("All sfid values: $sfidList");

        // Call your function or perform other operations with sfidList
        // await yourFunction(sfidList);
      } else {
        print("Error: 'data' field not found in the response.");
      }
    }
  }

  Future<List<Map<String, String>>> getMonthlyEarningSubCategoryDetails(
      String sfid) async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getMonthlyEarningSubCategoryDetails";
   // request.fields['service_provider_c'] = utility.service_provider_c;
    request.fields['service_provider_c'] = sfid;
    //request.fields['service_provider_c'] = "a3eHE000000029tYAA";
    print("sfid= $sfid");
    request.fields['sfid'] = sfid;
    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    print("subCategoryDetails fields = $url ${request.fields}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      listloadstatus = false;
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("subCategoryDetails =$jsonInput");

      if (jsonInput.containsKey('data')) {
        MonthlySubCategoryDetails monthlySubCategoryDetails =
            MonthlySubCategoryDetails.fromJson(jsonInput);

        List<Map<String, String>> subCategoryList =
            monthlySubCategoryDetails?.data
                    ?.map((categoryData) => {
                          'sfid': categoryData.sfid ?? "Select SubCategory",
                          'name': categoryData.name ?? "Select SubCategory",
                        })
                    ?.toList() ??
                [];

        print("subCategoryList=$subCategoryList");
        // Use subCategoryList as needed
        print("All subcategories: $subCategoryList");

        return subCategoryList;
      } else {
        print("Error: 'data' field not found in the response.");
        // Return an empty list if 'data' is not found
        return [];
      }
    } else {
      print(
          "Error: Unable to fetch category details. Status Code: ${response.statusCode}");
      // Return an empty list in case of an error
      return [];
    }
  }

  getMonthlyEarningmonthlyEarningIssueAdd(
      String Date, SFID, SubCategory, Trips, Type) async {
    loading();
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "monthlyEarningIssueAdd";
    request.fields['lithiumID'] = username;
    request.fields['service_provider_c'] = utility.service_provider_c;
    request.fields['date'] = Date;
    request.fields['category'] = SFID;
    request.fields['subcategory'] = SubCategory;
    request.fields['nooftrips'] = Trips;
    request.fields['type'] = Type;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("daily earn = $jsonInput");
      print("fields = $url ${request.fields}");
      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      print("message = $message");
      if (status == 'true') {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const Dashboard2()));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyTabPage(
                      title: '',
                      selectedtab: 0,
                    )));
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } else {}
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

  void stopLoading(BuildContext context) {
    Navigator.of(context).pop();
    // Additional logic for stopping loading (if needed)
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
// import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Dashboardtabbar.dart';
// import 'package:flutter_application_sfdc_idp/Bouncing.dart';
// import 'package:flutter_application_sfdc_idp/Colors.dart';
// import 'package:flutter_application_sfdc_idp/CommonColor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_sfdc_idp/CommonText.dart';
// import 'package:flutter_application_sfdc_idp/Model/MonthlyCategoryDetails.dart';
// import 'package:flutter_application_sfdc_idp/Model/MonthlySubCategoryDetails.dart';
// import 'package:flutter_application_sfdc_idp/URL.dart';
// import 'package:flutter_application_sfdc_idp/Utility.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class Monthearnings extends StatefulWidget {
//   const Monthearnings({Key? key}) : super(key: key);
//
//   @override
//   State<Monthearnings> createState() => _MonthearningsState();
// }
//
// class _MonthearningsState extends State<Monthearnings> {
//   Utility utility = Utility();
//   final List<TextEditingController> _controllers = [];
//   bool dropdownvaluebool = false;
//   String? dropdownvalue;
//   late String yearvalue;
//   var username = "";
//   late String paycycledatevalue;
//   late File _image;
//   late String sfidstr;
//   late String fromDate;
//   late String toDate;
//   String imgname = '';
//   bool imagebool = false;
//   bool listloadstatus = false;
//   String service_provider = '';
//   String? change_date;
//   List<dynamic> datedroplist = [];
//   String? dropdownvalue2;
//   String? fromdate;
//   String? isgrivanceshowbymonth = "false";
//   String? isWeeklyEarningAlreadyExist = "false";
//   String? isNoGrievanceExist = "false";
//   String? tripTime;
//   String? statusValue;
//   String? totalNoOfTripPerformed;
//   String? todate;
//   List items = [];
//   List firstsfidarray = [];
//   List items2 = [];
//   List monthdetailsarray = [];
//   List<dynamic> serviceDayDetails = [];
//   List additionDeletionData = [];
//   List attendance_datelist = [];
//   late String benchFileName;
//
//   // List monthyearningsarray = [];
//   String? sp_pay_cycle_start_date__c;
//   String? sp_pay_cycle_end_date__c;
//   String? showname;
//   MonthlyCategoryDetails? monthlyCategoryDetails;
//   MonthlySubCategoryDetails? monthlySubCategoryDetails;
//   bool isLoading = false;
//   bool dataLoaded = false;
//
//   String? no_of_days_present__c;
//   String? no_of_training_days__c;
//   String? week_off_days__c;
//   String? no_of_bench_days__c;
//   String? no_of_continuous_shift_days__c;
//   String? no_of_ueos_days__c;
//   String? total_no_extra_hours_day__c;
//   String? convenyenace_days__c;
//   String? service_attendance_bonus_days__c;
//   String? no_of_days_late__c;
//   String? continuous_shift_amount__c;
//   String? extra_hours_amount__c;
//   String? referral_bonus_amount__c;
//   String? arrears_amount__c;
//   String? awards_amount__c;
//   String? welfare_amount__c;
//   String? festival__c;
//   String? bench_payment__c;
//   String? ueos_deduction_amount__c;
//   String? campus_debit_amount__c;
//   String? deposit_recovery_amount__c;
//   String? advance_recovery_amount__c;
//   String? accident_recovery_amount__c;
//   String? tds_amount__c;
//   String? total_additions_rollup__c;
//   String? total_deductions_rollup__c;
//   String? total_earnings__c;
//
//   String type = "Bench";
//   bool isFirstTime = true;
//   String? numberOfTrips;
//   String? selectedDate;
//   String? selectedCategorySfid;
//   String? selectedSubCategory;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     isLoading = true; // Set loading to true initially
//     print("dropdownvalue$dropdownvalue");
//     Future<String> Serviceprovider = sessionManager.getspid();
//     Serviceprovider.then((value) {
//       service_provider = value.toString();
//     });
//     utility.GetUserdata().then((value) => {
//       sessionManager.internetcheck().then((intenet) async {
//         if (intenet) {
//           //utility.showspeedteststatus(context);
//           //await getmonthearnings(); // Call your API here
//           isLoading = false; // Set loading to false after API call
//           // checkupdate(_30minstr);,
//           // loading();
//           // Loginapi(serveruuid, serverstate);
//           print("sp_pay_cycle_start_date__c = $sp_pay_cycle_start_date__c");
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
//         }
//       }), // spuser
//       username = utility.lithiumid, getmonthearnings()
//     });
//     yearvalue = "";
//     paycycledatevalue = "";
//     sfidstr = "";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(right: 0, left: 0),
//                   child: Avenirtextblack(
//                     customfontweight: FontWeight.w500,
//                     fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                         AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                         AppLocalizations.of(context)!.id == "आयडी")
//                         ? 12
//                         : 14,
//                     text: AppLocalizations.of(context)!.monthYear + " :",
//                     textcolor: HexColor(Colorscommon.greenAppcolor),
//                   ),
//                 ),
//                 Container(
//                   height: 30,
//                   margin: const EdgeInsets.all(15.0),
//                   padding: const EdgeInsets.only(right: 0, left: 0),
//                   decoration: const ShapeDecoration(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                           width: 0.5,
//                           style: BorderStyle.solid,
//                           color: Colors.grey),
//                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                     ),
//                   ),
//                   child: Theme(
//                     data: Theme.of(context)
//                         .copyWith(canvasColor: Colors.grey.shade100),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton(
//                         hint: const Text("-- Select Month -- "),
//                         style: TextStyle(
//                             fontFamily: 'AvenirLTStd-Book',
//                             fontSize: (AppLocalizations.of(context)!.id ==
//                                 "ஐடி" ||
//                                 AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                                 AppLocalizations.of(context)!.id == "आयडी")
//                                 ? 12
//                                 : 12,
//                             color: HexColor(Colorscommon.greydark2),
//                             fontWeight: FontWeight.w500),
//                         elevation: 0,
//                         value: dropdownvalue,
//                         items: items.map((items) {
//                           return DropdownMenuItem(
//                               value: items,
//                               child: Text(
//                                 " " + items.toString(),
//                               ));
//                         }).toList(),
//                         icon: Icon(
//                           Icons.keyboard_arrow_down,
//                           color: HexColor(Colorscommon.greencolor),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             listloadstatus = true;
//                           });
//                           dropdownvalue = value.toString();
//                           dropdownvaluebool = false;
//                           String sfidarrayname;
//                           for (int i = 0; i < items.length; i++) {
//                             if (items[i].toString() == value) {
//                               sfidarrayname = firstsfidarray[i].toString();
//                               getmonthearningsdetailsbymonth(sfidarrayname);
//                             }
//                           }
//                           dropdownvalue2 = null;
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
//
//             SizedBox(height: 20),
//             if (dataLoaded)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.all(0),
//                     height: 25,
//                     child: Row(
//                       children: [
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: (AppLocalizations.of(context)!.id ==
//                               "ஐடி" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "आयडी")
//                               ? 14
//                               : 14,
//                           text: AppLocalizations.of(context)!.sp_payment_name +
//                               " : ",
//                           textcolor: HexColor(Colorscommon.greendark),
//                         ),
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: (AppLocalizations.of(context)!.id ==
//                               "ஐடி" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "आयडी")
//                               ? 14
//                               : 14,
//                           text: (showname != null &&
//                               showname!.isNotEmpty)
//                               ? showname!
//                               : "     -",
//
//                           textcolor: HexColor(Colorscommon.blackcolor),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(0),
//                     height: 25,
//                     child: Row(
//                       children: [
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: (AppLocalizations.of(context)!.id ==
//                               "ஐடி" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "आयडी")
//                               ? 14
//                               : 14,
//                           text: AppLocalizations.of(context)!
//                               .sp_payment_start_date +
//                               " : ",
//                           textcolor: HexColor(Colorscommon.greendark),
//                         ),
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: (AppLocalizations.of(context)!.id ==
//                               "ஐடி" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "आयडी")
//                               ? 14
//                               : 14,
//                           text: (sp_pay_cycle_start_date__c != null &&
//                               sp_pay_cycle_start_date__c!.isNotEmpty)
//                               ? sp_pay_cycle_start_date__c!
//                               : "     -",
//                           textcolor: HexColor(Colorscommon.blackcolor),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(0),
//                     height: 25,
//                     child: Row(
//                       children: [
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: (AppLocalizations.of(context)!.id ==
//                               "ஐடி" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "आयडी")
//                               ? 14
//                               : 14,
//                           text: AppLocalizations.of(context)!
//                               .sp_payment_end_date +
//                               "   : ",
//                           textcolor: HexColor(Colorscommon.greendark),
//                         ),
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: (AppLocalizations.of(context)!.id ==
//                               "ஐடி" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "आयडी")
//                               ? 14
//                               : 14,
//                           text: (sp_pay_cycle_end_date__c != null &&
//                               sp_pay_cycle_end_date__c!.isNotEmpty)
//                               ? sp_pay_cycle_end_date__c!
//                               : "     -",
//                           textcolor: HexColor(Colorscommon.blackcolor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             SizedBox(height: 50),
//             //Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
//             // SizedBox(height: 20), // Add some spacing between the date and headings
//             if (dataLoaded)
//               Container(
//                 child: Column(
//                   children: [
//                     // Headings for Description, Days, and Amount
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: 18, // Adjust the font size as needed
//                           text: "Description",
//                           textcolor: HexColor(Colorscommon.greendark),
//                         ),
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: 18, // Adjust the font size as needed
//                           text: "Days",
//                           textcolor: HexColor(Colorscommon.greendark),
//                         ),
//                         Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: 18, // Adjust the font size as needed
//                           text: "Amount",
//                           textcolor: HexColor(Colorscommon.greendark),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                     //Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
//                     // SizedBox(height: 25),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "No of days present",
//                             //AppLocalizations.of(context)!
//                                 //.no_of_days_present,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (no_of_days_present__c != null &&
//                                 no_of_days_present__c!.isNotEmpty)
//                                 ? no_of_days_present__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //   children: [
//                     //     Expanded(
//                     //       flex: 10,
//                     //       child: Avenirtextblack(
//                     //         customfontweight: FontWeight.w500,
//                     //         fontsize: 12,
//                     //         text: AppLocalizations.of(context)!
//                     //             .no_of_days_present,
//                     //         textcolor: HexColor(Colorscommon.greendark),
//                     //       ),
//                     //     ),
//                     //     Expanded(
//                     //       flex: 7,
//                     //       child: Avenirtextblack(
//                     //         customfontweight: FontWeight.w500,
//                     //         fontsize: 12,
//                     //
//                     //         text: "$no_of_days_present__c",
//                     //         textcolor: HexColor(Colorscommon.blackcolor),
//                     //       ),
//                     //     ),
//                     //     Expanded(
//                     //       flex: 2,
//                     //       child: Avenirtextblack(
//                     //         customfontweight: FontWeight.w500,
//                     //         fontsize: 12,
//                     //         text: "-",
//                     //         textcolor: HexColor(Colorscommon.blackcolor),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     // SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!
//                                 .no_of_training_days,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (no_of_training_days__c != null &&
//                                 no_of_training_days__c!.isNotEmpty)
//                                 ? no_of_training_days__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.week_off_days,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (week_off_days__c != null &&
//                                 week_off_days__c!.isNotEmpty)
//                                 ? week_off_days__c!
//                                 : "-",
//
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: GestureDetector(
//                             onTap: () async {
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               print(
//                                   "Warning icon in the first Expanded tapped!");
//
//                               try {
//                                 // Fetch attendance dates
//                                 String Type = "Bench";
//                                 List<String>? attendanceDatelist =
//                                 await getMonthlyEarningDateDetails(
//                                   sp_pay_cycle_start_date__c!,
//                                   sp_pay_cycle_end_date__c!,
//                                   Type,
//                                 );
//
//                                 // Fetch category details
//                                 await getMonthlyEarningCategoryDetails(type);
//
//                                 if (attendanceDatelist != null) {
//                                   String? selectedDate = "Select Date";
//                                   String? selectedCategory = "Select Category";
//                                   String? selectedSubCategory =
//                                       "Select SubCategory";
//                                   String selectedCategorySfid =
//                                       "Select Category";
//
//                                   int dropdownLevel = 0;
//
//                                   showDialog(
//                                     barrierDismissible: false,
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return StatefulBuilder(
//                                         builder: (BuildContext context,
//                                             StateSetter setState) {
//                                           return AlertDialog(
//                                             title: Avenirtextblack(
//                                               customfontweight: FontWeight.w500,
//                                               fontsize: 16,
//                                               text: "Bench day",
//                                               textcolor: HexColor(
//                                                   Colorscommon.greendark),
//                                             ),
//                                             content: SizedBox(
//                                               height: dropdownLevel == 0
//                                                   ? 75.0
//                                                   : dropdownLevel == 1
//                                                   ? 100.0
//                                                   : dropdownLevel == 2
//                                                   ? 150.0
//                                                   : dropdownLevel == 3
//                                                   ? 300.0
//                                                   : 350.0,
//                                               //height: dropdownLevel == 0 ? 100.0 : 150.0,
//
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceAround,
//                                                 children: [
//                                                   if (dropdownLevel >= 0)
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " Bench Date",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // SizedBox(width: 30),
//                                                         // Adjust the spacing between Dropdown and Text
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value: selectedDate,
//                                                             items: [
//                                                               DropdownMenuItem<
//                                                                   String>(
//                                                                 value:
//                                                                 "Select Date",
//                                                                 child:
//                                                                 Avenirtextblack(
//                                                                   customfontweight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                   fontsize: 12,
//                                                                   text:
//                                                                   "Select date",
//                                                                   textcolor: HexColor(
//                                                                       Colorscommon
//                                                                           .greendark),
//                                                                 ),
//                                                               ),
//                                                               ...attendanceDatelist
//                                                                   .map((String
//                                                               value) {
//                                                                 return DropdownMenuItem<
//                                                                     String>(
//                                                                   value: value,
//                                                                   child:
//                                                                   Avenirtextblack(
//                                                                     customfontweight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                     fontsize:
//                                                                     12,
//                                                                     text: value,
//                                                                     textcolor: HexColor(
//                                                                         Colorscommon
//                                                                             .greendark),
//                                                                   ),
//                                                                 );
//                                                               }).toList(),
//                                                             ],
//                                                             onChanged: (String?
//                                                             newValue) {
//                                                               if (newValue !=
//                                                                   null) {
//                                                                 print(
//                                                                     "Bench Date: $newValue");
//                                                                 setState(() {
//                                                                   selectedDate =
//                                                                       newValue;
//                                                                   dropdownLevel =
//                                                                   1;
//                                                                 });
//                                                               }
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel >= 1)
//                                                     Row(
//                                                       children: [
//                                                         // Text side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " Category",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // SizedBox(width: 30),
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value:
//                                                             selectedCategorySfid,
//                                                             items: [
//                                                               DropdownMenuItem<
//                                                                   String>(
//                                                                 value:
//                                                                 "Select Category",
//                                                                 child:
//                                                                 Avenirtextblack(
//                                                                   customfontweight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                   fontsize: 12,
//                                                                   text:
//                                                                   "Select Category",
//                                                                   textcolor: HexColor(
//                                                                       Colorscommon
//                                                                           .greendark),
//                                                                 ),
//                                                               ),
//                                                               if (monthlyCategoryDetails
//                                                                   ?.data !=
//                                                                   null)
//                                                                 ...monthlyCategoryDetails!
//                                                                     .data!
//                                                                     .map(
//                                                                       (category) {
//                                                                     return DropdownMenuItem<
//                                                                         String>(
//                                                                       value:
//                                                                       category?.sfid ??
//                                                                           "",
//                                                                       child:
//                                                                       Avenirtextblack(
//                                                                         customfontweight:
//                                                                         FontWeight.w500,
//                                                                         fontsize:
//                                                                         12,
//                                                                         text: (category?.name ??
//                                                                             ""),
//                                                                         textcolor:
//                                                                         HexColor(Colorscommon.greendark),
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                 ),
//                                                             ],
//                                                             onChanged: (String?
//                                                             newValue) async {
//                                                               if (newValue !=
//                                                                   null &&
//                                                                   newValue !=
//                                                                       "Select Category") {
//                                                                 setState(() {
//                                                                   selectedCategorySfid =
//                                                                       newValue;
//                                                                   dropdownLevel =
//                                                                   2;
//                                                                 });
//                                                                 await getMonthlyEarningSubCategoryDetails(
//                                                                   newValue,
//                                                                 );
//                                                                 print(
//                                                                     "newValue= $newValue");
//                                                               }
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel >= 2)
//                                                     Row(
//                                                       children: [
//                                                         // Text side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " SubCategory",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // Dropdown side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Container(
//                                                             child:
//                                                             SingleChildScrollView(
//                                                               scrollDirection:
//                                                               Axis.horizontal,
//                                                               child: FutureBuilder<
//                                                                   List<
//                                                                       Map<String,
//                                                                           String>>>(
//                                                                 future: getMonthlyEarningSubCategoryDetails(
//                                                                     selectedCategorySfid),
//                                                                 builder: (context,
//                                                                     snapshot) {
//                                                                   if (snapshot
//                                                                       .hasData) {
//                                                                     // Check if data is available
//                                                                     List<Map<String, String>>
//                                                                     subCategoryList =
//                                                                         snapshot.data ??
//                                                                             [];
//
//                                                                     if (subCategoryList
//                                                                         .isNotEmpty) {
//                                                                       return DropdownButton<
//                                                                           String>(
//                                                                         alignment:
//                                                                         AlignmentDirectional.bottomStart,
//                                                                         value:
//                                                                         selectedSubCategory,
//                                                                         items: [
//                                                                           DropdownMenuItem<
//                                                                               String>(
//                                                                             value:
//                                                                             "Select SubCategory",
//                                                                             child:
//                                                                             Avenirtextblack(
//                                                                               customfontweight: FontWeight.w500,
//                                                                               fontsize: 12,
//                                                                               text: "Select SubCategory",
//                                                                               textcolor: HexColor(Colorscommon.greendark),
//                                                                             ),
//                                                                           ),
//                                                                           ...subCategoryList
//                                                                               .map((subCategory) {
//                                                                             return DropdownMenuItem<String>(
//                                                                               value: subCategory['sfid'] ?? "Select SubCategory",
//                                                                               child: Avenirtextblack(
//                                                                                 customfontweight: FontWeight.w500,
//                                                                                 fontsize: 12,
//                                                                                 text: (subCategory['name'] ?? "Select SubCategory"),
//                                                                                 textcolor: HexColor(Colorscommon.greendark),
//                                                                               ),
//                                                                             );
//                                                                           }).toList(),
//                                                                         ],
//                                                                         onChanged:
//                                                                             (String?
//                                                                         newValue) {
//                                                                           if (newValue !=
//                                                                               null) {
//                                                                             setState(() {
//                                                                               selectedSubCategory = newValue;
//                                                                               dropdownLevel = 3; // Updated dropdownLevel
//                                                                             });
//                                                                             print("Johnny = $newValue");
//                                                                           }
//                                                                         },
//                                                                       );
//                                                                     } else {
//                                                                       // Return some placeholder or empty widget when there is no data
//                                                                       return SizedBox
//                                                                           .shrink();
//                                                                     }
//                                                                   } else if (snapshot
//                                                                       .hasError) {
//                                                                     return Text(
//                                                                         "Error: ${snapshot.error}");
//                                                                   } else {
//                                                                     // Return an empty container if there is no data or error
//                                                                     return SizedBox
//                                                                         .shrink();
//                                                                   }
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel == 3)
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Expanded(
//                                                               flex: 1,
//                                                               child:
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 "No Of Trip",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ),
//                                                             Expanded(
//                                                               flex: 1,
//                                                               child: TextField(
//                                                                 onChanged:
//                                                                     (value) {
//                                                                   setState(() {
//                                                                     numberOfTrips =
//                                                                         value;
//                                                                   });
//                                                                 },
//                                                                 onSubmitted:
//                                                                     (valuestr) {
//                                                                   setState(
//                                                                           () {});
//                                                                 },
//                                                                 maxLength: 5,
//                                                                 keyboardType:
//                                                                 TextInputType
//                                                                     .number,
//                                                                 inputFormatters: [
//                                                                   FilteringTextInputFormatter
//                                                                       .deny(
//                                                                     RegExp(
//                                                                         '[.,]'), // Deny dots and commas
//                                                                   ),
//                                                                 ],
//                                                                 style:
//                                                                 TextStyle(
//                                                                   fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "ಐಡಿ" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "आयडी")
//                                                                       ? 12
//                                                                       : 14,
//                                                                   fontFamily:
//                                                                   'AvenirLTStd-Book',
//                                                                   color: HexColor(
//                                                                       Colorscommon
//                                                                           .greydark2),
//                                                                   fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                 ),
//                                                                 cursorColor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                                 decoration:
//                                                                 InputDecoration(
//                                                                   hintText:
//                                                                   'No of Trips Performed',
//                                                                   counterText:
//                                                                   "",
//                                                                   enabledBorder:
//                                                                   UnderlineInputBorder(
//                                                                     borderSide:
//                                                                     BorderSide(
//                                                                         color:
//                                                                         HexColor(Colorscommon.greendark)),
//                                                                   ),
//                                                                   focusedBorder:
//                                                                   UnderlineInputBorder(
//                                                                     borderSide:
//                                                                     BorderSide(
//                                                                         color:
//                                                                         HexColor(Colorscommon.greendark)),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Center(
//                                                           child: Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .all(16.0),
//                                                             child:
//                                                             ElevatedButton(
//                                                               style:
//                                                               ElevatedButton
//                                                                   .styleFrom(
//                                                                 backgroundColor: HexColor(
//                                                                     Colorscommon
//                                                                         .greenlight2),
//                                                                 shape: RoundedRectangleBorder(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(
//                                                                         5)),
//                                                               ),
//                                                               //                      RaisedButton(
//                                                               // color: HexColor(Colorscommon.greenlight2),
//                                                               // shape: RoundedRectangleBorder(
//                                                               //     borderRadius: BorderRadius.circular(5)),
//                                                               child:
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                                 fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "आयडी" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "ಐಡಿ" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "ಐಡಿ")
//                                                                     ? 12
//                                                                     : 14,
//                                                                 text: AppLocalizations.of(
//                                                                     context)!
//                                                                     .submit,
//                                                                 textcolor:
//                                                                 Colors
//                                                                     .white,
//                                                               ),
//
//                                                               onPressed: () {
//                                                                 // Your onPressed logic here
//                                                                 print(
//                                                                     "Selected Date: $selectedDate");
//                                                                 print(
//                                                                     "Selected Category SFID: $selectedCategorySfid");
//                                                                 print(
//                                                                     "Selected SubCategory: $selectedSubCategory");
//                                                                 print(
//                                                                     "Number of Trips: $numberOfTrips");
//                                                                 // Call your function or perform any other actions
//                                                                 // e.g., submitData(selectedDate, selectedCategorySfid, selectedSubCategory, numberOfTrips);
//                                                                 String Type =
//                                                                     "Bench";
//                                                                 getMonthlyEarningmonthlyEarningIssueAdd(
//                                                                     selectedDate!,
//                                                                     selectedCategorySfid,
//                                                                     selectedSubCategory,
//                                                                     numberOfTrips,
//                                                                     Type);
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                 ],
//                                               ),
//                                             ),
//                                             actions: <Widget>[
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                                 child: Avenirtextblack(
//                                                   customfontweight:
//                                                   FontWeight.w500,
//                                                   fontsize: 12,
//                                                   text: "Close",
//                                                   textcolor: HexColor(
//                                                       Colorscommon.greendark),
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 } else {
//                                   print(
//                                       "Error: Unable to fetch attendance dates - returned null");
//                                 }
//                               } catch (error) {
//                                 print("Error in onTap: $error");
//                               } finally {
//                                 // Set loading to false when data fetching is complete
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                               }
//                             },
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Avenirtextblack(
//                                       customfontweight: FontWeight.w500,
//                                       fontsize: 12,
//                                       text: AppLocalizations.of(context)!
//                                           .bench_days,
//                                       textcolor:
//                                       HexColor(Colorscommon.greendark),
//                                     ),
//                                     SizedBox(width: 20),
//                                     Icon(
//                                       Icons.warning,
//                                       color: HexColor(Colorscommon.greydark2),
//                                       size: 15,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (no_of_bench_days__c != null &&
//                                 no_of_bench_days__c!.isNotEmpty)
//                                 ? no_of_bench_days__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!
//                                 .continuous_shift_days,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (no_of_continuous_shift_days__c != null &&
//                                 no_of_continuous_shift_days__c!.isNotEmpty)
//                                 ? no_of_continuous_shift_days__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (continuous_shift_amount__c != null &&
//                                 continuous_shift_amount__c!.isNotEmpty)
//                                 ? continuous_shift_amount__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: GestureDetector(
//                             onTap: () async {
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               print(
//                                   "Warning icon in the first Expanded tapped!");
//
//                               try {
//                                 // Fetch attendance dates
//                                 String Type = "EOS";
//                                 List<String>? attendanceDatelist =
//                                 await getMonthlyEarningDateDetails(
//                                   sp_pay_cycle_start_date__c!,
//                                   sp_pay_cycle_end_date__c!,
//                                   Type,
//                                 );
//
//                                 // Fetch category details
//                                 await getMonthlyEarningCategoryDetails(type);
//
//                                 if (attendanceDatelist != null) {
//                                   String? selectedDate = "Select Date";
//                                   String? selectedCategory = "Select Category";
//                                   String? selectedSubCategory =
//                                       "Select SubCategory";
//                                   String selectedCategorySfid =
//                                       "Select Category";
//
//                                   int dropdownLevel = 0;
//
//                                   showDialog(
//                                     barrierDismissible: false,
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return StatefulBuilder(
//                                         builder: (BuildContext context,
//                                             StateSetter setState) {
//                                           return AlertDialog(
//                                             title: Avenirtextblack(
//                                               customfontweight: FontWeight.w500,
//                                               fontsize: 16,
//                                               text: "EOS day",
//                                               textcolor: HexColor(
//                                                   Colorscommon.greendark),
//                                             ),
//                                             content: SizedBox(
//                                               height: dropdownLevel == 0
//                                                   ? 75.0
//                                                   : dropdownLevel == 1
//                                                   ? 100.0
//                                                   : dropdownLevel == 2
//                                                   ? 150.0
//                                                   : dropdownLevel == 3
//                                                   ? 300.0
//                                                   : 350.0,
//                                               //height: dropdownLevel == 0 ? 100.0 : 150.0,
//
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceAround,
//                                                 children: [
//                                                   if (dropdownLevel >= 0)
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " EOS Date",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // SizedBox(width: 30),
//                                                         // Adjust the spacing between Dropdown and Text
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value: selectedDate,
//                                                             items: [
//                                                               DropdownMenuItem<
//                                                                   String>(
//                                                                 value:
//                                                                 "Select Date",
//                                                                 child:
//                                                                 Avenirtextblack(
//                                                                   customfontweight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                   fontsize: 12,
//                                                                   text:
//                                                                   "Select date",
//                                                                   textcolor: HexColor(
//                                                                       Colorscommon
//                                                                           .greendark),
//                                                                 ),
//                                                               ),
//                                                               ...attendanceDatelist
//                                                                   .map((String
//                                                               value) {
//                                                                 return DropdownMenuItem<
//                                                                     String>(
//                                                                   value: value,
//                                                                   child:
//                                                                   Avenirtextblack(
//                                                                     customfontweight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                     fontsize:
//                                                                     12,
//                                                                     text: value,
//                                                                     textcolor: HexColor(
//                                                                         Colorscommon
//                                                                             .greendark),
//                                                                   ),
//                                                                 );
//                                                               }).toList(),
//                                                             ],
//                                                             onChanged: (String?
//                                                             newValue) {
//                                                               if (newValue !=
//                                                                   null) {
//                                                                 print(
//                                                                     "EOS Date: $newValue");
//                                                                 setState(() {
//                                                                   selectedDate =
//                                                                       newValue;
//                                                                   dropdownLevel =
//                                                                   1;
//                                                                 });
//                                                               }
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel >= 1)
//                                                     Row(
//                                                       children: [
//                                                         // Text side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " Category",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // SizedBox(width: 30),
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value:
//                                                             selectedCategorySfid,
//                                                             items: [
//                                                               DropdownMenuItem<
//                                                                   String>(
//                                                                 value:
//                                                                 "Select Category",
//                                                                 child:
//                                                                 Avenirtextblack(
//                                                                   customfontweight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                   fontsize: 12,
//                                                                   text:
//                                                                   "Select Category",
//                                                                   textcolor: HexColor(
//                                                                       Colorscommon
//                                                                           .greendark),
//                                                                 ),
//                                                               ),
//                                                               if (monthlyCategoryDetails
//                                                                   ?.data !=
//                                                                   null)
//                                                                 ...monthlyCategoryDetails!
//                                                                     .data!
//                                                                     .map(
//                                                                       (category) {
//                                                                     return DropdownMenuItem<
//                                                                         String>(
//                                                                       value:
//                                                                       category?.sfid ??
//                                                                           "",
//                                                                       child:
//                                                                       Avenirtextblack(
//                                                                         customfontweight:
//                                                                         FontWeight.w500,
//                                                                         fontsize:
//                                                                         12,
//                                                                         text: (category?.name ??
//                                                                             ""),
//                                                                         textcolor:
//                                                                         HexColor(Colorscommon.greendark),
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                 ),
//                                                             ],
//                                                             onChanged: (String?
//                                                             newValue) async {
//                                                               if (newValue !=
//                                                                   null &&
//                                                                   newValue !=
//                                                                       "Select Category") {
//                                                                 setState(() {
//                                                                   selectedCategorySfid =
//                                                                       newValue;
//                                                                   dropdownLevel =
//                                                                   2;
//                                                                 });
//                                                                 await getMonthlyEarningSubCategoryDetails(
//                                                                   newValue,
//                                                                 );
//                                                                 print(
//                                                                     "newValue= $newValue");
//                                                               }
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel >= 2)
//                                                     Row(
//                                                       children: [
//                                                         // Text side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " SubCategory",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // Dropdown side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Container(
//                                                             child:
//                                                             SingleChildScrollView(
//                                                               scrollDirection:
//                                                               Axis.horizontal,
//                                                               child: FutureBuilder<
//                                                                   List<
//                                                                       Map<String,
//                                                                           String>>>(
//                                                                 future: getMonthlyEarningSubCategoryDetails(
//                                                                     selectedCategorySfid),
//                                                                 builder: (context,
//                                                                     snapshot) {
//                                                                   if (snapshot
//                                                                       .hasData) {
//                                                                     // Check if data is available
//                                                                     List<Map<String, String>>
//                                                                     subCategoryList =
//                                                                         snapshot.data ??
//                                                                             [];
//
//                                                                     if (subCategoryList
//                                                                         .isNotEmpty) {
//                                                                       return DropdownButton<
//                                                                           String>(
//                                                                         alignment:
//                                                                         AlignmentDirectional.bottomStart,
//                                                                         value:
//                                                                         selectedSubCategory,
//                                                                         items: [
//                                                                           DropdownMenuItem<
//                                                                               String>(
//                                                                             value:
//                                                                             "Select SubCategory",
//                                                                             child:
//                                                                             Avenirtextblack(
//                                                                               customfontweight: FontWeight.w500,
//                                                                               fontsize: 12,
//                                                                               text: "Select SubCategory",
//                                                                               textcolor: HexColor(Colorscommon.greendark),
//                                                                             ),
//                                                                           ),
//                                                                           ...subCategoryList
//                                                                               .map((subCategory) {
//                                                                             return DropdownMenuItem<String>(
//                                                                               value: subCategory['sfid'] ?? "Select SubCategory",
//                                                                               child: Avenirtextblack(
//                                                                                 customfontweight: FontWeight.w500,
//                                                                                 fontsize: 12,
//                                                                                 text: (subCategory['name'] ?? "Select SubCategory"),
//                                                                                 textcolor: HexColor(Colorscommon.greendark),
//                                                                               ),
//                                                                             );
//                                                                           }).toList(),
//                                                                         ],
//                                                                         onChanged:
//                                                                             (String?
//                                                                         newValue) {
//                                                                           if (newValue !=
//                                                                               null) {
//                                                                             setState(() {
//                                                                               selectedSubCategory = newValue;
//                                                                               dropdownLevel = 3; // Updated dropdownLevel
//                                                                             });
//                                                                             print("Johnny = $newValue");
//                                                                           }
//                                                                         },
//                                                                       );
//                                                                     } else {
//                                                                       // Return some placeholder or empty widget when there is no data
//                                                                       return SizedBox
//                                                                           .shrink();
//                                                                     }
//                                                                   } else if (snapshot
//                                                                       .hasError) {
//                                                                     return Text(
//                                                                         "Error: ${snapshot.error}");
//                                                                   } else {
//                                                                     // Return an empty container if there is no data or error
//                                                                     return SizedBox
//                                                                         .shrink();
//                                                                   }
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel == 3)
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Expanded(
//                                                               flex: 1,
//                                                               child:
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 "No Of Trip",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ),
//                                                             Expanded(
//                                                               flex: 1,
//                                                               child: TextField(
//                                                                 onChanged:
//                                                                     (value) {
//                                                                   setState(() {
//                                                                     numberOfTrips =
//                                                                         value;
//                                                                   });
//                                                                 },
//                                                                 onSubmitted:
//                                                                     (valuestr) {
//                                                                   setState(
//                                                                           () {});
//                                                                 },
//                                                                 maxLength: 5,
//                                                                 keyboardType:
//                                                                 TextInputType
//                                                                     .number,
//                                                                 inputFormatters: [
//                                                                   FilteringTextInputFormatter
//                                                                       .deny(
//                                                                     RegExp(
//                                                                         '[.,]'), // Deny dots and commas
//                                                                   ),
//                                                                 ],
//                                                                 style:
//                                                                 TextStyle(
//                                                                   fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "ಐಡಿ" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "आयडी")
//                                                                       ? 12
//                                                                       : 14,
//                                                                   fontFamily:
//                                                                   'AvenirLTStd-Book',
//                                                                   color: HexColor(
//                                                                       Colorscommon
//                                                                           .greydark2),
//                                                                   fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                 ),
//                                                                 cursorColor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                                 decoration:
//                                                                 InputDecoration(
//                                                                   hintText:
//                                                                   'No of Trips Performed',
//                                                                   counterText:
//                                                                   "",
//                                                                   enabledBorder:
//                                                                   UnderlineInputBorder(
//                                                                     borderSide:
//                                                                     BorderSide(
//                                                                         color:
//                                                                         HexColor(Colorscommon.greendark)),
//                                                                   ),
//                                                                   focusedBorder:
//                                                                   UnderlineInputBorder(
//                                                                     borderSide:
//                                                                     BorderSide(
//                                                                         color:
//                                                                         HexColor(Colorscommon.greendark)),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Center(
//                                                           child: Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .all(16.0),
//                                                             child:
//                                                             ElevatedButton(
//                                                               style:
//                                                               ElevatedButton
//                                                                   .styleFrom(
//                                                                 backgroundColor: HexColor(
//                                                                     Colorscommon
//                                                                         .greenlight2),
//                                                                 shape: RoundedRectangleBorder(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(
//                                                                         5)),
//                                                               ),
//                                                               //                      RaisedButton(
//                                                               // color: HexColor(Colorscommon.greenlight2),
//                                                               // shape: RoundedRectangleBorder(
//                                                               //     borderRadius: BorderRadius.circular(5)),
//                                                               child:
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                                 fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "आयडी" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "ಐಡಿ" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "ಐಡಿ")
//                                                                     ? 12
//                                                                     : 14,
//                                                                 text: AppLocalizations.of(
//                                                                     context)!
//                                                                     .submit,
//                                                                 textcolor:
//                                                                 Colors
//                                                                     .white,
//                                                               ),
//
//                                                               onPressed: () {
//                                                                 // Your onPressed logic here
//                                                                 print(
//                                                                     "Selected Date: $selectedDate");
//                                                                 print(
//                                                                     "Selected Category SFID: $selectedCategorySfid");
//                                                                 print(
//                                                                     "Selected SubCategory: $selectedSubCategory");
//                                                                 print(
//                                                                     "Number of Trips: $numberOfTrips");
//                                                                 // Call your function or perform any other actions
//                                                                 // e.g., submitData(selectedDate, selectedCategorySfid, selectedSubCategory, numberOfTrips);
//                                                                 String Type =
//                                                                     "Bench";
//                                                                 getMonthlyEarningmonthlyEarningIssueAdd(
//                                                                     selectedDate!,
//                                                                     selectedCategorySfid,
//                                                                     selectedSubCategory,
//                                                                     numberOfTrips,
//                                                                     Type);
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                 ],
//                                               ),
//                                             ),
//                                             actions: <Widget>[
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                                 child: Avenirtextblack(
//                                                   customfontweight:
//                                                   FontWeight.w500,
//                                                   fontsize: 12,
//                                                   text: "Close",
//                                                   textcolor: HexColor(
//                                                       Colorscommon.greendark),
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 } else {
//                                   print(
//                                       "Error: Unable to fetch attendance dates - returned null");
//                                 }
//                               } catch (error) {
//                                 print("Error in onTap: $error");
//                               } finally {
//                                 // Set loading to false when data fetching is complete
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                               }
//                             },
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Avenirtextblack(
//                                       customfontweight: FontWeight.w500,
//                                       fontsize: 12,
//                                       text: AppLocalizations.of(context)!
//                                           .no_of_eos_days,
//                                       textcolor:
//                                       HexColor(Colorscommon.greendark),
//                                     ),
//                                     SizedBox(width: 20),
//                                     Icon(
//                                       Icons.warning,
//                                       color: HexColor(Colorscommon.greydark2),
//                                       size: 15,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (no_of_ueos_days__c != null &&
//                                 no_of_ueos_days__c!.isNotEmpty)
//                                 ? no_of_ueos_days__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!
//                                 .total_no_extra_hours_day,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (total_no_extra_hours_day__c != null &&
//                                 total_no_extra_hours_day__c!.isNotEmpty)
//                                 ? total_no_extra_hours_day__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (extra_hours_amount__c != null &&
//                                 extra_hours_amount__c!.isNotEmpty)
//                                 ? extra_hours_amount__c!
//                                 : "-",
//                             //   text: "$extra_hours_amount__c",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.conveyance_days,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (convenyenace_days__c != null &&
//                                 convenyenace_days__c!.isNotEmpty)
//                                 ? convenyenace_days__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!
//                                 .service_attendance_bonus_days,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (service_attendance_bonus_days__c != null &&
//                                 service_attendance_bonus_days__c!.isNotEmpty)
//                                 ? service_attendance_bonus_days__c!
//                                 : "-",
//
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.referral_bonus,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (referral_bonus_amount__c != null &&
//                                 referral_bonus_amount__c!.isNotEmpty)
//                                 ? referral_bonus_amount__c!
//                                 : "-",
//
//                             // text: "$referral_bonus_amount__c",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.arrears_amount,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (arrears_amount__c != null &&
//                                 arrears_amount__c!.isNotEmpty)
//                                 ? arrears_amount__c!
//                                 : "-",
//                             //text: "$arrears_amount__c",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //   children: [
//                     //     Expanded(
//                     //       flex: 10,
//                     //       child: Avenirtextblack(
//                     //         customfontweight: FontWeight.w500,
//                     //         fontsize: 12,
//                     //         text: AppLocalizations.of(context)!.awards_amount,
//                     //         textcolor: HexColor(Colorscommon.greendark),
//                     //       ),
//                     //     ),
//                     //     Expanded(
//                     //       flex: 7,
//                     //       child: Avenirtextblack(
//                     //         customfontweight: FontWeight.w500,
//                     //         fontsize: 12,
//                     //         text: "_",
//                     //         textcolor: HexColor(Colorscommon.blackcolor),
//                     //       ),
//                     //     ),
//                     //     Expanded(
//                     //       flex: 2,
//                     //       child: Avenirtextblack(
//                     //         customfontweight: FontWeight.w500,
//                     //         fontsize: 12,
//                     //         text: "$awards_amount__c",
//                     //         textcolor: HexColor(Colorscommon.blackcolor),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     //SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.welfare_amount,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (welfare_amount__c != null &&
//                                 welfare_amount__c!.isNotEmpty)
//                                 ? welfare_amount__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.festival_amount,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (festival__c != null &&
//                                 festival__c!.isNotEmpty)
//                                 ? festival__c!
//                                 : "-",
//                             //text: "$festival__c",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.bench_payment,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (bench_payment__c != null &&
//                                 bench_payment__c!.isNotEmpty)
//                                 ? bench_payment__c!
//                                 : "-",
//                             //  text: "$bench_payment__c",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 50),
//                     //   Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
//                     // SizedBox(height:25),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: GestureDetector(
//                             onTap: () async {
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               print(
//                                   "Warning icon in the first Expanded tapped!");
//
//                               try {
//                                 // Fetch attendance dates
//                                 String Type = "UEOS";
//                                 List<String>? attendanceDatelist =
//                                 await getMonthlyEarningDateDetails(
//                                   sp_pay_cycle_start_date__c!,
//                                   sp_pay_cycle_end_date__c!,
//                                   Type,
//                                 );
//
//                                 // Fetch category details
//                                 await getMonthlyEarningCategoryDetails(type);
//
//                                 if (attendanceDatelist != null) {
//                                   String? selectedDate = "Select Date";
//                                   String? selectedCategory = "Select Category";
//                                   String? selectedSubCategory =
//                                       "Select SubCategory";
//                                   String selectedCategorySfid =
//                                       "Select Category";
//
//                                   int dropdownLevel = 0;
//
//                                   showDialog(
//                                     barrierDismissible: false,
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return StatefulBuilder(
//                                         builder: (BuildContext context,
//                                             StateSetter setState) {
//                                           return AlertDialog(
//                                             title: Avenirtextblack(
//                                               customfontweight: FontWeight.w500,
//                                               fontsize: 16,
//                                               text: "UEOS day",
//                                               textcolor: HexColor(
//                                                   Colorscommon.greendark),
//                                             ),
//                                             content: SizedBox(
//                                               height: dropdownLevel == 0
//                                                   ? 75.0
//                                                   : dropdownLevel == 1
//                                                   ? 100.0
//                                                   : dropdownLevel == 2
//                                                   ? 150.0
//                                                   : dropdownLevel == 3
//                                                   ? 300.0
//                                                   : 350.0,
//                                               //height: dropdownLevel == 0 ? 100.0 : 150.0,
//
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceAround,
//                                                 children: [
//                                                   if (dropdownLevel >= 0)
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " UEOS Date",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // SizedBox(width: 30),
//                                                         // Adjust the spacing between Dropdown and Text
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value: selectedDate,
//                                                             items: [
//                                                               DropdownMenuItem<
//                                                                   String>(
//                                                                 value:
//                                                                 "Select Date",
//                                                                 child:
//                                                                 Avenirtextblack(
//                                                                   customfontweight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                   fontsize: 12,
//                                                                   text:
//                                                                   "Select date",
//                                                                   textcolor: HexColor(
//                                                                       Colorscommon
//                                                                           .greendark),
//                                                                 ),
//                                                               ),
//                                                               ...attendanceDatelist
//                                                                   .map((String
//                                                               value) {
//                                                                 return DropdownMenuItem<
//                                                                     String>(
//                                                                   value: value,
//                                                                   child:
//                                                                   Avenirtextblack(
//                                                                     customfontweight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                     fontsize:
//                                                                     12,
//                                                                     text: value,
//                                                                     textcolor: HexColor(
//                                                                         Colorscommon
//                                                                             .greendark),
//                                                                   ),
//                                                                 );
//                                                               }).toList(),
//                                                             ],
//                                                             onChanged: (String?
//                                                             newValue) {
//                                                               if (newValue !=
//                                                                   null) {
//                                                                 print(
//                                                                     "UEOS Date: $newValue");
//                                                                 setState(() {
//                                                                   selectedDate =
//                                                                       newValue;
//                                                                   dropdownLevel =
//                                                                   1;
//                                                                 });
//                                                               }
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel >= 1)
//                                                     Row(
//                                                       children: [
//                                                         // Text side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " Category",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // SizedBox(width: 30),
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value:
//                                                             selectedCategorySfid,
//                                                             items: [
//                                                               DropdownMenuItem<
//                                                                   String>(
//                                                                 value:
//                                                                 "Select Category",
//                                                                 child:
//                                                                 Avenirtextblack(
//                                                                   customfontweight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                   fontsize: 12,
//                                                                   text:
//                                                                   "Select Category",
//                                                                   textcolor: HexColor(
//                                                                       Colorscommon
//                                                                           .greendark),
//                                                                 ),
//                                                               ),
//                                                               if (monthlyCategoryDetails
//                                                                   ?.data !=
//                                                                   null)
//                                                                 ...monthlyCategoryDetails!
//                                                                     .data!
//                                                                     .map(
//                                                                       (category) {
//                                                                     return DropdownMenuItem<
//                                                                         String>(
//                                                                       value:
//                                                                       category?.sfid ??
//                                                                           "",
//                                                                       child:
//                                                                       Avenirtextblack(
//                                                                         customfontweight:
//                                                                         FontWeight.w500,
//                                                                         fontsize:
//                                                                         12,
//                                                                         text: (category?.name ??
//                                                                             ""),
//                                                                         textcolor:
//                                                                         HexColor(Colorscommon.greendark),
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                 ),
//                                                             ],
//                                                             onChanged: (String?
//                                                             newValue) async {
//                                                               if (newValue !=
//                                                                   null &&
//                                                                   newValue !=
//                                                                       "Select Category") {
//                                                                 setState(() {
//                                                                   selectedCategorySfid =
//                                                                       newValue;
//                                                                   dropdownLevel =
//                                                                   2;
//                                                                 });
//                                                                 await getMonthlyEarningSubCategoryDetails(
//                                                                   newValue,
//                                                                 );
//                                                                 print(
//                                                                     "newValue= $newValue");
//                                                               }
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel >= 2)
//                                                     Row(
//                                                       children: [
//                                                         // Text side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " SubCategory",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // Dropdown side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Container(
//                                                             child:
//                                                             SingleChildScrollView(
//                                                               scrollDirection:
//                                                               Axis.horizontal,
//                                                               child: FutureBuilder<
//                                                                   List<
//                                                                       Map<String,
//                                                                           String>>>(
//                                                                 future: getMonthlyEarningSubCategoryDetails(
//                                                                     selectedCategorySfid),
//                                                                 builder: (context,
//                                                                     snapshot) {
//                                                                   if (snapshot
//                                                                       .hasData) {
//                                                                     // Check if data is available
//                                                                     List<Map<String, String>>
//                                                                     subCategoryList =
//                                                                         snapshot.data ??
//                                                                             [];
//
//                                                                     if (subCategoryList
//                                                                         .isNotEmpty) {
//                                                                       return DropdownButton<
//                                                                           String>(
//                                                                         alignment:
//                                                                         AlignmentDirectional.bottomStart,
//                                                                         value:
//                                                                         selectedSubCategory,
//                                                                         items: [
//                                                                           DropdownMenuItem<
//                                                                               String>(
//                                                                             value:
//                                                                             "Select SubCategory",
//                                                                             child:
//                                                                             Avenirtextblack(
//                                                                               customfontweight: FontWeight.w500,
//                                                                               fontsize: 12,
//                                                                               text: "Select SubCategory",
//                                                                               textcolor: HexColor(Colorscommon.greendark),
//                                                                             ),
//                                                                           ),
//                                                                           ...subCategoryList
//                                                                               .map((subCategory) {
//                                                                             return DropdownMenuItem<String>(
//                                                                               value: subCategory['sfid'] ?? "Select SubCategory",
//                                                                               child: Avenirtextblack(
//                                                                                 customfontweight: FontWeight.w500,
//                                                                                 fontsize: 12,
//                                                                                 text: (subCategory['name'] ?? "Select SubCategory"),
//                                                                                 textcolor: HexColor(Colorscommon.greendark),
//                                                                               ),
//                                                                             );
//                                                                           }).toList(),
//                                                                         ],
//                                                                         onChanged:
//                                                                             (String?
//                                                                         newValue) {
//                                                                           if (newValue !=
//                                                                               null) {
//                                                                             setState(() {
//                                                                               selectedSubCategory = newValue;
//                                                                               dropdownLevel = 3; // Updated dropdownLevel
//                                                                             });
//                                                                             print("Johnny = $newValue");
//                                                                           }
//                                                                         },
//                                                                       );
//                                                                     } else {
//                                                                       // Return some placeholder or empty widget when there is no data
//                                                                       return SizedBox
//                                                                           .shrink();
//                                                                     }
//                                                                   } else if (snapshot
//                                                                       .hasError) {
//                                                                     return Text(
//                                                                         "Error: ${snapshot.error}");
//                                                                   } else {
//                                                                     // Return an empty container if there is no data or error
//                                                                     return SizedBox
//                                                                         .shrink();
//                                                                   }
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel == 3)
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Expanded(
//                                                               flex: 1,
//                                                               child:
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 "No Of Trip",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ),
//                                                             Expanded(
//                                                               flex: 1,
//                                                               child: TextField(
//                                                                 onChanged:
//                                                                     (value) {
//                                                                   setState(() {
//                                                                     numberOfTrips =
//                                                                         value;
//                                                                   });
//                                                                 },
//                                                                 onSubmitted:
//                                                                     (valuestr) {
//                                                                   setState(
//                                                                           () {});
//                                                                 },
//                                                                 maxLength: 5,
//                                                                 keyboardType:
//                                                                 TextInputType
//                                                                     .number,
//                                                                 inputFormatters: [
//                                                                   FilteringTextInputFormatter
//                                                                       .deny(
//                                                                     RegExp(
//                                                                         '[.,]'), // Deny dots and commas
//                                                                   ),
//                                                                 ],
//                                                                 style:
//                                                                 TextStyle(
//                                                                   fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "ಐಡಿ" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "आयडी")
//                                                                       ? 12
//                                                                       : 14,
//                                                                   fontFamily:
//                                                                   'AvenirLTStd-Book',
//                                                                   color: HexColor(
//                                                                       Colorscommon
//                                                                           .greydark2),
//                                                                   fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                 ),
//                                                                 cursorColor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                                 decoration:
//                                                                 InputDecoration(
//                                                                   hintText:
//                                                                   'No of Trips Performed',
//                                                                   counterText:
//                                                                   "",
//                                                                   enabledBorder:
//                                                                   UnderlineInputBorder(
//                                                                     borderSide:
//                                                                     BorderSide(
//                                                                         color:
//                                                                         HexColor(Colorscommon.greendark)),
//                                                                   ),
//                                                                   focusedBorder:
//                                                                   UnderlineInputBorder(
//                                                                     borderSide:
//                                                                     BorderSide(
//                                                                         color:
//                                                                         HexColor(Colorscommon.greendark)),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Center(
//                                                           child: Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .all(16.0),
//                                                             child:
//                                                             ElevatedButton(
//                                                               style:
//                                                               ElevatedButton
//                                                                   .styleFrom(
//                                                                 backgroundColor: HexColor(
//                                                                     Colorscommon
//                                                                         .greenlight2),
//                                                                 shape: RoundedRectangleBorder(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(
//                                                                         5)),
//                                                               ),
//                                                               //                      RaisedButton(
//                                                               // color: HexColor(Colorscommon.greenlight2),
//                                                               // shape: RoundedRectangleBorder(
//                                                               //     borderRadius: BorderRadius.circular(5)),
//                                                               child:
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                                 fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "आयडी" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "ಐಡಿ" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "ಐಡಿ")
//                                                                     ? 12
//                                                                     : 14,
//                                                                 text: AppLocalizations.of(
//                                                                     context)!
//                                                                     .submit,
//                                                                 textcolor:
//                                                                 Colors
//                                                                     .white,
//                                                               ),
//
//                                                               onPressed: () {
//                                                                 // Your onPressed logic here
//                                                                 print(
//                                                                     "Selected Date: $selectedDate");
//                                                                 print(
//                                                                     "Selected Category SFID: $selectedCategorySfid");
//                                                                 print(
//                                                                     "Selected SubCategory: $selectedSubCategory");
//                                                                 print(
//                                                                     "Number of Trips: $numberOfTrips");
//                                                                 // Call your function or perform any other actions
//                                                                 // e.g., submitData(selectedDate, selectedCategorySfid, selectedSubCategory, numberOfTrips);
//                                                                 String Type =
//                                                                     "Bench";
//                                                                 getMonthlyEarningmonthlyEarningIssueAdd(
//                                                                     selectedDate!,
//                                                                     selectedCategorySfid,
//                                                                     selectedSubCategory,
//                                                                     numberOfTrips,
//                                                                     Type);
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                 ],
//                                               ),
//                                             ),
//                                             actions: <Widget>[
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                                 child: Avenirtextblack(
//                                                   customfontweight:
//                                                   FontWeight.w500,
//                                                   fontsize: 12,
//                                                   text: "Close",
//                                                   textcolor: HexColor(
//                                                       Colorscommon.greendark),
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 } else {
//                                   print(
//                                       "Error: Unable to fetch attendance dates - returned null");
//                                 }
//                               } catch (error) {
//                                 print("Error in onTap: $error");
//                               } finally {
//                                 // Set loading to false when data fetching is complete
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                               }
//                             },
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Avenirtextblack(
//                                       customfontweight: FontWeight.w500,
//                                       fontsize: 12,
//                                       text: AppLocalizations.of(context)!
//                                           .no_of_ueos_days,
//                                       textcolor:
//                                       HexColor(Colorscommon.greendark),
//                                     ),
//                                     SizedBox(width: 20),
//                                     Icon(
//                                       Icons.warning,
//                                       color: HexColor(Colorscommon.greydark2),
//                                       size: 15,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (no_of_ueos_days__c != null &&
//                                 no_of_ueos_days__c!.isNotEmpty)
//                                 ? no_of_ueos_days__c!
//                                 : "-",
//                             //text: "$no_of_ueos_days__c",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (ueos_deduction_amount__c != null &&
//                                 ueos_deduction_amount__c!.isNotEmpty)
//                                 ? ueos_deduction_amount__c!
//                                 : "-",
//                             //text: "$ueos_deduction_amount__c",
//                             textcolor: HexColor(Colorscommon.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: GestureDetector(
//                             onTap: () async {
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               print(
//                                   "Warning icon in the first Expanded tapped!");
//
//                               try {
//                                 // Fetch attendance dates
//                                 String Type = "Late";
//                                 List<String>? attendanceDatelist =
//                                 await getMonthlyEarningDateDetails(
//                                   sp_pay_cycle_start_date__c!,
//                                   sp_pay_cycle_end_date__c!,
//                                   Type,
//                                 );
//
//                                 // Fetch category details
//                                 await getMonthlyEarningCategoryDetails(type);
//
//                                 if (attendanceDatelist != null) {
//                                   String? selectedDate = "Select Date";
//                                   String? selectedCategory = "Select Category";
//                                   String? selectedSubCategory =
//                                       "Select SubCategory";
//                                   String selectedCategorySfid =
//                                       "Select Category";
//
//                                   int dropdownLevel = 0;
//
//                                   showDialog(
//                                     barrierDismissible: false,
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return StatefulBuilder(
//                                         builder: (BuildContext context,
//                                             StateSetter setState) {
//                                           return AlertDialog(
//                                             title: Avenirtextblack(
//                                               customfontweight: FontWeight.w500,
//                                               fontsize: 16,
//                                               text: "Late day",
//                                               textcolor: HexColor(
//                                                   Colorscommon.greendark),
//                                             ),
//                                             content: SizedBox(
//                                               height: dropdownLevel == 0
//                                                   ? 75.0
//                                                   : dropdownLevel == 1
//                                                   ? 100.0
//                                                   : dropdownLevel == 2
//                                                   ? 150.0
//                                                   : dropdownLevel == 3
//                                                   ? 300.0
//                                                   : 350.0,
//                                               //height: dropdownLevel == 0 ? 100.0 : 150.0,
//
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceAround,
//                                                 children: [
//                                                   if (dropdownLevel >= 0)
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " Late Date",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // SizedBox(width: 30),
//                                                         // Adjust the spacing between Dropdown and Text
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value: selectedDate,
//                                                             items: [
//                                                               DropdownMenuItem<
//                                                                   String>(
//                                                                 value:
//                                                                 "Select Date",
//                                                                 child:
//                                                                 Avenirtextblack(
//                                                                   customfontweight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                   fontsize: 12,
//                                                                   text:
//                                                                   "Select date",
//                                                                   textcolor: HexColor(
//                                                                       Colorscommon
//                                                                           .greendark),
//                                                                 ),
//                                                               ),
//                                                               ...attendanceDatelist
//                                                                   .map((String
//                                                               value) {
//                                                                 return DropdownMenuItem<
//                                                                     String>(
//                                                                   value: value,
//                                                                   child:
//                                                                   Avenirtextblack(
//                                                                     customfontweight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                     fontsize:
//                                                                     12,
//                                                                     text: value,
//                                                                     textcolor: HexColor(
//                                                                         Colorscommon
//                                                                             .greendark),
//                                                                   ),
//                                                                 );
//                                                               }).toList(),
//                                                             ],
//                                                             onChanged: (String?
//                                                             newValue) {
//                                                               if (newValue !=
//                                                                   null) {
//                                                                 print(
//                                                                     "Late Date: $newValue");
//                                                                 setState(() {
//                                                                   selectedDate =
//                                                                       newValue;
//                                                                   dropdownLevel =
//                                                                   1;
//                                                                 });
//                                                               }
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel >= 1)
//                                                     Row(
//                                                       children: [
//                                                         // Text side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " Category",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // SizedBox(width: 30),
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value:
//                                                             selectedCategorySfid,
//                                                             items: [
//                                                               DropdownMenuItem<
//                                                                   String>(
//                                                                 value:
//                                                                 "Select Category",
//                                                                 child:
//                                                                 Avenirtextblack(
//                                                                   customfontweight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                   fontsize: 12,
//                                                                   text:
//                                                                   "Select Category",
//                                                                   textcolor: HexColor(
//                                                                       Colorscommon
//                                                                           .greendark),
//                                                                 ),
//                                                               ),
//                                                               if (monthlyCategoryDetails
//                                                                   ?.data !=
//                                                                   null)
//                                                                 ...monthlyCategoryDetails!
//                                                                     .data!
//                                                                     .map(
//                                                                       (category) {
//                                                                     return DropdownMenuItem<
//                                                                         String>(
//                                                                       value:
//                                                                       category?.sfid ??
//                                                                           "",
//                                                                       child:
//                                                                       Avenirtextblack(
//                                                                         customfontweight:
//                                                                         FontWeight.w500,
//                                                                         fontsize:
//                                                                         12,
//                                                                         text: (category?.name ??
//                                                                             ""),
//                                                                         textcolor:
//                                                                         HexColor(Colorscommon.greendark),
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                 ),
//                                                             ],
//                                                             onChanged: (String?
//                                                             newValue) async {
//                                                               if (newValue !=
//                                                                   null &&
//                                                                   newValue !=
//                                                                       "Select Category") {
//                                                                 setState(() {
//                                                                   selectedCategorySfid =
//                                                                       newValue;
//                                                                   dropdownLevel =
//                                                                   2;
//                                                                 });
//                                                                 await getMonthlyEarningSubCategoryDetails(
//                                                                   newValue,
//                                                                 );
//                                                                 print(
//                                                                     "newValue= $newValue");
//                                                               }
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel >= 2)
//                                                     Row(
//                                                       children: [
//                                                         // Text side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               // Add your image widget here
//                                                               Container(
//                                                                 width: 20,
//                                                                 height: 20,
//                                                                 decoration:
//                                                                 const BoxDecoration(
//                                                                   image:
//                                                                   DecorationImage(
//                                                                     image: AssetImage(
//                                                                         "assets/Reason.png"),
//                                                                     fit: BoxFit
//                                                                         .fitHeight,
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               // Adjust the spacing between the image and text
//
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 " SubCategory",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // Dropdown side
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Container(
//                                                             child:
//                                                             SingleChildScrollView(
//                                                               scrollDirection:
//                                                               Axis.horizontal,
//                                                               child: FutureBuilder<
//                                                                   List<
//                                                                       Map<String,
//                                                                           String>>>(
//                                                                 future: getMonthlyEarningSubCategoryDetails(
//                                                                     selectedCategorySfid),
//                                                                 builder: (context,
//                                                                     snapshot) {
//                                                                   if (snapshot
//                                                                       .hasData) {
//                                                                     // Check if data is available
//                                                                     List<Map<String, String>>
//                                                                     subCategoryList =
//                                                                         snapshot.data ??
//                                                                             [];
//
//                                                                     if (subCategoryList
//                                                                         .isNotEmpty) {
//                                                                       return DropdownButton<
//                                                                           String>(
//                                                                         alignment:
//                                                                         AlignmentDirectional.bottomStart,
//                                                                         value:
//                                                                         selectedSubCategory,
//                                                                         items: [
//                                                                           DropdownMenuItem<
//                                                                               String>(
//                                                                             value:
//                                                                             "Select SubCategory",
//                                                                             child:
//                                                                             Avenirtextblack(
//                                                                               customfontweight: FontWeight.w500,
//                                                                               fontsize: 12,
//                                                                               text: "Select SubCategory",
//                                                                               textcolor: HexColor(Colorscommon.greendark),
//                                                                             ),
//                                                                           ),
//                                                                           ...subCategoryList
//                                                                               .map((subCategory) {
//                                                                             return DropdownMenuItem<String>(
//                                                                               value: subCategory['sfid'] ?? "Select SubCategory",
//                                                                               child: Avenirtextblack(
//                                                                                 customfontweight: FontWeight.w500,
//                                                                                 fontsize: 12,
//                                                                                 text: (subCategory['name'] ?? "Select SubCategory"),
//                                                                                 textcolor: HexColor(Colorscommon.greendark),
//                                                                               ),
//                                                                             );
//                                                                           }).toList(),
//                                                                         ],
//                                                                         onChanged:
//                                                                             (String?
//                                                                         newValue) {
//                                                                           if (newValue !=
//                                                                               null) {
//                                                                             setState(() {
//                                                                               selectedSubCategory = newValue;
//                                                                               dropdownLevel = 3; // Updated dropdownLevel
//                                                                             });
//                                                                             print("Johnny = $newValue");
//                                                                           }
//                                                                         },
//                                                                       );
//                                                                     } else {
//                                                                       // Return some placeholder or empty widget when there is no data
//                                                                       return SizedBox
//                                                                           .shrink();
//                                                                     }
//                                                                   } else if (snapshot
//                                                                       .hasError) {
//                                                                     return Text(
//                                                                         "Error: ${snapshot.error}");
//                                                                   } else {
//                                                                     // Return an empty container if there is no data or error
//                                                                     return SizedBox
//                                                                         .shrink();
//                                                                   }
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   if (dropdownLevel == 3)
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Expanded(
//                                                               flex: 1,
//                                                               child:
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontsize: 12,
//                                                                 text:
//                                                                 "No Of Trip",
//                                                                 textcolor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                               ),
//                                                             ),
//                                                             Expanded(
//                                                               flex: 1,
//                                                               child: TextField(
//                                                                 onChanged:
//                                                                     (value) {
//                                                                   setState(() {
//                                                                     numberOfTrips =
//                                                                         value;
//                                                                   });
//                                                                 },
//                                                                 onSubmitted:
//                                                                     (valuestr) {
//                                                                   setState(
//                                                                           () {});
//                                                                 },
//                                                                 maxLength: 5,
//                                                                 keyboardType:
//                                                                 TextInputType
//                                                                     .number,
//                                                                 inputFormatters: [
//                                                                   FilteringTextInputFormatter
//                                                                       .deny(
//                                                                     RegExp(
//                                                                         '[.,]'), // Deny dots and commas
//                                                                   ),
//                                                                 ],
//                                                                 style:
//                                                                 TextStyle(
//                                                                   fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "ಐಡಿ" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "आयडी")
//                                                                       ? 12
//                                                                       : 14,
//                                                                   fontFamily:
//                                                                   'AvenirLTStd-Book',
//                                                                   color: HexColor(
//                                                                       Colorscommon
//                                                                           .greydark2),
//                                                                   fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                                 ),
//                                                                 cursorColor: HexColor(
//                                                                     Colorscommon
//                                                                         .greendark),
//                                                                 decoration:
//                                                                 InputDecoration(
//                                                                   hintText:
//                                                                   'No of Trips Performed',
//                                                                   counterText:
//                                                                   "",
//                                                                   enabledBorder:
//                                                                   UnderlineInputBorder(
//                                                                     borderSide:
//                                                                     BorderSide(
//                                                                         color:
//                                                                         HexColor(Colorscommon.greendark)),
//                                                                   ),
//                                                                   focusedBorder:
//                                                                   UnderlineInputBorder(
//                                                                     borderSide:
//                                                                     BorderSide(
//                                                                         color:
//                                                                         HexColor(Colorscommon.greendark)),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Center(
//                                                           child: Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .all(16.0),
//                                                             child:
//                                                             ElevatedButton(
//                                                               style:
//                                                               ElevatedButton
//                                                                   .styleFrom(
//                                                                 backgroundColor: HexColor(
//                                                                     Colorscommon
//                                                                         .greenlight2),
//                                                                 shape: RoundedRectangleBorder(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(
//                                                                         5)),
//                                                               ),
//                                                               //                      RaisedButton(
//                                                               // color: HexColor(Colorscommon.greenlight2),
//                                                               // shape: RoundedRectangleBorder(
//                                                               //     borderRadius: BorderRadius.circular(5)),
//                                                               child:
//                                                               Avenirtextblack(
//                                                                 customfontweight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                                 fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "आयडी" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "ಐಡಿ" ||
//                                                                     AppLocalizations.of(context)!.id ==
//                                                                         "ಐಡಿ")
//                                                                     ? 12
//                                                                     : 14,
//                                                                 text: AppLocalizations.of(
//                                                                     context)!
//                                                                     .submit,
//                                                                 textcolor:
//                                                                 Colors
//                                                                     .white,
//                                                               ),
//
//                                                               onPressed: () {
//                                                                 // Your onPressed logic here
//                                                                 print(
//                                                                     "Selected Date: $selectedDate");
//                                                                 print(
//                                                                     "Selected Category SFID: $selectedCategorySfid");
//                                                                 print(
//                                                                     "Selected SubCategory: $selectedSubCategory");
//                                                                 print(
//                                                                     "Number of Trips: $numberOfTrips");
//                                                                 // Call your function or perform any other actions
//                                                                 // e.g., submitData(selectedDate, selectedCategorySfid, selectedSubCategory, numberOfTrips);
//                                                                 String Type =
//                                                                     "Bench";
//                                                                 getMonthlyEarningmonthlyEarningIssueAdd(
//                                                                     selectedDate!,
//                                                                     selectedCategorySfid,
//                                                                     selectedSubCategory,
//                                                                     numberOfTrips,
//                                                                     Type);
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                 ],
//                                               ),
//                                             ),
//                                             actions: <Widget>[
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                                 child: Avenirtextblack(
//                                                   customfontweight:
//                                                   FontWeight.w500,
//                                                   fontsize: 12,
//                                                   text: "Close",
//                                                   textcolor: HexColor(
//                                                       Colorscommon.greendark),
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 } else {
//                                   print(
//                                       "Error: Unable to fetch attendance dates - returned null");
//                                 }
//                               } catch (error) {
//                                 print("Error in onTap: $error");
//                               } finally {
//                                 // Set loading to false when data fetching is complete
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                               }
//                             },
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Avenirtextblack(
//                                       customfontweight: FontWeight.w500,
//                                       fontsize: 12,
//                                       text: AppLocalizations.of(context)!
//                                           .no_of_days_late,
//                                       textcolor:
//                                       HexColor(Colorscommon.greendark),
//                                     ),
//                                     SizedBox(width: 20),
//                                     Icon(
//                                       Icons.warning,
//                                       color: HexColor(Colorscommon.greydark2),
//                                       size: 15,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (no_of_days_late__c != null &&
//                                 no_of_days_late__c!.isNotEmpty)
//                                 ? no_of_days_late__c!
//                                 : "-",
//                             //text: "$no_of_days_late__c",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.campusDebit,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (campus_debit_amount__c != null &&
//                                 campus_debit_amount__c!.isNotEmpty)
//                                 ? campus_debit_amount__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text:
//                             AppLocalizations.of(context)!.deposit_recovery,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (deposit_recovery_amount__c != null &&
//                                 deposit_recovery_amount__c!.isNotEmpty)
//                                 ? deposit_recovery_amount__c!
//                                 : "-",
//                             //text: "$deposit_recovery_amount__c",
//                             textcolor: HexColor(Colorscommon.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text:
//                             AppLocalizations.of(context)!.advance_recovery,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (advance_recovery_amount__c != null &&
//                                 advance_recovery_amount__c!.isNotEmpty)
//                                 ? advance_recovery_amount__c!
//                                 : "-",
//                             // text: "$advance_recovery_amount__c",
//                             textcolor: HexColor(Colorscommon.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text:
//                             AppLocalizations.of(context)!.accident_recovery,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (accident_recovery_amount__c != null &&
//                                 accident_recovery_amount__c!.isNotEmpty)
//                                 ? accident_recovery_amount__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.tds,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (tds_amount__c != null &&
//                                 tds_amount__c!.isNotEmpty)
//                                 ? tds_amount__c!
//                                 : "-",
//
//
//                             textcolor: HexColor(Colorscommon.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 50),
//                     // Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
//                     //SizedBox(height: 25),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!.total_additions,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (total_additions_rollup__c != null &&
//                                 total_additions_rollup__c!.isNotEmpty)
//                                 ? total_additions_rollup__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text:
//                             AppLocalizations.of(context)!.total_deductions,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (total_deductions_rollup__c != null &&
//                                 total_deductions_rollup__c!.isNotEmpty)
//                                 ? total_deductions_rollup__c!
//                                 : "-",
//
//                             textcolor: HexColor(Colorscommon.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 50),
//                     // Divider(height: 0.5,thickness: 0.5,color: Colors.grey,),
//                     //SizedBox(height: 25),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 10,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: AppLocalizations.of(context)!
//                                 .net_service_payment,
//                             textcolor: HexColor(Colorscommon.greendark),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 7,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: "-",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Avenirtextblack(
//                             customfontweight: FontWeight.w500,
//                             fontsize: 12,
//                             text: (total_earnings__c != null &&
//                                 total_earnings__c!.isNotEmpty)
//                                 ? total_earnings__c!
//                                 : "-",
//                             //  text: "$total_earnings__c",
//                             textcolor: HexColor(Colorscommon.blackcolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//
//             if (dataLoaded == false)
//               Column(
//                 children: [
//                   CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       HexColor(Colorscommon.greendark),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               )
//           ],
//         ),
//       ),
//     );
//   }
//
//   getmonthearnings() async {
//     var url = Uri.parse(CommonURL.localone);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//
//     String dataJson = jsonEncode([
//       {
//         "service_provider": utility.service_provider_c
//       }
//     ]);
//
//     request.fields['from'] = "getMonthYearDropdownByMonthlyEarning";
//     request.fields['idUser'] = utility.userid;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     request.fields['data'] = dataJson;
//
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     print("fields = $url ${request.fields}");
//
//     String? sfidValue;
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       String? status = jsonInput['status'].toString();
//
//       if (status == 'true') {
//         var dataarray = jsonInput['data'] as List;
//
//         for (int i = 0; i < dataarray.length; i++) {
//           if (i == 0) {
//             dropdownvalue = dataarray[i]['viewmonth'].toString();
//             yearvalue = dataarray[i]['viewyear'].toString();
//             sfidstr = dataarray[i]['sfid'].toString();
//             getmonthearningsdetailsbymonth(dataarray[i]['sfid'].toString());
//           }
//           var changeTodate = (dataarray[i]['viewmonth']).toString();
//           var dropsfidarray = (dataarray[i]['sfid']).toString();
//           items.add(changeTodate);
//           firstsfidarray.add(dropsfidarray);
//         }
//
//         if (dataarray.isNotEmpty) {
//           sfidValue = dataarray[0]['sfid'].toString();
//           print("sfidValue = $sfidValue");
//           await getmonthearningsdetailsbymonth(sfidValue);
//         }
//
//         if (mounted) {
//           setState(() {
//             dataLoaded = true;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             dataLoaded = false;
//           });
//         }
//       }
//
//       if (jsonInput.containsKey('data') &&
//           jsonInput['data'] != null &&
//           jsonInput['data'].isNotEmpty) {
//         sp_pay_cycle_start_date__c =
//         jsonInput['data'][0]['sp_pay_cycle_start_date__c'];
//         sp_pay_cycle_end_date__c =
//         jsonInput['data'][0]['sp_pay_cycle_end_date__c'];
//         showname = jsonInput['data'][0]['showname'];
//         print("showname == $showname");
//       } else {
//         print("No Data available");
//         if (mounted) {
//           setState(() {
//             dataLoaded = true;
//           });
//         }
//         print("No Data john");
//         if (sfidValue != null) {
//           await getmonthearningsdetailsbymonth(sfidValue);
//         }
//       }
//     }
//   }
//
//
//   // getmonthearnings() async {
//   //   var url = Uri.parse(CommonURL.localone);
//   //
//   //   Map<String, String> headers = {
//   //     "Accept": "application/json",
//   //     "Content-Type": "application/x-www-form-urlencoded"
//   //   };
//   //
//   //   var request = http.MultipartRequest("POST", url);
//   //   request.headers.addAll(headers);
//   //
//   //   // Prepare JSON data for the request
//   //   String dataJson = jsonEncode([
//   //     {
//   //       "service_provider": "a14HE000002vxAH"
//   //     }
//   //   ]);
//   //
//   //   // Add the required fields
//   //   request.fields['from'] = "getMonthYearDropdownByMonthlyEarning";
//   //   request.fields['idUser'] = utility.userid;
//   //   request.fields['service_provider_c'] = utility.service_provider_c;
//   //   request.fields['lithiumID'] = utility.lithiumid;
//   //   request.fields['languageType'] =
//   //       AppLocalizations.of(context)!.languagecode.toString();
//   //   request.fields['data'] = dataJson;
//   //
//   //   var streamResponse = await request.send();
//   //   var response = await http.Response.fromStream(streamResponse);
//   //   print("fields = $url ${request.fields}");
//   //
//   //   String? sfidValue;
//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
//   //     String? status = jsonInput['status'].toString();
//   //
//   //     if (status == 'true') {
//   //       var dataarray = jsonInput['data'] as List;
//   //
//   //       for (int i = 0; i < dataarray.length; i++) {
//   //         if (i == 0) {
//   //           dropdownvalue = dataarray[i]['viewmonth'].toString();
//   //           yearvalue = dataarray[i]['viewyear'].toString();
//   //           sfidstr = dataarray[i]['sfid'].toString();
//   //           getmonthearningsdetailsbymonth(dataarray[i]['sfid'].toString());
//   //         }
//   //         var changeTodate = (dataarray[i]['viewmonth']).toString();
//   //         var dropsfidarray = (dataarray[i]['sfid']).toString();
//   //         items.add(changeTodate);
//   //         firstsfidarray.add(dropsfidarray);
//   //       }
//   //
//   //       if (dataarray.isNotEmpty) {
//   //         sfidValue = dataarray[0]['sfid'].toString();
//   //         print("sfidValue = $sfidValue");
//   //         await getmonthearningsdetailsbymonth(sfidValue);
//   //       }
//   //
//   //       setState(() {
//   //         dataLoaded = true;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         dataLoaded = false;
//   //       });
//   //     }
//   //
//   //     if (jsonInput.containsKey('data') &&
//   //         jsonInput['data'] != null &&
//   //         jsonInput['data'].isNotEmpty) {
//   //       sp_pay_cycle_start_date__c =
//   //       jsonInput['data'][0]['sp_pay_cycle_start_date__c'];
//   //       sp_pay_cycle_end_date__c =
//   //       jsonInput['data'][0]['sp_pay_cycle_end_date__c'];
//   //       showname = jsonInput['data'][0]['showname'];
//   //       print("showname == $showname");
//   //     } else {
//   //       print("No Data available");
//   //       setState(() {
//   //         dataLoaded = true;
//   //       });
//   //       print("No Data john");
//   //       if (sfidValue != null) {
//   //         await getmonthearningsdetailsbymonth(sfidValue);
//   //       }
//   //     }
//   //   }
//   // }
//
//
//
//   // getmonthearnings() async {
//   //   var url = Uri.parse(CommonURL.herokuurl);
//   //
//   //   Map<String, String> headers = {
//   //     "Accept": "application/json",
//   //     "Content-Type": "application/x-www-form-urlencoded"
//   //   };
//   //
//   //   var request = http.MultipartRequest("POST", url);
//   //   request.headers.addAll(headers);
//   //   request.fields['from'] = "getMonthYearDropdownByMonthlyEarning";
//   //   request.fields['idUser'] = utility.userid;
//   //   request.fields['service_provider_c'] = utility.service_provider_c;
//   //   request.fields['lithiumID'] = utility.lithiumid;
//   //   request.fields['languageType'] =
//   //       AppLocalizations.of(context)!.languagecode.toString();
//   //   var streamResponse = await request.send();
//   //   var response = await http.Response.fromStream(streamResponse);
//   //   print("fields = $url ${request.fields}");
//   //
//   //   String? sfidValue; // Declare sfidValue outside the block
//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
//   //     String? status;
//   //
//   //     status = jsonInput['status'].toString();
//   //
//   //     if (status == 'true') {
//   //       var dataarray = jsonInput['data'] as List;
//   //       for (int i = 0; i < dataarray.length; i++) {
//   //         if (i == 0) {
//   //           dropdownvalue = dataarray[i]['viewmonth'].toString();
//   //           yearvalue = dataarray[i]['viewyear'].toString();
//   //           sfidstr = dataarray[i]['sfid'].toString();
//   //           getmonthearningsdetailsbymonth(dataarray[i]['sfid'].toString());
//   //         }
//   //         var changeTodate = (dataarray[i]['viewmonth']).toString();
//   //         var dropsfidarray = (dataarray[i]['sfid']).toString();
//   //         items.add(changeTodate);
//   //         firstsfidarray.add(dropsfidarray);
//   //       }
//   //
//   //       if (dataarray.isNotEmpty) {
//   //         sfidValue = dataarray[0]['sfid'].toString();
//   //         print("sfidValue = $sfidValue");
//   //         await getmonthearningsdetailsbymonth(sfidValue);
//   //         // Now you have called the next API with the sfid value
//   //       }
//   //
//   //       setState(() {
//   //         dataLoaded = true; // Set the boolean to true after data is loaded
//   //       });
//   //     } else {
//   //       setState(() {
//   //         dataLoaded =
//   //             false; // Set the boolean to false if there is an issue loading data
//   //       });
//   //     }
//   //
//   //     if (jsonInput.containsKey('data') &&
//   //         jsonInput['data'] != null &&
//   //         jsonInput['data'].isNotEmpty) {
//   //       sp_pay_cycle_start_date__c =
//   //           jsonInput['data'][0]['sp_pay_cycle_start_date__c'];
//   //       sp_pay_cycle_end_date__c =
//   //           jsonInput['data'][0]['sp_pay_cycle_end_date__c'];
//   //       showname = jsonInput['data'][0]['showname'];
//   //       print("showname == $showname");
//   //     } else {
//   //       print("No Data available");
//   //       setState(() {
//   //         dataLoaded = true;
//   //       });
//   //       print("No Data john");
//   //       if (sfidValue != null) {
//   //         await getmonthearningsdetailsbymonth(sfidValue);
//   //       }
//   //       // Handle the case where 'data' is null or empty
//   //     }
//   //   }
//   // }
//
//   // getmonthearningsdetailsbymonth(String sfid) async {
//   //   var url = Uri.parse(CommonURL.localone);
//   //
//   //   Map<String, String> headers = {
//   //     "Accept": "application/json",
//   //     "Content-Type": "application/x-www-form-urlencoded"
//   //   };
//   //
//   //   var request = http.MultipartRequest("POST", url);
//   //   request.headers.addAll(headers);
//   //   request.fields['from'] = "getMonthlyEarningPayDetails";
//   //   request.fields['sfid'] = sfid;
//   //   var streamResponse = await request.send();
//   //   var response = await http.Response.fromStream(streamResponse);
//   //   print("fields 1 = $url ${request.fields}");
//   //
//   //   if (response.statusCode == 200 || response.statusCode == 201) {
//   //     listloadstatus = false;
//   //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
//   //     print("lithiumIDdetails=$jsonInput");
//   //
//   //     if (jsonInput['status'] == true) {
//   //       List<dynamic> data = jsonInput['data'];
//   //
//   //       if (data.isNotEmpty) {
//   //         List<Map<String, dynamic>> detailsList =
//   //             List<Map<String, dynamic>>.from(data);
//   //
//   //         Map<String, dynamic> details = detailsList[0];
//   //         String status = jsonInput['status'].toString();
//   //         no_of_days_present__c = details['no_of_days_present__c'];
//   //         no_of_training_days__c = details['no_of_training_days__c'];
//   //         week_off_days__c = details['week_off_days__c'];
//   //         no_of_bench_days__c = details['no_of_bench_days__c'];
//   //         no_of_continuous_shift_days__c =
//   //             details['no_of_continuous_shift_days__c'];
//   //         no_of_ueos_days__c = details['no_of_ueos_days__c'];
//   //         total_no_extra_hours_day__c = details['total_no_extra_hours_day__c'];
//   //         convenyenace_days__c = details['convenyenace_days__c'];
//   //         service_attendance_bonus_days__c =
//   //             details['service_attendance_bonus_days__c'];
//   //         no_of_days_late__c = details['no_of_days_late__c'];
//   //         continuous_shift_amount__c = details['continuous_shift_amount__c'];
//   //         extra_hours_amount__c = details['extra_hours_amount__c'];
//   //         referral_bonus_amount__c = details['referral_bonus_amount__c'];
//   //         arrears_amount__c = details['arrears_amount__c'];
//   //         awards_amount__c = details['awards_amount__c'];
//   //         welfare_amount__c = details['welfare_amount__c'];
//   //         festival__c = details['festival__c'];
//   //         bench_payment__c = details['bench_payment__c'];
//   //         ueos_deduction_amount__c = details['ueos_deduction_amount__c'];
//   //         campus_debit_amount__c = details['campus_debit_amount__c'];
//   //         deposit_recovery_amount__c = details['deposit_recovery_amount__c'];
//   //         advance_recovery_amount__c = details['advance_recovery_amount__c'];
//   //         accident_recovery_amount__c = details['accident_recovery_amount__c'];
//   //         tds_amount__c = details['tds_amount__c'];
//   //         total_additions_rollup__c = details['total_additions_rollup__c'];
//   //         total_deductions_rollup__c = details['total_deductions_rollup__c'];
//   //         total_earnings__c = details['total_earnings__c'];
//   //
//   //         print("No of Days Present: $no_of_days_present__c");
//   //         print("No of Training Days: $no_of_training_days__c");
//   //         print("status: $status");
//   //       }
//   //     }
//   //   }
//   // }
//
//   getmonthearningsdetailsbymonth(String sfid) async {
//     var url = Uri.parse(CommonURL.localone);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//
//     String dataJson = jsonEncode([
//       {
//         "sp_payment": sfidstr
//       }
//     ]);
//
//     request.fields['from'] = "getMonthlyEarningPayDetails";
//     request.fields['data'] = dataJson;
//
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     print("fields 1 = $url ${request.fields}");
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       listloadstatus = false;
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("lithiumIDdetails=$jsonInput");
//
//       if (jsonInput['status'] == true) {
//         List<dynamic> data = jsonInput['data'];
//
//         if (data.isNotEmpty) {
//           Map<String, dynamic> details = data[0];
//
//           no_of_days_present__c = details['no_of_days_present']?.toString();
//           no_of_training_days__c = details['no_of_training_days']?.toString();
//           week_off_days__c = details['week_off_days']?.toString();
//           no_of_bench_days__c = details['no_of_bench_days']?.toString();
//           no_of_continuous_shift_days__c =
//               details['no_of_continuous_shift_days']?.toString();
//           no_of_ueos_days__c = details['no_of_ueos_days']?.toString();
//           total_no_extra_hours_day__c = details['total_no_extra_hours_day']?.toString();
//           convenyenace_days__c = details['convenyenace_days']?.toString();
//           service_attendance_bonus_days__c =
//               details['service_attendance_bonus_days']?.toString();
//           no_of_days_late__c = details['no_of_days_late']?.toString();
//           continuous_shift_amount__c = details['continuous_shift_amount']?.toString();
//           extra_hours_amount__c = details['extra_hours_amount']?.toString();
//           referral_bonus_amount__c = details['referral_bonus_amount']?.toString();
//           arrears_amount__c = details['arrears_amount']?.toString();
//           awards_amount__c = details['awards_amount']?.toString();
//           welfare_amount__c = details['welfare_amount']?.toString();
//           festival__c = details['festival']?.toString();
//           bench_payment__c = details['bench_payment']?.toString();
//           ueos_deduction_amount__c = details['ueos_deduction_amount']?.toString();
//           campus_debit_amount__c = details['campus_debit_amount']?.toString();
//           deposit_recovery_amount__c = details['deposit_recovery_amount']?.toString();
//           advance_recovery_amount__c = details['advance_recovery_amount']?.toString();
//           accident_recovery_amount__c = details['accident_recovery_amount']?.toString();
//           tds_amount__c = details['tds_amount']?.toString();
//           total_additions_rollup__c = details['total_additions_rollup']?.toString();
//           total_deductions_rollup__c = details['total_deductions_rollup']?.toString();
//           total_earnings__c = details['total_earnings']?.toString();
//
//           print("No of Days Present: $no_of_days_present__c");
//           print("No of Training Days: $no_of_training_days__c");
//           print("Status: ${jsonInput['status']}");
//         }
//       }
//     }
//   }
//
//
//
//   Future<List<String>> getMonthlyEarningDateDetails(
//       String start, String end, String type) async {
//     loading();
//     var url = Uri.parse(CommonURL.localone);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//
//     // Construct the data field as a JSON string
//     String dataJson = jsonEncode([
//       {
//         // "service_provider": utility.service_provider_c,
//         "service_provider": utility.service_provider_c,
//         "sp_pay_cycle_start_date": start,
//         "sp_pay_cycle_end_date": end,
//       }
//     ]);
//
//     request.fields['from'] = "getMonthlyEarningDateDetails";
//     request.fields['data'] = dataJson;
//     request.fields['type'] = type;
//
//     try {
//       var streamResponse = await request.send();
//       var response = await http.Response.fromStream(streamResponse);
//       print("DateDetails fields = $url ${request.fields}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Map<String, dynamic> jsonInput = jsonDecode(response.body);
//         print("DateDetails = $jsonInput");
//
//         if (jsonInput['status'] == true) {
//           List<dynamic> data = jsonInput['data'];
//
//           if (data.isEmpty) {
//             Fluttertoast.showToast(
//               msg: "No data available",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//             );
//             return []; // Return an empty list if no data is available
//           }
//
//           // Map attendance dates to a list of strings
//           List<String> attendanceDateList = data.map((item) {
//             return item['attendance_date'].toString(); // Ensure this key matches the API response
//           }).toList();
//
//           return attendanceDateList;
//         } else {
//           throw Exception("Data not available");
//         }
//       } else {
//         throw Exception("HTTP Status Code: ${response.statusCode}");
//       }
//     } catch (error) {
//       print("Error fetching attendance dates: $error");
//       stopLoading(context);
//       Fluttertoast.showToast(
//         msg: "No data available",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       throw Exception("Error fetching attendance dates");
//     }
//   }
//
//
//   // Future<List<String>> getMonthlyEarningDateDetails(
//   //     String start, String end, String Type) async {
//   //   loading();
//   //   var url = Uri.parse(CommonURL.localone);
//   //
//   //   Map<String, String> headers = {
//   //     "Accept": "application/json",
//   //     "Content-Type": "application/x-www-form-urlencoded"
//   //   };
//   //
//   //   var request = http.MultipartRequest("POST", url);
//   //   request.headers.addAll(headers);
//   //   request.fields['from'] = "getMonthlyEarningDateDetails";
//   //   request.fields['service_provider_c'] = utility.service_provider_c;
//   //   request.fields['sp_pay_cycle_start_date__c'] = start;
//   //   request.fields['sp_pay_cycle_end_date__c'] = end;
//   //   request.fields['type'] = Type;
//   //
//   //   try {
//   //     var streamResponse = await request.send();
//   //     var response = await http.Response.fromStream(streamResponse);
//   //     print("DateDetails fields = $url ${request.fields}");
//   //
//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//   //       print("DateDetails =$jsonInput");
//   //
//   //       if (jsonInput['status'] == true) {
//   //         List<dynamic> data = jsonInput['data'];
//   //
//   //         if (data.isEmpty) {
//   //           Fluttertoast.showToast(
//   //             msg: "No data available",
//   //             toastLength: Toast.LENGTH_SHORT,
//   //             gravity: ToastGravity.BOTTOM,
//   //           );
//   //           return []; // Returning an empty list when there is no data
//   //         }
//   //
//   //         List<String> attendanceDateList = data.map((item) {
//   //           return item['attendance_date__c'].toString();
//   //         }).toList();
//   //
//   //         return attendanceDateList;
//   //       } else {
//   //         throw Exception("Data not available");
//   //       }
//   //     } else {
//   //       throw Exception("HTTP Status Code: ${response.statusCode}");
//   //     }
//   //   } catch (error) {
//   //     print("Error fetching attendance dates: $error");
//   //     stopLoading(context);
//   //     Fluttertoast.showToast(
//   //       msg: "No data available",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       gravity: ToastGravity.BOTTOM,
//   //     );
//   //     throw Exception("Error fetching attendance dates");
//   //   }
//   // }
//
//   Future<void> getMonthlyEarningCategoryDetails(String type) async {
//     var url = Uri.parse(CommonURL.localone);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getMonthlyEarningCategoryDetails";
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['type'] = type;
//
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     print("CategoryDetails fields = $url ${request.fields}");
//     stopLoading(context);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//
//       print("CategoryDetails = $jsonInput");
//
//       if (jsonInput.containsKey('data')) {
//         monthlyCategoryDetails = MonthlyCategoryDetails.fromJson(jsonInput);
//
//         List<String?> sfidList = monthlyCategoryDetails?.data
//             ?.map((categoryData) => categoryData.sfid)
//             ?.toList() ??
//             [];
//
//         // Use sfidList as needed
//         print("All sfid values: $sfidList");
//
//         // Call your function or perform other operations with sfidList
//         // await yourFunction(sfidList);
//       } else {
//         print("Error: 'data' field not found in the response.");
//       }
//     }
//   }
//
//   Future<List<Map<String, String>>> getMonthlyEarningSubCategoryDetails(
//       String sfid) async {
//     var url = Uri.parse(CommonURL.localone);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getMonthlyEarningSubCategoryDetails";
//     //request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['service_provider_c'] = "a3eHE000000029tYAA";
//     print("sfid= $sfid");
//     request.fields['sfid'] = sfid;
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     print("subCategoryDetails fields = $url ${request.fields}");
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       listloadstatus = false;
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("subCategoryDetails =$jsonInput");
//
//       if (jsonInput.containsKey('data')) {
//         MonthlySubCategoryDetails monthlySubCategoryDetails =
//         MonthlySubCategoryDetails.fromJson(jsonInput);
//
//         List<Map<String, String>> subCategoryList =
//             monthlySubCategoryDetails?.data
//                 ?.map((categoryData) => {
//               'sfid': categoryData.sfid ?? "Select SubCategory",
//               'name': categoryData.name ?? "Select SubCategory",
//             })
//                 ?.toList() ??
//                 [];
//
//         print("subCategoryList=$subCategoryList");
//         // Use subCategoryList as needed
//         print("All subcategories: $subCategoryList");
//
//         return subCategoryList;
//       } else {
//         print("Error: 'data' field not found in the response.");
//         // Return an empty list if 'data' is not found
//         return [];
//       }
//     } else {
//       print(
//           "Error: Unable to fetch category details. Status Code: ${response.statusCode}");
//       // Return an empty list in case of an error
//       return [];
//     }
//   }
//
//   getMonthlyEarningmonthlyEarningIssueAdd(
//       String Date, SFID, SubCategory, Trips, Type) async {
//     loading();
//     var url = Uri.parse(CommonURL.localone);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "monthlyEarningIssueAdd";
//     request.fields['lithiumID'] = username;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['date'] = Date;
//     request.fields['category'] = SFID;
//     request.fields['subcategory'] = SubCategory;
//     request.fields['nooftrips'] = Trips;
//     request.fields['type'] = Type;
//
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("daily earn = $jsonInput");
//       print("fields = $url ${request.fields}");
//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//       print("message = $message");
//       if (status == 'true') {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//         // Navigator.push(context,
//         //     MaterialPageRoute(builder: (context) => const Dashboard2()));
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const MyTabPage(
//                   title: '',
//                   selectedtab: 0,
//                 )));
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//       }
//     } else {}
//     setState(() {});
//   }
//
//   void loading() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         // dialogContext = context;
//         return Dialog(
//           child: Padding(
//             padding: const EdgeInsets.all(25.0),
//             // ignore: unnecessary_new
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(
//                   'assets/lithiugif.gif',
//                   width: 50,
//                   // color: HexColor(Colorscommon.greencolor),
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
//
//   void stopLoading(BuildContext context) {
//     Navigator.of(context).pop();
//     // Additional logic for stopping loading (if needed)
//   }
// }
//
